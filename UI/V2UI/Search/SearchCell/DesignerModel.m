//
//  DesignerModel.m
//  Wefafa
//
//  Created by su on 15/2/11.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "DesignerModel.h"

@implementation DesignerModel
- (id)initWithDesignerInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.concernsCount = [[dict objectForKey:@"concernsCount"] integerValue];
        self.designCount = [[dict objectForKey:@"designCount"] integerValue];
        self.fansCount = [[dict objectForKey:@"fansCount"] integerValue];
        self.grade = [dict objectForKey:@"grade"];
        self.headPortrait = [dict objectForKey:@"headPortrait"];
        self.isConcerned = [[dict objectForKey:@"isConcerned"] integerValue];
        self.points = [[dict objectForKey:@"points"] integerValue];
        self.userId = [dict objectForKey:@"userId"];
        self.userName = [dict objectForKey:@"nickName"];
        self.userSignature = [dict objectForKey:@"userSignature"];
    }
    return self;
}
@end
