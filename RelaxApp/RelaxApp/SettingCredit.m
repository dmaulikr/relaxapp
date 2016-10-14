//
//  CreaterTimer.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SettingCredit.h"
#import "Define.h"
#import "FileHelper.h"
@interface SettingCredit ()
{

}
@end

@implementation SettingCredit

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.imgBackGround.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);

}
-(void)setCallback:(SettingCreditCallback)callback
{
    _callback = callback;
}
-(void)dismissKeyboard {
    [self endEditing:YES];
}

-(IBAction)closeAction:(id)sender
{
    if (_callback) {
        _callback();
    }
    [self removeFromSuperview];
}
@end
