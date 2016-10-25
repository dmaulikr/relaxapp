//
//  SettingView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SettingView.h"
#import "Define.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "SettingAbout.h"
#import "SettingUpdate.h"
#import "NSDate+Extensions.h"
#import "FileHelper.h"
#import "Define.h"
#import "UIImage+ImageEffects.h"
#import "SettingCredit.h"
#import "AppDelegate.h"
#import "RageIAPHelper.h"
@interface SettingView () <MFMailComposeViewControllerDelegate>
{
//    BOOL areUnlockPro;
    BOOL areAdsRemoved;
    NSArray *_products;

}
@end
@implementation SettingView

-(void)awakeFromNib
{
    [super awakeFromNib];
    if (VERSION_PRO) {
        self.contraintHeightAds.constant = 0;
        self.vAds.hidden = YES;
    }
    else
    {
        self.contraintHeightAds.constant = 71;
        self.vAds.hidden = NO;
    }
    self.lbShare.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    
    self.lbTitleCheckUpdate.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
    self.lbTitleLestTalk.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
    self.lbTitleConnectWithUs.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
    self.lbTitleAbout.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
//    self.lbCredit.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
//    self.lbPrivacy.font= [UIFont fontWithName:@"Roboto-Regular" size:13];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(caculatorTimeAgo) name: NOTIFCATION_CATEGORY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _products = app.arrAIP;
    if (!_products) {
        [self reloadIAP];
    }
    areAdsRemoved = VERSION_PRO?1:[[NSUserDefaults standardUserDefaults] boolForKey:kTotalRemoveAdsProductIdentifier];
//    areUnlockPro = [[NSUserDefaults standardUserDefaults] boolForKey:kUnlockProProductIdentifier];
//    _unlockPro.on = areUnlockPro;
    _totalRemoveAds.on = areAdsRemoved;
    [self caculatorTimeAgo];
}
-(void)caculatorTimeAgo
{
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_CATEGORY_SAVE];
    NSDictionary *dicTmp = [NSDictionary dictionaryWithContentsOfFile:strPath];
    if (dicTmp) {
        NSDate * inputDates = dicTmp[@"date"];
        self.timeAgo.text= [inputDates timeAgo];

    }

}
- (IBAction)shareAction:(id)sender {
    NSString * message = @"© 2016 by Relafapp";
    
//    UIImage * image = [UIImage imageNamed:@"icon"];
    
    NSArray * shareItems = @[message];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    
    [self.parent presentViewController:avc animated:YES completion:nil];
    
}
//MARK: -FACEBOOK
- (IBAction)shareFacebookAction:(id)sender {
    
    // Facebook
    [self openUrl:@"http://fb.com/relafapp"];


}
-(void) openUrlInBrowser:(NSString *) url
{
    if (url.length > 0) {
        NSURL *linkUrl = [NSURL URLWithString:url];
        [[UIApplication sharedApplication] openURL:linkUrl];
    }
}
-(void) openUrl:(NSString *) urlString
{
    
    //check if facebook app exists
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        
        // Facebook app installed
        NSArray *tokens = [urlString componentsSeparatedByString:@"/"];
        NSString *profileName = [tokens lastObject];
        
        //call graph api
        NSURL *apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@",profileName]];
        NSData *apiResponse = [NSData dataWithContentsOfURL:apiUrl];
        if(!apiResponse)
        {
            [self openUrlInBrowser:urlString];
            return;
        }
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:apiResponse options:NSJSONReadingMutableContainers error:&error];
        
        //check for parse error
        if (error == nil) {
            
            NSString *profileId = [jsonDict objectForKey:@"id"];
            
            if (profileId.length > 0) {//make sure id key is actually available
                NSURL *fbUrl = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@",profileId]];
                [[UIApplication sharedApplication] openURL:fbUrl];
            }
            else{
                                [self openUrlInBrowser:urlString];
            }
            
        }
        else{//parse error occured
                        [self openUrlInBrowser:urlString];
        }
        
    }
    else{//facebook app not installed
                [self openUrlInBrowser:urlString];
    }
    
}

