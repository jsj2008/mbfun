//
//  MBStoreVisitorShowDataView.m
//  Wefafa
//
//  Created by Jiang on 5/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#define kTitleName @"我的数据："

#import "MBStoreVisitorTitleView.h"
#import "Utils.h"

@implementation MBStoreVisitorTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.layer.cornerRadius = 4.0;
    CGRect frame = self.frame;
    frame.size.width = UI_SCREEN_WIDTH - 30;
    [self createSubViewsWithFrame:frame];
    self.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
}

- (void)createSubViewsWithFrame:(CGRect)frame{
    CGRect titleRect = CGRectMake(15, 0, frame.size.width, 35);
    //我的数据
    self.titleLabel = [[UILabel alloc]initWithFrame:titleRect];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.text = kTitleName;
    self.titleLabel.textColor = [Utils HexColor:0x333333 Alpha:1];
    [self addSubview:self.titleLabel];
    
    UIView *lineView_1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleRect), frame.size.width, 1.0)];
    lineView_1.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
    [self addSubview:lineView_1];
    
    //分享数
    CGFloat height = (frame.size.height - titleRect.size.height) / 2;
    CGRect rect = CGRectMake(0, CGRectGetMaxY(titleRect) + (height - 20.0), titleRect.size.width/2, 20.0);
    self.shareCountLabel = [[UILabel alloc]initWithFrame:rect];
    self.shareCountLabel.textColor = [Utils HexColor:0x333333 Alpha:1];
    self.shareCountLabel.textAlignment = NSTextAlignmentCenter;
    self.shareCountLabel.font = [UIFont systemFontOfSize:15.0];
    self.shareCountLabel.text = @"0";
    [self addSubview:self.shareCountLabel];
    
    titleRect = rect;
    titleRect.origin.y = CGRectGetMaxY(titleRect);
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:titleRect];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.text = @"分享次数";
    shareLabel.textColor = [Utils HexColor:0x919191 Alpha:1];
    shareLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:shareLabel];
    
    UIView *lineView_2 = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/ 2, CGRectGetMaxY(_titleLabel.frame) + 10, 1.0, frame.size.height - _titleLabel.frame.size.height - 20)];
    lineView_2.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
    [self addSubview:lineView_2];
    
    //访客数
    rect.origin.x = rect.size.width;
    self.visitorCountLabel = [[UILabel alloc]initWithFrame:rect];
    self.visitorCountLabel.textColor = [Utils HexColor:0x333333 Alpha:1];
    self.visitorCountLabel.textAlignment = NSTextAlignmentCenter;
    self.visitorCountLabel.font = [UIFont systemFontOfSize:15.0];
    self.visitorCountLabel.text = @"0";
    [self addSubview:self.visitorCountLabel];
    
    titleRect.origin.x = rect.origin.x;
    UILabel *visitorLabel = [[UILabel alloc]initWithFrame:titleRect];
    visitorLabel.text = @"访客量";
    visitorLabel.textColor = [Utils HexColor:0x919191 Alpha:1];
    visitorLabel.textAlignment = NSTextAlignmentCenter;
    visitorLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:visitorLabel];
}

- (void)setShareCount:(NSString *)shareCount{
    _shareCount = [shareCount copy];
    self.shareCountLabel.text = _shareCount;
}

- (void)setVisitorCount:(NSString *)visitorCount{
    _visitorCount = [visitorCount copy];
    self.visitorCountLabel.text = _visitorCount;
}

@end
