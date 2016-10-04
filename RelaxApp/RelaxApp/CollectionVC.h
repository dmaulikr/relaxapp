//
//  CollectionVC.h
//  RelaxApp
//
//  Created by JoJo on 9/28/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CollectionVCCallback)(NSDictionary *itemMusic,NSDictionary *dicCategory);
typedef void (^CategoryCallback)(NSDictionary *dicCategory);

@interface CollectionVC : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UIButton *btnDownLoad;

-(instancetype)initWithEVC;
-(void)addContraintSupview:(UIView*)viewSuper;
-(void)updateDataMusic:(NSDictionary*)dicTmp;
@property (nonatomic,copy) CollectionVCCallback callback;
@property (nonatomic,copy) CategoryCallback callbackCategory;

@end
