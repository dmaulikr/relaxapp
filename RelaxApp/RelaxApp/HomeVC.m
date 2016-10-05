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
#import "MBProgressHUD.h"
#import "AppDelegate.h"
extern float volumeGlobal;

@interface HomeVC ()<UIScrollViewDelegate>
{
    NSMutableArray                  *arrCategory;
    NSMutableArray                  *arrPlayList;
    NSMutableArray                  *arrColection;
    NSMutableArray *arrTotal;
    int iNumberCollection;
    BOOL preSignSelect;
}
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    arrCategory  = [NSMutableArray new];
    arrPlayList = [NSMutableArray new];
    arrColection = [NSMutableArray new];
    self.scroll_View.delegate = self;
    self.imgSingle.hidden = YES;
    [self getCategory];
    [self fnSetButtonNavigation];
    //timer
    AppDelegate * myAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [myAppDelegate setCallback:^(NSDate *date)
     {
     
     }];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)updateDataMusic:(NSDictionary*)dicMusic withCategory:(NSDictionary *)category
{

    [self setupPlayerWithMusicItem:dicMusic];
    for (int i = 0; i< arrCategory.count; i++) {
        
        NSMutableDictionary *dicCategory = [arrCategory[i] mutableCopy];
        if ([dicCategory[@"id"] intValue] == [category[@"id"] intValue]) {
            NSMutableArray *arrSounds = [dicCategory[@"sounds"] mutableCopy];
            for (int j = 0; j <arrSounds.count; j++) {
                NSDictionary *dicSound = arrSounds[j];
                if (dicSound[@"id"] == dicMusic[@"id"]) {
                    [arrSounds replaceObjectAtIndex:j withObject:dicMusic];
                    [dicCategory setObject:arrSounds forKey:@"sounds"];
                    [arrCategory replaceObjectAtIndex:i withObject:dicCategory];
                    [self caculatorSubScrollview];
                    break;
                }
            }

        }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK: ACTION

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

-(void) addSubViewFavorite
{
    __weak HomeVC *wself = self;
    self.vFavorite = [[FavoriteView alloc] initWithClassName:NSStringFromClass([FavoriteView class])];
    [self.vFavorite addContraintSupview:self.vContrainer];
    [self.vFavorite setCallback:^(NSDictionary *dicCateogry)
     {
         wself.dicChooseCategory = dicCateogry;
         NSArray *chooseMusic = wself.dicChooseCategory[@"music"];
         [wself fnPlayerFromFavorite:chooseMusic];
     }];
}
-(void) addSubViewTimer
{
    self.vTimer = [[TimerView alloc] initWithClassName:NSStringFromClass([TimerView class])];
    self.vTimer.parent = self;
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
-(void) addSubViewVolumeItemWithDicMusic:(NSDictionary*)dicMusic withCategory:(NSDictionary *)dicCategory
{
    __weak HomeVC *wself = self;
    [self.vVolumeItem removeFromSuperview];
    self.vVolumeItem = [[VolumeItem alloc] initWithClassName:NSStringFromClass([VolumeItem class])];
    [self.vVolumeItem addContraintSupview:self.vContrainer];
    [self.vVolumeItem showVolumeWithDicMusic:dicMusic];
    [self.vVolumeItem setCallback:^(NSDictionary *dicMusic)
     {
         [wself updateDataMusic:dicMusic withCategory:dicCategory];
     }];

}
//MARK: - NETWORK
-(void)getCategory
{
    __weak HomeVC *wself = self;
    managerCategory = [AFHTTPSessionManager manager];
    [managerCategory GET:[NSString stringWithFormat:@"%@%@",BASE_URL,@"data.json"] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"categories"] isKindOfClass:[NSArray class]]) {
            [arrCategory addObjectsFromArray:responseObject[@"categories"]];
            [wself caculatorSubScrollview];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//MARK: - PLAYER
-(void)setupPlayerWithMusicItem:(NSDictionary*)dicMusic
{
    for (int i = 0; i < arrPlayList.count; i++) {
        NSDictionary *musicItem = arrPlayList[i];
        if ([dicMusic[@"id"] intValue] == [musicItem[@"music"][@"id"] intValue]) {
            IDZAQAudioPlayer *player  = musicItem[@"player"];
            [player stop];
            [arrPlayList removeObjectAtIndex:i];
            break;
        }
        
    }
    if ([dicMusic[@"active"] boolValue]) {
        NSString *category_name = @"";
        for (NSDictionary *dicCategory in arrCategory) {
            if (category_name.length > 0) {
                break;
            }
            NSArray *arrSounds = dicCategory[@"sounds"];
            for (NSDictionary *dicSound in arrSounds) {
                if (dicSound[@"id"] == dicMusic[@"id"]) {
                    category_name = dicCategory[@"path"];
                    break;
                }
            }
        }
        if (category_name.length ==0) {
            return;
        }
        
        NSString *path = [self getFullPathWithFileName:[NSString stringWithFormat:@"%@/sound/%@",category_name,dicMusic[@"sound"]]];
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
    _dicChooseCategory = nil;
    [self fnClearAllSounds];
    [self fnSetButtonNavigation];
}
-(void)fnClearAllSounds
{
    [self fnSetButtonNavigation];
    for (int i = 0; i< arrCategory.count; i++) {
        NSMutableDictionary *dicCategory = [arrCategory[i] mutableCopy];
        NSMutableArray *arrSounds = [dicCategory[@"sounds"] mutableCopy];
        for (int j = 0; j <arrSounds.count; j++) {
            NSMutableDictionary *dicSound = [arrSounds[j] mutableCopy];
            [dicSound setObject:@(0) forKey:@"active"];
            [arrSounds replaceObjectAtIndex:j withObject:dicSound];
            [dicCategory setObject:arrSounds forKey:@"sounds"];
            [arrCategory replaceObjectAtIndex:i withObject:dicCategory];
            [self setupPlayerWithMusicItem:dicSound];
        }
    }
    [self caculatorSubScrollview];

}
//MARK: - FAVORITE
-(IBAction)addFavoriteAction:(id)sender
{
    if (_dicChooseCategory) {
        // show info Favotite
        //favorite
        self.vAddFavorite = [[AddFavoriteView alloc] initWithClassName:NSStringFromClass([AddFavoriteView class])];
        [self.vAddFavorite addContraintSupview:self.view];
        self.vAddFavorite.modeType = MODE_INFO;
        [self.vAddFavorite fnSetInfoFavorite:_dicChooseCategory];

    }
    else
    {
        NSMutableArray *arrChoose = [NSMutableArray new];
        for (int i = 0; i< arrCategory.count; i++) {
            NSMutableArray *arrSounds = [arrCategory[i][@"sounds"] mutableCopy];
            for (int j = 0; j <arrSounds.count; j++) {
                NSMutableDictionary *dicSound = [arrSounds[j] mutableCopy];
                if ([dicSound[@"active"] boolValue] == YES) {
                    [arrChoose addObject:dicSound];
                }
            }
        }
        //favorite
        self.vAddFavorite = [[AddFavoriteView alloc] initWithClassName:NSStringFromClass([AddFavoriteView class])];
        [self.vAddFavorite addContraintSupview:self.view];
        self.vAddFavorite.modeType = MODE_CREATE;
        [self.vAddFavorite fnSetDataMusic:arrChoose];

    }
}
-(void)fnPlayerFromFavorite:(NSArray*)chooseFavotite
{
    //clear befor
    [self fnClearAllSounds];
    //set list choose from favorite
    for (NSDictionary *dichChoose in chooseFavotite) {
        
        for (int i = 0; i< arrCategory.count; i++) {
            NSMutableDictionary *dicCategory = [arrCategory[i] mutableCopy];
            NSMutableArray *arrSounds = [dicCategory[@"sounds"] mutableCopy];
            for (int j = 0; j <arrSounds.count; j++) {
                NSMutableDictionary *dicSound = [arrSounds[j] mutableCopy];
                if ([dicSound[@"id"] intValue] == [dichChoose[@"id"] intValue]) {
                    [dicSound setObject:dichChoose[@"volume"] forKey:@"volume"];
                    [dicSound setObject:dichChoose[@"active"] forKey:@"active"];

                    //show music
                    [arrSounds replaceObjectAtIndex:j withObject:dicSound];
                    [dicCategory setObject:arrSounds forKey:@"sounds"];
                    [arrCategory replaceObjectAtIndex:i withObject:dicCategory];
                    [self setupPlayerWithMusicItem:dicSound];
                    break;
                    
                }
            }
        }
    }

    [self caculatorSubScrollview];
    [self fnSetButtonNavigation];

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
//MARK: - SCROLL VIEW
-(void)caculatorSubScrollview
{
    __weak HomeVC *wself = self;
    iNumberCollection = 0;

    //remove subview scroll news
    for (UIView *view in self.scroll_View.subviews) {
        [view removeFromSuperview];
    }
    [arrColection removeAllObjects];
    
    float delta = CGRectGetWidth(self.scroll_View.frame);
    //caculator number page
   arrTotal = [NSMutableArray new];
    for (int j=0; j < arrCategory.count; j++) {
        NSArray *arrItem = arrCategory[j][@"sounds"];
        int deltal = 13;
        for (int i = 0; i <arrItem.count; i = i + deltal) {
            NSMutableDictionary *dicCategory = [arrCategory[j] mutableCopy];
            [dicCategory removeObjectForKey:@"sounds"];
            
            if (i + deltal <= arrItem.count - 1) {
                [dicCategory setObject:[arrItem subarrayWithRange:NSMakeRange(i, deltal)] forKey:@"sounds"];
                [arrTotal addObject:dicCategory];
            }
            else
            {
                [dicCategory setObject:[arrItem subarrayWithRange:NSMakeRange(i, arrItem.count - i)] forKey:@"sounds"];
                [arrTotal addObject:dicCategory];
            }
        }
        if (arrItem.count == 0) {
            NSMutableDictionary *dicCategory = [arrCategory[j] mutableCopy];
            [dicCategory removeObjectForKey:@"sounds"];
            [arrTotal addObject:dicCategory];
        }
    }
    //add scroll view
    iNumberCollection = iNumberCollection + (int)arrTotal.count;
    int i = 0;
    for (NSDictionary *dicCategory in arrTotal) {
        UIView *v =[UIView new];
        v.frame = CGRectMake( i*delta, 0 , delta , CGRectGetHeight(self.scroll_View.frame));
        
        [self.scroll_View addSubview:v];
        CollectionVC *collection = [[CollectionVC alloc] initWithEVC];
        [collection addContraintSupview:v];
        [collection updateDataMusic:dicCategory];
        [collection setCallback:^(NSDictionary *dicMusic,NSDictionary *dicCategory)
         {
             _dicChooseCategory = nil;
             //neu truoc day chon 1 thang la signle
             if (preSignSelect) {
                 preSignSelect = !preSignSelect;
                 [wself fnClearAllSounds];
             }
             if (![dicCategory[@"manyselect"] boolValue]) {
                 preSignSelect = YES;
                 [wself fnClearAllSounds];
             }
             NSMutableDictionary *dic = [dicMusic mutableCopy];
             if ([dic[@"active"] boolValue]) {
                 [dic setObject:@(0) forKey:@"active"];
             }
             else
             {
                 [dic setObject:@(1) forKey:@"active"];
                 [dic setObject:@(0.5) forKey:@"volume"];
                 //show music
                 [wself addSubViewVolumeItemWithDicMusic:dic withCategory:dicCategory];
                 
                 
             }
             [wself updateDataMusic:dic withCategory:dicCategory];
             [wself fnSetButtonNavigation];
         }];
        [collection setCallbackCategory:^(NSDictionary *dicCategory)
         {
             [self downloadSoundWithCategory:dicCategory];

         }];
        [arrColection addObject:collection];
        i++;
    }

    [self.scroll_View setContentSize:CGSizeMake(iNumberCollection*delta, CGRectGetHeight(self.scroll_View.frame))];
    [self.scroll_View setPagingEnabled:YES];
    self.pageControl.numberOfPages = iNumberCollection;
    //set title
    CGFloat pageWidth = CGRectGetWidth(self.scroll_View.frame);
    CGFloat currentPage = floor((self.scroll_View.contentOffset.x-pageWidth/2)/pageWidth)+1;
    // Change the indicator
    self.pageControl.currentPage = (int) currentPage;
    if (currentPage < arrTotal.count) {
        self.titleCategory.text = arrTotal[(int)currentPage][@"name"];
        self.imgSingle.hidden = [arrTotal[(int)currentPage][@"manyselect"] boolValue];

    }


}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    CGFloat currentPage = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    // Change the indicator
    self.pageControl.currentPage = (int) currentPage;
    if (currentPage < arrTotal.count) {
        self.titleCategory.text = arrTotal[(int)currentPage][@"name"];
        self.imgSingle.hidden = [arrTotal[(int)currentPage][@"manyselect"] boolValue];
    }

}
-(void)downloadSoundWithCategory:(NSDictionary*)dicCategory
{
    __weak HomeVC *wself = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = @"Downloading...";
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

    });

    DownLoadCategory *download = [DownLoadCategory sharedInstance];
    [download fnListMusicWithCategory:@[dicCategory]];
    [download setCallback:^(NSDictionary *dicItemCategory)
     {
         [wself caculatorSubScrollview];
         dispatch_async(dispatch_get_main_queue(), ^{
             [hud hideAnimated:YES];
         });
     }];
    [download setCallbackProgess:^(float progress)
     {
         dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD HUDForView:self.view].progress = progress;
             });
         });

     }];
}
//MARK: - STATUS BUTTON
-(void)fnSetButtonNavigation
{
    if (arrPlayList.count == 0) {
        _btnAddfavorite.hidden = YES;
        _imgAddfavorite.hidden = YES;
        //
        _btnclearAll.hidden = YES;
        _imgclearAll.hidden = YES;
    }
    else
    {
        if (_dicChooseCategory) {
            _imgAddfavorite.image = [UIImage imageNamed:@"infofavorite"];
        }
        else
        {
            _imgAddfavorite.image = [UIImage imageNamed:@"addtofavorite"];
        }
        _btnAddfavorite.hidden = NO;
        _imgAddfavorite.hidden = NO;
        _btnclearAll.hidden = NO;
        _imgclearAll.hidden = NO;

    }
}
@end
