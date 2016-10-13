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
#import "MBProgressHUD.h"
#import "DownLoadCategory.h"
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

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want update something new?"
                                                    message:@"By Clicking OK you permit the app download and use free storage on your phone"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles: @"OK", nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex){
        case 0:
            //Cancel button handler
            [self closeAction:nil];
            break;
        case 1:
            //OK button handler
            self.btnCancel.hidden = NO;
            [self updateAction:nil];
            break;
        default:
            break;
    }
}

-(void)dismissKeyboard {
    [self endEditing:YES];
}

-(IBAction)closeAction:(id)sender
{
    [self removeFromSuperview];
}
-(IBAction)updateAction:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = @"Updating...";

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
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];

}
-(void)fnGetListCategory:(NSArray*)arrCategory
{
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_CATEGORY_SAVE];
    NSDictionary *dicCache = [NSDictionary dictionaryWithContentsOfFile:strPath];
    NSArray *arrCache = dicCache[@"category"];

    NSMutableArray *arrUpdate = [NSMutableArray new];
    
    for (NSDictionary *dic in arrCategory) {
        for (NSDictionary *dicTmp in arrCache) {
            if (([dic[@"id"] intValue] == [dicTmp[@"id"] intValue])
                && ([dic[@"md5"] intValue] > [dicTmp[@"md5"] intValue])
                //free
                &&(![dic[@"price"] boolValue])) {
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
    }

}
-(void)downloadSoundWithCategory:(NSArray*)arrCategory
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = @"Downloading...";
    
    DownLoadCategory *download = [DownLoadCategory sharedInstance];
    [download fnListMusicWithCategory:arrCategory];
    [download setCallback:^(NSDictionary *dicItemCategory)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [hud hideAnimated:YES];
             [self closeAction:nil];
             [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_CATEGORY object:nil];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NAME_APP
                                                             message:@"Success"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];

         });
     }];
    [download setCallbackProgess:^(float progress)
     {
         dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD HUDForView:self].progress = progress;
             });
         });
         
     }];
}

@end
