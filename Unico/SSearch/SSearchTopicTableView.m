//
//  SSearchTopicTableView.m
//  Wefafa
//
//  Created by unico_0 on 6/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SSearchTopicTableView.h"
#import "StopicListModel.h"
#import "STopicListTableViewCell.h"
#import "SUtilityTool.h"

@interface SSearchTopicTableView () <UITableViewDataSource, UITableViewDelegate, STopicListTableViewCellDelegate>
{
    NSArray *_contentModelArray;
}
@property (nonatomic, weak) UIView *showNoneData;
@end

static NSString *cellIdentifier = @"STopicListTableViewCellIdentifier";
@implementation SSearchTopicTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_C4;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerNib:[UINib nibWithNibName:@"STopicListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return self;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    _contentModelArray = [StopicListModel modelArrayForDataArray:contentArray];
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
        label.text = @"抱歉，没有找到相关的话题，请重新搜索";
        [view addSubview:label];
        
        frame = CGRectMake(0, 160, self.frame.size.width, 40);
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:frame];
        nameLabel.backgroundColor = COLOR_C4;
        nameLabel.textColor = COLOR_C6;
        nameLabel.font = FONT_t4;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"热门话题推荐";
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

#pragma mark - touch action
- (void)topicTouchNextAction:(UIButton *)button contentModel:(StopicListModel *)model{
    if (self.opration) {
        self.opration(model);
    }
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    STopicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.parentVC = self.targetController;
    StopicListModel *model = _contentModelArray[indexPath.row];
    cell.contentModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_topicDelegate && [_topicDelegate respondsToSelector:@selector(listViewDidScroll:)]) {
        [_topicDelegate listViewDidScroll:scrollView];
    }
}

@end
