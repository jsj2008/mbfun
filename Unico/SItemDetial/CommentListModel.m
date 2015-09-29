//
//  CommentListModel.m
//  Wefafa
//
//  Created by unico_0 on 5/30/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "CommentListModel.h"
#import "Utils.h"

@implementation CommentListModel

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

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        CommentListModel *model = [[CommentListModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setTo_user_id:(NSString *)to_user_id{
    _to_user_id = [Utils getSNSString:to_user_id];
}

@end
