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
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbShare;
@property (strong, nonatomic) IBOutlet UILabel *lbTitleCheckUpdate;
@property (strong, nonatomic) IBOutlet UILabel *lbTitleLestTalk;
@property (strong, nonatomic) IBOutlet UILabel *lbTitleConnectWithUs;
@property (strong, nonatomic) IBOutlet UILabel *lbTitleAbout;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackGround;

@end
