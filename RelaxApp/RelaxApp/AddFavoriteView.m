//
//  AddFavoriteView.m
//  RelaxApp
//
//  Created by JoJo on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "AddFavoriteView.h"
#import "Define.h"
#import "FileHelper.h"
@implementation AddFavoriteView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = UIColorFromRGB(COLOR_NAVIGATION_FAVORITE);
    [self.vContent.layer setMasksToBounds:YES];
    self.vContent.layer.cornerRadius= 5.0;
    [self.btnSave.layer setMasksToBounds:YES];
    self.btnSave.layer.cornerRadius= 5.0;

    _dataSource = [NSMutableArray new];
}
-(void)fnSetDataMusic:(NSArray*)arr
{
    _dataSource = [NSMutableArray new];

    _dataMusic = arr;
    for (NSDictionary *dicMusic in arr) {
        AHTag *tag = [AHTag new];
        tag.title =dicMusic[@"titleShort"];
        [_dataSource addObject:tag];
    }
    [self.label fnSetTags:_dataSource withScreen:0] ;
}
-(IBAction)saveAction:(id)sender
{
    if (_tfTitle.text.length > 0) {
        NSDictionary *dicSave = @{@"name": _tfTitle.text,@"music": _dataMusic};
        //read in cache
        NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
        NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
        NSMutableArray *arrSave = [arrTmp mutableCopy];
        [arrSave addObject:dicSave];
        //save cache
        [arrSave writeToFile:strPath atomically:YES];
        [self removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Relax App"
                                                        message:@"Success"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
-(IBAction)cancelAction:(id)sender
{
    self.hidden = YES;
}
@end
