//
//  SMineProductModel.h
//  Wefafa
//  我的-》我的商品-》顶部btn数据
//  Created by wave on 15/9/10.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subs : NSObject
@property (nonatomic, strong) NSString *aid;    //id
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSMutableArray *subs_array;   //与自身相同的数据结构实力集合
@property (nonatomic, strong) NSString *temp_id;
@property (nonatomic, strong) NSString *url;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end

@interface SMineProductModel : NSObject
/*
//{
//    id = 4;
//    level = 1;
//    name = "\U5973\U88c5";
//    "parent_id" = 0;
//    subs =             (
//                        {
//                            id = 21;
//                            level = 2;
//                            name = "T\U6064";
//                            "parent_id" = 4;
//                            subs =                     (
//                                                        {
//                                                            id = 143;
//                                                            level = 3;
//                                                            name = POLO;
//                                                            "parent_id" = 21;
//                                                            "temp_id" = 143;
//                                                            url = "http://metersbonwe.qiniucdn.com/faxian_pp14.jpg";
//                                                        },
//                                                        {
//                                                            id = 144;
//                                                            level = 3;
//                                                            name = "\U80cc\U5fc3";
//                                                            "parent_id" = 21;
//                                                            "temp_id" = 144;
//                                                            url = "http://metersbonwe.qiniucdn.com/faxian_pp15.jpg";
//                                                        },
//                                                        {
//                                                            id = 145;
//                                                            level = 3;
//                                                            name = "\U957f\U8896T\U6064";
//                                                            "parent_id" = 21;
//                                                            "temp_id" = 145;
//                                                            url = "http://metersbonwe.qiniucdn.com/faxian_pp1.jpg";
//                                                        },
//                                                        {
//                                                            id = 146;
//                                                            level = 3;
//                                                            name = "\U77ed\U8896T\U6064";
//                                                            "parent_id" = 21;
//                                                            "temp_id" = 146;
//                                                            url = "http://metersbonwe.qiniucdn.com/faxian_pp2.jpg";
//                                                        },
//                                                        {
//                                                            id = 147;
//                                                            level = 3;
//                                                            name = "\U4e2d\U8896T\U6064";
//                                                            "parent_id" = 21;
//                                                            "temp_id" = 147;
//                                                            url = "http://metersbonwe.qiniucdn.com/faxian_pp3.jpg";
//                                                        }
//                                                        );
//                            "temp_id" = 21;
//                            url = "http://metersbonwe.qiniucdn.com/faxian_pp12.jpg";
//                        },
 */
@property (nonatomic, strong) NSString *aid;    //id
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *parent_id;

@property (nonatomic, strong) NSMutableArray *subs_array;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
