//
//  CreaterTimer.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "CreaterTimer.h"
#import "Define.h"
@interface CreaterTimer ()

@end

@implementation CreaterTimer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vContent.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
    self.vViewNav.backgroundColor = UIColorFromRGB(COLOR_NAVIGATION_FAVORITE);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(IBAction)addActionAction:(id)sender
{
}
@end
