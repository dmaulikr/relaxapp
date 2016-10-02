//
//  VolumeView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "VolumeItem.h"
#import "Define.h"
@implementation VolumeItem

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
    [self.slider setMinimumTrackTintColor:UIColorFromRGB(COLOR_SLIDER_THUMB)];
    [self.slider setMaximumTrackTintColor:[UIColor whiteColor]];
    [self.slider setThumbImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
    [self.vBackGround setBackgroundColor:UIColorFromRGB(COLOR_VOLUME)];
    dicMusic = [NSMutableDictionary new];
}
-(IBAction)dismissView:(id)sender
{
    self .hidden = YES;
}
- (IBAction)volumeSliderChanged:(id)sender
{

}
- (IBAction)volumeSliderEdittingDidBegin:(id)sender
{
    [timer invalidate];
    timer = nil;

    UISlider *slider = (UISlider*)sender;
    float volume =  slider.value;
    if (dicMusic) {
        [dicMusic setObject:@(volume) forKey:@"volume"];
        if (_callback) {
            _callback(dicMusic);
        }
    }
}
- (IBAction)volumeSliderEdittingDidEnd:(id)sender
{
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                             target: self
                                           selector:@selector(dismissView:)
                                           userInfo: nil repeats:NO];
}
-(void)showVolumeWithDicMusic:(NSDictionary*)dic
{
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                                  target: self
                                                selector:@selector(dismissView:)
                                                userInfo: nil repeats:NO];
    dicMusic = [dic mutableCopy];
    self.titleFull.text = dicMusic[@"titleFull"];
    self.titleSub.text = [NSString stringWithFormat:@"%@,%@",dic[@"titleShort"],dic[@"titleOther"]];
    [self hide:NO];
}

@end
