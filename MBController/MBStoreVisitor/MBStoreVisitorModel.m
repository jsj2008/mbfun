//
//  MBStoreVisitorModel.m
//  Wefafa
//
//  Created by Jiang on 5/19/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBStoreVisitorModel.h"

@interface MBStoreVisitorModel ()

@end

@implementation MBStoreVisitorModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *channelArray_1 = [NSMutableArray array];
    NSMutableArray *channelArray_2 = [NSMutableArray array];
    NSMutableArray *channelArray_3 = [NSMutableArray array];
    NSMutableArray *channelArray_99 = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        MBStoreVisitorModel *model = [[MBStoreVisitorModel alloc]initWithDictionary:dict];
        switch (model.channel.intValue) {
            case 1:
                [channelArray_1 addObject:model];
                break;
            case 2:
                [channelArray_2 addObject:model];
                break;
            case 3:
                [channelArray_3 addObject:model];
                break;
            case 99:
                [channelArray_99 addObject:model];
                break;
            default:
                break;
        }
    }
    return @[channelArray_1, channelArray_2, channelArray_3, channelArray_99];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setCreate_date:(NSString *)create_date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _create_date = [formatter dateFromString:create_date];
}

@end
