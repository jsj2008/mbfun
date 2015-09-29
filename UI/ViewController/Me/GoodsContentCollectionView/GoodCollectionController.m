//
//  GoodCollectionController.m
//  Wefafa
//
//  Created by Jiang on 15/8/28.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "GoodCollectionController.h"
#import "LPLabel.h"
#import "SUtilityTool.h"

#import "GoodsSizeSelectionCollectionView.h"
#import "GoodsColorSelectConllectionView.h"
#import "UIStepperNumberField.h"

#import "MBGoodsDetailsModel.h"
#import "MBGoodsDetailsPictureModel.h"

/** 获取数据 */
#import "UIImageView+WebCache.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "Utils.h"
#import "ModelBase.h"
#import "SDataCache.h"
#import "WeFaFaGet.h"
#import "TalkingData.h"
#import "SProductDetailModel.h"

/** 
    加载
 */
@interface BoundceSpotAnimationView : UIView
@property (nonatomic, strong) CALayer *spotLayer;
- (void)removeAnimation;
@end

@implementation BoundceSpotAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithSize:CGSizeMake(100, 100)];
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)createUIWithSize:(CGSize)size
{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake((self.frame.size.width-size.width)/2, ((self.frame.size.height)/3*2)/2, size.width, size.height);
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:replicatorLayer];
    NSInteger numOfDot = 5;
    CGFloat animationTimer = 1.f;
    replicatorLayer.instanceCount = numOfDot;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(size.width/5, 0, 0);
    replicatorLayer.instanceDelay = animationTimer/numOfDot;
    
    CGFloat radius = size.width/5;
    self.spotLayer = [CALayer layer];
    self.spotLayer.bounds = CGRectMake(0, 0, radius, radius);
    self.spotLayer.position = CGPointMake(radius/2, size.height/2);
    self.spotLayer.cornerRadius = radius/2;
    self.spotLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    self.spotLayer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2);
    [replicatorLayer addSublayer:self.spotLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @0.2;
    animation.toValue = @1;
    animation.duration = animationTimer;
    animation.autoreverses = YES;
    animation.repeatCount = CGFLOAT_MAX;
    
    [self.spotLayer addAnimation:animation forKey:@"animation"];
}

- (void)removeAnimation
{
    [self.spotLayer removeAnimationForKey:@"animation"];
    [self removeFromSuperview];
}

@end



/**
    GoodCollectionController
 */
static const CGFloat kGoodsNumH = 30.f;
static const CGFloat kGoodsNumW = 150.f;

@interface GoodCollectionController ()
    <GoodsColorSelectConllectionViewDelegate,
        GoodsSizeSelectionCollectionViewDelegate>
{
    NSInteger _currentColorIndex;       // 用于索引颜色数组里，当前选中的下标
    NSInteger _currentSizeIndex;        // 用于索引尺码数组里，当前选中的下标
    NSInteger _firIndex;                // 第一次进入控制器的size的下标
    
    NSString *fromControllerName;
    NSMutableArray *canUseSizeArray;    // 可用的尺码数组
    
    UIView *_showNoneData;              // 无数据视图
}

@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UIView *shrunkView;
@property (nonatomic, strong) UIScrollView *myScrollView;

@property (nonatomic, strong) GoodsColorSelectConllectionView *goodsColorView;
@property (nonatomic, strong) GoodsSizeSelectionCollectionView *goodsSizeView;
@property (nonatomic, strong) UIStepperNumberField *goodsNum;
@property (nonatomic, weak) UILabel *numLb;


/** 数据 */
@property (nonatomic, strong) MyShoppingTrollyGoodsData *goodsData;
@property (nonatomic, strong) SProductDetailModel *goodsDetailModel;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSString *productCode;
@property (nonatomic, strong) NSString *promotion_ID;

@property (nonatomic, strong) NSMutableArray *colorArrM;    // 存放颜色
@property (nonatomic, strong) NSMutableArray *sizeArrM;     // 存放尺码

@property (nonatomic, strong) NSString *chooseColorStr;     // 当前界面选中颜色
@property (nonatomic, strong) NSString *chooseSizeStr;      // 当前界面选中尺码
@property (nonatomic, strong) NSString *selectedSizeStr;    // 用户点击尺码

@property (nonatomic, assign) BOOL isProductDetail;         // 是否是单品详情

/** 控件 */
@property (nonatomic, weak) UIButton *doneBtn;
@property (nonatomic, weak) UILabel *storeLb;
@property (nonatomic, weak) UILabel *priceLb;
@property (nonatomic, weak) UILabel *salePriceLb;
@property (nonatomic, weak) UIImageView *titleHeadImgView;

@end

@implementation GoodCollectionController
@synthesize colorArrM = _colorArrM;
@synthesize sizeArrM = _sizeArrM;

#pragma mark - override getter methods for lazy load
- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSMutableArray *)colorArrM
{
    if (!_colorArrM) {
        _colorArrM = [NSMutableArray array];
    }
    return _colorArrM;
}

- (NSMutableArray *)sizeArrM
{
    if (!_sizeArrM) {
        _sizeArrM = [NSMutableArray array];
    }
    return _sizeArrM;
}

#pragma mark - override setter methods for load
- (void)setColorArrM:(NSMutableArray *)colorArrM
{
    _colorArrM = colorArrM;
    [_goodsColorView reloadData];
}

- (void)setSizeArrM:(NSMutableArray *)sizeArrM
{
    _sizeArrM = sizeArrM;
    [_goodsColorView reloadData];
}

