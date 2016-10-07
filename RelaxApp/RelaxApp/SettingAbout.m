//
//  CreaterTimer.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SettingAbout.h"
#import "Define.h"
#import "FileHelper.h"
@interface SettingAbout ()
{

}
@end

@implementation SettingAbout

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vContent.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
    self.vViewNav.backgroundColor = UIColorFromRGB(COLOR_NAVIGATION_FAVORITE);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
