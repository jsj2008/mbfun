//
//  SProductDetaileModuleView.m
//  Wefafa
//
//  Created by unico_0 on 7/21/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SProductDetaileModuleView.h"
#import "MBGoodsDetailsModel.h"
#import "SProductShowImageCell.h"
#import "UIScrollView+MJRefresh.h"
#import "Utils.h"

#define kImageHeight UI_SCREEN_WIDTH

@interface SProductDetaileModuleView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) SProductDetaileModuleView *showImageTableHeaderView;
@property (strong, nonatomic) UITableView *showImageTableView;

@end

static NSString *cellIdentifier = @"SProductShowImageCellIdentifier";
@implementation SProductDetaileModuleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showImageTableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"SProductDetaileModuleView" owner:nil options:nil][0];
        
        _showImageTableView = [[UITableView alloc]initWithFrame:self.bounds];
        _showImageTableView.tableHeaderView = self.showImageTableHeaderView;
        _showImageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showImageTableView.delegate = self;
        _showImageTableView.dataSource = self;
        [_showImageTableView addHeaderJumpWithTarget:self action:@selector(headerJump) titleName:@""];
        [self addSubview:_showImageTableView];
    }
    return self;
}

- (void)headerJump
{
    if (_detailModuleDelegate && [_detailModuleDelegate respondsToSelector:@selector(SProductDetaileModuleViewaddHeaderJump)]) {
        [_detailModuleDelegate SProductDetaileModuleViewaddHeaderJump];
    }
}

- (void)setContentModel:(MBGoodsDetailsModel *)contentModel{
    _contentModel = contentModel;

    [self subViewsFrame];
    _showImageTableView.tableHeaderView = self.showImageTableHeaderView;
    [_showImageTableView reloadData];
}

- (void)subViewsFrame{
    if (!_contentModel) return;
    self.showImageTableHeaderView.descriptionLabel.text = _contentModel.clsInfo.aDescription;
    self.showImageTableHeaderView.brandNameLabel.text = [NSString stringWithFormat:@"品牌：%@",[Utils getSNSString: _contentModel.clsInfo.brand ]];
    self.showImageTableHeaderView.productNameLabel.text = [NSString stringWithFormat:@"款名：%@",[Utils getSNSString: _contentModel.clsInfo.name]];
    self.showImageTableHeaderView.productCodeLabel.text = [NSString stringWithFormat:@"款号：%@", [Utils getSNSString:[NSString stringWithFormat:@"%@", _contentModel.clsInfo.code]]];
    
    self.showImageTableHeaderView.editerLb.frame = CGRectMake(10, 16, UI_SCREEN_WIDTH-20, 12);
    self.showImageTableHeaderView.lineLb.frame = CGRectMake(10, CGRectGetMaxY(self.showImageTableHeaderView.editerLb.frame)+8, UI_SCREEN_WIDTH-10, 0.5);
    
    CGSize size = [_contentModel.clsInfo.aDescription boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading| NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.showImageTableHeaderView.descriptionLabel.font} context:nil].size;
    self.showImageTableHeaderView.descriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(self.showImageTableHeaderView.lineLb.frame)+16, UI_SCREEN_WIDTH-20, size.height);//
    
    CGFloat detailViewY = CGRectGetMaxY(self.showImageTableHeaderView.descriptionLabel.frame)+20; //
    self.showImageTableHeaderView.productDetailContentView.frame = CGRectMake(0, detailViewY, UI_SCREEN_WIDTH, 124); //
    
    CGFloat height = detailViewY+124+20;
    self.showImageTableHeaderView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self subViewsFrame];
}

- (CGFloat)getAllImageHeightWith:(NSArray*)modelArray{
    CGFloat height = 0.0;
    /*
    for (MBGoodsDetailsPictureModel *model in modelArray) {
        height += model.height.floatValue * (UI_SCREEN_WIDTH/ model.width.floatValue);
    }*/
//    for (int i=0; i<modelArray.count; i++) {
//        height += (200*(i+1));
//    }
    height = kImageHeight * (modelArray.count);
    return height;
}

#pragma mark - delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SProductShowImageTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.contentView.bounds];
        imageView.tag = 999;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:imageView];
    }
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:999];
    if (imageView) {
        imageView.frame = cell.bounds;
        MBGoodsDetailsPictureModel *model = _contentModel.clsPicUrl[indexPath.row];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.filE_PATH]
                                 placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kImageHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentModel.clsPicUrl.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_detailModuleDelegate && [_detailModuleDelegate respondsToSelector:@selector(SProductDetaileModuleViewDidScroll:)]) {
        [_detailModuleDelegate SProductDetaileModuleViewDidScroll:scrollView];
    }
}


@end
