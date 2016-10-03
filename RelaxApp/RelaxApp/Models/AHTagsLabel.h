//
//  AHTagsLabel.h
//  AutomaticHeightTagTableViewCell
//
//  Created by WEI-JEN TU on 2016-07-16.
//  Copyright © 2016 Cold Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHTag.h"

@interface AHTagsLabel : UILabel
@property (nonatomic, strong) NSArray *tags;
- (void)fnSetTags:(NSArray*)tags withScreen:(int)screen;
@end
