//
//  SDiscoveryFiexibleHeaderView.m
//  Wefafa
//
//  Created by unico_0 on 7/8/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryFlexibleHeaderView.h"
#import "SDiscoveryHeaderTableView.h"

@interface SDiscoveryFlexibleHeaderView ()

@property (nonatomic, strong) SDiscoveryHeaderTableView *contentTableView;

@end

@implementation SDiscoveryFlexibleHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _contentTableView = [[SDiscoveryHeaderTableView alloc]initWithFrame:self.bounds];
    [self addSubview:_contentTableView];
    _contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    _contentTableView.contentArray = contentArray;
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    _contentTableView.target = target;
}

@end
