//
//  SDiscoveryShowBannerTableView.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryShowBannerTableView.h"
#import "UIImageView+WebCache.h"
#import "SDiscoveryBannerModel.h"
#import "SDiscoveryFlexibleModel.h"
#import "SUtilityTool.h"

@interface SDiscoveryShowBannerTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SDiscoveryShowBannerTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollEnabled = NO;
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.backgroundColor = COLOR_C4;
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = COLOR_C4;
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    [self reloadData];
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    self.contentArray = contentModel.config;
    self.height = [self getSumHeight:contentModel.config];
}

- (CGFloat)getSumHeight:(NSArray*)bannerModelArray{
    CGFloat sumHeight = -5.0;
    for (SDiscoveryBannerModel *model in bannerModelArray) {
        CGFloat height = model.img_height.floatValue * UI_SCREEN_WIDTH/ model.img_width.floatValue;
        sumHeight += height;
    }
    return sumHeight;
}

#pragma mark - tableView delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SDiscoveryShowBannerTableViewCellIdentifier";
    SDiscoveryShowBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SDiscoveryShowBannerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SDiscoveryBannerModel *model = _contentArray[indexPath.row];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryBannerModel *model = _contentArray[indexPath.row];
    CGFloat height = model.img_height.floatValue * UI_SCREEN_WIDTH/ model.img_width.floatValue;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryBannerModel *model = _contentArray[indexPath.row];
    [[SUtilityTool shared]jumpControllerWithContent:model.dict target:_target];
}

@end

@implementation SDiscoveryShowBannerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = self.bounds;
        frame.size.height -= 5;
        _contentImageView = [[UIImageView alloc]initWithFrame:frame];
        _contentImageView.layer.masksToBounds = YES;
        _contentImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_contentImageView];
    }
    return self;
}

@end
