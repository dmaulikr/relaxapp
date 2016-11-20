//
//  ImageViewAction.m
//  Naturapass
//
//  Created by Manh on 11/26/15.
//  Copyright © 2015 Appsolute. All rights reserved.
//

#import "ImageViewAction.h"

@implementation ImageViewAction
- (void)awakeFromNib {
    [super awakeFromNib];
    [self removeGestureRecognizer:_singleTap];
}
-(void)fnRemoveClick
{
    [self removeGestureRecognizer:_singleTap];
}
-(void)setOncallback:(onCallBack)oncallback
{
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    _singleTap.numberOfTapsRequired = 1;
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:_singleTap];
    _oncallback = oncallback;
    
}
-(void)tapDetected{
    if (self.oncallback) {
        self.oncallback(self.tag);
    }
}

@end