#pragma mark - initiliar
- (id)init
{
    self = [super init];
    if (self) {
        //A dark gray color is the default
        _backgroundColor = [UIColor whiteColor];
        //  The modal view
        _modalView = [UIView new];
        [_modalView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        //  The visible view
        _myView = [UIView new];
        [_myView setBackgroundColor:_backgroundColor];
        //  Visible
        _visible = NO;
        //  Should the parent view shrink down?
        _shrinksParentView = NO;
        
        _myScrollView = [UIScrollView new];
        
        _currentColorIndex = -1;
        _currentSizeIndex = -1;
    }
    return self;
}

- (id)initWithProductCode:(NSString *)productCode isProductDetail:(BOOL)isProductDetail{
    self.isProductDetail = YES;
    return [self initWithParameter:nil productCode:productCode promotion_ID:nil];
}

- (id)initWithParameter:(id)parameter productCode:(NSString *)productCode promotion_ID:(NSString *)promotion_ID
{
    self = [self init];
    if (self) {
        _firIndex = -1;

      canUseSizeArray= [@[] mutableCopy];
        if (!fromControllerName) {
            NSInteger count = self.navigationController.viewControllers.count - 2;
            if (count > 0) {
                fromControllerName = NSStringFromClass([self.navigationController.viewControllers[count] class]);
            }
        }

        self.productCode = productCode;
        self.promotion_ID = promotion_ID;
        NSString *imgVStr = @"";
        double salepriceStr=0;
        double priceStr=0;
        NSString *productCode = @"";
        int stocknum = 0;
        //单品详情
        if (parameter && [parameter isKindOfClass:[SProductDetailModel class]]) {
            self.isProductDetail = YES;
            self.goodsDetailModel = (SProductDetailModel *)parameter;
            if ([self.goodsDetailModel.goodsDetailModel.clsPicUrl count]<=0) {
                imgVStr = self.goodsDetailModel.goodsDetailModel.clsInfo.mainImage;
                
            }
            else
            {
                MBGoodsDetailsPictureModel *model = self.goodsDetailModel.goodsDetailModel.clsPicUrl[0];
                imgVStr = model.filE_PATH;
   
            }
            salepriceStr = self.goodsDetailModel.goodsDetailModel.clsInfo.sale_price.floatValue;
            priceStr = self.goodsDetailModel.goodsDetailModel.clsInfo.price.floatValue;
            productCode = self.goodsDetailModel.goodsDetailModel.clsInfo.code;
            stocknum = [[NSString stringWithFormat:@"%@",self.goodsDetailModel.goodsDetailModel.clsInfo.stockCount] intValue];
/*
            NSLog(@"clsPicUrl: %@", self.goodsDetailModel.clsPicUrl);
            MBGoodsDetailsPictureModel *colorModel = self.goodsDetailModel.clsPicUrl[0];
            NSLog(@"colorModel.filE_PATH: %@", colorModel.filE_PATH);
            NSLog(@"specList: %@", self.goodsDetailModel.specList);
 */         
            
        } else if ([parameter isKindOfClass:[MyShoppingTrollyGoodsData class]]) {
            //购物袋
            self.isProductDetail = NO;
            self.goodsData = (MyShoppingTrollyGoodsData *)parameter;
            imgVStr = self.goodsData.imageurl;
            salepriceStr = self.goodsData.saleprice;
            priceStr = self.goodsData.price;
            productCode = self.goodsData.productcode;
            stocknum = [[NSString stringWithFormat:@"%d",self.goodsData.stocknum]intValue];
        }
        
        
        // image view
        CGRect imgViewRect = CGRectMake(10, -25, 120, 120);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgViewRect];
        imgView.layer.cornerRadius = 3;
        imgView.layer.masksToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView sd_setImageWithURL:[NSURL URLWithString:@""]// imgVStr
                   placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        [_myView addSubview:imgView];
        self.titleHeadImgView = imgView;
        
        
        // 价格（现）
        CGFloat priceLbX = CGRectGetMaxX(imgView.frame)+15.f;
        UILabel *priceLb = [[UILabel alloc] init];
        NSString *salePrice=[NSString stringWithFormat:@"%0.2f",salepriceStr];
        priceLb.text = [Utils getSNSRMBMoney:salePrice];//@"￥99.00";
        CGFloat priceLbW = [self widthOfLabel:priceLb.text
                                      ForFont:[UIFont systemFontOfSize:18.f]
                                  labelHeight:18.f];
        CGRect priceLbF = CGRectMake(priceLbX, 25.f, priceLbW, 18.f);
        priceLb.frame = priceLbF;
        priceLb.font = [UIFont systemFontOfSize:18.f];
        priceLb.textColor = COLOR_C2;//[UIColor blackColor];
        [_myView addSubview:priceLb];
        self.salePriceLb = priceLb;
        
        
        // 价格（前）
        CGFloat preLbX = CGRectGetMaxX(priceLb.frame);
        CGFloat preLbY = CGRectGetMaxY(priceLb.frame)-10.f;
        CGRect preLbF = CGRectMake(preLbX, preLbY, 60, 10);
        LPLabel *preLb = [[LPLabel alloc] initWithFrame:preLbF];
        NSString *price= [NSString stringWithFormat:@"%0.2f",priceStr];
        preLb.text = [Utils getSNSRMBMoney:price];//@"￥199.00";
        preLb.font = [UIFont systemFontOfSize:10.f];
        preLb.textColor = COLOR_C6;//[UIColor blackColor];
        [_myView addSubview:preLb];
        self.priceLb =preLb;
        
        // 商品编号
        CGFloat NOLbY = CGRectGetMaxY(priceLb.frame)+10;
        CGRect NOLbF = CGRectMake(priceLbX, NOLbY, 150, 10);
        UILabel *NOLb = [[UILabel alloc] initWithFrame:NOLbF];
        NOLb.text = [NSString stringWithFormat:@"商品编号: %@",productCode.length > 0? productCode: self.productCode];//@"商品编号：226228";
        NOLb.font = [UIFont systemFontOfSize:10.f];
        NOLb.textColor = COLOR_C6;//[UIColor blackColor];
        [_myView addSubview:NOLb];
        
        // 库存
        CGFloat storeLbY = CGRectGetMaxY(NOLb.frame)+10;
        CGRect storeLbF = CGRectMake(priceLbX, storeLbY, 60, 10);
        UILabel *storeLb = [[UILabel alloc] initWithFrame:storeLbF];

        
        storeLb.text = [NSString stringWithFormat:@"库存%@件",[Utils getSNSInteger:[ NSString stringWithFormat:@"%d",stocknum]]];//@"库存3件";
        storeLb.font = [UIFont systemFontOfSize:10.f];
        storeLb.textColor = COLOR_C6;//[UIColor blackColor];
        [_myView addSubview:storeLb];
        self.storeLb = storeLb;
        
        // cancel btn
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat x = width - 10 - 16;
        CGFloat y = 10;
        CGRect btnRect = CGRectMake(x, y, 16, 16);
        UIButton *btn = [[UIButton alloc] initWithFrame:btnRect];
        //        [btn setTitle:@"×" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Unico/关闭"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancleClicked:)
      forControlEvents:UIControlEventTouchUpInside];
        [_myView addSubview:btn];
        
        // 画线
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 110, width, 0.5);
        layer.backgroundColor = COLOR_C9.CGColor;
        [_myView.layer addSublayer:layer];
        
        // 确定 按钮
        CGFloat doneBtnY = self.view.frame.size.height *2/3-44;
        CGRect doneBtnF = CGRectMake(0, doneBtnY, width, 44);
        UIButton *doneBtn = [[UIButton alloc] initWithFrame:doneBtnF];
        [doneBtn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn.titleLabel setFont:FONT_T2];
        [doneBtn setBackgroundColor:COLOR_C2];
        [doneBtn addTarget:self action:@selector(doneBtnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [_myView addSubview:doneBtn];
        self.doneBtn = doneBtn;
        
        // scroll view作为滚动视图
        CGFloat scrollviewY = CGRectGetMaxY(layer.frame);
        CGFloat scrollViewH = CGRectGetMinY(doneBtn.frame)-CGRectGetMaxY(layer.frame);
        _myScrollView.frame = CGRectMake(0, scrollviewY, width, scrollViewH);
        [_myView addSubview:_myScrollView];
        
        // 颜色 collection View
        CGRect colorSelectRect = CGRectMake(0, 0, width, 40);
        GoodsColorSelectConllectionView *goodsColorView = [[GoodsColorSelectConllectionView alloc] initWithFrame:colorSelectRect];
        goodsColorView.clickedDelegate = self;
        goodsColorView.backgroundColor = [UIColor whiteColor];
        [_myScrollView addSubview:goodsColorView];
        self.goodsColorView = goodsColorView;
        
        
        // 尺寸 colllection view
        CGRect sizeSelectRect = CGRectMake(0, CGRectGetMaxY(goodsColorView.frame)-15, width, 40);
        GoodsSizeSelectionCollectionView *goodSizeView = [[GoodsSizeSelectionCollectionView alloc] initWithFrame:sizeSelectRect];
        goodSizeView.clickedDelegate = self;
        goodSizeView.backgroundColor = [UIColor whiteColor];
        [_myScrollView addSubview:goodSizeView];
        self.goodsSizeView = goodSizeView;
        
        if (self.isProductDetail) {
            // 数量
            UILabel *numLb = [[UILabel alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(goodSizeView.frame)+10, 100, 30)];
            numLb.text = @"购买数量";
            numLb.textColor = COLOR_C2;
            numLb.font = FONT_t6;//[UIFont systemFontOfSize:12.f];
            [_myScrollView addSubview:numLb];
            self.numLb = numLb;
            
            CGRect goodsNumRect = CGRectMake(UI_SCREEN_WIDTH-kGoodsNumW-10, CGRectGetMaxY(goodSizeView.frame)+10, kGoodsNumW, kGoodsNumH);
            UIStepperNumberField *goodsNum = [[UIStepperNumberField alloc] initWithFrame:goodsNumRect];
            
            [goodsNum addTarget:self action:@selector(stepperValueChangednew:)
               forControlEvents:UIControlEventValueChanged];
            [goodsNum addTarget:self action:@selector(textEditingDidEndnew:)
               forControlEvents:UIControlEventEditingDidEnd];
            [_myScrollView addSubview:goodsNum];
        
            self.goodsNum = goodsNum;
            _goodsNum.inputView = [UIView new];

        }
        
    }
    return self;
}

