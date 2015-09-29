//
//  SProductDetailCommentModel.m
//  Wefafa
//
//  Created by Jiang on 8/4/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SProductDetailCommentModel.h"
#import "Utils.h"

@implementation SProductDetailCommentModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

- (void)setCreatE_DATE:(NSString *)creatE_DATE{
    _creatE_DATE = [Utils getdate:creatE_DATE];
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SProductDetailCommentModel *model = [[SProductDetailCommentModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end
