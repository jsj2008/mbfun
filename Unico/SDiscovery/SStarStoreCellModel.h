//
//  SStarStoreCellModel.h
//  Wefafa
//
//  Created by lizhaoxiang on 15/5/28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SStarStoreCellModel : NSObject
@property(nonatomic,strong)NSString* userName;
@property(nonatomic,strong)NSString* collocationCount;
@property(nonatomic,strong)NSString* concernCount;
@property(nonatomic,strong)NSString* storeDescription;
@property(nonatomic,strong)NSString* headImg;
@property(nonatomic,strong)NSString* designId;
@property(nonatomic,strong)NSString *head_v_type;
@property (nonatomic) NSString *is_like;

@property(nonatomic,strong)NSMutableArray* collocationList;
-(id)initStarStoreModelWithDic:(NSDictionary*)dic;

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
