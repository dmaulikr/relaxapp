//
//  BaseVC.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabVC.h"
@interface BaseVC : UIViewController
@property (nonatomic, strong) IBOutlet UIView *vContrainer;
@property (nonatomic, strong) TabVC *vBottom;
-(void) addMainNav:(NSString*) nameView;
@end