- (id)initWithParameter:(id)parameter
{
    return [self initWithParameter:parameter productCode:@"" promotion_ID:@""];
}

#pragma mark - 数量的点击事件
- (void)textEditingDidEndnew:(id)sender
{
    NSDictionary *changeDic = [self getObjectWithSize:_chooseSizeStr colorStr:_chooseColorStr];
    NSString *qty=[NSString stringWithFormat:@"%@",changeDic[@"lisT_QTY"]];
    int stocknum=[qty intValue];
    
    if (stocknum<1||[_goodsNum.text intValue]>stocknum)
    {
        [Toast makeToast:@"商品的库存不足!" duration:2 position:@"center"];
        return;
    }
    
    //判断购买数量
    
    if ([_goodsNum.text intValue]>20)
    {
        _goodsNum.text=@"20";
        [Toast makeToast:@"最多购买20件商品!" duration:2 position:@"center"];
        return;
    }
    
    if ([_goodsNum.text intValue]<=0) {
        _goodsNum.text=@"1";
        [Toast makeToast:@"商品数量不能为0!" duration:1 position:@"center"];
        return;
    }
}

- (void)stepperValueChangednew:(id)sender
{
    _goodsNum.inputView = [UIView new];

    
    NSDictionary *changeDic = [self getObjectWithSize:_chooseSizeStr colorStr:_chooseColorStr];
    NSString *qty=[NSString stringWithFormat:@"%@",changeDic[@"lisT_QTY"]];
      int stocknum=[qty intValue];
    if (stocknum<1||[_goodsNum.text intValue]>stocknum)
    {
        [Toast makeToast:@"商品的库存不足!" duration:2 position:@"center"];
        return;
    }
    
    //判断购买数量
    
    if ([_goodsNum.text intValue]>20)
    {
        _goodsNum.text=@"20";
        [Toast makeToast:@"最多购买20件商品!" duration:2 position:@"center"];
        return;
    }
    
    if ([_goodsNum.text intValue]<=0) {
        _goodsNum.text=@"1";
        
        [Toast makeToast:@"商品数量不能为0!" duration:1 position:@"center"];
        return;
    }
}

