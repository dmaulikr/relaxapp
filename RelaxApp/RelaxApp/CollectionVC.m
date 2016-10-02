//
//  CollectionVC.m
//  RelaxApp
//
//  Created by JoJo on 9/28/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "CollectionVC.h"
#import "CollectionCell.h"
#import "SpringboardLayout.h"
#import "Define.h"

@interface CollectionVC ()
{
    NSMutableArray                  *arrCategory;
    NSMutableArray                  *arrPage;
    NSMutableArray                  *arrMusic;
    NSMutableArray                  *arrPlayList;

}
@end
@implementation CollectionVC
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self instance];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self instance];
    }
    return self;
}
-(instancetype)initWithEVC
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0] ;
    if (self) {
        [self instance];
    }
    return self;
}
-(void)addContraintSupview:(UIView*)viewSuper
{
    UIView *view = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    view.frame = viewSuper.frame;
    
    [viewSuper addSubview:view];
    
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(65)-[view]-(0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
    
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
    int item_width = 90;
    int item_height = 90;
    CGRect rect = self.frame;
    int paddingHorizontal = (rect.size.width - 3*item_width)/3;
    int paddingVertical = (rect.size.height - 65  - 5*item_height)/6;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // setting cell attributes globally via layout properties ///////////////
    [self.collectionView setCollectionViewLayout:layout];
    layout.itemSize = CGSizeMake(item_width, item_height);
    layout.minimumInteritemSpacing = paddingVertical - 5;
    layout.minimumLineSpacing = paddingHorizontal;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(paddingVertical/2 + 10, paddingHorizontal/2, paddingVertical/2 + 10, paddingHorizontal/2);
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    
}

-(void)instance
{
    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(COLOR_PAGE_ACTIVE);
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionID"];
    self.collectionView.allowsSelection = NO;
    arrCategory = [NSMutableArray new];
    arrMusic  = [NSMutableArray new];
    arrPlayList = [NSMutableArray new];
}
//MARK: - DATA
-(void)fnSetDataCategory:(NSArray*)category
{
    arrCategory = [category mutableCopy];
    
    
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:[self getFullPathWithFileName:@"1/example.json"] encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    NSDictionary *dicTmp = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    arrMusic = [dicTmp[@"Exprorer Cities"] mutableCopy];
  //  [arrMusic addObjectsFromArray:dicTmp[@"Exprorer Cities"]];
 //   [arrMusic addObjectsFromArray:dicTmp[@"Exprorer Cities"]];
 //   [arrMusic addObjectsFromArray:dicTmp[@"Exprorer Cities"]];

    double pages = ceil(arrMusic.count/15);
    [self.pageControl setNumberOfPages:pages];

    [self.collectionView reloadData];
}
-(void)updateDataMusic:(NSArray*)arrTmp
{
    arrMusic = [arrTmp mutableCopy];
    double pages = ceil(arrMusic.count/15);
    [self.pageControl setNumberOfPages:pages];
    
    [self.collectionView reloadData];

}
-(NSString*)getFullPathWithFileName:(NSString*)fileName
{
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return archivePath;
}
//MARK: -
-(void)selectItem:(NSInteger)index
{
    NSDictionary *dic = arrMusic[index];

        if (_callback) {
            _callback(dic);
        }
}
-(void)setCallback:(CollectionVCCallback)callback
{
    _callback = callback;
}
//MARK: - COLLECTION
// collection view data source methods ////////////////////////////////////

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrMusic.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = arrMusic[indexPath.row];
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionID" forIndexPath:indexPath];

    cell.lbTitle.text = dic[@"titleShort"];
    NSString *fullPath = [self getFullPathWithFileName:[NSString stringWithFormat:@"1/%@",dic[@"img"]]];
    cell.imgIcon.image = [UIImage imageWithContentsOfFile:fullPath];
    if ([dic[@"active"] boolValue]) {
        cell.imgCheck.hidden = NO;
    }
    else
    {
        cell.imgCheck.hidden = YES;
    }
    __weak CollectionVC *myWeak = self;
    cell.imgIcon.tag = indexPath.row;
    [cell setCallback:^(GESTURE_TYPE type, NSInteger index)
     {
         if (type == GESTURE_TAP) {
             [myWeak selectItem:index];
         }
     }];
    return cell;
}
/////////////////////////////////////////////////////////////////////////////////

// collection view delegate methods ////////////////////////////////////////

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell #%ld was selected", (long)indexPath.row);
}
/////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = self.collectionView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

@end
