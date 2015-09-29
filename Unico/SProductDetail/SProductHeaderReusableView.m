//
//  SProductHeaderReusableView.m
//  Wefafa
//
//  Created by unico_0 on 7/21/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SProductHeaderReusableView.h"
#import "MBGoodsDetailsShowPictureView.h"
#import "SProductRelatedCollocationView.h"
#import "SProductSelectedModuleView.h"
#import "SProductShowInfoView.h"
#import "SProductDetaileModuleView.h"
#import "GoodsCommentView.h"
#import "SBrandSotryViewController.h"
#import "SProductCommentTableView.h"
#import "SActivityDiscountViewController.h"
#import "SActivityReceiveViewController.h"
#import "DailyNewViewController.h"
#import "SUtilityTool.h"
#import "SProductDetailModel.h"
#import "Utils.h"


#import "ProductSimilarityView.h"
#import "ProductCollocationView.h"
#import "UIScrollView+MJRefresh.h"
#import "SActivityDiscountViewController.h"
#import "JSWebViewController.h"

@interface SProductHeaderReusableView () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *showPlayerContentView;
@property (strong, nonatomic) MBGoodsDetailsShowPictureView *showPlayerView;

@property (weak, nonatomic) IBOutlet UIView *commentAndSizeView;
@property (weak, nonatomic) UIView *commentLevelView;
@property (weak, nonatomic) UILabel *commentLb;

//------
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;    // 画线价格
@property (weak, nonatomic) IBOutlet UILabel *productSaleLabel;     // 出售价格
@property (weak, nonatomic) IBOutlet UILabel *productDiscountLabel; // 折扣
@property (weak, nonatomic) IBOutlet UIImageView *productBrandImageView;
@property (weak, nonatomic) IBOutlet UILabel *productBrandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productBrandDescription;
@property (weak, nonatomic) IBOutlet UIView *salePriceDeleteLineView;
@property (weak, nonatomic) IBOutlet SProductShowInfoView *showProductInfoView;
@property (weak, nonatomic) IBOutlet UIButton *showAllActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *showListActivityButton;
@property (weak, nonatomic) IBOutlet UIImageView *activityShowArrow;

@property (weak, nonatomic) IBOutlet UIView *nameView;  // showPlayer下的品牌名和价格折扣
//------------
@property (nonatomic, strong) SProductDetaileModuleView *detailView;
@property (nonatomic, strong) GoodsCommentView *sizeTableView;
@property (nonatomic, strong) SProductCommentTableView *commentView;
@property (nonatomic, weak) UITableView *showActivityTableView;

@property (nonatomic, strong) ProductSimilarityView *similiarView;
@property (nonatomic, strong) ProductCollocationView *collocationView;

@end

@implementation SProductHeaderReusableView

