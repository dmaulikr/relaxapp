//
//  CollectionCell.m
//  RelaxApp
//
//  Created by JoJo on 9/28/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imgIcon.layer setMasksToBounds:YES];
    self.imgIcon.layer.cornerRadius= 10.0;
}

@end
