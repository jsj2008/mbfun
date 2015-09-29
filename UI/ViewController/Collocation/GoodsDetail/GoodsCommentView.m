//
//  GoodsCommentView.m
//  Wefafa
//
//  Created by Jiang on 3/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "GoodsCommentView.h"
#import "GoodsCommentListTableViewCell.h"
#import "SUtilityTool.h"

static const CGFloat headerH = 30.f;

@interface GoodsCommentView ()<UITableViewDataSource, UITableViewDelegate>
{
    CGFloat _rowLableSumWidth;
}
@property(nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSMutableArray *labelSizeArray;
@end

static NSString *cellIdentifier = @"ListTableViewCellIdentifier";
@implementation GoodsCommentView

- (void)awakeFromNib{
    CGRect frame = self.bounds;
    frame.size.height = 30;
    self.titleView = [[UIView alloc]initWithFrame:frame];
    self.titleView.backgroundColor = COLOR_C4;
    [self addSubview:_titleView];
    
    frame.origin.y = frame.size.height;
    frame.size.height = self.bounds.size.height - frame.size.height;
    self.listTableView = [[UITableView alloc]initWithFrame:frame];
    [self addSubview:_listTableView];
    self.listTableView.scrollEnabled = NO;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc]init];
    self.listTableView.tableFooterView = view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    if (modelArray.count <= 0) return;
    self.height = ([modelArray[0] count] - 1) * 25 + 30;
    self.listTableView.height = ([modelArray[0] count] - 1) * 25;
    [self calculateLabelSize];
    [self initTitleView];
    [self.listTableView reloadData];
}

- (void)initTitleView{
    CGFloat space = (self.titleView.width - _rowLableSumWidth)/ (_labelSizeArray.count + 1);
    space = MAX(space, 0);
    [self.titleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat widthSum = 0.0;
    for (int i = 0; i < _labelSizeArray.count; i++) {
        NSNumber *widthNumber = _labelSizeArray[i];
        CGRect rect = CGRectMake(space + space * i + widthSum, 0, widthNumber.floatValue, 30);
        UILabel *label = [[UILabel alloc]initWithFrame:rect];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.modelArray[i][0];
        [self.titleView addSubview:label];
        widthSum += widthNumber.floatValue;
    }
}

- (void)calculateLabelSize{
    _rowLableSumWidth = 0.0;
    [self.labelSizeArray removeAllObjects];
    for (int i = 0; i < self.modelArray.count; i++) {
        NSArray *array = self.modelArray[i];
        CGSize size = CGSizeZero;
        for (int j = 0; j < array.count; j++) {
            NSString *string = array[j];
            CGSize currentSize;
            if (j == 0) {
                currentSize = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12]}];
            }else{
                currentSize = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
            }
            if (currentSize.width > size.width) {
                size = currentSize;
            }
        }
        _rowLableSumWidth += size.width;
        [self.labelSizeArray addObject:@(size.width)];
    }
}

- (NSMutableArray *)labelSizeArray{
    if (!_labelSizeArray) {
        _labelSizeArray = [NSMutableArray array];
    }
    return _labelSizeArray;
}

#pragma mark - tableview delelgate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[GoodsCommentListTableViewCell alloc]initWithSubViewsCount:self.modelArray.count sizeArray:self.labelSizeArray cellSize:CGSizeMake(tableView.bounds.size.width, 25.0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setContentArray:_modelArray index:indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.modelArray || self.modelArray.count == 0) {
        return 0;
    }
    NSArray *array = self.modelArray[0];
    return array.count - 1;
}

@end
