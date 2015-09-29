//
//  SCollocationDetailCollectionReusableView.m
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationDetailCollectionReusableView.h"
#import "SCollocationDetailModel.h"
#import "SCollocationDescriptionView.h"
#import "SCollocationShowTagView.h"
#import "SCollocationProductTableView.h"
#import "SCollocationDesignerView.h"
#import "SCollocationCommitmentsView.h"
#import "SCollocationParticipateContentView.h"
#import "SCollocationShowBrandTagView.h"
#import "SCollocationModaInfoView.h"
#import "SCollocationPlayerView.h"
#import "SCollocationProductCollectionView.h"

@interface SCollocationDetailCollectionReusableView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@end

@implementation SCollocationDetailCollectionReusableView

- (void)awakeFromNib {
    _contentTableView.scrollEnabled = NO;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    [_contentTableView reloadData];
}

-(void)dealloc{
    NSInteger sections = _contentTableView.numberOfSections;
    for (int section = 0; section < sections; section++) {
        NSInteger rows =  [_contentTableView numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [_contentTableView cellForRowAtIndexPath:indexPath];
            for (UIView *view in [[_contentTableView cellForRowAtIndexPath:indexPath].contentView subviews]) {
                if ([view isKindOfClass:[SCollocationPlayerView class]]) {
                    SCollocationPlayerView *playerView = (SCollocationPlayerView *)view;
                    [playerView playerViewPause];
                }
                [view removeFromSuperview];
            }
        }
    }
    _contentTableView = nil;
}

