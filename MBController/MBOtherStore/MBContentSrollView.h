//
//  MBContentSrollView.h
//  Wefafa
//
//  Created by Jiang on 4/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBContentSrollView : UIScrollView

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) NSMutableArray *subViewArray;

@end
