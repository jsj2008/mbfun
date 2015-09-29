//
//  MBStoreShowDataView.h
//  Wefafa
//
//  Created by Jiang on 5/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kShowPointLocation_X ((UI_SCREEN_WIDTH - 60)/ 6)

@interface MBStoreShowDataView : UIView

@property (nonatomic, assign) int maxVisitorCount;
@property (nonatomic, strong) NSArray *contentModelArray;

@end
