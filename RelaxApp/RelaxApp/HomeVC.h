//
//  HomeVC.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TabVC.h"
#import "FavoriteView.h"
#import "TimerView.h"
#import "SettingView.h"
#import "VolumeView.h"
#import "VolumeItem.h"
#import "AFHTTPSessionManager.h"
#import "IDZAQAudioPlayer.h"
#import "AddFavoriteView.h"
@interface HomeVC : UIViewController<AVAudioPlayerDelegate, IDZAudioPlayerDelegate>
{
    AFURLSessionManager *manager;
    AFHTTPSessionManager *managerCategory;

}
@property (nonatomic, strong) NSDictionary *dicChooseCategory;

@property (nonatomic, strong) IBOutlet UIView *vContrainer;
@property (nonatomic, strong) IBOutlet UIImageView *imgBackGround;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIScrollView *scroll_View;
@property (nonatomic, strong) IBOutlet UILabel *titleCategory;
@property (nonatomic, strong) IBOutlet UIImageView *imgSingle;

@property (nonatomic, strong) IBOutlet UIButton *btnAddfavorite;
@property (nonatomic, strong) IBOutlet UIImageView *imgAddfavorite;

@property (nonatomic, strong) IBOutlet UIButton *btnclearAll;
@property (nonatomic, strong) IBOutlet UIImageView *imgclearAll;

//VOLUME
@property (nonatomic, strong) IBOutlet UILabel *lbVolume;
@property (nonatomic, strong) IBOutlet UIImageView *imgVolume;
//FAVORITE
@property (nonatomic, strong) IBOutlet UILabel *lbFavorite;
@property (nonatomic, strong) IBOutlet UIImageView *imgFavorite;
//HOME
@property (nonatomic, strong) IBOutlet UILabel *lbHome;
@property (nonatomic, strong) IBOutlet UIImageView *imgHome;
//TIMER
@property (nonatomic, strong) IBOutlet UILabel *lbTimer;
@property (nonatomic, strong) IBOutlet UIImageView *imgTimer;
//SETTING
@property (nonatomic, strong) IBOutlet UILabel *lbSetting;
@property (nonatomic, strong) IBOutlet UIImageView *imgSetting;


@property (nonatomic, strong) TabVC *vTabbar;
@property (nonatomic, strong)  FavoriteView *vFavorite;
@property (nonatomic, strong)  AddFavoriteView *vAddFavorite;

@property (nonatomic, strong)  SettingView *vSetting;
@property (nonatomic, strong)  TimerView *vTimer;
@property (nonatomic, strong)  VolumeView *vVolumeTotal;
@property (nonatomic, strong)  VolumeItem *vVolumeItem;

@end
