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
#import "FileHelper.h"
#import <StoreKit/StoreKit.h>
#import "RageIAPHelper.h"
#import "AppDelegate.h"
@interface CollectionVC ()
{
    NSMutableArray                  *arrCategory;
    NSMutableArray                  *arrPage;
    NSMutableArray                  *arrMusic;
    NSMutableArray                  *arrPlayList;
    NSDictionary                    *dicCategory;
    BOOL areAdsRemoved;
    BOOL areBuyCategory;
    NSArray *_products;
    NSString * productIdentifier;
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
    int numberHozi = 3;
    int numberVertical =3;
    int item_width = 70;
    int item_height = 70;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if( screenHeight < screenWidth ){
        screenHeight = screenWidth;
    }
    
    if ( screenHeight >= 667){
        numberHozi = 3;
        numberVertical = 4;
        item_width = 90;
        item_height = 80;
    }else {
        numberHozi = 3;
        numberVertical = 3;
        item_width = 70;
        item_height = 70;
    }
    
    CGRect rect = self.frame;
    
    int paddingHorizontal = (rect.size.width - numberHozi*item_width)/numberHozi;
    int paddingVertical = (rect.size.height - 20  - numberVertical*item_height)/(numberVertical + 1);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // setting cell attributes globally via layout properties ///////////////
    [self.collectionView setCollectionViewLayout:layout];
    layout.itemSize = CGSizeMake(item_width, item_height);
    layout.minimumInteritemSpacing = paddingVertical - 5;
    layout.minimumLineSpacing = paddingHorizontal;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(paddingVertical/2 + 10, paddingHorizontal/2, paddingVertical/2 + 10, paddingHorizontal/2);
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    self.collectionView.hidden = YES;
    self.vDownLoad.hidden = YES;
    
}

