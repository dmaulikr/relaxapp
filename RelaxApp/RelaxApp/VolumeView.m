//
//  VolumeView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "VolumeView.h"
#import "Define.h"
@implementation VolumeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.btnDecrease setTitleColor:UIColorFromRGB(COLOR_SLIDER_THUMB) forState:UIControlStateNormal];
    [self.btnIncrease setTitleColor:UIColorFromRGB(COLOR_SLIDER_THUMB) forState:UIControlStateNormal];
    [self.slider setMinimumTrackTintColor:UIColorFromRGB(COLOR_SLIDER_THUMB)];
    [self.slider setMaximumTrackTintColor:[UIColor whiteColor]];
    [self.slider setThumbImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
    [self.vBackGround setBackgroundColor:UIColorFromRGB(COLOR_VOLUME)];
}
-(IBAction)dismissView:(id)sender
{
    self .hidden = YES;
}
- (IBAction)volumeSliderChanged:(id)sender
{
    UISlider *slider = (UISlider*)sender;
}
@end