- (IBAction)shareTwitterAction:(id)sender {
    //twitter
    NSString *urlString = @"https://twitter.com/relafapp";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        [self openUrlInBrowser:urlString];
    }

}
- (IBAction)showEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"relafapp@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    if(mc)
    {
        [self.parent presentViewController:mc animated:YES completion:NULL];
    }
    
}
-(IBAction)aboutAction:(id)sender
{
    self.hidden = YES;
    SettingAbout *viewController1 = [[SettingAbout alloc] initWithClassName:NSStringFromClass([SettingAbout class])];
    [viewController1 addContraintSupview:self.parent.view];
    [viewController1 setCallback:^(){self.hidden = NO;}];
}
-(IBAction)updateAction:(id)sender
{
    
    SettingUpdate *viewController1 = [[SettingUpdate alloc] initWithClassName:NSStringFromClass([SettingUpdate class])];
    [viewController1 addContraintSupview:self.parent.view];
    viewController1.blurredBgImage.image = [self blurWithImageEffects:[self takeSnapshotOfView:self.parent.view]];

}
-(IBAction)creditAction:(id)sender
{
    
    self.hidden = YES;
    SettingCredit *viewController1 = [[SettingCredit alloc] initWithClassName:NSStringFromClass([SettingCredit class])];
    [viewController1 addContraintSupview:self.parent.view];
    [viewController1 setCallback:^(){self.hidden = NO;}];
}
-(IBAction)privacyAction:(id)sender
{
    [self openUrlInBrowser:@"https://www.relafapp.com/privacy.html"];

}
- (IBAction)switchUnlockProValueChanged:(id)sender
{
//    UISwitch *sw = (UISwitch*)sender;
//    if (areUnlockPro) {
//        sw.on = areUnlockPro;
//        return;
//    }
//    else
//    {
//        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        _products = app.arrAIP;
//        
//        NSString * productIdentifier = kUnlockProProductIdentifier;
//        [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
//            if ([product.productIdentifier isEqualToString:productIdentifier]) {
//                [[RageIAPHelper sharedInstance] buyProduct:product];
//                *stop = YES;
//            }
//        }];
//    }
}
- (IBAction)switchRemoveAdsProValueChanged:(id)sender
{
    UISwitch *sw = (UISwitch*)sender;
    if (areAdsRemoved) {
        sw.on = areAdsRemoved;
        return;
    }
    else
    {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _products = app.arrAIP;
        
        NSString * productIdentifier = kTotalRemoveAdsProductIdentifier;
        [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
            if ([product.productIdentifier isEqualToString:productIdentifier]) {
                [[RageIAPHelper sharedInstance] buyProduct:product];
                *stop = YES;
            }
        }];
    }
}
- (void)reloadIAP {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app reloadIAP];
    [app setCallbackAIP:^()
     {
         AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
         _products = app.arrAIP;
     }];
}

- (void)restoreTapped:(id)sender {
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}
- (void)productPurchased:(NSNotification *)notification {
    [self doRemoveAds];
}

- (void)doRemoveAds{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTotalRemoveAdsProductIdentifier];
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:kTotalRemoveAdsProductIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    areUnlockPro = [[NSUserDefaults standardUserDefaults] boolForKey:kUnlockProProductIdentifier];
    
//    _unlockPro.on = areUnlockPro;
    _totalRemoveAds.on = areAdsRemoved;

    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_HIDE_ADS object:nil];

    
}
- (UIImage *)takeSnapshotOfView:(UIView *)view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage *)blurWithImageEffects:(UIImage *)image
{
    return [image applyBlurWithRadius:30 tintColor:[UIColor colorWithWhite:0 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self.parent dismissViewControllerAnimated:YES completion:NULL];
}
@end
