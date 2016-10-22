//
//  AppDelegate.m
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import "FileHelper.h"
#import "RageIAPHelper.h"
@import Firebase;
@interface AppDelegate ()<GADInterstitialDelegate>
{
    NSTimer* timer;
    HomeVC *viewController1;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RageIAPHelper sharedInstance];
    [self reloadIAP];
    // [START configure]
    [FIRApp configure];
    // [END configure]
    // Initialize Google Mobile Ads SDK
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-1671106005232686~9687608051"];

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];

    // Override point for customization after application launch.
    viewController1 = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    
    [self.window setRootViewController:self.navigationController ];

    [self.window makeKeyAndVisible];
    [self timerBackGround];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)setCallback:(AppDelegateCallback)callback
{
    _callback = callback;
}
-(void)setCallbackTimerTick:(TimerTickCallback)callbackTimerTick
{
    _callbackTimerTick = callbackTimerTick;
}
-(void)timerBackGround
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //How often to update the clock labels
        timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(myTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });


}
-(void)stopTimerBackGround
{
    [timer invalidate];
    timer = nil;
}
-(void)myTimerAction
{

    NSDate *date = [NSDate date];
    NSString *strCurrentDate = [self convertDateToString:date];
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
    NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
    if (arrTmp.count> 0) {
        NSMutableArray *arrSave = [arrTmp mutableCopy];
        for (int i = 0; i < arrSave.count; i++) {
            NSDictionary *dicTimer = arrSave[i];
            if ([dicTimer[@"enabled"] boolValue]) {
                if ([dicTimer[@"type"] intValue] == TIMER_CLOCK) {
                    NSString *strTimer = [self convertDateToString:dicTimer[@"timer"]];
                    if ([self checkDateEqualDate:strCurrentDate withTimer:strTimer]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_TIMER object:dicTimer];
                        if (_callback) {
                            _callback(dicTimer);
                        }
                    }
                }
                else
                {
                    int countDown = [dicTimer[@"countdown"] intValue];
                    if (countDown <= 1) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_TIMER object:dicTimer];
                        if (_callback) {
                            _callback(dicTimer);
                        }
                        NSMutableDictionary *dicTmp = [dicTimer mutableCopy];
                        [dicTmp setObject:@(0) forKey:@"enabled"];
                        [dicTmp setObject:@(0) forKey:@"countdown"];
                        [arrSave replaceObjectAtIndex:i withObject:dicTmp];
                    }
                    else
                    {
                        countDown -= 1;
                        NSMutableDictionary *dicTmp = [dicTimer mutableCopy];
                        [dicTmp setObject:@(countDown) forKey:@"countdown"];
                        [arrSave replaceObjectAtIndex:i withObject:dicTmp];
                    }
                    [arrSave writeToFile:strPath atomically:YES];

                }
            }
        }

    }
    if (_callbackTimerTick) {
        _callbackTimerTick(nil);
    }
}

-(NSDate*)convertStringToDate:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];

    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}
-(NSString*)convertDateToString:(NSDate*)date
{
    //
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH:mm"];
    NSString *stringFromDate1 = [formatter1 stringFromDate:date];

    NSDate *date1 =[formatter1 dateFromString:stringFromDate1];
    //
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:date1];
    return stringFromDate;
}
-(BOOL)checkDateEqualDate:(NSString*)time1 withTimer:(NSString*)time2
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date1= [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    
    NSComparisonResult result = [date1 compare:date2];
    if(result == NSOrderedSame)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark Game logic
-(void)setCallbackDismissAds:(DismisAdsDelegateCallback)callbackDismissAds
{
    _callbackDismissAds = callbackDismissAds;
}
- (void)startNewAds {
    [self createAndLoadInterstitial];
}
-(void)showAds
{
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:viewController1];
    } else {
        NSLog(@"Ad wasn't ready");
    }
    
}
- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:FIREBASE_INTERSTITIAL_UnitID];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    [self.interstitial loadRequest:request];
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [self showAds];
//    [self performSelector:@selector(showAds) withObject:nil afterDelay:1.0];
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{

}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    if (_callbackDismissAds) {
        _callbackDismissAds();
    }
}
//MARK: -AIP
-(void)setCallbackAIP:(AIPDelegateCallback)callbackAIP
{
    _callbackAIP = callbackAIP;
}
- (void)reloadIAP {
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _arrAIP = products;
            if (_callbackAIP) {
                _callbackAIP();
            }
        }
    }];
}
@end
