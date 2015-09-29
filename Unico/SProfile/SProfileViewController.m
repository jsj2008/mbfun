//
//  SProfileViewController.m
//  Wefafa
//
//  Created by unico on 15/5/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SProfileViewController.h"
#import "SCollocationCollectionViewCell.h"
#import "SCollocationCollectionViewLayout.h"
#import "LNGood.h"


@interface SProfileViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

// 商品列表数组
@property (nonatomic, strong) NSMutableArray *goodsList;
// 当前的数据索引
@property (nonatomic, assign) NSInteger index;


// 瀑布流布局
@property (nonatomic)  SCollocationCollectionViewLayout *collectionFlowLayout;
// 底部视图
@property (nonatomic) UICollectionReusableView *footerView;
@property (nonatomic) UICollectionReusableView *headerView;
// 是否正在加载数据标记
@property (nonatomic, assign, getter=isLoading) BOOL loading;

@end

@implementation SProfileViewController
static NSString* CollocationCellReuseIdentifier = @"CollocationCellReuseIdentifier";
static NSString* HeaderReuseIdentifier = @"HeaderReuseIdentifier";
static NSString* FooterReuseIdentifier = @"FooterReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置页眉高度,默认600
    self.headerViewHeight = 600;
    [self loadData];
    [self setHeaderView];
    
    [self setCollectionView];
    //最上面遮盖下
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 40)];
    [tempView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:tempView];
    self.collectionView.backgroundColor =UIColorFromRGB(0x262626);
    //布局界面
    [self setHeadTitle];
}
//生成带箭头的线
-(UIImage*)getArrowLine{
    UIImage* tempImage = [UIImage imageNamed:@"djt_line"];
    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 750/2, 2, 750/2-1) resizingMode:UIImageResizingModeStretch];
    return tempImage;
}

//生成普通的线
-(UIImage*)getNormalLine{
    UIImage* tempImage = [UIImage imageNamed:@"line"];
    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeStretch];
    return tempImage;
}

-(void)setHeadTitle{
    //顶端背景
    UIImageView *topBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_bg"]];
    topBgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 128/2);
    [topBgView setUserInteractionEnabled:YES];
    
    //添加返回
    UIImageView *tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shop"]];
    tempView.frame = CGRectMake(0, 20, 38/2, 34/2);
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBack:)];
    [tempView setUserInteractionEnabled:YES];
    [tempView addGestureRecognizer:recognizer];
    [topBgView addSubview:tempView];
    
    //有范logo
    tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shop"]];
    tempView.frame = CGRectMake(0, 20, 38/2, 34/2);
    
    //分享
    tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart"]];
    tempView.frame = CGRectMake(self.view.frame.size.width-88,20,  88/2, 88/2);
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCart:)];
    [tempView setUserInteractionEnabled:YES];
    [tempView addGestureRecognizer:recognizer];
    [topBgView addSubview:tempView];
    
    //购物袋
    UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-44, 20,88/2,88/2)];
    [tempBtn setImage:[UIImage imageNamed:@"icon_share" ] forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:tempBtn];
    
    
    [self.view addSubview:topBgView];
    
}
//添加标签和闪烁动画
-(void)addTag:(NSString*) str fontStyle:(UIFont*)fontStyle imageView:(UIImageView*)imageView point:(CGPoint)point{
    UIImage *tempImage = [UIImage imageNamed:@"bq_d"];
    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(20/2-1, 34/2-1, 20/2-1, 34/2-1) resizingMode:UIImageResizingModeStretch];
    UIImageView *bqView = [[UIImageView alloc]initWithImage:tempImage];
    NSString *tempStr =str;
    CGSize labelSize  = [tempStr sizeWithAttributes:@{ NSFontAttributeName : fontStyle }];
    bqView.frame =  CGRectMake(point.x, point.x, labelSize.width+30, 20);
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, labelSize.width, 20)];
    tempLabel.text = tempStr;
    tempLabel.font = fontStyle;
    tempLabel.textColor = [UIColor whiteColor];
    [bqView addSubview:tempLabel];
    [imageView addSubview:bqView];
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    NSString *imageName;
    UIImage *image;
    for (int i = 1; i<9; i++)
    {
        imageName = [[NSString alloc] initWithFormat:@"u_tag_%d",i];
        image =[UIImage imageNamed:imageName];
        [imageArr addObject:image];
    }
    
    UIImageView *animationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-40/2, bqView.frame.size.height/2-40/2/2, 40/2, 40/2)];
    
    animationImageView.animationImages = imageArr;//将序列帧数组赋给UIImageView的animationImages属性
    animationImageView.animationDuration = 2;//设置动画时间
    animationImageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [animationImageView startAnimating];//开始播放动画
    [bqView addSubview:animationImageView];
    
    
    
}