#pragma mark - 更新视图位置
- (void)resizeGoodsView
{
    /** 重新设置frame */
    CGRect colorSelectRect = _goodsColorView.frame;
    CGFloat colorViewH = _goodsColorView.colorViewH;
    colorSelectRect.size.height = colorViewH;
    self.goodsColorView.frame = colorSelectRect;

    /** 重新设置frame */
//    CGRect sizeSelectRect = _goodsSizeView.frame;
    CGFloat sizeViewH = _goodsSizeView.sizeViewH;
//    sizeSelectRect.size.height = sizeViewH;
    self.goodsSizeView.frame = CGRectMake(0, CGRectGetMaxY(self.goodsColorView.frame), self.view.frame.size.width, sizeViewH);//sizeSelectRect;
    
    if (self.isProductDetail) {
        self.numLb.frame = CGRectMake(10, CGRectGetMaxY(self.goodsSizeView.frame), 100, 30);
        
        self.goodsNum.frame = CGRectMake(UI_SCREEN_WIDTH-10-kGoodsNumW, CGRectGetMaxY(self.goodsSizeView.frame), kGoodsNumW, kGoodsNumH);
        
        _myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, colorViewH+sizeViewH+50);
    } else {
        _myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, colorViewH+sizeViewH);
    }
}

- (void)showNoneData{
    if (!_showNoneData) {
        CGRect frame = CGRectMake(0, 180, _myView.frame.size.width, 200);
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.backgroundColor = [UIColor clearColor];
        view.opaque = NO;
        frame.origin.y = 0;
        frame.size.height = 160;
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.textColor = COLOR_C6;
        label.font = FONT_T3;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无颜色尺码相关数据";
        [view addSubview:label];
        
        [_myView addSubview:view];
        _showNoneData = view;
    }
}

#pragma mark - goods collection delegate
- (void)didClickedGoodsSizeCollectionViewWithcell:(GoodsSizeCollectionCell *)cell
                                            index:(NSInteger)index
{
    _currentSizeIndex = index;
    //根据尺码 获取颜色
    _goodsColorView.tempArrM = [self reloadColorWithText:cell.lb.text];
    _chooseSizeStr =cell.lb.text;
    _selectedSizeStr=cell.lb.text;
    _goodsColorView.selectedIndex = _currentColorIndex;
    
//    _goodsSizeView.tempArrM = [@[] mutableCopy];
    _goodsSizeView.selectedIndex = _currentSizeIndex;
    
    [self updateData];
}

- (void)didClickedGoodsColorCollectionViewWithCell:(GoodsColorCollectionCell *)cell
                                             index:(NSInteger)index
{
/*
    _currentColorIndex = index;

    _chooseColorStr = cell.coloR_ID;
    //根据图片 获取尺码
    _goodsSizeView.tempArrM = [self reloadSizeWithText:cell.coloR_ID];
    if ([canUseSizeArray count]>_currentSizeIndex) {
      
        _goodsSizeView.selectedIndex = _currentSizeIndex;

    }
    _goodsColorView.tempArrM = [@[] mutableCopy];//self.colorArrM;
    _goodsColorView.selectedIndex = _currentColorIndex;
    
    [self updateData];
 */
    _currentColorIndex = index;
    _chooseColorStr = cell.coloR_ID;

    _goodsSizeView.sizeArrM = [self getNewSizeArrWithText:cell.coloR_ID];
    
    BOOL b = false;   // 判断上一个颜色的尺码是否存在
    if(_goodsSizeView.sizeArrM.count > 0){
        _currentSizeIndex = 0;
        
        for(NSString *str in _goodsSizeView.sizeArrM){
            if([_selectedSizeStr isEqualToString:str]){
                b=true;
                break;
            }
            _currentSizeIndex++;
        }
    }
//    _chooseSizeStr =_goodsSizeView.sizeArrM[0];
    if(!b){
        _currentSizeIndex=0;
        _chooseSizeStr = _goodsSizeView.sizeArrM[0];
    }else{
        _chooseSizeStr = _goodsSizeView.sizeArrM[_currentSizeIndex];
    }
    
    _goodsSizeView.selectedIndex = _currentSizeIndex;//_currentSizeIndex;
    [self updateData];
}

- (void)updateData
{
    if (_currentColorIndex == -1 || _currentSizeIndex == -1) {
        return ;
    }

    NSDictionary *changeDic = [self getObjectWithSize:_chooseSizeStr colorStr:_chooseColorStr];
    NSString *qty=[NSString stringWithFormat:@"%@",changeDic[@"lisT_QTY"]];
    NSString *price= [NSString stringWithFormat:@"%@",changeDic[@"price"]];
    NSString *salePrice=[NSString stringWithFormat:@"%@",changeDic[@"salE_PRICE"]];
    NSString *imgStr=[NSString stringWithFormat:@"%@",changeDic[@"coloR_FILE_PATH"]];
    self.storeLb.text=[NSString stringWithFormat:@"库存%@件",[Utils getSNSString:qty]];
    self.priceLb.text =[Utils getSNSRMBMoney:price];
    self.salePriceLb.text=[Utils getSNSRMBMoney:salePrice];//salePrice
    
    // 判断当出售价大于划线价时，不显示划线价
    if ([changeDic[@"price"] floatValue] <= [changeDic[@"salE_PRICE"] floatValue]) {
        self.priceLb.hidden = YES;
    } else {
        self.priceLb.hidden = NO;
    }
//    NSLog(@"___%@", NSStringFromClass(changeDic[@"price"]));
    
    
    
    /** 重设frame */
    CGRect rect = self.priceLb.frame;
    CGRect saleRect = self.salePriceLb.frame;
    CGFloat width = [self widthOfLabel:_salePriceLb.text
               ForFont:[UIFont systemFontOfSize:18.f]
           labelHeight:18.f];
    rect.origin.x = CGRectGetMinX(_salePriceLb.frame)+width;
    saleRect.size.width = width;
    self.salePriceLb.frame = saleRect;
    self.priceLb.frame = rect;
    
    [self.titleHeadImgView sd_setImageWithURL:[NSURL URLWithString:imgStr]
                             placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
}

-(NSDictionary *)getObjectWithSize:(NSString *)sizeStr colorStr:(NSString *)colorStr
{

   __block NSMutableDictionary *showDic=[@{}mutableCopy];
    
    [self.datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([colorStr isEqualToString:obj[@"coloR_ID"]]&&[sizeStr isEqualToString:obj[@"speC_NAME"]]) {

            showDic =(NSMutableDictionary *)obj;
            
        }
    }];
    
    
    return showDic;
}

