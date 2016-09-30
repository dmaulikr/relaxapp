//
//  BaseView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView
-(instancetype)initWithClassName:(NSString*)className
{
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0] ;
    if (self) {
        [self instance];
    }
    return self;
}

-(void)instance
{
}
-(void)addContraintSupview:(UIView*)viewSuper
{
    UIView *view = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    view.frame = viewSuper.frame;
    
    [viewSuper addSubview:view];
    
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
    
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
}
#pragma mark - CONFIG

-(void)dismissView
{
    [self hide:YES];
}
-(void)hide:(BOOL)hidden
{
    
    if (hidden) {
        _contraintBottom.constant = self.frame.size.height;
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: 0
                         animations:^
         {
             [self layoutIfNeeded]; // Called on parent view
         }
                         completion:^(BOOL finished)
         {
             
             NSLog(@"HIDE");
             self.hidden = hidden;
         }];
    }
    else
    {
        self.hidden = hidden;
        _contraintBottom.constant = 0;
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: 0
                         animations:^
         {
             [self layoutIfNeeded]; // Called on parent view
         }
                         completion:^(BOOL finished)
         {
             
             NSLog(@"SHOW");
         }];
    }
    
}
-(void)setup
{
    self.hidden = YES;
    _contraintBottom.constant = self.frame.size.height;
}
@end
