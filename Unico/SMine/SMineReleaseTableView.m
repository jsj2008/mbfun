//
//  SMineReleaseTableView.m
//  Wefafa
//
//  Created by unico_0 on 6/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SMineReleaseTableView.h"
#import "SContentOnePageCell.h"
#import "Utils.h"

@interface SMineReleaseTableView ()<UITableViewDataSource, UITableViewDelegate, kMainViewCellDelegate>{
    NSMutableArray *_modelArray;
}

@end

static NSString *contentOnePageCellID = @"contentOnePageCellID";
@implementation SMineReleaseTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [UIView new];
        _modelArray = [NSMutableArray new];
    }
    return self;
}

- (void)setContentArray:(NSArray *)contentArray{
    if(!contentArray){
        [_modelArray removeAllObjects];
        [_contentArray removeAllObjects];
    }
    if(contentArray.count<_modelArray.count){
        [_modelArray removeAllObjects];
    }
    for (NSInteger i=_modelArray.count; i<contentArray.count; i++) {
        SMDataModel *model = [[SMDataModel alloc] initWithDictionary:contentArray[i]];
        [_modelArray addObject:model];
    }
    _contentArray = [NSMutableArray arrayWithArray:contentArray];
    [self reloadData];
}

- (void)kMainViewCellUploadCellAtIndex:(NSInteger)indexCell cellData:(NSMutableDictionary *)dict
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexCell inSection:0];
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //发布的搭配
        SMDataModel *model = _modelArray[indexPath.row];
        SContentOnePageCell *cell = (SContentOnePageCell *)[tableView dequeueReusableCellWithIdentifier:contentOnePageCellID];
        if (!cell) {
            cell = [[SContentOnePageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:contentOnePageCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        __weak __typeof(self) ws = self;
        cell.likeAnimationBlock = ^(SContentOnePageCell*cell, BOOL isLike){
            //            NSIndexPath *indexPath = [ws indexPathForCell:cell];
            CGRect rect = cell.frame;
            rect.size.height -= 79 + 50;
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            [ws addSubview:imgView];
            UIImage *img = [UIImage new];
            if (isLike) {
                img = [UIImage imageNamed:@"Unico/community_like22.png"];
            }
            [imgView setImage:img];
            imgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                ws.scrollEnabled = NO;
                imgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7f, 0.7f);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    imgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
                } completion:^(BOOL finished) {
                    ws.scrollEnabled = YES;
                    [imgView removeFromSuperview];
                }];
            }];
        };
        cell.parentVc = self.parentVc;
        cell.isMine=_isMine;
        [cell updateCellUIWithModel:model atIndex:indexPath.row];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMDataModel *model = _modelArray[indexPath.row];
    CGFloat height = 0;
    height = model.cellHeight;
    return height;
//    UITableViewCell *cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.opration) {
        self.opration(indexPath, _contentArray);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.tableViewDelegate respondsToSelector:@selector(listViewDidScroll:)]) {
        [self.tableViewDelegate listViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.tableViewDelegate respondsToSelector:@selector(listViewWillBeginDraggingScroll:)]) {
        [self.tableViewDelegate listViewWillBeginDraggingScroll:scrollView];
    }
}

- (void)kMainViewCellDeleteCellAtIndex:(NSInteger)indexCell
{
    if ([self.tableViewDelegate respondsToSelector:@selector(cellDeleteAtIndex:)]) {
        [self.tableViewDelegate cellDeleteAtIndex:indexCell];
    }
}
@end
