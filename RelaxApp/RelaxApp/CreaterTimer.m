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
    
    _timeToSetOff.backgroundColor = [UIColor whiteColor];
//    [_timeToSetOff setValue:[UIColor whiteColor] forKey:@"textColor"];
//    [_timeToSetOff setValue:@(0.8) forKey:@"alpha"];

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
        [dateFormatter setDateFormat:@"hh:mm"];
        NSString *timer = [dateFormatter stringFromDate:_timeToSetOff.date];
        
        //read in cache
        NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
        NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
        NSDictionary *lastFavorite = [arrTmp lastObject];
        int _id = [lastFavorite[@"id"] intValue] + 1;
        NSDictionary *dicSave = @{@"id":@(_id),
                                  @"name": _tfTitle.text,
                                  @"type": @(_timerType),
                                  @"active":@(0),
                                  @"description":@"",
                                  @"timer": timer,
                                  @"id_favorite": dicChooseCategory[@"id"]};
        
        NSMutableArray *arrSave = [NSMutableArray new];
        if (arrTmp) {
            [arrSave addObjectsFromArray:arrTmp];
        }
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
-(NSString*)convertDateToString:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
        
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}
-(NSDate*)convertStringToDate:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}
@end
