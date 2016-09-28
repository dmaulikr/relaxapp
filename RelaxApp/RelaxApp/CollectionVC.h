//
//  CollectionVC.h
//  RelaxApp
//
//  Created by JoJo on 9/28/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionVC : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

-(instancetype)initWithEVC;
-(void)addContraintSupview:(UIView*)viewSuper;
@end
