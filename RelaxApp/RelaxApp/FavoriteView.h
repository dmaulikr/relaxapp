//
//  FavoriteView.h
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
typedef void (^FavoriteViewCallback)(NSArray *chooseMusic);

@interface FavoriteView : BaseView
{
    NSMutableArray *_dataSource;
    NSArray *_arrMusic;

}
@property (nonatomic, strong) IBOutlet UIView *vViewNav;
@property (nonatomic, strong) IBOutlet UIView *vContent;
@property (strong, nonatomic) IBOutlet UITableView *tableControl;
@property (nonatomic,copy) FavoriteViewCallback callback;

@end
