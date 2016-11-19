//
//  SettingView.h
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface SettingView : BaseView
@property (nonatomic, strong) IBOutlet UIView *vViewNav;
@property (nonatomic, strong) IBOutlet UIView *vContent;
@property (nonatomic, strong) IBOutlet UILabel *timeAgo;
@property (strong, nonatomic) IBOutlet UILabel *lbShare;
@property (strong, nonatomic) IBOutlet UILabel *lbTitleCheckUpdate;
@property (strong, nonatomic) IBOutlet UILabel *lbTitleLestTalk;
@property (strong, nonatomic) IBOutlet UILabel *lbTitleConnectWithUs;
@property (strong, nonatomic) IBOutlet UILabel *lbTitleAbout;
@property (strong, nonatomic) IBOutlet UILabel *lbCredit;
@property (strong, nonatomic) IBOutlet UILabel *lbPrivacy;
@property (strong, nonatomic) IBOutlet UISwitch *unlockPro;
@property (strong, nonatomic) IBOutlet UISwitch *totalRemoveAds;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintHeightAds;
@property (weak, nonatomic) IBOutlet UIView *vAds;
@property (strong, nonatomic) IBOutlet UIView *vViewCheckNow;
@property (strong, nonatomic) IBOutlet UIView *vViewFeedBack;
@property (strong, nonatomic) IBOutlet UIView *vViewFacebook;
@property (strong, nonatomic) IBOutlet UIView *vViewTwitter;
@property (strong, nonatomic) IBOutlet UIView *vViewAbout;
@property (strong, nonatomic) IBOutlet UIView *vViewVersion;
@property (strong, nonatomic) IBOutlet UIView *vViewBuild;
@property (strong, nonatomic) IBOutlet UIView *vViewCredit;
@property (strong, nonatomic) IBOutlet UIView *vViewPrivacy;


@end
