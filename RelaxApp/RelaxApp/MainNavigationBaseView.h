//
//  MainNavHome.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void (^callBackMainNav) (UIButton*);

@interface MainNavigationBaseView : UIView
@property (nonatomic, strong) IBOutlet UILabel *myTitle;
@property (nonatomic, copy) callBackMainNav myMainNavCallback;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadConstraintWidth;
@property (strong, nonatomic) IBOutlet UIImageView *imgUpload;


-(IBAction)fnMainNavClick:(id)sender;

@end
