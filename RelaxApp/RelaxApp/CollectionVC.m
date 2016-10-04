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
#import "UIImageView+WebCache.h"
@interface CollectionVC ()
{
    NSMutableArray                  *arrCategory;
    NSMutableArray                  *arrPage;
    NSMutableArray                  *arrMusic;
    NSMutableArray                  *arrPlayList;
    NSDictionary                    *dicCategory;

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
    
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
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
    self.collectionView.hidden = YES;
    self.image.hidden = YES;
}

-(void)instance
{
//    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(COLOR_PAGE_ACTIVE);
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionID"];
    self.collectionView.allowsSelection = NO;
    arrCategory = [NSMutableArray new];
    arrMusic  = [NSMutableArray new];
    arrPlayList = [NSMutableArray new];
}
//MARK: - DATA
-(void)updateDataMusic:(NSDictionary*)dicTmp
{
    dicCategory = dicTmp;
    
    NSString *path = [self getFullPathWithFileName:dicCategory[@"path"]];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (dicCategory[@"sounds"] && exists) {
        arrMusic = [dicCategory[@"sounds"] mutableCopy];
        self.collectionView.hidden = NO;
        self.image.hidden = YES;
        [self.collectionView reloadData];
    }
    else
    {
        self.collectionView.hidden = YES;
        self.image.hidden = NO;
        
        NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMAGE_URL,dicCategory[@"cover"]]];
        [self.image sd_setImageWithURL:url placeholderImage: nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];


    }

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
            _callback(dic,dicCategory);
        }
}
-(void)setCallback:(CollectionVCCallback)callback
{
    _callback = callback;
}
-(void)setCallbackCategory:(CategoryCallback)callbackCategory
{
    _callbackCategory = callbackCategory;
}
//MARK: - ACTION
-(IBAction)downloadAction:(id)sender
{
    if (_callbackCategory) {
        _callbackCategory(dicCategory);
    }
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
    NSString *fullPath = [self getFullPathWithFileName:[NSString stringWithFormat:@"%@/img/%@",dicCategory[@"path"],dic[@"img"]]];
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
@end