- (void)awakeFromNib {
    [self initSubViews];
    self.backgroundColor = COLOR_C4;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)initSubViews{
    _showPlayerView = [[MBGoodsDetailsShowPictureView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH)];
    [_showPlayerContentView addSubview:_showPlayerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(brandContentViewTap:)];
    [self.brandContentView addGestureRecognizer:tap];
    
    self.showAllActivityButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                 action:@selector(touchActivityViewShowAction:)];
    [_activityContentView addGestureRecognizer:tap];
    
    // 底部线条
    CALayer *funwearCommitmentViewLineLayer = [CALayer layer];
    funwearCommitmentViewLineLayer.frame = CGRectMake(0, 65-0.5, UI_SCREEN_WIDTH, 0.5f);
    funwearCommitmentViewLineLayer.backgroundColor = COLOR_C9.CGColor;
    [self.funwearCommitmentView.layer addSublayer:funwearCommitmentViewLineLayer];
    
    CALayer *brandContentViewLineLayer = [CALayer layer];
    brandContentViewLineLayer.frame = CGRectMake(0, 60-0.5, UI_SCREEN_WIDTH, 0.5f);
    brandContentViewLineLayer.backgroundColor = COLOR_C9.CGColor;
    [self.brandContentView.layer addSublayer:brandContentViewLineLayer];
    
    // add comment and size view
    // size
    CGRect sizeRect = CGRectMake(0, 0, UI_SCREEN_WIDTH, 50);
    UIView *sizeView = [[UIView alloc] initWithFrame:sizeRect];
    sizeView.tag = 100;
    [sizeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailBtnClicked:)]];
    [self.commentAndSizeView addSubview:sizeView];
    
    CGRect sizeLbRect = CGRectMake(10, 0, 200, 50);
    UILabel *sizeLb = [[UILabel alloc] initWithFrame:sizeLbRect];
    sizeLb.font = FONT_t4;
    sizeLb.textAlignment = NSTextAlignmentLeft;
    sizeLb.backgroundColor = [UIColor clearColor];
    sizeLb.opaque = NO;
    sizeLb.text = @"尺码参数";
    sizeLb.textColor = COLOR_C2;
    [sizeView addSubview:sizeLb];
    
    [sizeView addSubview:[self detailBtnWithY:(50-14)/2 tag:100]];
    
    // line
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(10, 50, UI_SCREEN_WIDTH, 0.5f);
    lineLayer.backgroundColor = COLOR_C9.CGColor;
    [self.commentAndSizeView.layer addSublayer:lineLayer];
    
    // comment
    CGRect commmentRect = CGRectMake(0, 50.5, UI_SCREEN_WIDTH, 50);
    UIView *commentView = [[UIView alloc] initWithFrame:commmentRect];
    [commentView setBackgroundColor:[UIColor whiteColor]];
    commentView.tag = 200;
    [commentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailBtnClicked:)]];
    [self.commentAndSizeView addSubview:commentView];
    
    UILabel *commentLb = [[UILabel alloc] init];
    commentLb.font = FONT_t4;
    commentLb.textAlignment = NSTextAlignmentLeft;
    commentLb.backgroundColor = [UIColor clearColor];
    commentLb.opaque = NO;
    commentLb.textColor = COLOR_C2;
    commentLb.text = @"评价(0)";
    CGSize commentSize = [commentLb.text sizeWithAttributes:@{NSFontAttributeName:FONT_t4}];
    commentLb.frame = CGRectMake(10, 0, commentSize.width, 50);
    [commentView addSubview:commentLb];
    self.commentLb = commentLb;
    
    [commentView addSubview:[self detailBtnWithY:(50-14)/2 tag:200]];
    
    
    // 底部线条
    CALayer *bottonLayer = [CALayer layer];
    bottonLayer.frame = CGRectMake(0, 100, UI_SCREEN_WIDTH, 0.5f);
    bottonLayer.backgroundColor = COLOR_C9.CGColor;
    [self.commentAndSizeView.layer addSublayer:bottonLayer];
    
    
    
    CGFloat commentLevelX = CGRectGetMaxX(commentLb.frame) + 5.f;
    CGRect commentLevelViewRect = CGRectMake(commentLevelX, 0, 100, 50);
    UIView *showCommentLevelView = [[UIView alloc] initWithFrame:commentLevelViewRect];
    showCommentLevelView.backgroundColor = [UIColor clearColor];
    showCommentLevelView.opaque = NO;
    [commentView addSubview:showCommentLevelView];
    self.commentLevelView = showCommentLevelView;
    
    [self initCommentLevelViewWithHeight:50.f];
    
    // 品牌图标加layer
    _productBrandImageView.layer.borderColor = COLOR_C9.CGColor;
    _productBrandImageView.layer.borderWidth = 1.f;
    
//    [_productBrandDescription setFrame:CGRectMake(0, 0, 100, 30)];
    _productBrandDescription.text=[NSString stringWithFormat:@"新品 %d  促销 %d  折扣 %d",0,0,0];
    _productBrandDescription.hidden = YES;

    // -----------
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    lb.opaque = NO;
    lb.backgroundColor = [UIColor clearColor];
    lb.text = @"下面更多惊喜哟!";
    lb.font = FONT_t6;
    lb.textColor = COLOR_C6;
    lb.textAlignment = NSTextAlignmentCenter;
    [self.selectedContentView addSubview:lb];
    
    UIImage *arrowImg = [UIImage imageNamed:@"Unico/icon_home_pull"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:arrowImg];
    [self.selectedContentView addSubview:imgView];
    
    CGSize lbSize = [lb.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 13.f) options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading| NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    CGFloat lbX = (UI_SCREEN_WIDTH-lbSize.width)/2;
    CGFloat lbY = (44-13)/2;
    lb.frame = (CGRect){{lbX, lbY},lbSize};
    CGFloat imgViewX = CGRectGetMinX(lb.frame)-(12+13);
    imgView.frame = CGRectMake(imgViewX, (44-13)/2+2, 13, 13);
    
    CGFloat lineLayerH = (44-0.5)/2;
    CGFloat lineW = (UI_SCREEN_WIDTH-(lbSize.width+12+10*4))/2;
    CGRect leftRect = CGRectMake(10, lineLayerH, lineW-12, 0.5f);
    [self.selectedContentView.layer addSublayer:[self lineLayerWithFrame:leftRect]];
    CGFloat rightX = UI_SCREEN_WIDTH-(lineW+10);
    CGRect rightRect = CGRectMake(rightX, lineLayerH, lineW, 0.5f);
    [self.selectedContentView.layer addSublayer:[self lineLayerWithFrame:rightRect]];
 
    self.selectedContentView.backgroundColor = [UIColor clearColor];
    self.selectedContentView.opaque = NO;
}

