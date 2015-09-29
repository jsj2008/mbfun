//
//  MBBrandModel.h
//  Wefafa
//
//  Created by su on 15/4/2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBMyStoreInfoModel.h"
@class HomeStoreInfo;
@interface MBBrandModel : NSObject

@end

@interface HomeSelectionModel : NSObject
@property(nonatomic,assign)NSInteger favoritCount;
@property(nonatomic,strong)NSString *headPortrait;
@property(nonatomic,strong)NSString *idValue;
@property(nonatomic,strong)NSString *pictureUrl;
@property(nonatomic,assign)NSInteger sharedCount;
@property(nonatomic,strong)NSString *detailStr;
@property(nonatomic,strong)MBMyStoreInfoModel *storeInfo;
@property(nonatomic,assign)BOOL isFavorite;

@property(nonatomic,strong)NSString * shareUserID;
@property(nonatomic,strong)NSString * designID;
- (id)initWithDictionary:(id)dict;
@end
