//
//  AddFavoriteView.h
//  RelaxApp
//
//  Created by JoJo on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "BaseView.h"
#import "AHTagsLabel.h"
@interface AddFavoriteView : BaseView
{
    NSMutableArray *_dataSource;
    NSArray *_dataMusic;

}
@property (nonatomic, weak) IBOutlet AHTagsLabel *label;
@property (nonatomic, strong) IBOutlet UIView *vViewNav;
@property (nonatomic, strong) IBOutlet UIView *vContent;
@property (nonatomic, strong) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) IBOutlet UITextField *tfTitle;
-(void)fnSetDataMusic:(NSArray*)arr;
@end