- (CALayer *)lineLayerWithFrame:(CGRect)frame
{
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = frame;
    lineLayer.backgroundColor = COLOR_C9.CGColor;
    return lineLayer;
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    _similiarView.target = target;
    _collocationView.target = target;
}

- (void)initCommentLevelViewWithHeight:(CGFloat)height
{
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * 20, (height-20)/2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"Unico/add1"];
        [self.commentLevelView addSubview:imageView];
    }
}

- (void)initTotalScoreViewWithTotalScore:(NSInteger)totalScore commentCount:(NSInteger)commentCount
{
    if (commentCount==0) {
        return ;
    }
    int score = (int)(totalScore/ commentCount * 2 / 1);
    int count = 0;
    for (int i = score; count < 5; count++){
        UIImageView *imageView = _commentLevelView.subviews[count];
        NSString *imageNameString = @"";
        if (i > 1) {
            i -= 2;
            imageNameString = @"Unico/add1";
        }else if(i > 0){
            i --;
            imageNameString = @"Unico/add3";
        }else{
            imageNameString = @"Unico/add2";
        }
        imageView.image = [UIImage imageNamed:imageNameString];
    }
}

- (UIButton *)detailBtnWithY:(CGFloat)y tag:(NSInteger)tag
{
    CGFloat detailBtnX = UI_SCREEN_WIDTH-7-10;
    CGRect detailBtnRect = CGRectMake(detailBtnX, y, 7.f, 14.f);
    UIButton *detailBtn = [[UIButton alloc] initWithFrame:detailBtnRect];
    [detailBtn setImage:[UIImage imageNamed:@"Unico/right_arrow"]
               forState:UIControlStateNormal];
    detailBtn.tag = tag;
    return detailBtn;
}


#pragma mark - btn action methods
- (void)detailBtnClicked:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.view.tag == 100) {
        // 跳转到尺码参数界面
        if (_delegate && [_delegate respondsToSelector:@selector(productHeaderPushToSizeViewWithParameter:)]) {
            [_delegate productHeaderPushToSizeViewWithParameter:nil];
        }
    } else if (tapGesture.view.tag == 200) {
        // 调转到评论界面;
        if (_delegate && [_delegate respondsToSelector:@selector(productHeaderPUshToCommmentViewWithParamete:)]) {
            [_delegate productHeaderPUshToCommmentViewWithParamete:nil];
        }
    }
}