/** 根据选择颜色重新获取尺码数据 */
- (NSMutableArray *)getNewSizeArrWithText:(NSString *)text
{
    NSMutableArray *tempArrM = [@[] mutableCopy];
    [self.datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"coloR_ID"] isEqualToString:text]) {
            [tempArrM addObject:obj[@"speC_NAME"]];
        };
    }];
    return tempArrM;
}


/** 处理按钮灰色 */
- (NSMutableArray *)reloadSizeWithText:(NSString *)text
{
    [canUseSizeArray  removeAllObjects];
    
    NSMutableArray *tempArr = [@[] mutableCopy];    // 尺码大小数组
    [self.datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"coloR_ID"] isEqualToString:text]) {
            NSString *lisT_QTY = [NSString stringWithFormat:@"%@",obj[@"lisT_QTY"]];
            if([Utils getSNSString:lisT_QTY].length==0||[[Utils getSNSString:lisT_QTY] isEqualToString:@"0"])
            {
            }
            else
            {
    
                 [tempArr addObject:obj[@"speC_NAME"]];
                [canUseSizeArray addObject:obj[@"speC_NAME"]];
                 
            }
         
        }
    }];
    
    NSMutableArray *newArr = [@[] mutableCopy];
    //不匹配对颜色
    [self.sizeArrM enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![tempArr containsObject:obj]) {
            [newArr addObject:obj];
        } else {
            if (_firIndex == -1) {
                _firIndex = idx;
            }
        }
    }];
    return newArr;
}

- (NSMutableArray *)reloadColorWithText:(NSString *)text
{
    NSMutableArray *tempArr = [@[] mutableCopy];    // 颜色数组
    [self.datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"speC_NAME"] isEqualToString:text]) {
            NSString *lisT_QTY = [NSString stringWithFormat:@"%@",obj[@"lisT_QTY"]];
            if([Utils getSNSString:lisT_QTY].length==0||[[Utils getSNSString:lisT_QTY] isEqualToString:@"0"])
            {
            }
            else
            {
            NSDictionary *colorDic=@{@"coloR_FILE_PATH":obj[@"coloR_FILE_PATH"],
                                     @"coloR_ID":obj[@"coloR_ID"] };
//            [tempArr addObject:obj[@"coloR_FILE_PATH"]];
            [tempArr addObject:colorDic];
       
            }
            
        }
    }];
    
    NSMutableArray *newArr = [@[] mutableCopy];
    [self.colorArrM enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![tempArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }];
    
    return newArr;
}

