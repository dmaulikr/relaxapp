//
//  DownLoadCategory.h
//  RelaxApp
//
//  Created by JoJo on 10/2/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
typedef void (^DownLoadCategoryCallback)(NSDictionary *itemCategory);
@interface DownLoadCategory : NSObject
{
    AFURLSessionManager *manager;
    AFHTTPSessionManager *managerCategory;

}
+ (DownLoadCategory *) sharedInstance;
@property (nonatomic, strong) NSOperationQueue * operationQueue;
-(void)fnListMusicWithCategory :(NSArray*) arrCategory;
@property (nonatomic,copy) DownLoadCategoryCallback callback;
/*
DownLoadCategory *download = [DownLoadCategory sharedInstance];
[download fnListMusicWithCategory:arrCategory];
[download setCallback:^(NSDictionary *dicItemCategory)
 {
     
 }];
*/
@end
