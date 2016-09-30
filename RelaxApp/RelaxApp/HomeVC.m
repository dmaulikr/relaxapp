//
//  HomeVC.m
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "HomeVC.h"
#import "CollectionVC.h"
@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CollectionVC *colectionView = [[CollectionVC alloc] initWithEVC];
    [colectionView addContraintSupview:self.vContrainer];
    [self addSubViewFavorite];
    [self addSubViewTimer];
    [self addSubViewSetting];
    [self addSubViewVolume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tabBottomVCAction:(id)sender
{
    [self.vFavorite setup];
    [self.vTimer setup];
    [self.vSetting setup];
    [self.vVolume setup];
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag - 10) {
        case 0:
        {
            //setting
            [self.vVolume hide:NO];
        }
            break;
        case 1:
        {
            //favorite
            [self.vFavorite hide:NO];
        }
            break;
        case 2:
        {
            //home
        }
            break;
        case 3:
        {
            //timer
            [self.vTimer hide:NO];

        }
            break;
        case 4:
        {
            //setting
            [self.vSetting hide:NO];

        }
            break;
        default:
            break;
    }
}
//MARK: view filter
-(void) addSubViewFavorite
{
    self.vFavorite = [[FavoriteView alloc] initWithClassName:NSStringFromClass([FavoriteView class])];
    [self.vFavorite addContraintSupview:self.vContrainer];
    [self.vFavorite setup];
}
-(void) addSubViewTimer
{
    self.vTimer = [[TimerView alloc] initWithClassName:NSStringFromClass([TimerView class])];
    [self.vTimer addContraintSupview:self.vContrainer];
    [self.vTimer setup];
}
-(void) addSubViewSetting
{
    self.vSetting = [[SettingView alloc] initWithClassName:NSStringFromClass([SettingView class])];
    [self.vSetting addContraintSupview:self.vContrainer];
    [self.vSetting setup];
}
-(void) addSubViewVolume
{
    self.vVolume = [[VolumeView alloc] initWithClassName:NSStringFromClass([VolumeView class])];
    [self.vVolume addContraintSupview:self.vContrainer];
    [self.vVolume setup];
}
@end
