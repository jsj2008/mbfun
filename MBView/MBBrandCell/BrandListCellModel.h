//
//  BrandListCellModel.h
//  Wefafa
//
//  Created by CesarBlade on 15-4-1.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandListCellModel : NSObject
@property(nonatomic,assign)NSInteger brandID;//品牌id
@property(nonatomic,assign)NSInteger brandCode;//编码
@property(nonatomic,strong)NSString * logoImg;//logo图片
@property(nonatomic,strong)NSString * brand;//品牌名称
-(id)initWithBrandListCellDic:(NSDictionary*)dic;
@end
