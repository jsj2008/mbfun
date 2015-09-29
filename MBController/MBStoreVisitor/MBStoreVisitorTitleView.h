//
//  MBStoreVisitorShowDataView.h
//  Wefafa
//
//  Created by Jiang on 5/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBStoreVisitorTitleView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *shareCountLabel;
@property (nonatomic, strong) UILabel *visitorCountLabel;

@property (nonatomic, copy) NSString *shareCount;
@property (nonatomic, copy) NSString *visitorCount;
@end
