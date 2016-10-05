//
//  CreaterTimer.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "CreaterTimer.h"
#import "Define.h"
#import "FileHelper.h"
@interface CreaterTimer ()
{
    NSArray *_arrCategory;
    NSDictionary *dicChooseCategory;
}
@end

@implementation CreaterTimer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vContent.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
    self.vViewNav.backgroundColor = UIColorFromRGB(COLOR_NAVIGATION_FAVORITE);
    // read cache favorite
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
    NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
    _arrCategory = arrTmp;
    //test
    dicChooseCategory = _arrCategory[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(IBAction)saveAction:(id)sender
{
    if (_tfTitle.text.length > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"hh:mm:ss"];
        NSString *timer = [dateFormatter stringFromDate:_timeToSetOff.date];
        
        //read in cache
        NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
        NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
        NSDictionary *lastFavorite = [arrTmp lastObject];
        int _id = [lastFavorite[@"id"] intValue] + 1;
        NSDictionary *dicSave = @{@"id":@(_id),
                                  @"name": _tfTitle.text,
                                  @"type": @(TIMER_COUNTDOWN),
                                  @"active":@(0),
                                  @"description":@"",
                                  @"timer": timer,
                                  @"id_favorite": dicChooseCategory[@"id"]};
        
        NSMutableArray *arrSave = [arrTmp mutableCopy];
        [arrSave addObject:dicSave];
        //save cache
        [arrSave writeToFile:strPath atomically:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Relax App"
                                                        message:@"Success"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
