//
//  HomeVC.m
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "HomeVC.h"
#import "CollectionVC.h"
#import "SSZipArchive.h"
#import "IDZTrace.h"
#import "IDZOggVorbisFileDecoder.h"

@interface HomeVC ()
{
    NSMutableArray                  *arrCategory;
    CollectionVC *colectionView;
    NSMutableArray                  *arrPlayList;

}
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    arrCategory  = [NSMutableArray new];
    arrPlayList = [NSMutableArray new];
    [self getCategory];
    [self downloadShowingProgress];
    // Do any additional setup after loading the view from its nib.
    [self setupPlayerWithFullPath:[self getFullPathWithFileName:[NSString stringWithFormat:@"1/%@",@"sound/1.ogg"]]];
    [self setupPlayerWithFullPath:[self getFullPathWithFileName:[NSString stringWithFormat:@"1/%@",@"sound/2.ogg"]]];
    [self setupPlayerWithFullPath:[self getFullPathWithFileName:[NSString stringWithFormat:@"1/%@",@"sound/3.ogg"]]];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //COLLECTION
    colectionView = [[CollectionVC alloc] initWithEVC];
    [colectionView addContraintSupview:self.vContrainer];
    //ADD VIEW
    [self addSubViewFavorite];
    [self addSubViewTimer];
    [self addSubViewSetting];
    [self addSubViewVolume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tabBottomVCAction:(id)sender
{
    [self.vFavorite setup];
    [self.vTimer setup];
    [self.vSetting setup];
    [self.vVolume setup];
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag - 10) {
        case 0:
        {
            //setting
            [self.vVolume hide:NO];
        }
            break;
        case 1:
        {
            //favorite
            [self.vFavorite hide:NO];
        }
            break;
        case 2:
        {
            //home
            for (IDZAQAudioPlayer *player in arrPlayList) {
                [player play];
            }

        }
            break;
        case 3:
        {
            //timer
            [self.vTimer hide:NO];

        }
            break;
        case 4:
        {
            //setting
            [self.vSetting hide:NO];

        }
            break;
        default:
            break;
    }
}
//MARK: view filter
-(void) addSubViewFavorite
{
    self.vFavorite = [[FavoriteView alloc] initWithClassName:NSStringFromClass([FavoriteView class])];
    [self.vFavorite addContraintSupview:self.vContrainer];
    [self.vFavorite setup];
}
-(void) addSubViewTimer
{
    self.vTimer = [[TimerView alloc] initWithClassName:NSStringFromClass([TimerView class])];
    [self.vTimer addContraintSupview:self.vContrainer];
    [self.vTimer setup];
}
-(void) addSubViewSetting
{
    self.vSetting = [[SettingView alloc] initWithClassName:NSStringFromClass([SettingView class])];
    [self.vSetting addContraintSupview:self.vContrainer];
    [self.vSetting setup];
}
-(void) addSubViewVolume
{
    self.vVolume = [[VolumeView alloc] initWithClassName:NSStringFromClass([VolumeView class])];
    [self.vVolume addContraintSupview:self.vContrainer];
    [self.vVolume setup];
}
//MARK: - NETWORK
-(void)downloadShowingProgress
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://lavie.dothome.co.kr/data/1.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        [self unzipWithFileName:@"1.zip"];
    }];
    [downloadTask resume];
    
}
-(void)getCategory
{
    /*
    {
    categories: [
        {
            id: 1,
        title: "example sounds",
        cover: "img/1.png",
        source: "1.zip",
        price: false,
        manyselect: true,
        md5: "d784fa8b6d98d27699781bd9a7cf19f0"
        }
                 ]
    }
    */
    managerCategory = [AFHTTPSessionManager manager];
    [managerCategory GET:@"http://lavie.dothome.co.kr/data/data-test.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"categories"] isKindOfClass:[NSArray class]]) {
            [arrCategory addObjectsFromArray:responseObject[@"categories"]];
            [self downloadShowingProgress];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
//MARK: - UNZIP
- (void)unzipWithFileName:(NSString*)filename {
    // use extracted files from [-testUnzipping]
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:filename];
    //
    NSString *unzipPath = documentsDirectory;
    //unzip
    [SSZipArchive unzipFileAtPath:archivePath toDestination:unzipPath overwrite:YES password:@"" progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        //PRORESS
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
        //COMPLETE
        [colectionView fnSetDataCategory:arrCategory];
    }];
}
//MARK: - PLAYER
-(void)setupPlayerWithFullPath:(NSString*)path
{
    NSError* error = nil;
    NSURL* url = [NSURL fileURLWithPath:path];
    
    IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:url error:&error];
    NSLog(@"Ogg Vorbis file duration is %g", decoder.duration);
    IDZAQAudioPlayer *player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
    if(!player)
    {
        NSLog(@"Error creating player: %@", error);
    }
    player.delegate = self;
    [player prepareToPlay];
    [arrPlayList addObject:player];
}
-(NSString*)getFullPathWithFileName:(NSString*)fileName
{
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return archivePath;
}
#pragma mark - IDZAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(id<IDZAudioPlayer>)player successfully:(BOOL)flag
{
    NSLog(@"%s successfully=%@", __PRETTY_FUNCTION__, flag ? @"YES"  : @"NO");
}

- (void)audioPlayerDecodeErrorDidOccur:(id<IDZAudioPlayer>)player error:(NSError *)error
{
    NSLog(@"%s error=%@", __PRETTY_FUNCTION__, error);
}

@end
