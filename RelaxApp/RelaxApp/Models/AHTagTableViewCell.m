//
//  AHTagTableViewCell.m
//  AutomaticHeightTagTableViewCell
//
//  Created by WEI-JEN TU on 2016-07-16.
//  Copyright © 2016 Cold Yam. All rights reserved.
//

#import "AHTagTableViewCell.h"

@implementation AHTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _dataSource = [NSMutableArray new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)fnSetDataWithDicMusic:(NSDictionary*)dicMusic
{
    self.title.text = dicMusic[@"name"];
    _dataSource = [NSMutableArray new];

    NSArray *arrMusic = dicMusic[@"music"];
    for (NSDictionary *dicMusic in arrMusic) {
        AHTag *tag = [AHTag new];
        tag.title =dicMusic[@"titleShort"];
        [_dataSource addObject:tag];
    }
    [self.label fnSetTags:_dataSource withScreen:1];
}
@end
