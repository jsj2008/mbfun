//
//  SSearchBrandTableView.m
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SSearchBrandTableView.h"
#import "UIImageView+WebCache.h"
#import "SUtilityTool.h"

@interface SSearchBrandTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIView *showNoneData;

@end

@implementation SSearchBrandTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableFooterView = [[UIView alloc]init];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    [self reloadData];
}

- (UIView *)showNoneData{
    if (!_showNoneData) {
        CGRect frame = CGRectMake(0, -200, self.frame.size.width, 200);
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.backgroundColor = [UIColor whiteColor];
        frame.origin.y = 0;
        frame.size.height = 160;
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.textColor = COLOR_C6;
        label.font = FONT_t5;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"抱歉，没有找到相关的品牌，请重新搜索";
        [view addSubview:label];
        
        frame = CGRectMake(0, 160, self.frame.size.width, 40);
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:frame];
        nameLabel.backgroundColor = COLOR_C4;
        nameLabel.textColor = COLOR_C6;
        nameLabel.font = FONT_t4;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"热门品牌推荐";
        [view addSubview:nameLabel];
        
        frame = CGRectMake(10, 20, 100, 0.5);
        CALayer *leftLayer = [CALayer layer];
        leftLayer.backgroundColor = COLOR_C9.CGColor;
        leftLayer.frame = frame;
        leftLayer.zPosition = 5;
        [nameLabel.layer addSublayer:leftLayer];
        
        frame = CGRectMake(self.frame.size.width - 110, 20, 100, 0.5);
        CALayer *rightLayer = [CALayer layer];
        rightLayer.backgroundColor = COLOR_C9.CGColor;
        rightLayer.frame = frame;
        rightLayer.zPosition = 5;
        [nameLabel.layer addSublayer:rightLayer];
        
        [self addSubview:view];
        _showNoneData = view;
    }
    return _showNoneData;
}

- (void)setIsHotData:(NSNumber *)isHotData{
    _isHotData = isHotData;
    if (isHotData.boolValue) {
        if (_showNoneData) {
            return;
        }else{
            UIEdgeInsets edgeInset = self.contentInset;
            edgeInset.top = 200;
            self.contentInset = edgeInset;
            self.contentOffset = CGPointMake(0, - 200);
            [self showNoneData];
        }
    }else{
        UIEdgeInsets edgeInset = self.contentInset;
        edgeInset.top = 0;
        self.contentInset = edgeInset;
        [_showNoneData removeFromSuperview];
    }
}

#pragma mark - table View delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SSearchBrandTableViewCellIndentifeir";
    SSearchBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SSearchBrandTableViewCell alloc]init];
    }
    NSDictionary *dict = _contentArray[indexPath.row];
//    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"logo_img"]]];
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"logo_img"]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    
    cell.titleLabel.text = dict[@"english_name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.opration) {
        self.opration(indexPath, _contentArray);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_brandDelegate && [_brandDelegate respondsToSelector:@selector(listViewDidScroll:)]) {
        [_brandDelegate listViewDidScroll:scrollView];
    }
}

@end

@implementation SSearchBrandTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 35)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_showImageView];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_showImageView.frame) + 10, 0, 200, frame.size.height)];
        _titleLabel.textColor = COLOR_C2;
        _titleLabel.font = FONT_t4;
        [self addSubview:_titleLabel];
        
    }
    return self;
}

@end
