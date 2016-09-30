//
//  VolumeView.h
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface VolumeView : BaseView
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UIButton *btnDecrease;
@property (nonatomic, strong) IBOutlet UIButton *btnIncrease;
@property (nonatomic, strong) IBOutlet UIImageView *vBackGround;

@end
