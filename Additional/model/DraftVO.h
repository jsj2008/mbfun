//
//  DraftVO.h
//  newdesigner
//
//  Created by Miaoz on 14-9-22.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface DraftVO : NSManagedObject
@property(nonatomic,strong)NSString *draftid;
@property(nonatomic,strong)NSData *draftimageData;
@property(nonatomic,strong)NSString *draftname;
@property(nonatomic,strong)NSString *savetag;
@end