#pragma mark - button actions
- (void)cancleClicked:(UIButton *)sender
{
    [self hide];
}
//lisT_QTY
- (void)doneBtnClicked:(UIButton *)sender
{
    NSLog(@"。。。");
    
    if (_currentSizeIndex==-1||_currentColorIndex==-1) {
         [Toast makeToast:@"请选择商品颜色或尺码"];
        return;
    }
    

/*    if ([_delegate respondsToSelector:@selector(goodsCollectionController:doneClicked:)]) {
        [_delegate goodsCollectionController:self doneClicked:sender];
    }*/
    
    NSDictionary *changeDic = [self getObjectWithSize:_chooseSizeStr colorStr:_chooseColorStr];
//    NSString *qty=[NSString stringWithFormat:@"%@",changeDic[@"lisT_QTY"]];
//    NSString *price= [NSString stringWithFormat:@"%@",changeDic[@"price"]];
//    NSString *salePrice=[NSString stringWithFormat:@"%@",changeDic[@"salE_PRICE"]];
    NSString *sizeStr=[NSString stringWithFormat:@"%@",changeDic[@"speC_NAME"]];
    NSString *colorStr = [NSString stringWithFormat:@"%@",changeDic[@"coloR_NAME"]];
    NSString *barcodeStr=[NSString stringWithFormat:@"%@",changeDic[@"barcode_sys_code"]];
    
    if (self.goodsData.shoppingcartid == nil) {
        
        NSArray *activityArray = self.goodsDetailModel.activtiyArray;
        NSDictionary *params= nil;//[[NSDictionary alloc]init];
        
        if ([activityArray count]>0) {
            NSMutableArray *aidArray =[@[]mutableCopy];
            //遍历活动  －1 去掉 相同去掉
            for (int a=0; a<[activityArray count]; a++) {
                SProductDetailActivityModel *activityModel=activityArray[a];
                NSString *aidStr=[NSString stringWithFormat:@"%@",activityModel.json];
                NSString *activityType=[NSString stringWithFormat:@"%@",activityModel.type];
                
                if ([aidStr isEqualToString:@"-1"]) {
                }
                else
                {
                    if ([activityType isEqualToString:@"1"]) {
                        
                        [aidArray addObject:aidStr];
                    }
                }
            }
            aidArray =  (NSMutableArray *)[self arrayWithMemberIsOnly:aidArray];
            if ([aidArray count]==0) {
                NSMutableDictionary *m_params =[[NSMutableDictionary alloc]init];
                [m_params setObject:[NSString stringWithFormat:@"%@",barcodeStr] forKey:@"barcode"];
                [m_params setObject:_goodsNum.text forKey:@"Qty"];//数量是选择的数量
                [m_params setObject:[NSString stringWithFormat:@"%@",self.goodsDetailModel.goodsDetailModel.clsInfo.sale_price] forKey:@"Price"];//价格可不传
                [m_params setObject:@"" forKey:@"cid"];
                [m_params setObject:[Utils getSNSString:self.promotion_ID] forKey:@"aid"];
                NSMutableArray *paramsArray = [[NSMutableArray alloc]init];
                [paramsArray addObject:m_params];
                params = @{@"lstCreateDto":paramsArray,@"userId":sns.ldap_uid};
            }
            else
            {
                NSMutableArray *paramsArray = [[NSMutableArray alloc]init];
         
                for (int k=0;k<[aidArray count];k++) {
                    NSMutableDictionary *m_params =[[NSMutableDictionary alloc]init];
                    NSString *aidStrk=[NSString stringWithFormat:@"%@",[Utils getSNSString:aidArray[k]]];
                    [m_params setObject:[NSString stringWithFormat:@"%@",barcodeStr] forKey:@"barcode"];
                    [m_params setObject:_goodsNum.text forKey:@"Qty"];//数量是选择的数量
                    [m_params setObject:[NSString stringWithFormat:@"%@",self.goodsDetailModel.goodsDetailModel.clsInfo.sale_price] forKey:@"Price"];//价格可不传
                    [m_params setObject:@"" forKey:@"cid"];
                    [m_params setObject:aidStrk forKey:@"aid"];
                    [paramsArray addObject:m_params];
 
                }
               params = @{@"lstCreateDto":paramsArray,@"userId":sns.ldap_uid};
            }
            
          
        }
        else
        {
                NSMutableDictionary *m_params =[[NSMutableDictionary alloc]init];
                [m_params setObject:[NSString stringWithFormat:@"%@",barcodeStr] forKey:@"barcode"];
                [m_params setObject:_goodsNum.text forKey:@"Qty"];//数量是选择的数量
                [m_params setObject:[NSString stringWithFormat:@"%@",self.goodsDetailModel.goodsDetailModel.clsInfo.sale_price] forKey:@"Price"];//价格可不传
                [m_params setObject:@"" forKey:@"cid"];
                [m_params setObject:[Utils getSNSString:self.promotion_ID] forKey:@"aid"];
                NSMutableArray *paramsArray = [[NSMutableArray alloc]init];
                [paramsArray addObject:m_params];
                params = @{@"lstCreateDto":paramsArray,@"userId":sns.ldap_uid};
 
        }
        [HttpRequest orderPostRequestPath:@"Cart" methodName:@"ShoppingCartCreateList" params:params success:^(NSDictionary *dict) {
            if([dict[@"isSuccess"] boolValue]){
                
                //[Toast makeToastSuccess:@"成功添加到购物车！"];
                [TalkingData trackEvent:@"添加到购物车" label:@"添加到购物车成功"];
                [TalkingData trackEvent:@"填加购物车成功" label:[NSString stringWithFormat:@"商品信息来自:%@", fromControllerName? fromControllerName: @"模块获取失败"]];
               /*
                // 添加购物车成功之后再隐藏视图
                if ([_delegate respondsToSelector:@selector(goodsCollectionController:doneClicked:)]) {
                    [_delegate goodsCollectionController:self doneClicked:sender];
                }
                */
                
                //隐藏购物袋
                //  2. Animate everything out of place
                [UIView
                 animateWithDuration:0.3
                 animations:^{
                     
                     //  Shrink the main view by 15 percent
                     CGAffineTransform t = CGAffineTransformIdentity;
                     [_shrunkView setTransform:t];
                     //[_shrunkView.layer addAnimation:[self animationGroupPopView] forKey:nil];
                     //  Fade in the modal
                     [[self modalView] setAlpha:0.0];
                     
                     //  Slide the buttons into place
                     
                     t = CGAffineTransformTranslate(t, 0, [[self myView] frame].size.height);
                     [[self myView] setTransform:t];
                     
                 }
                 
                 completion:^(BOOL finished) {
                     [[self view] removeFromSuperview];
                     _visible = NO;

                     //成功添加到购物车刷新购物袋数字
                     if ([_delegate respondsToSelector:@selector(goodsCollectionController:isBuySuccesss:)]) {
                         [_delegate goodsCollectionController:self isBuySuccesss:YES];
                     }
                     
                     
                 }];
                
                // 建立通知，用于btn的箭头改变
                /*  [[NSNotificationCenter defaultCenter] postNotificationName:@"arrowDirectionChange"
                 object:nil];*/
                if (self.changeBtnState!=nil) {
                    self.changeBtnState();
                }
                


            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"添加到购物车失败！" message:dict[@"message"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alertView show];
                [TalkingData trackEvent:@"选择商品" label:@"添加到购物车失败(数据问题)" parameters:dict];
                [TalkingData trackEvent:@"填加购物车失败(数据导致)" label:[NSString stringWithFormat:@"商品信息来自:%@", fromControllerName? fromControllerName: @"模块获取失败"]];
                
                if ([_delegate respondsToSelector:@selector(goodsCollectionController:doneClicked:)]) {
                    [_delegate goodsCollectionController:self doneClicked:sender];
                }
            }
        } failed:^(NSError *error) {
            
            [TalkingData trackEvent:@"选择商品" label:@"添加到购物车失败(网络问题)"];
            [TalkingData trackEvent:@"填加购物车失败(网络导致)" label:[NSString stringWithFormat:@"商品信息来自:%@", fromControllerName? fromControllerName: @"模块获取失败"]];
            
            if ([_delegate respondsToSelector:@selector(goodsCollectionController:doneClicked:)]) {
                [_delegate goodsCollectionController:self doneClicked:sender];
            }
        }];

    }
    else
    {
      
        NSDictionary *tempDict = @{@"size":sizeStr,
                                   @"color":colorStr,
                                   @"coloR_FILE_PATH":[NSString stringWithFormat:@"%@",changeDic[@"coloR_FILE_PATH"]]};
        //如果没有更改的话 不请求
        if ([self.goodsData.sizename isEqualToString:sizeStr]&&[self.goodsData.colorname isEqualToString:colorStr]) {
           
            [Toast makeToast:@"请选择不同的颜色或尺码"];
            return;
        }
        NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
        NSArray *productAry =@[@{@"barcode":barcodeStr,
                                 @"num":[NSString stringWithFormat:@"%d",self.goodsData.number],
                                 @"id":[Utils getSNSString:[NSString stringWithFormat:@"%@",self.goodsData.shoppingcartid]]}];
        
        NSDictionary *paramsDic=@{@"token":userToken,
                                  @"productAry":productAry};
        //选择好后要上传给服务器
        [HttpRequest orderPostRequestPath:@"Cart" methodName:@"updateProductFromCartV2" params:paramsDic success:^(NSDictionary *dict) {
            NSLog(@"－－－dict 上传服务器---%@",dict);
            NSString *isSuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
            NSString *message = [NSString stringWithFormat:@"%@",dict[@"message"]];
            if ([isSuccess boolValue]==1) {
                if (self.block) {
                    self.block(tempDict);
                }
                [self hide];
                
            }
            else
            {
                if (message.length==0) {
                    message=@"更改失败";
                }
                [Toast makeToast:message];
                
            }
            
   
        } failed:^(NSError *error) {
            
        }];
    }
}

