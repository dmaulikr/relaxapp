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
#import "DownLoadCategory.h"
@interface HomeVC ()
{
    NSMutableArray                  *arrCategory;
    CollectionVC *colectionView;
    NSMutableArray                  *arrPlayList;
    NSMutableArray                  *arrMusic;

}
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    arrCategory  = [NSMutableArray new];
    arrPlayList = [NSMutableArray new];
    arrMusic = [NSMutableArray new];
    
    [self getCategory];
    // Do any additional setup after loading the view from its nib.
//    [self setupPlayerWithFullPath:[self getFullPathWithFileName:[NSString stringWithFormat:@"1/%@",@"sound/1.ogg"]]];
//    [self setupPlayerWithFullPath:[self getFullPathWithFileName:[NSString stringWithFormat:@"1/%@",@"sound/2.ogg"]]];
//    [self setupPlayerWithFullPath:[self getFullPathWithFileName:[NSString stringWithFormat:@"1/%@",@"sound/3.ogg"]]];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    __weak HomeVC *wself = self;
    //COLLECTION
    colectionView = [[CollectionVC alloc] initWithEVC];
    [colectionView addContraintSupview:self.vContrainer];
    [colectionView setCallback:^(NSDictionary *dicMusic)
     {
         NSMutableDictionary *dic = [dicMusic mutableCopy];
         if ([dic[@"active"] boolValue]) {
             [dic setObject:@(0) forKey:@"active"];
         }
         else
         {
             [dic setObject:@(1) forKey:@"active"];
             [dic setObject:@(0.5) forKey:@"volume"];
             //show music
             [wself.vVolumeItem showVolumeWithDicMusic:dic];
             
             
         }
         [wself updateDataMusic:dic];
     }];
    //ADD VIEW
    [self addSubViewFavorite];
    [self addSubViewTimer];
    [self addSubViewSetting];
    [self addSubViewVolumeTotal];
    [self addSubViewVolumeItem];
}
-(void)updateDataMusic:(NSDictionary*)dicMusic
{

    [self setupPlayerWithMusicItem:dicMusic];
    for (int i = 0; i < arrMusic.count; i++) {
        NSDictionary *musicItem = arrMusic[i];
        if ([musicItem[@"ID"] intValue] == [dicMusic[@"ID"] intValue]) {
            [arrMusic replaceObjectAtIndex:i withObject:dicMusic];
            [colectionView updateDataMusic:arrMusic];
            break;
        }

    }

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
    [self.vVolumeTotal setup];
    [self.vVolumeItem setup];
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag - 10) {
        case 0:
        {
            //setting
            [self.vVolumeTotal hide:NO];
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
            for (NSDictionary *dicMusic in arrPlayList) {
                IDZAQAudioPlayer *player  = dicMusic[@"player"];
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
-(void) addSubViewVolumeTotal
{
    self.vVolumeTotal = [[VolumeView alloc] initWithClassName:NSStringFromClass([VolumeView class])];
    [self.vVolumeTotal addContraintSupview:self.vContrainer];
    [self.vVolumeTotal setup];
}
-(void) addSubViewVolumeItem
{
    __weak HomeVC *wself = self;
    self.vVolumeItem = [[VolumeItem alloc] initWithClassName:NSStringFromClass([VolumeItem class])];
    [self.vVolumeItem addContraintSupview:self.vContrainer];
    [self.vVolumeItem setCallback:^(NSDictionary *dicMusic)
     {
         [wself updateDataMusic:dicMusic];
     }];

    [self.vVolumeItem setup];

}
//MARK: - NETWORK
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
    __weak HomeVC *wself = self;
    managerCategory = [AFHTTPSessionManager manager];
    [managerCategory GET:@"http://lavie.dothome.co.kr/data/data-test.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"categories"] isKindOfClass:[NSArray class]]) {
            [arrCategory addObjectsFromArray:responseObject[@"categories"]];
            DownLoadCategory *download = [DownLoadCategory sharedInstance];
            [download fnListMusicWithCategory:arrCategory];
            [download setCallback:^(NSDictionary *dicItemCategory)
             {
                 [wself getListMusicFromCategory:arrCategory];
             }];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)getListMusicFromCategory:(NSArray*)category
{
    
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:[self getFullPathWithFileName:@"1/example.json"] encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    NSDictionary *dicTmp = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    arrMusic = [dicTmp[@"Exprorer Cities"] mutableCopy];
    [colectionView updateDataMusic:arrMusic];

}
//MARK: - PLAYER
-(void)setupPlayerWithMusicItem:(NSDictionary*)dicMusic
{
    for (int i = 0; i < arrPlayList.count; i++) {
        NSDictionary *musicItem = arrPlayList[i];
        if ([dicMusic[@"ID"] intValue] == [musicItem[@"music"][@"ID"] intValue]) {
            IDZAQAudioPlayer *player  = musicItem[@"player"];
            [player stop];
            [arrPlayList removeObjectAtIndex:i];
            break;
        }
        
    }
    if ([dicMusic[@"active"] boolValue]) {
        NSString *path = [self getFullPathWithFileName:[NSString stringWithFormat:@"1/%@",dicMusic[@"sound"]]];
        NSError* error = nil;
        NSURL* url = [NSURL fileURLWithPath:path];
        
        IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:url error:&error];
        NSLog(@"Ogg Vorbis file duration is %g", decoder.duration);
        IDZAQAudioPlayer *player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
        [player setVolume:[dicMusic[@"volume"] floatValue]];
        if(!player)
        {
            NSLog(@"Error creating player: %@", error);
        }
        player.delegate = self;
        [player prepareToPlay];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:player forKey:@"player"];
        [dic setObject:dicMusic forKey:@"music"];
        [arrPlayList addObject:dic];

    }
    [self performSelector:@selector(playMusic) withObject:nil afterDelay:0.04];

}
-(void)playMusic
{
    for (NSDictionary *dicMusic in arrPlayList) {
        IDZAQAudioPlayer *player  = dicMusic[@"player"];
        [player play];
    }
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
