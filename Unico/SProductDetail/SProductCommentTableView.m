//
//  SProductCommentTableView.m
//  Wefafa
//
//  Created by Jiang on 8/4/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SProductCommentTableView.h"
#import "SCommentListTableViewCell.h"
#import "SProductDetailCommentModel.h"
#import "CommentsViewController.h"
#import "SProductDetailModel.h"

@interface SProductCommentTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIView *commentContentView;
@property (nonatomic, weak) UIView *commentLevelView;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, weak) UILabel *headerTitleLabel;

@end

static NSString *cellIdentifier = @"SCommentListTableViewCellIdentifier";
@implementation SProductCommentTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSubViews];
}

- (void)initSubViews{
    self.scrollEnabled = NO;
    [self registerNib:[UINib nibWithNibName:@"SCommentListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.delegate = self;
    self.dataSource = self;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    self.tableHeaderView = headerView;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"综合评价：";
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x3b3b3b);
    
    UIView *commentContentView = [self createCommentViewWithFrame:CGRectMake(110, 0, 100, 44)];
    [headerView addSubview:commentContentView];
    
    CALayer *headerLineLayer = [CALayer layer];
    headerLineLayer.backgroundColor = UIColorFromRGB(0xd9d9d9).CGColor;
    headerLineLayer.zPosition = 5.0;
    headerLineLayer.frame = CGRectMake(0, 43.5, UI_SCREEN_WIDTH, 0.5);
    [label.layer addSublayer:headerLineLayer];
    [headerView addSubview:label];
    _headerTitleLabel = label;
    _commentContentView = commentContentView;
    
    _footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40)];
    _footerLabel.text = @"查看所有评论";
    _footerLabel.textAlignment = NSTextAlignmentCenter;
    _footerLabel.textColor = UIColorFromRGB(0x3b3b3b);
    _footerLabel.font = [UIFont systemFontOfSize:13];
    _footerLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchShowAllComment:)];
    [_footerLabel addGestureRecognizer:tap];
    
    CALayer *footerLineLayer = [CALayer layer];
    footerLineLayer.backgroundColor = UIColorFromRGB(0xd9d9d9).CGColor;
    footerLineLayer.zPosition = 5.0;
    footerLineLayer.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5);
    [_footerLabel.layer addSublayer:footerLineLayer];
    self.tableFooterView = _footerLabel;
}

#pragma mark - action

- (void)touchShowAllComment:(UITapGestureRecognizer*)tap{
    CommentsViewController *commentViewController = [CommentsViewController new];
    commentViewController.productID =[NSString stringWithFormat:@"%@", _contentModel.goodsDetailModel.clsInfo.aID];
    int commentCount = _contentModel.goodsDetailModel.commonCountTotal.commentCount.intValue;
    int commentScore = _contentModel.goodsDetailModel.commonCountTotal.avgComment.intValue * _contentModel.goodsDetailModel.commonCountTotal.commentCount.intValue;
    commentViewController.commentCount = commentCount;
    commentViewController.commentTotalScore = commentScore;
    [_target.navigationController pushViewController:commentViewController animated:YES];
}

#pragma mark -

- (UIView*)createCommentViewWithFrame:(CGRect)frame{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    UIView *commentLevelNoneView = [[UIView alloc]initWithFrame:view.bounds];
    commentLevelNoneView.backgroundColor = [UIColor whiteColor];
    [view addSubview:commentLevelNoneView];
    
    frame = view.bounds;
    frame.size.width = 0;
    UIView *commentLevelView = [[UIView alloc]initWithFrame:frame];
    commentLevelView.layer.masksToBounds = YES;
    commentLevelView.backgroundColor = [UIColor whiteColor];
    [view addSubview:commentLevelView];
    _commentLevelView = commentLevelView;
    
    for (int i = 0; i < 5; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 * i, 0, 20, 20)];
        CGPoint point = imageView.center;
        point.y = commentLevelView.centerY;
        imageView.center = point;
        imageView.image = [UIImage imageNamed:@"Unico/add1"];
        [commentLevelView addSubview:imageView];
    }
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 * i, 0, 20, 20)];
        CGPoint point = imageView.center;
        point.y = commentLevelNoneView.centerY;
        imageView.center = point;
        imageView.image = [UIImage imageNamed:@"Unico/add2"];
        [commentLevelNoneView addSubview:imageView];
    }
    view.userInteractionEnabled = NO;
    return view;
}

- (void)setContentModel:(SProductDetailModel *)contentModel{
    _contentModel = contentModel;
    self.contentModelArray = contentModel.commentList;
    _footerLabel.text = [NSString stringWithFormat:@"查看所有评论(%d)", contentModel.goodsDetailModel.commonCountTotal.commentCount.intValue];
    
    int commentScore = contentModel.goodsDetailModel.commonCountTotal.avgComment.intValue;
    [self setScore:commentScore];
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    self.height = [self getCommentListSumHeight];
    [self reloadData];
}

- (CGFloat)getCommentListSumHeight{
    if (_contentModelArray.count <= 0) return 0.0;
    CGFloat sumHeight = 0.0;
    for (SProductDetailCommentModel *model in _contentModelArray){
        CGSize size = [model.content boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 100, 0)
                                                  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}
                                                  context:nil].size;
        sumHeight += size.height - 10 + 50;
    }
    return sumHeight + 84;
}

- (void)setScore:(int)score{
    _commentLevelView.width = score/ 5.0 * _commentContentView.width;
    _headerTitleLabel.text = [NSString stringWithFormat:@"综合评价：%.1d", score];
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.productModel = _contentModelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SProductDetailCommentModel *model = _contentModelArray[indexPath.row];
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 100, 0)
                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}
                                           context:nil].size;
    return size.height - 10 + 50;
}

@end
