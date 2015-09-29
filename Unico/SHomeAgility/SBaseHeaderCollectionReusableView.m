//
//  SBaseHeaderCollectionReusableView.m
//  Wefafa
//
//  Created by Mr_J on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseHeaderCollectionReusableView.h"
#import "SDiscoveryFlexibleModel.h"
#import "SDiscoveryHeaderMoudleTool.h"

@implementation SBaseHeaderCollectionReusableView

- (UIView*)getContentViewWithModel:(SDiscoveryFlexibleModel*)model{
    UIView *contentView = [self viewWithTag:666];
    if (!contentView) {
        contentView = [SDiscoveryHeaderMoudleTool cellContentViewWithModel:model];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        [self addSubview:contentView];
    }
    return contentView;
}

@end
