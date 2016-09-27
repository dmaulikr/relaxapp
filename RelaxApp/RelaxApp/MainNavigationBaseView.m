//
//  MainNavHome.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "MainNavigationBaseView.h"

@implementation MainNavigationBaseView

-(IBAction)fnMainNavClick:(id)sender
{
    //Left -> Right... 10 11 12
    UIButton *btn = (UIButton*) sender;
    //set selected
    self.myMainNavCallback(btn);
    
}


@end
