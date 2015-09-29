//
//  GoodsCommentListTableViewCell.m
//  Wefafa
//
//  Created by Jiang on 3/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "GoodsCommentListTableViewCell.h"
#import "SUtilityTool.h"

@interface GoodsCommentListTableViewCell ()
{
    CGFloat _rowLableSumWidth;
    
    // 用于去除最后一行数据的分割线
    NSInteger _currentIndex;
    NSInteger _sizeArrCount;
}

@property (nonatomic, strong) NSMutableArray *contentViewArray;

@end

@implementation GoodsCommentListTableViewCell

- (instancetype)initWithSubViewsCount:(NSInteger)count sizeArray:(NSArray*)sizeArray cellSize:(CGSize)cellSize
{
    self = [super init];
    if (self) {
        _sizeArrCount = sizeArray.count;
        
        _contentViewArray = [NSMutableArray array];
        _rowLableSumWidth = 0.0;
        for (NSNumber *number in sizeArray) {
            _rowLableSumWidth += number.floatValue;
        }
        CGFloat space = (cellSize.width - _rowLableSumWidth)/ (sizeArray.count + 1);
        space = MAX(space, 0);
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat widthSum = 0.0;
        for (int i = 0; i < sizeArray.count; i++) {
            NSNumber *widthNumber = sizeArray[i];
            CGRect rect = CGRectMake(space + space * i + widthSum, 0, widthNumber.floatValue, 25);
            UILabel *label = [[UILabel alloc]initWithFrame:rect];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:11];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            [_contentViewArray addObject:label];
            widthSum += widthNumber.floatValue;
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (_currentIndex == _sizeArrCount-1) {
        return ;
    }
    [self addSeparatorLine];
}

- (void)addSeparatorLine
{
//    CALayer *lineLayer = [CALayer layer];
//    lineLayer.backgroundColor = COLOR_C9.CGColor;
//    lineLayer.frame = CGRectMake(25, self.frame.size.height-0.5, self.frame.size.width-50, 0.5);
//    [self.layer addSublayer:lineLayer];
    CGRect frame = CGRectMake(15, self.frame.size.height-0.5, self.frame.size.width-30, 0.5);
    UIView *lindView = [[UIView alloc] initWithFrame:frame];
    lindView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lindView];
}

- (void)setContentArray:(NSArray *)array index:(NSInteger)index{
    _currentIndex = index;
    
    _contentArray = array;
    long int sumCount = MIN(array.count, _contentViewArray.count);
    for (int i = 0; i < sumCount; i ++) {
        
        UILabel *label = _contentViewArray[i];
        NSArray *tempArr = array[i];
        if (index < tempArr.count) {  // 数组越界
            label.text = [NSString stringWithFormat:@"%@", tempArr[index]];
        }
    }
}

- (NSMutableArray *)subLabelMutableArray{
    if (!_subLabelMutableArray) {
        _subLabelMutableArray = [NSMutableArray array];
    }
    return _subLabelMutableArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
