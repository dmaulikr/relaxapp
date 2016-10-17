//
//  AppDelegate.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavigationController.h"
#import <Firebase/FirebaseApp.h>
typedef void (^AppDelegateCallback)(NSDictionary *dicTimer);
typedef void (^TimerTickCallback)();

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic,copy) AppDelegateCallback callback;
@property (nonatomic,copy) TimerTickCallback  callbackTimerTick;

@end

