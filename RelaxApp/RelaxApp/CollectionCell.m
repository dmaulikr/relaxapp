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
   self.lbTitle.font = [UIFont fontWithName:@"Roboto-Regular" size:10];
    [self.imgIcon.layer setMasksToBounds:YES];
    self.imgIcon.layer.cornerRadius= 10.0;
    /**Adds a gesture recognizer for a long press.*/
    UILongPressGestureRecognizer * pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    pressRecognizer.minimumPressDuration = 1.5;
    [self addGestureRecognizer:pressRecognizer];
    
    /**Adds a gesture recognizer for a tab.*/
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [tapRecognizer requireGestureRecognizerToFail:pressRecognizer];
    [self addGestureRecognizer:tapRecognizer];

}
#pragma mark User-Interaction handling

-(void)handleTap:(UIGestureRecognizer *)gestureRecognizer{
    if (_callback) {
        _callback(GESTURE_TAP,self.imgIcon.tag);
    }
 
}

-(void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (_callback) {
        _callback(GESTURE_LONG,self.imgIcon.tag);
    }
}
-(void)setCallback:(CollectionCellCallback)callback
{
    _callback = callback;
}
- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}
@end
