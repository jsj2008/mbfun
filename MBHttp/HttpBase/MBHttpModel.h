//
//  MBHttpModel.h
//  Wefafa
//
//  Created by su on 15/3/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBHttpModel : NSObject
@property(nonatomic,strong)NSString *requestType;
@property(nonatomic,strong)NSString *path;
@property(nonatomic,strong)NSString *serverName;
@property(nonatomic,strong)NSString *methodName;
@property(nonatomic,strong)NSDictionary *params;
@property(nonatomic,copy)void (^successBlock) (NSDictionary *dict);
@property(nonatomic,copy)void (^failedBlock) (NSError *error);
@end
