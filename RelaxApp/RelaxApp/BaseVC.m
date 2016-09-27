//
//  BaseVC.m
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "BaseVC.h"
#import "TabVC.h"
#import "MainNavigationBaseView.h"
#import "BaseNavigation.h"
#define TAG_MAIN_NAV_VIEW 100
@interface BaseVC ()
{
    BaseNavigation *navigation;
}
@end

@implementation BaseVC
//MARK: - view did
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadNavigation];
    [self addTabbarBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK: - add tabbar
-(void) addTabbarBottom
{
    UIView *vv = self.vContrainer;
    NSArray *nibArrayTab = [[NSBundle mainBundle]loadNibNamed:@"TabVC" owner:self options:nil];
    
    
    self.vBottom = (TabVC*)[nibArrayTab objectAtIndex:0];
    
    __weak BaseVC *wself = self;
    [self.vBottom setMyCallBack:^(UIButton*btn)
     {
         [wself tabBottomVCAction:btn];
     }];
    
    
    self.vBottom.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *tview = self.vBottom;
    
    CGRect rectTab = self.vBottom.frame;
    rectTab.size.height = 44;
    self.vBottom.frame = rectTab;
    
    [self.view addSubview:self.vBottom];
    
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[vv]-0-[tview(50)]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(vv,tview)]];
    
    
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[tview]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(tview)]];

}
-(IBAction)tabBottomVCAction:(id)sender
{

}
//MARK: - add navigation
#pragma mark - Custom Navigation
- (void)loadNavigation{
    navigation =[[BaseNavigation alloc] initWithNibName:@"BaseNavigation" bundle:nil];
    
    self.navigationItem.titleView = navigation.view;
    
    self.navigationController.navigationBar.translucent = NO;
    [navigation.view sizeToFit];
}
-(void) addMainNav:(NSString*) nameView
{
    NSArray *nibArray = nil;
    id md_view=nil;
    if ([nameView isEqualToString:@"MainNavLiveMap"]) {
        return;

    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        nibArray = [[NSBundle mainBundle]loadNibNamed:@"MainNavHome" owner:self options:nil];
        md_view =[nibArray objectAtIndex:0];
    }
    
    MainNavigationBaseView *subview = (MainNavigationBaseView*)md_view;
    
    
    [subview setMyMainNavCallback:^(UIButton*btn)
     {
         
     }];
    
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [navigation.viewNavigation1 addSubview:subview];
    subview.tag = TAG_MAIN_NAV_VIEW;
    NSDictionary *views = NSDictionaryOfVariableBindings(subview);
    [navigation.viewNavigation1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subview]-0-|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:views]];
    [navigation.viewNavigation1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:views]];
}
@end
