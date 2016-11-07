//
//  AppCommon.m
//  Arcatime
//
//  Created by ocsdeveloper12 on 16/07/13.
//  Copyright (c) 2013 ocsdeveloper12. All rights reserved.
//

#import "AppCommon.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/xattr.h>
#import "FileHelper.h"
#import "Define.h"
#import "UIAlertView+Blocks.h"

AppCommon *SharedCommon = nil;
static int countNetworkIssue;

@implementation AppCommon

+ (AppCommon *) common
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		SharedCommon = [[self alloc] init];
        countNetworkIssue = 0;
	});
	
	return SharedCommon;
}

#pragma mark - Reachable
- (BOOL) isReachable {
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) || !([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable))
        return YES;
    else
    {
        return NO;
    }
}
- (BOOL) isReachableCheck {
     if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) || !([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable))
        return YES;
    else
    {
        [UIAlertView showWithTitle:@"OOPS you are Offline" message:@"You need to connect to Wifi or Mobile data to access data!"
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              
                              if (buttonIndex == 1) {
                              }
                          }];
        return NO;
    }
}
@end
