//
//  AppDelegate.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

typedef void (^AppDelegateCallback)(NSDictionary *dicTimer);
typedef void (^TimerTickCallback)();
typedef void (^DismisAdsDelegateCallback)();

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic,copy) AppDelegateCallback callback;
@property (nonatomic,copy) TimerTickCallback  callbackTimerTick;
@property (nonatomic,copy) DismisAdsDelegateCallback  callbackDismissAds;

@property(nonatomic, strong) GADInterstitial *interstitial;
- (void)startNewAds;
@end

