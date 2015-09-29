//
//  SCollocationParticipateContentView.m
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationParticipateContentView.h"
#import "SCollocationDetailModel.h"
#import "SCollocationShowImageCell.h"
#import "SUtilityTool.h"
#import "SMineViewController.h"
#import "SCollocationLoversController.h"
#import "CommentsViewController.h"

@interface SCollocationParticipateContentView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, weak) UIView *commentContentView;
@property (nonatomic, weak) UIView *commentLevelView;
@property (nonatomic, weak) UIView *commentTitleContentView;

@end

static NSString *cellIdentifier = @"SCollocationShowImageCellIdentifier";
@implementation SCollocationParticipateContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    UIView *view = [self createTitleJumpViewWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 80)];
    _likeLabel = [self createTitleLaebl];
    [view addSubview:_likeLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLikeCellAction:)];
    [_likeLabel addGestureRecognizer:tap];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 10.0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(30, 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_likeLabel.frame) + 10, UI_SCREEN_WIDTH, 30) collectionViewLayout:layout];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SCollocationShowImageCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentCollectionView];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), UI_SCREEN_WIDTH, 40)];
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    _commentTitleContentView = view;
    _commentLabel = [self createTitleLaebl];
    [view addSubview:_commentLabel];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCommentCellAction:)];
    [_commentLabel addGestureRecognizer:tap];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5);
    lineLayer.zPosition = 5;
    lineLayer.backgroundColor = COLOR_C9.CGColor;
    [_commentTitleContentView.layer addSublayer:lineLayer];
    
    UIView *commentContentView = [self createCommentViewWithFrame:CGRectMake(65, 0, 100, 40)];
    [view addSubview:commentContentView];
    _commentContentView = commentContentView;
    
    _likeLabel.text = @"喜欢";
    _commentLabel.text = @"评论";
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    self.contentModelArray = contentModel.like_user_list;
    _likeLabel.text = [NSString stringWithFormat:@"喜欢(%@)", contentModel.like_count];
    
    NSString *commentString = [NSString stringWithFormat:@"评论(%@)", contentModel.comment_count];
    _commentLabel.text = commentString;
    
    CGSize size = [commentString sizeWithAttributes:@{NSFontAttributeName: FONT_t4}];
    CGRect frame = _commentContentView.frame;
    frame.origin.x = size.width + _commentLabel.frame.origin.x + 5;
    _commentContentView.frame = frame;
    
    int commentCount = contentModel.comment_count.intValue;
    int commentScore = contentModel.comment_score.intValue;
    CGFloat score = commentCount == 0? 0: commentScore/ (CGFloat)commentCount;
    _commentLevelView.width = score/ 5.0 * _commentContentView.width;
    
    frame = _commentTitleContentView.frame;
    if(contentModel.isNoneShopping){
        frame.size.height = 39.5;
    }else{
        frame.size.height = 40;
    }
    _commentTitleContentView.frame = frame;
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    if (contentModelArray.count <= 0){
        self.height = 80;
        _contentCollectionView.hidden = YES;
        _commentTitleContentView.top = 40;
    }else{
        self.height = 120;
        _contentCollectionView.hidden = NO;
        _commentTitleContentView.top = 80;
    }
    [_contentCollectionView reloadData];
}

- (UIView*)createTitleJumpViewWithFrame:(CGRect)frame{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    
//    CALayer *lineLayer = [CALayer layer];
//    lineLayer.frame = CGRectMake(0, frame.size.height - 0.5, UI_SCREEN_WIDTH, 0.5);
//    lineLayer.zPosition = 5;
//    lineLayer.backgroundColor = COLOR_C9.CGColor;
//    [view.layer addSublayer:lineLayer];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.width - 15, 40)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setImage:[UIImage imageNamed:@"Unico/right_arrow"] forState:UIControlStateNormal];
    [view addSubview:button];
    return view;
}

- (UILabel *)createTitleLaebl{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH - 10, 20)];
    titleLabel.userInteractionEnabled = YES;
    titleLabel.font = FONT_t4;
    titleLabel.textColor = COLOR_C2;
    return titleLabel;
}

- (UIView*)createCommentViewWithFrame:(CGRect)frame{
//    隐藏评分信息
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.hidden = YES;
    
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

#pragma mark - action

- (void)touchLikeCellAction:(UITapGestureRecognizer*)tap{
    //喜欢
    if (_contentModel.aID.length){
        SCollocationLoversController *loverController = [[SCollocationLoversController alloc] init];
        loverController.collocationId = _contentModel.aID;
        [_target.navigationController pushViewController:loverController animated:YES];
    }
}

- (void)touchCommentCellAction:(UITapGestureRecognizer*)tap{
    return;
    if (_contentModel.aID.length){
        CommentsViewController *controller = [CommentsViewController new];
        controller.collocationID =[NSString stringWithFormat:@"%@",_contentModel.aID] ;
        [_target.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SCollocationShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    SDiscoveryUserModel *model = _contentModelArray[indexPath.row];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    cell.contentImageView.layer.cornerRadius = 15.0;
    cell.contentImageView.layer.masksToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMineViewController *vc = [[SMineViewController alloc]init];
    SDiscoveryUserModel *model = _contentModelArray[indexPath.row];
    vc.person_id = model.user_id;
    [_target.navigationController pushViewController:vc animated:YES];
}

@end