-(void) setHeaderView{
    NSInteger offset = 0;
    contentView = [UIView new];
    UIView *tempUIView;
    UILabel *tempLabel;
    UIImageView *tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic1"]];
    tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 818/2/2);
    [contentView addSubview:tempView];
    //头像
    UIImageView *headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic1"]];
    headView.frame = CGRectMake(tempView.frame.size.width/2 - 44, tempView.frame.size.height/2-44, 88, 88);
    headView.layer.cornerRadius = headView.frame.size.height/2;
    headView.clipsToBounds = YES;
    [tempView addSubview:headView];
    
    //字体
    UIFont *fontStyle = [UIFont systemFontOfSize:12];
//    //在图片上弄标签
//    [self addTag:@"美女" fontStyle:fontStyle imageView:tempView point:CGPointMake(tempView.frame.size.width/2, tempView.frame.size.height/2)];
    
    offset += 818/2;
    
    NSInteger bgOffset = 0;
    
    //******uiview 1
    UIImageView *bgContent  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dp_bg"]];
    
    [contentView addSubview:bgContent];
    
    bgOffset += 10;
    tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"biaoqian"]];
    tempView.frame = CGRectMake(10, bgOffset, 24/2, 23/2);
    [bgContent addSubview:tempView];
    
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(24/2+10+10, bgOffset, self.view.frame.size.width, 23/2)];
    tempLabel.text = @"#夏日 ＃NIKE ";
    tempLabel.textColor = [UIColor yellowColor];
    [bgContent addSubview:tempLabel];
    bgOffset += 23/2;
    bgOffset += 10;
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, bgOffset, self.view.frame.size.width*2/3, 60)];
    tempLabel.text = @"UICollectionView与UITableView的实现类似，都需要设置delegate和dataSource在collectionView中，cell的布局比tableView要复杂";
    [tempLabel setNumberOfLines:2];
    tempLabel.font = [UIFont systemFontOfSize:14];
    tempLabel.textColor = [UIColor whiteColor];
    [bgContent addSubview:tempLabel];
    bgOffset += 60;
    
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,bgOffset, self.view.frame.size.width, 20)];
    tempLabel.text = @"推荐搭配";
    tempLabel.textColor = [UIColor yellowColor];
    tempLabel.font = [UIFont systemFontOfSize:20];
    [bgContent addSubview:tempLabel];
    
    //价格
    tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kuang"]];
    tempView.frame = CGRectMake(self.view.frame.size.width -10 - self.view.frame.size.width/4,10,self.view.frame.size.width/4, 50);
    [bgContent addSubview:tempView];
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,tempView.frame.size.height/2-10, tempView.frame.size.width-20, 20)];
    tempLabel.text = @"¥283";
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.textColor = [UIColor yellowColor];
    tempLabel.font = [UIFont systemFontOfSize:20];
    [tempView addSubview:tempLabel];
    
    
    bgOffset += 20;
    //箭头分割线
    tempView = [[UIImageView alloc]initWithImage:[self getArrowLine]];
    tempView.frame = CGRectMake(0, bgOffset, self.view.frame.size.width, 5);
    [bgContent addSubview:tempView];
    bgOffset += 10;
    bgOffset += 1;
    UIView *tempContent;
    
    //搭配详情
    NSInteger widthLen = (self.view.frame.size.width -20-6)/4;
    tempContent = [UIView new];
    tempContent.frame = CGRectMake(0,bgOffset, self.view.frame.size.width-20, widthLen+20);
    
    [bgContent addSubview:tempContent];
    NSArray *picAry = @[@"pic2",@"pic3",@"pic4",@"pic5"];
    for (int i = 0 ; i<[picAry count]; i++) {
        
        tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:picAry[i]]];
        tempView.frame = CGRectMake(10 +i*(widthLen+2),10, widthLen,widthLen);
        [tempContent addSubview:tempView];
    }
    bgOffset += widthLen+20;
    tempView = [[UIImageView alloc]initWithImage:[self getNormalLine]];
    tempView.alpha = 0.2;
    tempView.frame = CGRectMake(0,bgOffset,self.view.frame.size.width, 1);
    [bgContent addSubview:tempView];
    bgOffset += 1;
    bgOffset += 10;
    //设计师
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,bgOffset, 100, 20)];
    tempLabel.text = @"商品详情";
    tempLabel.textColor = [UIColor yellowColor];
    tempLabel.font = [UIFont systemFontOfSize:22];
    [bgContent addSubview:tempLabel];
    bgOffset += 20;
    bgOffset += 10;
    //箭头的线
    tempView = [[UIImageView alloc]initWithImage:[self getArrowLine]];
    tempView.frame = CGRectMake(0, bgOffset, self.view.frame.size.width, 5);
    [bgContent addSubview:tempView];
    bgOffset += 5;
    bgOffset += 1;
    //自适应背景大小
    bgContent.frame = CGRectMake(0, 818/2, self.view.frame.size.width, bgOffset);
    
    offset += bgOffset;
    
    //******uiview 2
    //商品详情
    UIView *itemContent = [UIView new];
    NSInteger itemContentOffset = 0;
    itemContent.frame = CGRectMake(0, offset, self.view.frame.size.width, 200);
    itemContent.backgroundColor = [UIColor blackColor];
    [contentView addSubview: itemContent];
    //编辑推荐
    itemContentOffset += 10;
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,itemContentOffset, self.view.frame.size.width -20, 20)];
    tempLabel.text = @"编辑推荐";
    tempLabel.textColor = [UIColor whiteColor];
    [itemContent addSubview:tempLabel];
    NSString *editStr =  @"编辑印像中，Swing 的许多组件都可设置 Insets 属性，可对于 iOS 的控件就没那么幸运了，比如我想设置 UILable UITextField 中的文本离边界的间隙，无伦是在 xi";
    CGSize labelSize = [editStr sizeWithAttributes:@{ NSFontAttributeName : fontStyle }];
    float height = (labelSize.width/(self.view.frame.size.width - 20));
    height = ceil(height);
    height = height*(labelSize.height);
    itemContentOffset += 20;
    itemContentOffset += 10;
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,itemContentOffset, self.view.frame.size.width -20, height)];
    [tempLabel setNumberOfLines:10];
    tempLabel.text = editStr;
    tempLabel.font = fontStyle;
    tempLabel.textColor = [UIColor whiteColor];
    [itemContent addSubview:tempLabel];
    itemContentOffset += height;
    itemContentOffset += 10;
    tempView = [[UIImageView alloc]initWithImage:[self getNormalLine]];
    tempView.alpha = 0.2;
    tempView.frame = CGRectMake(0,itemContentOffset,self.view.frame.size.width, 1);
    [itemContent addSubview:tempView];
    itemContentOffset += 1;
    itemContentOffset += 10;
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,itemContentOffset, self.view.frame.size.width -20, 20)];
    tempLabel.text = @"商品信息";
    tempLabel.textColor = [UIColor whiteColor];
    [itemContent addSubview:tempLabel];
    itemContentOffset += 20;
    itemContentOffset += 10;
    NSString *strTemp = @"高";
    labelSize = [strTemp sizeWithAttributes:@{ NSFontAttributeName : fontStyle }];
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,itemContentOffset, self.view.frame.size.width -20, labelSize.height)];
    tempLabel.text = @"品牌：海澜之家";
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.font = fontStyle;
    [itemContent addSubview:tempLabel];
    itemContentOffset += labelSize.height;
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,itemContentOffset, self.view.frame.size.width -20, labelSize.height)];
    tempLabel.text = @"款名：西装";
    tempLabel.textColor = [UIColor whiteColor];
    [itemContent addSubview:tempLabel];
    tempLabel.font = fontStyle;
    itemContentOffset += labelSize.height;
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,itemContentOffset, self.view.frame.size.width -20, labelSize.height)];
    tempLabel.text = @"款号：3333";
    tempLabel.textColor = [UIColor whiteColor];
    [itemContent addSubview:tempLabel];
    tempLabel.font = fontStyle;
    itemContentOffset += labelSize.height;
    itemContentOffset += 20;
    
    tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic1"]];
    tempView.frame = CGRectMake(10, itemContentOffset, self.view.frame.size.width-20, 818/2);
    [itemContent addSubview:tempView];
    itemContentOffset += 818/2;
    itemContentOffset += 20;
    tempView = [[UIImageView alloc]initWithImage:[self getNormalLine]];
    tempView.alpha = 0.2;
    tempView.frame = CGRectMake(0,itemContentOffset,self.view.frame.size.width, 1);
    [itemContent addSubview:tempView];
    itemContentOffset += 1;
    itemContentOffset += 10;
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,itemContentOffset, self.view.frame.size.width -20, 20)];
    tempLabel.text = @"尺码参考";
    tempLabel.textColor = [UIColor whiteColor];
    [itemContent addSubview:tempLabel];
    itemContentOffset += tempLabel.frame.size.height;
    itemContentOffset += 10;
    
    UIView *sizeView = [UIView new];
    sizeView.frame = CGRectMake(10, itemContentOffset, self.view.frame.size.width - 20, 300);
    sizeView.backgroundColor = [UIColor whiteColor];
    [itemContent addSubview:sizeView];
    itemContentOffset += sizeView.frame.size.height;
    itemContentOffset += 30;
    tempView = [[UIImageView alloc]initWithImage:[self getNormalLine]];
    tempView.alpha = 0.2;
    tempView.frame = CGRectMake(0,itemContentOffset,self.view.frame.size.width, 1);
    [itemContent addSubview:tempView];
    itemContentOffset += 1;
    offset += itemContentOffset;
    
    //******uiview 4
    tempUIView = [UIView new];
    [contentView addSubview: tempUIView];
    //banner
    NSInteger tempUIOffset = 0;
    tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banner"]];
    tempView.frame = CGRectMake(10,10,self.view.frame.size.width-20, 189/2);
    [tempUIView addSubview:tempView];
    tempUIOffset += 189/2;
    tempUIOffset += 20;
    //点赞数
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,tempUIOffset, self.view.frame.size.width-10, 20)];
    tempLabel.text = @"点赞 9999";
    tempLabel.textAlignment = NSTextAlignmentLeft;
    tempLabel.textColor = [UIColor whiteColor];
    [tempUIView addSubview:tempLabel];
    tempUIOffset += 20;
    tempUIOffset += 10;
    //带箭头线
    tempView = [[UIImageView alloc]initWithImage:[self getArrowLine]];
    tempView.frame = CGRectMake(0, tempUIOffset, self.view.frame.size.width, 5);
    [tempUIView addSubview:tempView];
    tempUIOffset += 5;
    tempUIView.frame = CGRectMake(0, offset, self.view.frame.size.width, tempUIOffset);
    
    offset += tempUIOffset;
    //******uiview 5
    //点赞人头像
    
    picAry = @[@"pic1",@"pic1",@"pic1",@"pic1",@"pic1",@"pic1",@"pic1",@"pic1"];
    tempUIView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, 60)];
    tempUIView.backgroundColor = [UIColor blackColor];
    [contentView addSubview: tempUIView];
    for (int i = 0; i<[picAry count]; i++) {
        tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:picAry[i]]];
        tempView.frame = CGRectMake(10+i*(88/2+10), tempUIView.frame.size.height/2-88/2/2, 88/2, 88/2);
        tempView.layer.cornerRadius = 88/2/4;
        tempView.clipsToBounds = YES;
        [tempUIView addSubview:tempView];
    }
    
    offset+=60;
    tempView = [[UIImageView alloc]initWithImage:[self getNormalLine]];
    tempView.frame = CGRectMake(10,offset,self.view.frame.size.width, 1);
    tempView.alpha = 0.2;
    [tempUIView addSubview:tempView];
    offset += 1;
    
    tempUIView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, 50)];
    tempUIView.backgroundColor = [UIColor blackColor];
    [contentView addSubview: tempUIView];
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,0, self.view.frame.size.width/4, 50)];
    tempLabel.text = @"评论9999";
    tempLabel.textAlignment = NSTextAlignmentLeft;
    tempLabel.textColor = [UIColor whiteColor];
    [tempUIView addSubview:tempLabel];
    for (int i = 0; i<5; i++) {
        tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add1"]];
        tempView.frame = CGRectMake(self.view.frame.size.width/4+10+10+i*29/2,tempUIView.frame.size.height/2 - 29/2/2,29/2, 29/2);
        [tempUIView addSubview:tempView];
    }
    
    tempView = [[UIImageView alloc]initWithImage:[self getNormalLine]];
    tempView.alpha = 0.2;
    tempView.frame = CGRectMake(0,tempUIView.frame.size.height -1,self.view.frame.size.width, 1);
    [tempUIView addSubview:tempView];
    
    tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_arrow_y"]];
    tempView.frame = CGRectMake(tempUIView.frame.size.width -14/2 -20,tempUIView.frame.size.height/2-28/2/2,14/2, 28/2);
    [tempUIView addSubview:tempView];
    offset += tempUIView.frame.size.height;
    //******uiview 6
    //推荐搭配
    NSInteger textLen = 80;
    tempUIView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, 60)];
    [contentView addSubview: tempUIView];
    tempView = [[UIImageView alloc]initWithImage:[self getNormalLine]];
    tempView.alpha = 0.2;
    tempView.frame = CGRectMake(0,tempUIView.frame.size.height/2,(self.view.frame.size.width-textLen)/2, 1);
    [tempUIView addSubview:tempView];
    tempView = [[UIImageView alloc]initWithImage:[self getNormalLine]];
    tempView.alpha = 0.2;
    tempView.frame = CGRectMake(self.view.frame.size.width/2+textLen/2,tempUIView.frame.size.height/2,(self.view.frame.size.width-50)/2, 1);
    [tempUIView addSubview:tempView];
    
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake((self.view.frame.size.width-textLen)/2,0, textLen, 60)];
    tempLabel.text = @"推荐搭配";
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.textColor = [UIColor whiteColor];
    [tempUIView addSubview:tempLabel];
    offset += 60;
    self.headerViewHeight = offset;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)getNewData{
    NSArray *goods = [LNGood goodsWithIndex:self.index];
    [self.goodsList addObjectsFromArray:goods];
    self.index++;
    self.collectionFlowLayout.goodsList = self.goodsList;
    // 刷新数据
    [self.collectionView reloadData];
}
-(void) setCollectionView{
    // 设置布局的属性
    self.collectionFlowLayout = [SCollocationCollectionViewLayout new];
    self.collectionFlowLayout.itemSize = CGSizeMake(153,204);
    self.collectionFlowLayout.minimumInteritemSpacing = 15;
    self.collectionFlowLayout.minimumLineSpacing = 10;
    self.collectionFlowLayout.columnCount = 2;
    self.collectionFlowLayout.goodsList = self.goodsList;
    self.collectionFlowLayout.headerViewHeight = self.headerViewHeight;
    self.collectionFlowLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.headerViewHeight);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.collectionFlowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[SCollocationCollectionViewCell class] forCellWithReuseIdentifier:CollocationCellReuseIdentifier];
    // 注意这里注册head的方式。
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderReuseIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterReuseIdentifier];
    // 刷新数据
    [self.collectionView reloadData];
}
/**
 *  加载数据
 */
