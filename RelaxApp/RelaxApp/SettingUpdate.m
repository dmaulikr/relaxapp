//
//  CreaterTimer.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SettingUpdate.h"
#import "Define.h"
#import "FileHelper.h"
#import "AFHTTPSessionManager.h"
#import "DownLoadCategory.h"
#import "UIAlertView+Blocks.h"
#import "AppDelegate.h"
@interface SettingUpdate ()
{
    AFHTTPSessionManager *managerCategory;

}
@end

@implementation SettingUpdate

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.btnCancel.layer setMasksToBounds:YES];
    self.btnCancel.layer.cornerRadius= 23.0;
    self.btnCancel.hidden = YES;
    // Blurred with UIImage+ImageEffects
    //show ads
    areUnlockPro = [[NSUserDefaults standardUserDefaults] boolForKey:kUnlockProProductIdentifier];
    if (areUnlockPro) {
        [UIAlertView showWithTitle:@"Do you want update something new?" message:@"By Clicking OK you permit the app download and use free storage on your phone"
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@[@"OK"]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              
                              if (buttonIndex == 1) {
                                  //OK button handler
                                       self.btnCancel.hidden = NO;
                                       [self updateAction:nil];
                              }
                              else
                              {
                                  //Cancel button handler
                                  [self closeAction:nil];
                                  
                              }
                          }];
    }
    else
    {
        [UIAlertView showWithTitle:@"Watch a video to check update in this time !" message:@"By Clicking OK you permit the app download and use free storage on your phone"
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@[@"OK"]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              
                              if (buttonIndex == 1) {
                                  //OK button handler
                                  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                  [app startNewAds];
                                  [app setCallbackDismissAds:^()
                                   {
                                       self.btnCancel.hidden = NO;
                                       [self updateAction:nil];
                                       
                                   }];
                              }
                              else
                              {
                                  //Cancel button handler
                                  [self closeAction:nil];
                                  
                              }
                          }];

    }
    
    self.percentageDoughnut.dataSource              = self;
    self.percentageDoughnut.percentage              = 0;
    self.percentageDoughnut.linePercentage          = 0.15;
    self.percentageDoughnut.animationDuration       = 2;
    self.percentageDoughnut.decimalPlaces           = 1;
    self.percentageDoughnut.showTextLabel           = YES;
    self.percentageDoughnut.animatesBegining        = NO;
    self.percentageDoughnut.fillColor               = UIColorFromRGB(COLOR_PROGRESS);
    self.percentageDoughnut.unfillColor             = [UIColor clearColor];
    self.percentageDoughnut.textLabel.textColor     = [UIColor whiteColor];
    self.percentageDoughnut.textLabel.font          =  [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.percentageDoughnut.gradientColor1          = [UIColor clearColor];
    self.percentageDoughnut.gradientColor2          = [UIColor clearColor];

}


-(void)dismissKeyboard {
    [self endEditing:YES];
}

-(IBAction)closeAction:(id)sender
{
    self.viewProgress.hidden = YES;
    [[DownLoadCategory sharedInstance] resetParam];
    [self removeFromSuperview];
}
-(IBAction)updateAction:(id)sender
{
    self.viewProgress.hidden = NO;
    self.percentageDoughnut.percentage              = 0;
    managerCategory = [AFHTTPSessionManager manager];
    [managerCategory GET:[NSString stringWithFormat:@"%@%@",BASE_URL,@"data.json"] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"categories"] isKindOfClass:[NSArray class]]) {
            //free
            NSMutableArray *arrTmp = [NSMutableArray new];
            for (NSDictionary *dic in responseObject[@"categories"]) {
                if (![dic[@"price"] boolValue]) {
                    [arrTmp addObject:dic];
                }
                
            }
            [self fnGetListCategory: arrTmp];

        }
        else
        {
            [self closeAction:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_SHOW_ADS object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_CATEGORY object:nil];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NAME_APP
                                                            message:@"Bad network"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [self closeAction:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_SHOW_ADS object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_CATEGORY object:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NAME_APP
                                                        message:@"Bad network"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];

}
-(void)fnGetListCategory:(NSArray*)arrCategory
{
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_CATEGORY_SAVE];
    NSDictionary *dicCache = [NSDictionary dictionaryWithContentsOfFile:strPath];
    NSArray *arrCache = dicCache[@"category"];
    //remove blacklist
    NSString *strPathBlackList = [FileHelper pathForApplicationDataFile:FILE_BLACKLIST_CATEGORY_SAVE];
    NSArray *arrBlackList =@[];
    [arrBlackList writeToFile:strPathBlackList atomically:YES];
    
    NSMutableArray *arrUpdate = [NSMutableArray new];
    for (NSDictionary *dic in arrCategory) {
        for (NSDictionary *dicTmp in arrCache) {
            int  _id = [dic[@"id"] intValue];
            int  _id_Tmp = [dicTmp[@"id"] intValue];
            int _md5 = [dic[@"md5"] intValue];
            int _md5_Tmp = [dicTmp[@"md5"] intValue];
            BOOL price = [dic[@"price"] boolValue];
            if ((_id == _id_Tmp) && (_md5 > _md5_Tmp) &&(!price)){
                [arrUpdate addObject:dic];
            }
        }
    }
    
    if (arrCategory.count > 0) {
        NSDate *date = [NSDate date];
        NSDictionary *dicTmp = @{@"category": arrCategory,@"date":date};
        [dicTmp writeToFile:strPath atomically:YES];
    }
    if (arrUpdate.count) {
        [self downloadSoundWithCategory:arrUpdate];
    }
    else
    {
        [self closeAction:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_SHOW_ADS object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_CATEGORY object:nil];
        
    }

}
-(void)downloadSoundWithCategory:(NSArray*)arrCategory
{
    self.percentageDoughnut.percentage              = 0;
    DownLoadCategory *download = [DownLoadCategory sharedInstance];
    [download fnListMusicWithCategory:arrCategory];
    [download setCallback:^(NSDictionary *dicItemCategory)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             self.viewProgress.hidden = YES;
             [self closeAction:nil];
             [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_SHOW_ADS object:nil];
             [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_CATEGORY object:nil];
             
         });
     }];
    [download setCallbackProgess:^(float progress)
     {
         dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.percentageDoughnut.percentage   = progress;
             });
         });
         
     }];
}

@end
