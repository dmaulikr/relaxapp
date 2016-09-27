//
//  BaseVC.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "MainNavigationController.h"
#import "AppDelegate.h"

@interface MainNavigationController ()

/**
 *	@Author Clément Padovani, 14-10-07 11:10
 *
 *	@brief  Classes to SHOW the tab bar.
 */

@property (nonatomic, copy) NSArray *whiteListedClasses;

/**
 *	@Author Clément Padovani, 14-10-07 11:10
 *
 *	@brief  Classes to HIDE the tab bar.
 */

@property (nonatomic, copy) NSArray *blackListedClasses;

@end

@implementation MainNavigationController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"didShowViewController:%@", viewController);
    
    if (self.completionBlock && self.pushedVC == viewController) {
        self.completionBlock();
    }
    self.completionBlock = nil;
    self.pushedVC = nil;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.pushedVC != viewController) {
        self.pushedVC = nil;
        self.completionBlock = nil;
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completion {
    self.pushedVC = viewController;
    self.completionBlock = completion;
    [self pushViewController:viewController animated:animated];
}

@end
