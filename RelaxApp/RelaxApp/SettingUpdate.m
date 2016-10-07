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
@interface SettingUpdate ()
{
    AFHTTPSessionManager *managerCategory;

}
@end

@implementation SettingUpdate

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnUpdate.layer setMasksToBounds:YES];
    self.btnUpdate.layer.cornerRadius= 4.0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(IBAction)updateAction:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = @"Updating...";

    managerCategory = [AFHTTPSessionManager manager];
    [managerCategory GET:[NSString stringWithFormat:@"%@%@",BASE_URL,@"data.json"] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"categories"] isKindOfClass:[NSArray class]]) {
            NSArray *arrCategory = responseObject[@"categories"];
            NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_CATEGORY_SAVE];
            if (arrCategory.count > 0) {
                NSDate *date = [NSDate date];
                NSDictionary *dicTmp = @{@"category": arrCategory,@"date":date};
                [dicTmp writeToFile:strPath atomically:YES];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_CATEGORY object:nil];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NAME_APP
                                                            message:@"Success"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

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
@end
