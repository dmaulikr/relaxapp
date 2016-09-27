//
//  BaseVC.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic,copy) dispatch_block_t completionBlock;
@property (nonatomic,strong) UIViewController * pushedVC;

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completion;

@end
