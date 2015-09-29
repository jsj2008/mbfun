//
//  OrderBtn.h
//  Wefafa
//
//  Created by fafatime on 14-12-18.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderBtn : UIButton
@property (nonatomic,assign) NSInteger sectionTag;
@property (nonatomic,retain) NSIndexPath * clickIndexPath;
//@property (nonatomic,retain)NSString *sectionTagStr;
@end
