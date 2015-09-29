//
//  CommunityHotHeadView.h
//  Wefafa
//
//  Created by wave on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^moreEventBlock)(NSInteger section);

@interface CommunityHotHeadView : UIView

@property (nonatomic, strong) moreEventBlock block;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger section;
@end
        