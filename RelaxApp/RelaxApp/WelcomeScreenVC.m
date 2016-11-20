//
//  WelcomeScreenVC.m
//  RelaxApp
//
//  Created by JoJo on 11/20/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "WelcomeScreenVC.h"
#import "WSItemView.h"
@interface WelcomeScreenVC ()
{
    int iNumberCollection;

}
@end

@implementation WelcomeScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnSkip setTitleColor:UIColorFromRGB(COLOR_TEXT_ITEM) forState:UIControlStateNormal];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addWelcomeScreen];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addWelcomeScreen
{
    //remove subview scroll news
    for (UIView *view in self.scroll_View.subviews) {
        [view removeFromSuperview];
    }
    iNumberCollection = 4;
    float delta = CGRectGetWidth(self.scroll_View.frame);
    for (int i = 0; i< iNumberCollection; i++) {
        UIView *v =[UIView new];
        v.frame = CGRectMake( i*delta, 0 , delta , CGRectGetHeight(self.scroll_View.frame));
        [self.scroll_View addSubview:v];
        WSItemView *view = [[WSItemView alloc] initWithClassName:NSStringFromClass([WSItemView class])];
        [view  addContraintSupview:v];
        [self.scroll_View setContentSize:CGSizeMake(iNumberCollection*delta, CGRectGetHeight(self.scroll_View.frame))];
    }
    
    [self.scroll_View setPagingEnabled:YES];
    self.pageControl.numberOfPages = iNumberCollection;
    //set title
    CGFloat pageWidth = CGRectGetWidth(self.scroll_View.frame);
    CGFloat currentPage = floor((self.scroll_View.contentOffset.x-pageWidth/2)/pageWidth)+1;
    // Change the indicator
    self.pageControl.currentPage = (int) currentPage;
    if (currentPage == iNumberCollection -1)
    {
        [self.btnNext setTitle:@"BEGIN" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.btnNext setTitle:@"NEXT" forState:UIControlStateNormal];
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //set ramdom background
    //    [self randomBackGround];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *userLanguage = @"en";
    if (language.length >=2) {
        userLanguage = [language substringToIndex:2];
    }
    userLanguage = [language substringToIndex:2];
    
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    CGFloat currentPage = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    // Change the indicator
    self.pageControl.currentPage = (int) currentPage;
    if (currentPage == iNumberCollection -1)
    {
        [self.btnNext setTitle:@"BEGIN" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.btnNext setTitle:@"NEXT" forState:UIControlStateNormal];
    }
}
-(IBAction)closeAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:show_welcome_screen];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(IBAction)nextAction:(id)sender
{
    if (self.pageControl.currentPage == iNumberCollection -1)
    {
        [self closeAction:nil];
    }
    else
    {
        //NEXT
    }
}
@end