- (void)loadData {
    NSArray *goods = [LNGood goodsWithIndex:self.index];
    [self.goodsList addObjectsFromArray:goods];
    self.index++;
    
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建可重用的cell
    SCollocationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollocationCellReuseIdentifier forIndexPath:indexPath];
    //判断是否是重用
    if(!cell.good) {
        [cell initWaterFallFlowCell];
    }
    cell.good = self.goodsList[indexPath.item];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, self.headerViewHeight);
}

/**
 *  追加视图
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *temp = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterReuseIdentifier forIndexPath:indexPath];
        temp = self.footerView;
        
    }
    else  if(kind == UICollectionElementKindSectionHeader){
        self.headerView= [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderReuseIdentifier forIndexPath:indexPath];
        [self.headerView addSubview:contentView];
        self.headerView.backgroundColor = UIColorFromRGB(0x262626);
        
        temp = self.headerView;
    }
    return temp;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)clickBack:(id)selector{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickShare:(id)selector{
    NSLog(@"分享");
}


#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    
    CGRect bounds = scrollView.bounds;
    
    CGSize size = scrollView.contentSize;
    
    UIEdgeInsets inset = scrollView.contentInset;
    
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    
    CGFloat maximumOffset = size.height;
    SGLOBAL_DATA_INSTANCE.scrollSelectedOffset = currentOffset;
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    if((maximumOffset-currentOffset) <= 0 && (maximumOffset-currentOffset)>-1)
    {
        NSLog(@"开始刷新");
        // 如果正在刷新数据，不需要再次刷新
        self.loading = YES;
        //[self.footerView.indicator startAnimating];
        // 模拟数据刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //self.footerView = nil;
            [self getNewData];
            self.loading = NO;
        });
    }
    
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - 懒加载
- (NSMutableArray *)goodsList {
    if (_goodsList == nil) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}
@end
