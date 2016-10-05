//
//  CreaterTimer.h
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreaterTimer : UIViewController
@property (nonatomic, strong) IBOutlet UIView *vViewNav;
@property (nonatomic, strong) IBOutlet UIView *vContent;
@property (nonatomic, strong) IBOutlet UITextField *tfTitle;
@property (nonatomic, strong) IBOutlet UIDatePicker *timeToSetOff;
@property(nonatomic,assign) BOOL editMode;

@end