- (NSString *)getColorArrWithUrlStr:(NSString *)urlStr sizeStr:(NSString *)sizeStr
{
    __block NSString *colorStr = nil;
    NSMutableArray *newArr = [@[] mutableCopy];
    [self.datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([urlStr isEqualToString:obj[@"coloR_ID"]]) {
            [newArr addObject:obj];
        }
    }];
    
    [newArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([sizeStr isEqualToString:obj[@"speC_NAME"]]) {
            colorStr = obj[@"coloR_NAME"];
        };
    }];
    
    return colorStr;
}

-(NSString *)getBarcode_sys_codeWithSize:(NSString *)sizeStr colorStr:(NSString *)colorStr
{
    __block NSString *barcode_sys_codeStr = nil;
    NSMutableArray *newArr = [@[] mutableCopy];
    [self.datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([colorStr isEqualToString:obj[@"coloR_ID"]]&&[sizeStr isEqualToString:obj[@"speC_NAME"]]) {
            [newArr addObject:obj];
            barcode_sys_codeStr = [NSString stringWithFormat:@"%@",obj[@"barcode_sys_code"]];
            
        }
    }];

    return barcode_sys_codeStr;
}

#pragma mark - private
- (CGFloat)widthOfLabel:(NSString *)strText ForFont:(UIFont *)font labelHeight:(CGFloat)height
{
    CGSize size;
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [strText boundingRectWithSize:CGSizeMake(0, height)
                                 options:NSStringDrawingTruncatesLastVisibleLine
            | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                              attributes:attribute context:nil].size;
    return size.width;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //  1. Set view to be transparent - with autoresizing
    [[self view] setOpaque:NO];
    [[self view] setBackgroundColor:[UIColor clearColor]];
    [[self view] setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    //  2. Add a modal overlay - with autoresizing
    [[self view] addSubview:_modalView];
    [_modalView setFrame:[[self view] bounds]];
    [_modalView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    //  3. Add a sheet that's one third of the screen
    [[self view] addSubview:_myView];
    
    // Position at the bottom of the screen
    CGRect frame = [[self view] bounds];
    frame.origin.y = frame.size.height-(frame.size.height/3.0*2);
    frame.size.height /= 3.0;
    frame.size.height *= 2.0;
    [_myView setFrame:frame];
    [_myView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth)];
    [Toast makeToastActivity];
    
    // 获取数据
    [self getData];
}

#pragma mark - 从服务器获取数据
- (void)getData
{
    NSString *codeStr = @"";
    if (self.goodsData) {
        codeStr = [NSString stringWithFormat:@"%@",self.goodsData.productcode];
    } else {
        codeStr = self.productCode;
    }
    
//    BoundceSpotAnimationView *spotView = [[BoundceSpotAnimationView alloc] initWithFrame:_myView.frame];
//    [_myView.superview addSubview:spotView];
    
    [HttpRequest productGetRequestPath:@"Product" methodName:@"ProductFilter"
                                params:@{@"prodClsIdList": codeStr}
                               success:^(NSDictionary *dict)
    {
//        [spotView removeAnimation];
        if ([dict[@"isSuccess"] integerValue] == 1) {
            NSArray *tempArr = dict[@"results"];
            [Toast hideToastActivity];
            if(tempArr.count==0){ // 没有尺码颜色数据时
                [self showNoneData];
                self.goodsNum.hidden = YES;
                self.goodsSizeView.hidden = YES;
                self.goodsColorView.hidden = YES;
                self.doneBtn.hidden = YES;
                self.numLb.hidden = YES;
                return ;
            }
            // 1.去除库存为0的数据
            self.datasource = [self removeDateWithListQTY:tempArr];//[tempArr mutableCopy];
            
            // 2.获取颜色数组
            self.colorArrM = [[self getColorArrWithArr:_datasource] mutableCopy];// tempArr
            self.goodsColorView.colorArrM = self.colorArrM;
            
            // 3.获取尺码数组
            self.sizeArrM = [[self getSizeArrWithArr:_datasource] mutableCopy];// tempArr
            self.goodsSizeView.sizeArrM = self.sizeArrM;
            
            // 4.调整视图位置
            [self resizeGoodsView];

            // 5.进入界面默认值设定
/*(置灰时方法)
            _currentColorIndex = 0;
            _currentSizeIndex = 0;

            _chooseColorStr = [_colorArrM firstObject][@"coloR_ID"];

            [self.goodsColorView setSelectedIndex:0];
            _currentSizeIndex=-1;
            _goodsSizeView.selectedIndex = _currentSizeIndex;
            [self.goodsSizeView setSelectedIndex:_currentSizeIndex];
            NSMutableArray *tempArrM = [self reloadSizeWithText:_chooseColorStr];
            if (tempArr.count <= 0) {
      
            }
            else
            {
                _goodsSizeView.tempArrM = tempArrM;//[@[] mutableCopy];//self.sizeArrM;
                
                if (_firIndex == -1) {
                    ;
                } else {
                    _goodsSizeView.selectedIndex = _firIndex;
                    _currentSizeIndex = _firIndex;
                    _chooseSizeStr = [NSString stringWithFormat:@"%@",self.datasource[_firIndex][@"speC_NAME"]];

                }
                
                [self.goodsSizeView setSelectedIndex:_currentSizeIndex];
            }
*/
            _currentColorIndex = -1;
            if (_colorArrM) {
                _currentColorIndex = 0;
                [self.goodsColorView setSelectedIndex:0];   // 颜色默认选中为第一项
                _chooseColorStr = [_colorArrM firstObject][@"coloR_ID"];
                _goodsSizeView.sizeArrM = [self getNewSizeArrWithText:_chooseColorStr]; // 根据选中的颜色获取存在的尺码数组
            }
            _currentSizeIndex = -1;
            if (_goodsSizeView.sizeArrM) {
                _currentSizeIndex = 0;
                [self.goodsSizeView setSelectedIndex:0];    // 尺码默认选中为第一项
                _chooseSizeStr = _goodsSizeView.sizeArrM[0];
            }
            
            // 6.更新视图数据
            [self updateData];
            
        } else {
            [Toast makeToast:@"获取相关数据失败！"];
        }
        
    } failed:^(NSError *error) {
//        [spotView removeAnimation];
        [Toast makeToast:kNoneInternetTitle];
        
    }];
}

#pragma mark - 数据的处理
#pragma mark - 去除库存为零的数据
- (NSMutableArray *)removeDateWithListQTY:(NSArray *)arr
{
    NSMutableArray *newDict = [@[] mutableCopy];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![[NSString stringWithFormat:@"%@", obj[@"lisT_QTY"]] isEqualToString:@"0"]) {
            [newDict addObject:obj];
        };
    }];
    return newDict;
}

