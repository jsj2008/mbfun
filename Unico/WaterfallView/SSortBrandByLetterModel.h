//
//  SSortBrandByLetterModel.h
//  Wefafa
//
//  Created by lizhaoxiang on 15/6/9.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSortBrandByLetterSubModel;
@interface SSortBrandByLetterModel : NSObject
@property(nonatomic,strong)NSMutableArray * brandInfo_array;
@property(nonatomic,strong)NSString * sortString;
-(instancetype)initWithDic:(NSDictionary*)dic;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray;
@end


@interface SSortBrandByLetterSubModel : NSObject
@property (nonatomic,strong)NSString*branD_NAME;
@property (nonatomic,strong)NSString *brand_code;
@property (nonatomic,strong)NSString *first_letter;
@property (nonatomic,strong)NSString*idStr;
@property (nonatomic,strong)NSString*logO_URL;
- (instancetype)sortBrandWithDic:(NSDictionary*)dic ;
@end

@interface SNewSortBrandByLetterSubModel : NSObject
@property(nonatomic,strong)NSString*branD_NAME;
@property(nonatomic,strong)NSString*aId;
@property(nonatomic,strong)NSString*logO_URL;
@property(nonatomic,strong)NSString*hotFlag;
@property(nonatomic,strong)NSString*remark;
@property(nonatomic,strong)NSString*mainUrl;
@property(nonatomic,strong)NSString*uP_FLAG;
@property(nonatomic,strong)NSString*aDescription;
@property (nonatomic,strong)NSString*branD_CODE;
@property (nonatomic,strong) NSArray *picUrls;

- (instancetype)sortBrandWithDic:(NSDictionary*)dic ;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray;
@end