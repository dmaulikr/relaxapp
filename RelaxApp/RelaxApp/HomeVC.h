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
@interface HomeVC : UIViewController<AVAudioPlayerDelegate, IDZAudioPlayerDelegate>
{
    AFURLSessionManager *manager;
    AFHTTPSessionManager *managerCategory;

}
@property (nonatomic, strong) IBOutlet UIView *vContrainer;
@property (nonatomic, strong) IBOutlet UIImageView *imgBackGround;

@property (nonatomic, strong) TabVC *vTabbar;
@property (nonatomic, strong)  FavoriteView *vFavorite;
@property (nonatomic, strong)  SettingView *vSetting;
@property (nonatomic, strong)  TimerView *vTimer;
@property (nonatomic, strong)  VolumeView *vVolumeTotal;
@property (nonatomic, strong)  VolumeItem *vVolumeItem;

@end