#pragma mark 获取颜色数组
- (NSArray *)getColorArrWithArr:(NSArray *)arr
{
    //    NSMutableArray *newArr = [@[] mutableCopy];
    NSMutableDictionary *newDict = [@{} mutableCopy];
       NSMutableArray *tempArr =[@[]mutableCopy];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *newDictM = [@{} mutableCopy];
        [newDictM setObject:obj[@"coloR_ID"] forKey:@"coloR_ID"];//不通的id 对应的 不通的图片地址 图片地址是随机的
        [newDictM setObject:obj[@"coloR_FILE_PATH"] forKey:@"coloR_FILE_PATH"];
        [newDict setObject:newDictM forKey:obj[@"coloR_ID"]];
        [tempArr addObject:newDictM];
    }];
    
    tempArr = [[newDict allValues] copy];

    return [self arrayWithMemberIsOnly:tempArr];//[self arrayWithMemberIsOnly:newArr];
}

/*
- (NSArray *)getColorArrWithArr:(NSArray *)arr
{
//    NSMutableArray *newArr = [@[] mutableCopy];
    NSMutableDictionary *newDictM = [@{} mutableCopy];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        [newDictM setObject:obj[@"coloR_FILE_PATH"] forKey:obj[@"coloR_ID"]];
    }];

    NSArray *tempArr = [newDictM allValues];
    NSLog(@"tempaarray－－－%@",tempArr);
          
    return [self arrayWithMemberIsOnly:tempArr];//[self arrayWithMemberIsOnly:newArr];
}
*/
//不通的id 对应的 不通的图片地址 图片地址是随机的

#pragma mark 获取尺码数组
- (NSArray *)getSizeArrWithArr:(NSArray *)arr
{
    NSMutableArray *newArr = [@[] mutableCopy];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [newArr addObject:obj[@"speC_NAME"]];
    }];
    return [self arrayWithMemberIsOnly:newArr];
}

#pragma mark 去除数组中相同的元素
- (NSArray *)arrayWithMemberIsOnly:(NSArray *)array
{
    NSMutableArray *tempArrM = [@[] mutableCopy];
    for (NSInteger i = 0; i < [array count]; i++) {
        @autoreleasepool {
            if (![tempArrM containsObject:array[i]]) {
                [tempArrM addObject:array[i]];
            }
        }
    }
    NSLog(@"temparray-----%@,,,,,,,%@",tempArrM,array);
    
    return tempArrM;
}

- (void)requestAndShowInView:(UIView *)view{
    [self getData];
    [self showInView:view];
}

#pragma mark - 加入购物袋动画
#pragma mark 显示动画
- (void) showInView:(UIView*)view
{
    
    //  1. Hide the modal
    [[self modalView] setAlpha:0];
    
    //  2. Install the modal view
    [[view superview] addSubview:[self view]];
    
    _shrunkView = view;
    
    [[self view] setFrame:[[[self view] superview] bounds]];
    
    //  3. Show the buttons
    [[self myView] setTransform:CGAffineTransformMakeTranslation(0, [[self myView] frame].size.height)];
    
    
    //  4. Animate everything into place
    [UIView
     animateWithDuration:0.3
     animations:^{
         [view.layer setTransform:CATransform3DMakeTranslation (0, 0, -10000)];
         //  Shrink the main view by 15 percent
         CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
         [view setTransform:t];
         //[view.layer addAnimation:[self animationGroupPushView] forKey:nil];
         //  Fade in the modal
         [[self modalView] setAlpha:1.0];
         
         //  Slide the buttons into place
         [[self myView] setTransform:CGAffineTransformIdentity];
         
     }
     completion:^(BOOL finished) {
         _visible = YES;
     }];
}


#pragma mark 隐藏动画
- (void)hide
{
    //  2. Animate everything out of place
    [UIView
     animateWithDuration:0.3
     animations:^{
         
         //  Shrink the main view by 15 percent
         CGAffineTransform t = CGAffineTransformIdentity;
         [_shrunkView setTransform:t];
         //[_shrunkView.layer addAnimation:[self animationGroupPopView] forKey:nil];
         //  Fade in the modal
         [[self modalView] setAlpha:0.0];
         
         //  Slide the buttons into place
         
         t = CGAffineTransformTranslate(t, 0, [[self myView] frame].size.height);
         [[self myView] setTransform:t];
         
     }
     
     completion:^(BOOL finished) {
         [[self view] removeFromSuperview];
         _visible = NO;
     }];
    
    // block用于购物袋改变箭头方向
    if (self.changeBtnState!=nil) {
        self.changeBtnState();
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/







#pragma mark - ***备用方法 暂时弃用***
-(CAAnimationGroup*)animationGroupPushView {
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0 / -1000;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2 = CATransform3DScale(t2, 0.90, 0.90, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    animation.duration = 0.3 ;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:t2];
    animation2.beginTime = animation.duration;
    animation2.duration = 0.3 ;
    animation2.fillMode = kCAFillModeForwards;
    [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration * 2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}

-(CAAnimationGroup*)animationGroupPopView {
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0 / -1000;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    animation.duration = 0.3 ;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation2.beginTime = animation.duration;
    animation2.duration = 0.3 ;
    animation2.fillMode = kCAFillModeForwards;
    [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration * 2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}



@end