#pragma mark - setter methods
- (void)setContentModel:(SProductDetailModel *)contentModel{
    _contentModel = contentModel;
    MBGoodsDetailsModel *goodsModel = contentModel.goodsDetailModel;
    _showPlayerView.contentModelArray = goodsModel.clsPicUrl;//colorList;
    _productNameLabel.text = goodsModel.clsInfo.name;
    
    CGFloat height = 0;
    if (_contentModel.isShowActivity) {
        height += (_contentModel.activtiyArray.count-1) * 44;
    }
    CGSize size = [_contentModel.goodsDetailModel.clsInfo.name boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH-35, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading| NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    self.height = 431 + UI_SCREEN_WIDTH + size.height + height;
    for (NSLayoutConstraint *layout in _nameView.constraints){
        if (layout.firstAttribute == NSLayoutAttributeHeight) {
            layout.constant = size.height + 80;
        }
    }
    
    _productNameLabel.backgroundColor = [UIColor clearColor];
    
    _showProductInfoView.contentModel = goodsModel.commonCountTotal;
    _productPriceLabel.text = [Utils getSNSRMBMoney:[NSString stringWithFormat:@"%@",goodsModel.clsInfo.price]];
    _productSaleLabel.text = [Utils getSNSRMBMoney:[NSString stringWithFormat:@"%@",goodsModel.clsInfo.sale_price]];

    int discount = 0 ;
    if (goodsModel.clsInfo.price.floatValue!=0) {
        discount = goodsModel.clsInfo.sale_price.floatValue/ goodsModel.clsInfo.price.floatValue * 100;
    }
   
    NSString *discountString;
    if(discount % 10 == 0){
        discountString = [NSString stringWithFormat:@"  %d折  ", (int)discount/ 10];
    }else {
        discountString = [NSString stringWithFormat:@"  %0.1f折  ", discount/ 10.0];
    }
    _productDiscountLabel.text = discountString;

    [_productBrandImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.clsInfo.brandUrl] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    _productBrandNameLabel.text = goodsModel.clsInfo.brand;
//    _productBrandDescription.text=[NSString stringWithFormat:@"新品 %d  促销 %d  折扣 %d",0,0,0];

    if (goodsModel.clsInfo.price.floatValue <= goodsModel.clsInfo.sale_price.floatValue) {
        _salePriceDeleteLineView.hidden = YES;
        _productPriceLabel.hidden = YES;
        _productDiscountLabel.hidden = YES;
    }else{
        _salePriceDeleteLineView.hidden = NO;
        _productPriceLabel.hidden = NO;
        _productDiscountLabel.hidden = NO;
    }
    
    // 活动优惠
    if (contentModel.activtiyArray.count > 0) {
        self.showListActivityButton.hidden = NO;
        SProductDetailActivityModel *activityModel = contentModel.activtiyArray[0];
        [self.showAllActivityButton setTitle:[NSString stringWithFormat:@"%@  ", activityModel.name] forState:UIControlStateNormal];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:activityModel.url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [_showAllActivityButton setImage:image forState:UIControlStateNormal];
        }];
    }else{
//        self.showListActivityButton.hidden = YES;
        self.showListActivityButton.hidden = NO;
        [self.showListActivityButton setTitle:@"暂无优惠   "
                                     forState:UIControlStateNormal];
    }
    
    if (contentModel.activtiyArray.count > 1) {
        self.showListActivityButton.hidden = NO;
        self.activityShowArrow.hidden = NO;
        SProductDetailActivityModel *activityModel = contentModel.activtiyArray[1];
        [self.showListActivityButton setTitle:[NSString stringWithFormat:@"%@  ",activityModel.name] forState:UIControlStateNormal];
        NSString *imageString = activityModel.type.intValue == 1? @"Unico/icon_activity_cu": @"Unico/icon_activity_piao";
        [self.showListActivityButton setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    }else{
        self.activityShowArrow.hidden = YES;
    }
    self.detailView.contentModel = goodsModel;
    self.commentView.contentModel = contentModel;
    self.commentView.target = _target;
    self.showListActivityButton.hidden = _contentModel.isShowActivity;
    if (_contentModel.isShowActivity) {
        [self openActivityList];
    }else{
        [self closeActivityList];
    }
    
    self.commentLb.text = [NSString stringWithFormat:@"评价(%d)", contentModel.goodsDetailModel.commonCountTotal.commentCount.intValue];  // 评论数
    self.commentLb.width = [self.commentLb.text sizeWithAttributes:@{NSFontAttributeName:FONT_t4}].width;
    
    int commentCount = _contentModel.goodsDetailModel.commonCountTotal.commentCount.intValue;
    int commentScore = _contentModel.goodsDetailModel.commonCountTotal.avgComment.intValue * commentCount;
    [self initTotalScoreViewWithTotalScore:commentScore
                              commentCount:commentCount];
}

#pragma mark - 上拉刷新
- (void)requestAddData
{
    // 相似单品的上拉刷新
    if (_delegate && [_delegate respondsToSelector:@selector(similarFootRefreshWithDataBlock:)]) {
        [_delegate similarFootRefreshWithDataBlock:^(NSArray *dataArr) {
            [_similiarView footerEndRefreshing];
            [_similiarView loadNextContentArray:dataArr];
        }];
    }
}

#pragma mark - override setter methods for data
- (void)setCollocationArr:(NSArray *)collocationArr
{
    _collocationView.contentArray = collocationArr;
    [self.collocationView reloadData];
}

- (void)setSmiilartyArr:(NSArray *)smiilartyArr
{
    _similiarView.contentArray = smiilartyArr;
    [self.similiarView reloadData];
}

