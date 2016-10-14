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
@interface SettingView () <MFMailComposeViewControllerDelegate>

@end
@implementation SettingView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.lbTitle.font = [UIFont fontWithName:@"Roboto-Medium" size:16];
    self.lbShare.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    
    self.lbTitleCheckUpdate.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
    self.lbTitleLestTalk.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
    self.lbTitleConnectWithUs.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
    self.lbTitleAbout.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(caculatorTimeAgo) name: NOTIFCATION_CATEGORY object:nil];
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
- (IBAction)shareFacebookAction:(id)sender {
    // Facebook
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [tweet setInitialText:@"Initial tweet text."];
        [tweet setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             if (result == SLComposeViewControllerResultCancelled)
             {
                 NSLog(@"The user cancelled.");
             }
             else if (result == SLComposeViewControllerResultDone)
             {
                 NSLog(@"The user sent the post.");
             }
         }];
        [self.parent presentViewController:tweet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
                                                        message:@"Facebook integration is not available.  Make sure you have setup your Facebook account on your device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }

}

- (IBAction)shareTwitterAction:(id)sender {
    // Twitter
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweet setInitialText:@"This is my first tweet!"];
        [tweet setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             if (result == SLComposeViewControllerResultCancelled)
             {
                 NSLog(@"The user cancelled.");
             }
             else if (result == SLComposeViewControllerResultDone)
             {
                 NSLog(@"The user sent the tweet");
             }
         }];
        [self.parent presentViewController:tweet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
                                                        message:@"Twitter integration is not available.  A Twitter account must be set up on your device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}
- (IBAction)showEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"iOS programming is so fun!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@relaxapp.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self.parent presentViewController:mc animated:YES completion:NULL];
    
}
-(IBAction)aboutAction:(id)sender
{
    SettingAbout *viewController1 = [[SettingAbout alloc] initWithNibName:@"SettingAbout" bundle:nil];
    [self.parent presentViewController:viewController1 animated:YES completion:^{
    }];

}
-(IBAction)updateAction:(id)sender
{
    
    SettingUpdate *viewController1 = [[SettingUpdate alloc] initWithClassName:NSStringFromClass([SettingUpdate class])];
    [viewController1 addContraintSupview:self.parent.view];
    viewController1.blurredBgImage.image = [self blurWithImageEffects:[self takeSnapshotOfView:self.parent.view]];

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
