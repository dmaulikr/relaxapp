//
//  VolumeView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "VolumeItem.h"
#import "Define.h"
extern float volumeItem;

@implementation VolumeItem

-(instancetype)initWithClassName:(NSString*)className
{
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0] ;
    if (self) {
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleFull.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    self.titleSub.font = [UIFont fontWithName:@"Roboto-Medium" size:11];
    [self.slider setMinimumTrackTintColor:UIColorFromRGB(COLOR_SLIDER_THUMB)];
    [self.slider setMaximumTrackTintColor:[UIColor whiteColor]];
    [self.slider setThumbImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
    [self.vBackGround setBackgroundColor:UIColorFromRGB(COLOR_VOLUME)];
    dicMusic = [NSMutableDictionary new];
}
-(void)addContraintSupview:(UIView*)viewSuper
{
    UIView *view = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    view.frame = viewSuper.frame;
    
    [viewSuper addSubview:view];
    [viewSuper addConstraint: [NSLayoutConstraint
                               constraintWithItem:view attribute:NSLayoutAttributeLeading
                               relatedBy:NSLayoutRelationEqual
                               toItem:viewSuper
                               attribute:NSLayoutAttributeLeading
                               multiplier:1.0 constant:0] ];
    
    
    [viewSuper addConstraint: [NSLayoutConstraint
                               constraintWithItem:view attribute:NSLayoutAttributeTrailing
                               relatedBy:NSLayoutRelationEqual
                               toItem:viewSuper
                               attribute:NSLayoutAttributeTrailing
                               multiplier:1.0 constant:0] ];
    [viewSuper addConstraint: [NSLayoutConstraint
                               constraintWithItem:view attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:viewSuper
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0 constant:0] ];
}
-(IBAction)dismissView:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)volumeSliderEdittingDidBegin:(id)sender
{
    [timer invalidate];
    timer = nil;

    UISlider *slider = (UISlider*)sender;
    float volume =  slider.value;
    volumeItem = volume;
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
    [self.slider setValue:[dic[@"volume"] floatValue]];

}

@end