-(void)instance
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionID"];
    self.collectionView.allowsSelection = NO;
    arrCategory = [NSMutableArray new];
    arrMusic  = [NSMutableArray new];
    arrPlayList = [NSMutableArray new];
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:kTotalRemoveAdsProductIdentifier];

}
//MARK: - DATA
-(BOOL)checkPassOneDaye:(NSDate*)date
{
    NSDate *current= [NSDate date];
    NSDate *yesterday = [current dateByAddingTimeInterval: -86400.0];
    NSComparisonResult result = [yesterday compare:date];
    if(result == NSOrderedDescending)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)updateDataMusic:(NSDictionary*)dicTmp
{
    dicCategory = dicTmp;
    BOOL price = false;
    if ([dicCategory[@"price"] isKindOfClass:[NSDictionary class]]) {
        if ([dicCategory[@"price"][@"isPrice"] boolValue]) {
            price = true;
            productIdentifier = dicCategory[@"price"][@"iap"];
            areBuyCategory = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
        }
    }

    [arrMusic removeAllObjects];
    NSString *path = [self getFullPathWithFileName:dicCategory[@"path"]];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (dicCategory[@"sounds"] && exists) {
        NSArray *arrSounds = [dicCategory[@"sounds"] mutableCopy];
        for (int i = 0; i <arrSounds.count; i++) {
            NSMutableDictionary *dic = [arrSounds[i] mutableCopy];
            if (areAdsRemoved) {
                [dic setObject:@(0) forKey:@"ads"];
                
            }
            else
            {
                if ([dic[@"ads"] boolValue]) {
                    
                    //check exist in blacklist
                    NSString *strPathShowAds = [FileHelper pathForApplicationDataFile:FILE_HISTORY_SHOW_ADS_SAVE];
                    NSDictionary *dicLoadCache = [NSDictionary dictionaryWithContentsOfFile:strPathShowAds];
                    NSMutableDictionary *dicShowAds = [NSMutableDictionary dictionaryWithDictionary:dicLoadCache];
                    
                    NSString *strID = [NSString stringWithFormat:@"%@%@",dicCategory[@"id"],dic[@"id"]];
                    if (dicShowAds[strID]) {
                        NSDate *dateShowAds = dicShowAds[strID];
                        if ([self checkPassOneDaye:dateShowAds]) {
                            [dicShowAds removeObjectForKey:strID];
                            [dicShowAds writeToFile:strPathShowAds atomically:YES];
                        }
                        else
                        {
                            [dic setObject:@(0) forKey:@"ads"];
                        }
                    }
                    
                }
            }
            [arrMusic addObject:dic];
        }
        
        self.collectionView.hidden = NO;
        self.vDownLoad.hidden = YES;
        [self.collectionView reloadData];
    }
    else
    {
        self.collectionView.hidden = YES;
        self.vDownLoad.hidden = NO;
        NSString *strCover = @"";
        //check device
        NSString *strDevice = @"i4";
        //its iPhone. Find out which one?
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        if( screenHeight < screenWidth ){
            screenHeight = screenWidth;
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //its iPhone. Find out which one?
            
            if(screenHeight <= 480)
            {
                // iPhone Classic
                strDevice = @"i4";
            }
            else if(screenHeight == 568)
            {
                // iPhone 5
                strDevice = @"i5";
                
            }
            else if(screenHeight == 667)
            {
                // iPhone 6
                strDevice = @"i6";
            }
            else if(screenHeight >= 736)
            {
                // iPhone 6 Plus
                strDevice = @"i6plus";
            }
            
        }
        else
        {
            //its iPad
            strDevice = @"i6plus";
        }
        [[NSUserDefaults standardUserDefaults] synchronize];

        if ([dicCategory[@"cover"] isKindOfClass:[NSArray class]]) {

            if (areBuyCategory) {
                strCover = dicCategory[@"cover"][1][strDevice];
                [self.btnDownLoad setTitle:@"Update" forState:UIControlStateNormal];
            }
            else
            {

                if (price) {
                    strCover = dicCategory[@"cover"][0][strDevice];
                    [self.btnDownLoad setTitle:[NSString stringWithFormat:@"Buy %@%@",@"$",dicCategory[@"price"][@"value"]] forState:UIControlStateNormal];

                }
                else
                {
                    strCover = dicCategory[@"cover"][1][strDevice];
                    [self.btnDownLoad setTitle:@"Update" forState:UIControlStateNormal];
                }
            }
        }
        else
        {
            if (areBuyCategory) {
                strCover = dicCategory[@"cover"][1][strDevice];
                [self.btnDownLoad setTitle:@"Update" forState:UIControlStateNormal];
            }
            else
            {
                BOOL price = false;
                if ([dicCategory[@"price"] isKindOfClass:[NSDictionary class]]) {
                    if ([dicCategory[@"price"][@"isPrice"] boolValue]) {
                        price = true;
                    }
                }
                if (price) {
                    [self.btnDownLoad setTitle:@"Buy" forState:UIControlStateNormal];
                    [self.btnDownLoad setTitle:[NSString stringWithFormat:@"Buy %@%@",@"$",dicCategory[@"price"][@"value"]] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [self.btnDownLoad setTitle:@"Update" forState:UIControlStateNormal];
                }
            }
            strCover = dicCategory[@"cover"];
            
        }
        NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMAGE_URL,strCover]];
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
-(void)selectItem:(NSInteger)index withIsLongTap:(BOOL)isLongTap
{
    NSDictionary *dic = arrMusic[index];
    
    if (_callback) {
        _callback(dic,dicCategory,isLongTap);
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
    if (areBuyCategory) {
        if (_callbackCategory) {
            _callbackCategory(dicCategory, YES);
        }
        
    }
    else
    {
        BOOL price = false;
        if ([dicCategory[@"price"] isKindOfClass:[NSDictionary class]]) {
            if ([dicCategory[@"price"][@"isPrice"] boolValue]) {
                price = true;
            }
        }
        if (price) {
            [self buyButtonTapped:nil];
        }
        else
        {
            if (_callbackCategory) {
                _callbackCategory(dicCategory, YES);
            }
        }
    }
}
-(IBAction)closeAction:(id)sender
{
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_BLACKLIST_CATEGORY_SAVE];
    NSArray *blackList = [ NSArray arrayWithContentsOfFile:strPath];
    NSMutableArray *arrTmp = [NSMutableArray arrayWithArray:blackList];
    [arrTmp addObject:dicCategory[@"id"]];
    [arrTmp writeToFile:strPath atomically:YES];
    if (_callbackCategory) {
        _callbackCategory(dicCategory, NO);
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
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *userLanguage = @"en";
    if (language.length >=2) {
        userLanguage = [language substringToIndex:2];
    }
    userLanguage = [language substringToIndex:2];
    
    
    NSDictionary *dic = arrMusic[indexPath.row];
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionID" forIndexPath:indexPath];
    NSString *strTitleShort;
    if ([dic[@"titleShort"] isKindOfClass:[NSDictionary class]]) {
        
        if (dic[@"titleShort"][userLanguage]) {
            strTitleShort = dic[@"titleShort"][userLanguage];
        }
        else
        {
            strTitleShort = dic[@"titleShort"][@"en"];
            
        }
    }
    else
    {
        strTitleShort = dic[@"titleShort"];
    }
    
    cell.lbTitle.text = strTitleShort;
    NSString *fullPath = [self getFullPathWithFileName:[NSString stringWithFormat:@"%@/img/%@",dicCategory[@"path"],dic[@"img"]]];
    cell.imgIcon.image = [UIImage imageWithContentsOfFile:fullPath];
    if ([dic[@"active"] boolValue]) {
        cell.imgCheck.hidden = NO;
    }
    else
    {
        cell.imgCheck.hidden = YES;
    }
    if ([dic[@"ads"] boolValue]) {
        cell.imgAds.hidden = NO;
    }
    else
    {
        cell.imgAds.hidden = YES;
    }
    __weak CollectionVC *myWeak = self;
    cell.imgIcon.tag = indexPath.row;
    [cell setCallback:^(GESTURE_TYPE type, NSInteger index)
     {
         if (type == GESTURE_TAP) {
             [myWeak selectItem:index withIsLongTap:NO];
         }
         else if(type == GESTURE_LONG)
         {
             [myWeak selectItem:index withIsLongTap:YES];
         }
     }];
    return cell;
}
//MARK: - InAppPurchase

- (void)reloadIAP {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app reloadIAP];
    [app setCallbackAIP:^()
     {
         _products = app.arrAIP;
         [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
             if ([product.productIdentifier isEqualToString:productIdentifier]) {
                 [[RageIAPHelper sharedInstance] buyProduct:product];
                 [self removeAds];
                 *stop = YES;
             }

         }];
     }];
}
- (void)buyButtonTapped:(id)sender {
    if (productIdentifier.length > 0) {
        [[RageIAPHelper sharedInstance] addProdcutPurchase:productIdentifier];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _products = app.arrAIP;
        [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
            if ([product.productIdentifier isEqualToString:productIdentifier]) {
                [[RageIAPHelper sharedInstance] buyProduct:product];
                [self removeAds];
                *stop = YES;
            }
            else
            {
                [self reloadIAP];

            }
        }];

    }
}

- (void)restoreTapped:(id)sender {
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}
-(void)removeAds
{
    [[RageIAPHelper sharedInstance] productPurchasedValidate:^(BOOL success, NSString *proIdentifier) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:proIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        areBuyCategory = [[NSUserDefaults standardUserDefaults] boolForKey:proIdentifier];
        [self.btnDownLoad setTitle:@"Update" forState:UIControlStateNormal];
        [self downloadAction:nil];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
