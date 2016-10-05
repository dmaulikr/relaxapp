//
//  AddFavoriteView.m
//  RelaxApp
//
//  Created by JoJo on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "AddFavoriteView.h"
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
-(void)fnSetInfoFavorite:(NSDictionary*)dicFavorite
{
    _dicFavorite = dicFavorite;
    if (_modeType == MODE_INFO) {
        _tfTitle.enabled = NO;
        _btnSave.hidden = YES;
        _lbTitle.text = @"Info to favorites";
    }
    else
    {
        _lbTitle.text = @"Edit to favorites";
    }
    _tfTitle.text = dicFavorite[@"name"];
    
    _dataSource = [NSMutableArray new];
    
    _dataMusic = dicFavorite[@"music"];
    for (NSDictionary *dicMusic in _dataMusic) {
        AHTag *tag = [AHTag new];
        tag.title =dicMusic[@"titleShort"];
        [_dataSource addObject:tag];
    }
    [self.label fnSetTags:_dataSource withScreen:0] ;

}
-(void)fnSetDataMusic:(NSArray*)arr
{
    _lbTitle.text = @"Add to favorites";
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
        if (_modeType == MODE_EDIT) {
            NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
            NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
            NSMutableArray *arrSave = [NSMutableArray new];
            if (arrTmp) {
                [arrSave addObjectsFromArray:arrTmp];
            }
            
            for (int i = 0 ; i< arrSave.count; i++) {
                if ([_dicFavorite[@"id"] intValue] == [arrSave[i][@"id"]intValue]) {
                    NSDictionary *dicSave = @{@"id":_dicFavorite[@"id"],@"name": _tfTitle.text,@"music": _dicFavorite[@"music"]};
                    [arrSave replaceObjectAtIndex:i withObject:dicSave];
                    [arrSave writeToFile:strPath atomically:YES];
                    [self removeFromSuperview];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Relax App"
                                                                    message:@"Success"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    if (_callback) {
                        _callback(dicSave);
                    }
                    break;
                }
            }
        }
        else
        {
            //read in cache
            NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
            NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
            NSDictionary *lastFavorite = [arrTmp lastObject];
            int _id = [lastFavorite[@"id"] intValue] + 1;
            NSDictionary *dicSave = @{@"id":@(_id),@"name": _tfTitle.text,@"music": _dataMusic};
            
            NSMutableArray *arrSave = [NSMutableArray new];
            if (arrTmp) {
                [arrSave addObjectsFromArray:arrTmp];
            }
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
}
-(IBAction)cancelAction:(id)sender
{
    self.hidden = YES;
}
-(void)setCallback:(AddFavoriteViewCallback)callback
{
    _callback = callback;
}
@end