#pragma mark - action
- (void)brandContentViewTap:(UITapGestureRecognizer*)tap{
    DailyNewViewController *controller = [DailyNewViewController new];
    controller.brandId = [NSString stringWithFormat:@"%@",_contentModel.goodsDetailModel.clsInfo.branD_ID];
    [_target.navigationController pushViewController:controller animated:YES];
}

- (void)touchActivityViewShowAction:(UITapGestureRecognizer*)tap{
    if (_contentModel.activtiyArray.count <= 0) return;
    if (_showActivityTableView) {
        _contentModel.isShowActivity = NO;
    }else{
        _contentModel.isShowActivity = YES;
    }
    if ([self.delegate respondsToSelector:@selector(productHeaderOprationActivityList)]) {
        [self.delegate productHeaderOprationActivityList];
    }
}

- (void)closeActivityList{
    self.showListActivityButton.hidden = NO;
    [_showActivityTableView removeFromSuperview];
    for (NSLayoutConstraint *constraint in _activityContentView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 50;
        }
    }
    [UIView animateWithDuration:0.15 animations:^{
        self.activityShowArrow.transform = CGAffineTransformIdentity;
    }];
    [self updateConstraintsIfNeeded];
}

- (void)openActivityList{
    if (_contentModel.activtiyArray.count <= 0) return;
    self.showListActivityButton.hidden = YES;
    [UIView animateWithDuration:0.15 animations:^{
        self.activityShowArrow.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    CGFloat height = (_contentModel.activtiyArray.count - 1) * 44;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_activityContentView.frame), UI_SCREEN_WIDTH, height) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    for (NSLayoutConstraint *constraint in _activityContentView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 50 + height;
        }
    }
    [self addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    CALayer *layer = [CALayer layer];
    layer.zPosition = 5;
    [tableView.layer addSublayer:layer];
    layer.frame = CGRectMake(10, 0, UI_SCREEN_WIDTH-10, 0.5);
    layer.backgroundColor = COLOR_C9.CGColor;
    _showActivityTableView = tableView;
    [self updateConstraintsIfNeeded];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentModel.activtiyArray.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UITableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = UIColorFromRGB(0x3b3b3b);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ((_contentModel.activtiyArray.count-2) == indexPath.row) {
        [cell.contentView.layer addSublayer:[self addBottomLineWithWidth:UI_SCREEN_WIDTH]];
    } else {
        [cell.contentView.layer addSublayer:[self addBottomLineWithWidth:UI_SCREEN_WIDTH-10]];
    }
    
    SProductDetailActivityModel *activityModel = _contentModel.activtiyArray[indexPath.row + 1];
    cell.textLabel.text = activityModel.name;
    NSString *imageString = activityModel.type.intValue == 1? @"Unico/icon_activity_cu": @"Unico/icon_activity_piao";
    cell.imageView.image = [UIImage imageNamed:imageString];
    return cell;
}

- (CALayer *)addBottomLineWithWidth:(CGFloat)width
{
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(UI_SCREEN_WIDTH-width, 44.f-0.5f, width, 0.5f);
    bottomLine.backgroundColor = COLOR_C9.CGColor;
    return bottomLine;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SProductDetailActivityModel *activityModel = _contentModel.activtiyArray[indexPath.row+1];
    NSString *web_url=[NSString stringWithFormat:@"%@",activityModel.web_url];
    
    if([Utils getSNSString:web_url].length!=0)
    {
        JSWebViewController *jsWebVC=[[JSWebViewController alloc]initWithUrl:web_url];
        jsWebVC.naviTitle = [NSString stringWithFormat:@"%@",activityModel.name];
       [_target.navigationController pushViewController:jsWebVC animated:YES];
        return;
        
    }

    if (activityModel.type.intValue == 1){
        
        // 活动
        SActivityDiscountViewController *controller = [SActivityDiscountViewController new];
        controller.activityID =[NSString stringWithFormat:@"%@",activityModel.aid];
        [_target.navigationController pushViewController:controller animated:YES];
    }
    else if ([[NSString stringWithFormat:@"%@",activityModel.type] isEqualToString:@"-1"]) {
        //正品保证
    }
    else {
        // 饭票
        if ([BaseViewController pushLoginViewController]) {
            SActivityReceiveViewController *controller = [[SActivityReceiveViewController alloc]init];
            controller.activityId = activityModel.aid;
            [_target.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
