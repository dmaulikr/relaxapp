//
//  CollectionVC.h
//  RelaxApp
//
//  Created by JoJo on 9/28/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CollectionVCCallback)(NSDictionary *itemMusic);
@interface CollectionVC : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

-(instancetype)initWithEVC;
-(void)addContraintSupview:(UIView*)viewSuper;
-(void)fnSetDataCategory:(NSArray*)category;
-(void)updateDataMusic:(NSArray*)arrTmp;
@property (nonatomic,copy) CollectionVCCallback callback;

@end