#pragma mark - delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *number = _contentTypeArray[indexPath.row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"SCollocationHeaderCell%@", number];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.layer.masksToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:[self cellContentViewWithType:number.intValue]];
    }
    UIView *view = [cell.contentView viewWithTag:666];
    if (view) {
        if ([view respondsToSelector:@selector(setContentModel:)]) {
            [view setValue:_contentModel forKey:@"contentModel"];
        }
        if([view respondsToSelector:@selector(setTarget:)]){
            [view setValue:_target forKey:@"target"];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentTypeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *number = _contentTypeArray[indexPath.row];
    return [self cellHeightWithType:number.intValue];;
}


- (CGFloat)cellHeightWithType:(int)type{
    CGFloat cellHeight = 0.0;
    switch (type) {
        case collocationCellNone:
            cellHeight = 10.0;
            break;
        case collocationCellShowImage:
            cellHeight = UI_SCREEN_WIDTH/ _contentModel.img_width.floatValue * _contentModel.img_height.floatValue;
            break;
        case collocationCellDescription:
        {
            if (_contentModel.content_info.length > 0) {
                CGSize size = [_contentModel.content_info boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 40, 0) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
                cellHeight = size.height + 25;
            }
        }
            break;
        case collocationCellShowTag:
            cellHeight = [self getShowTagHeight];
            break;
        case collocationCellProductList:
        {
            if (_contentModel.product_list.count > 0) {
                NSInteger count = (_contentModel.product_list.count + 2)/ 3;
                cellHeight = 50 + count * ((UI_SCREEN_WIDTH - 30)/ 3 + 30) + 5 * (count - 1);
            }
        }
            break;
        case collocationCellDesigner:
        {
            if (_contentModel.isNoneShopping) {
                cellHeight = 64;
            }else{
                SDiscoveryUserModel *designerModel = _contentModel.designer;
                if (designerModel.userSignature.length <= 0) {
                    cellHeight = 90;
                }else{
                    CGSize size = [designerModel.userSignature boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 58, 0) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
                    cellHeight = size.height + 90 - 23;
                }
            }
        }
            break;
        case collocationCellCommitments:
            cellHeight = [self getCommitmentsHeight];
            break;
        case collocationCellJump:
            cellHeight = _contentModel.like_user_list.count <= 0? 80: 120;
            break;
        case collocationCellLine:
            cellHeight = 0.5;
            break;
        case collocationCellBrandTag:
            cellHeight = [self getShowBrandTagHeight];
            break;
        case collocationCellModaInfo:
            cellHeight = [self getModaInfoHeight];
            break;
        default:
            break;
    }
    if (isnan(cellHeight)) {
        cellHeight = 0.0;
    }
    return cellHeight;
}

- (CGFloat)getCommitmentsHeight{
    CGFloat height = 67 * SCALE_UI_SCREEN + 30;
    SDiscoveryBannerModel *model = [_contentModel.banner firstObject];
    if (model.img_width.floatValue > 0) {
        height += model.img_height.floatValue * (UI_SCREEN_WIDTH/ model.img_width.floatValue);
    }
    return height;
}

- (CGFloat)getShowTagHeight{
    if (_contentModel.tab_str.count <= 0) return 0.0;
    CGFloat tag_X = 10.0;
    CGFloat tag_Y = 40;
    for(int i = 0; i < _contentModel.tab_str.count; i++){
        SCollocationDetailTagTypeModel *tagModel = _contentModel.tab_str[i];
        CGSize size = [tagModel.contentText boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 30, 0)
                                               options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        if (size.width + 20 + tag_X > UI_SCREEN_WIDTH - 10) {
            tag_X = 10.0;
            tag_Y += 30;
        }
        tag_X += size.width + 25;
    }
    return tag_Y + 40;
}

- (CGFloat)getShowBrandTagHeight{
    if (_contentModel.useBrand.count <= 0) return 0.0;
    CGFloat tag_X = 10.0;
    CGFloat tag_Y = 40;
    for(int i = 0; i < _contentModel.useBrand.count; i++){
        SCollocationGoodsTagModel *tagModel = _contentModel.useBrand[i];
        NSString *tagString = tagModel.text;
        CGSize size = [tagString boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 30, 0)
                                                         options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        if (size.width + 20 + tag_X > UI_SCREEN_WIDTH - 10) {
            tag_X = 10.0;
            tag_Y += 30;
        }
        tag_X += size.width + 25;
    }
    return tag_Y + 40;
}

- (CGFloat)getModaInfoHeight{
    if (_contentModel.user_json) {
        NSString *stringAge = [NSString stringWithFormat:@"%@", _contentModel.user_json[@"age"]];
        NSString *stringHeight = [NSString stringWithFormat:@"%@", _contentModel.user_json[@"height"]];
        NSString *stringWeight = [NSString stringWithFormat:@"%@", _contentModel.user_json[@"weight"]];
        if (!_contentModel.user_json[@"info"]) {
            return 0.0;
        }else if ([stringAge length] <= 0 &&
                  [stringHeight length] <= 0 &&
                  [stringWeight length] <= 0){
            return 0.0;
        }else{
            return 70.0;
        }
    }
    return 0.0;
}

- (UIView*)cellContentViewWithType:(int)type{
    UIView *view = [UIView new];
    CGRect rect = CGRectMake(0, 0, UI_SCREEN_WIDTH, 300);
    switch (type) {
        case collocationCellNone:
            view = [self getLineView];
            break;
        case collocationCellShowImage:
            view = [[SCollocationPlayerView alloc]initWithFrame:rect];
            break;
        case collocationCellDescription:
            view = [[SCollocationDescriptionView alloc]initWithFrame:rect];
            break;
        case collocationCellShowTag:
            view = [[SCollocationShowTagView alloc]initWithFrame:rect];
            break;
        case collocationCellProductList:
            view = [[SCollocationProductCollectionView alloc]initWithFrame:rect];
            break;
        case collocationCellDesigner:
            view = [[SCollocationDesignerView alloc]initWithFrame:rect];
            break;
        case collocationCellCommitments:
            view = [[SCollocationCommitmentsView alloc]initWithFrame:rect];
            break;
        case collocationCellJump:
            view = [[SCollocationParticipateContentView alloc]initWithFrame:rect];
            break;
        case collocationCellLine:
            view = [self getLine];
            break;
        case collocationCellBrandTag:
            view = [[SCollocationShowBrandTagView alloc]initWithFrame:rect];
            break;
        case collocationCellModaInfo:
            view = [[SCollocationModaInfoView alloc]initWithFrame:rect];
            break;
        default:
            break;
    }
    view.tag = 666;
    return view;
}

- (UIView*)getLineView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 10)];
    view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    CALayer *layer = [CALayer layer];
    layer.zPosition = 10;
    layer.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5);
    layer.backgroundColor = UIColorFromRGB(0xd9d9d9).CGColor;
    [view.layer addSublayer:layer];
    return view;
}

- (UIView *)getLine{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5)];
    view.backgroundColor = UIColorFromRGB(0xd9d9d9);
    return view;
}

@end
