//
//  FavoriteView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "FavoriteView.h"
#import "Define.h"
@implementation FavoriteView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.vContent.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
    self.vViewNav.backgroundColor = UIColorFromRGB(COLOR_NAVIGATION_FAVORITE);
}

@end
