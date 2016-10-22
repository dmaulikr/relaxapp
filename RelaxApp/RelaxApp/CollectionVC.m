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
#define kRemoveAdsProductIdentifier @"com.Relaf.Relaf.RelafPricing"

@interface CollectionVC ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSMutableArray                  *arrCategory;
    NSMutableArray                  *arrPage;
    NSMutableArray                  *arrMusic;
    NSMutableArray                  *arrPlayList;
    NSDictionary                    *dicCategory;
    BOOL areAdsRemoved;
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
            item_height = 90;
        }else {
            numberHozi = 3;
            numberVertical = 3;
            item_width = 70;
            item_height = 70;
        }

    CGRect rect = self.frame;

    int paddingHorizontal = (rect.size.width - numberHozi*item_width)/numberHozi;
    int paddingVertical = (rect.size.height - 20   - numberVertical*item_height)/(numberVertical + 1);
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
//    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(COLOR_PAGE_ACTIVE);
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionID"];
    self.collectionView.allowsSelection = NO;
    arrCategory = [NSMutableArray new];
    arrMusic  = [NSMutableArray new];
    arrPlayList = [NSMutableArray new];
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
    [arrMusic removeAllObjects];
    NSString *path = [self getFullPathWithFileName:dicCategory[@"path"]];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (dicCategory[@"sounds"] && exists) {
        NSArray *arrSounds = [dicCategory[@"sounds"] mutableCopy];
        for (int i = 0; i <arrSounds.count; i++) {
            NSMutableDictionary *dic = [arrSounds[i] mutableCopy];
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
        areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if ([dicCategory[@"cover"] isKindOfClass:[NSArray class]]) {
            
            if (areAdsRemoved) {
                strCover = dicCategory[@"cover"][1][strDevice];
                [self.btnDownLoad setTitle:@"Update" forState:UIControlStateNormal];
            }
            else
            {
            if ([dicCategory[@"price"] boolValue]) {
                strCover = dicCategory[@"cover"][0][strDevice];
                [self.btnDownLoad setTitle:@"Buy $0.99" forState:UIControlStateNormal];
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
            if (areAdsRemoved) {
                [self.btnDownLoad setTitle:@"Update" forState:UIControlStateNormal];
            }
            else
            {
                if ([dicCategory[@"price"] boolValue]) {
                    [self.btnDownLoad setTitle:@"Buy $0.99" forState:UIControlStateNormal];
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
    if (areAdsRemoved) {
        if (_callbackCategory) {
            _callbackCategory(dicCategory, YES);
        }
        
    }
    else
    {
        if ([dicCategory[@"price"] boolValue]) {
            [self restore];
            [self tapsRemoveAds];
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
- (void)tapsRemoveAds{
    NSLog(@"User requests to remove ads");
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        //If you have more than one in-app purchase, and would like
        //to have the user purchase a different product, simply define
        //another function and replace kRemoveAdsProductIdentifier with
        //the identifier for the other product
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            //if you have more than one in-app purchase product,
            //you restore the correct product for the identifier.
            //For example, you could use
            //if(productID == kRemoveAdsProductIdentifier)
            //to get the product identifier for the
            //restored purchases, you can use
            //
            //NSString *productID = transaction.payment.productIdentifier;
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}
- (void)doRemoveAds{
    areAdsRemoved = YES;
    [self.btnDownLoad setTitle:@"Update" forState:UIControlStateNormal];
    //set the bool for whether or not they purchased it to YES, you could use your own boolean here, but you would have to declare it in your .h file
    
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    //use NSUserDefaults so that you can load wether or not they bought it
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
