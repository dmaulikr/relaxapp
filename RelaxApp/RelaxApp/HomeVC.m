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
#import "FileHelper.h"
#import "Define.h"
extern float volumeGlobal;

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
             [wself addSubViewVolumeItemWithDicMusic:dic];
             
             
         }
         [wself updateDataMusic:dic];
     }];
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
    [self.vFavorite dismissView];
    [self.vAddFavorite dismissView];
    [self.vTimer dismissView];
    [self.vSetting dismissView];
    [self.vVolumeTotal removeFromSuperview];
    [self.vVolumeItem removeFromSuperview];
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag - 10) {
        case 0:
        {
            //setting
            [self addSubViewVolumeTotal];
        }
            break;
        case 1:
        {
            //favorite
            [self addSubViewFavorite];
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
            [self addSubViewTimer];

        }
            break;
        case 4:
        {
            //setting
            [self addSubViewSetting];

        }
            break;
        default:
            break;
    }
}
//MARK: view filter
-(void) addSubViewFavorite
{
    __weak HomeVC *wself = self;
    self.vFavorite = [[FavoriteView alloc] initWithClassName:NSStringFromClass([FavoriteView class])];
    [self.vFavorite addContraintSupview:self.vContrainer];
    [self.vFavorite setCallback:^(NSArray *chooseMusic)
     {
         [wself fnPlayerFromFavorite:chooseMusic];
     }];
}
-(void) addSubViewTimer
{
    self.vTimer = [[TimerView alloc] initWithClassName:NSStringFromClass([TimerView class])];
    [self.vTimer addContraintSupview:self.vContrainer];
}
-(void) addSubViewSetting
{
    self.vSetting = [[SettingView alloc] initWithClassName:NSStringFromClass([SettingView class])];
    [self.vSetting addContraintSupview:self.vContrainer];
}
//MARK: - VOLUME

-(void) addSubViewVolumeTotal
{
    __weak HomeVC *wself = self;
    [self.vVolumeTotal removeFromSuperview];

    self.vVolumeTotal = [[VolumeView alloc] initWithClassName:NSStringFromClass([VolumeView class])];
    [self.vVolumeTotal addContraintSupview:self.vContrainer];
    [self.vVolumeTotal setCallback:^()
     {
         [wself changeVolumeTotal];
     }];

}
-(void)changeVolumeTotal
{
    for (int i = 0; i < arrPlayList.count; i++) {
        NSDictionary *musicItem = arrPlayList[i];
            IDZAQAudioPlayer *player  = musicItem[@"player"];
            [player setVolume:[musicItem[@"music"][@"volume"] floatValue] * volumeGlobal];
    }
}
-(void) addSubViewVolumeItemWithDicMusic:(NSDictionary*)dicMusic
{
    __weak HomeVC *wself = self;
    [self.vVolumeItem removeFromSuperview];
    self.vVolumeItem = [[VolumeItem alloc] initWithClassName:NSStringFromClass([VolumeItem class])];
    [self.vVolumeItem addContraintSupview:self.vContrainer];
    [self.vVolumeItem showVolumeWithDicMusic:dicMusic];
    [self.vVolumeItem setCallback:^(NSDictionary *dicMusic)
     {
         [wself updateDataMusic:dicMusic];
     }];

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
            [wself getListMusicFromCategory:arrCategory];

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
        [player setVolume:[dicMusic[@"volume"] floatValue] * volumeGlobal];
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
//MARK: - CLEAR ALL
-(IBAction)clearAll:(id)sender
{
    for (int i = 0; i< arrMusic.count; i++) {
        NSMutableDictionary *dic = [arrMusic[i] mutableCopy];
        [dic setObject:@(0) forKey:@"active"];
        [arrMusic replaceObjectAtIndex:i withObject:dic];
        [self setupPlayerWithMusicItem:dic];
    }
    [colectionView updateDataMusic:arrMusic];
}
//MARK: - ADD FAVORITE
-(IBAction)addFavoriteAction:(id)sender
{
    NSMutableArray *arrChoose = [NSMutableArray new];
    for (NSDictionary *dic in arrMusic) {
        if ([dic[@"active"] boolValue] == YES) {
            [arrChoose addObject:dic];
        }
    }
    //favorite
    self.vAddFavorite = [[AddFavoriteView alloc] initWithClassName:NSStringFromClass([AddFavoriteView class])];
    [self.vAddFavorite addContraintSupview:self.view];
    [self.vAddFavorite fnSetDataMusic:arrChoose];
}
//MARK: - CHOOSE FAVORITE
-(void)fnPlayerFromFavorite:(NSArray*)chooseFavotite
{
    //clear befor
    [self clearAll:nil];
    //set list choose from favorite
    for (NSDictionary *dichChoose in chooseFavotite) {
        for (int i = 0; i< arrMusic.count; i++) {
            NSDictionary *musicItem = arrMusic[i];
            if ([musicItem[@"ID"] intValue] == [dichChoose[@"ID"] intValue]) {
                NSMutableDictionary *dic = [musicItem mutableCopy];
                    [dic setObject:@(1) forKey:@"active"];
                    [dic setObject:dichChoose[@"volume"] forKey:@"volume"];
                    //show music
                [arrMusic replaceObjectAtIndex:i withObject:dic];
                [self setupPlayerWithMusicItem:dic];
                break;

            }

        }
    }
    [colectionView updateDataMusic:arrMusic];


}
//MARK: - CHECK HIDE SHOW BUTTON
-(void)checkStatusButtonFavorite
{
    if (arrPlayList.count > 0) {
        
    }
    else
    {
    
    }
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
