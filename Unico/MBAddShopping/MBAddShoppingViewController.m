//
//  MBAddShoppingViewController.m
//  Wefafa
//
//  Created by Jiang on 5/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBAddShoppingViewController.h"
#import "MBAddShoppingProductInfoModel.h"
#import "MBGoodsDetailListModel.h"
#import "MBAddShoppingContentTableViewCell.h"
#import "MBCollocationDetailModel.h"
#import "MyShoppingTrollyGoodsTableViewCell.h"
#import "MBCreateGoodsOrderViewController.h"
#import "MyShoppingTrollyViewController.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "Utils.h"
#import "WeFaFaGet.h"
#import "ShoppIngBagShowButton.h"
#import "LoginViewController.h"
#import "WeFaFaGet.h"
#import "SDataCache.h"
#import "SUtilityTool.h"
#import "TalkingData.h"
#import "TalkingData.h"
#import "NSString+help.h"

#import "SShoppingBagSharedInstance.h"

@interface MBAddShoppingViewController () <UITableViewDataSource, UITableViewDelegate, MBAddShoppingContentTableViewCellDelegate,SShoppingBagSharedInstanceDelegate>
{
    CGFloat _price;
    CGFloat _sale_price;
}
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;     //显示活动商品用tableview
@property (weak, nonatomic) IBOutlet UILabel *totalPirceLabel;          //打完折后的总价
@property (weak, nonatomic) IBOutlet UILabel *pirceLabel;               //原价的总价
@property (weak, nonatomic) IBOutlet UIView *tabBarContentView;         //显示购物信息
@property (weak, nonatomic) IBOutlet UIButton *addShoppingBagButton;    //加入购物袋button
@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;            //立即购买button

- (IBAction)addShoppingButtonAction:(UIButton *)sender;                 //加入购物袋方法
- (IBAction)buyNowButtonAction:(UIButton *)sender;                      //立即购买方法
- (IBAction)shoppingBagGoButtonAction:(UIButton *)sender;               //进入个人购物袋




@property (nonatomic, weak)     CAGradientLayer *headerContentViewBackLayer;
@property (nonatomic, weak)     CALayer *backImageLayer;
@property (nonatomic, strong)   NSMutableArray *contentModelArray;
@property (nonatomic, strong)   NSMutableArray *productInfoModelArray;
@property (nonatomic, strong)   ShoppIngBagShowButton *shoppingBagButton;

@end

static NSString *contentCellIdentifier = @"MBAddShoppingContentTableCellIdentifier";
@implementation MBAddShoppingViewController

#pragma mark - UIViewController Plifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _contentModelArray = [NSMutableArray array];
    //初始化Navbar
    [self setupNavbar];
    //初始化界面
    [self initSubViews];
    
    [self requestCollocationData];
    //[self requestAndJudge];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestCarCount];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init View
#pragma mark - init navbar
- (void)setupNavbar{
    [super setupNavbar];
    
    //Navigation添加进入购物袋rightBarButtonItem
    /*
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    */
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:[SShoppingBagSharedInstance sharedInstance]];
    [SShoppingBagSharedInstance sharedInstance].delegate = self;

    self.navigationItem.rightBarButtonItems = @[rightItem1];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backHome:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
}


- (void)initSubViews{
    _price = 0.0;
    _sale_price = 0.0;
//    self.addShoppingBagButton.layer.cornerRadius = 3.0;
//    self.addShoppingBagButton.layer.masksToBounds = YES;
    self.buyNowButton.layer.cornerRadius = 3.0;
    self.buyNowButton.layer.masksToBounds = YES;
    self.contentTableView.tableFooterView = [[UIView alloc]init];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MBAddShoppingContentTableViewCell" bundle:nil] forCellReuseIdentifier:contentCellIdentifier];
    
    self.tabBarContentView.layer.masksToBounds = NO;
    self.tabBarContentView.layer.shadowOffset = CGSizeMake(0, -1.5);
    self.tabBarContentView.layer.shadowOpacity = 0.5;
    CGRect frame = self.tabBarContentView.bounds;
    frame.size.width = UI_SCREEN_WIDTH;
    self.tabBarContentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:frame].CGPath;
    self.tabBarContentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    if (_contentModel && _contentModel.isSelectedCurrent) {
        _price = _contentModel.clsInfo.price.floatValue * _contentModel.goodsNumber;
        _sale_price = _contentModel.clsInfo.sale_price.floatValue * _contentModel.goodsNumber;

        NSString *showSalePrice = [NSString stringWithFormat:@"%.2f",_sale_price];
        NSString *showPrice =[NSString stringWithFormat:@"%.2f",_price];
        self.totalPirceLabel.text = [NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:showSalePrice]];
        self.pirceLabel.text = [NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:showPrice]];
        
        NSMutableAttributedString *attrbutdestring = [[NSMutableAttributedString alloc]initWithString:self.pirceLabel.text];
        
        [attrbutdestring addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                                         NSForegroundColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                                         NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                         NSFontAttributeName:FONT_t7
                                         }range:NSMakeRange(0,self.pirceLabel.text.length)];
        
        self.pirceLabel.attributedText =attrbutdestring;
        if ([showPrice isEqualToString:showSalePrice]) {
            self.pirceLabel.hidden=YES;
        }
        else
        {
            self.pirceLabel.hidden=YES;
        }
    }
//    更改底部按钮
//    [self settingShowType];
    self.navigationItem.title = @"选择商品";
    self.title=@"选择商品";
}



#pragma mark - Get Data
#pragma mark - 获取商品关联信息
- (void)requestCollocationData{
    // MARK：尽量锁定交互，避免vc释放后引起的问题
    [Toast makeToastActivity];
    if (!self.itemAry) {
        [Toast hideToastActivity];
        return;
    }

    NSDictionary *params = @{@"ids": self.itemAry};
    NSString *codeStr = [self.itemAry componentsJoinedByString:@","];
    
    params = @{@"IDS": codeStr, @"loginUserId": sns.ldap_uid};
    
   //新接口
    /*
    [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductClsFilter" params:params success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        
        NSLog(@"MBGoodsDetailsModel:%@",dict[@"results"]);
        self.contentModelArray = [MBGoodsDetailsModel modelArrayForDataArray:dict[@"results"]];
    } failed:^(NSError *error) {
        [Toast makeToast:@"获取商品失败！" duration:3.0 position:@"center"];
        [Toast hideToastActivity];
        NSLog(@"单品详情请求错误---MBGoodsDetailsViewController---%@", error);
    }];
    */
    
    [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductFilter" params:@{@"prodClsIdList": codeStr} success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        NSLog(@"MBAddShoppingProductInfoModel:%@",dict);
        
        self.productInfoModelArray = [[MBAddShoppingProductInfoModel modelArrayForDataArray:dict[@"results"]] copy];
        NSLog(@"%@",_productInfoModelArray);
        
    } failed:^(NSError *error) {
        NSLog(@"失败....");
        
        [Toast hideToastActivity];
    }];
}


-(void)backHome:(id)sender
{
    [self popAnimated:YES];
}

#pragma mark - Data Processing
#pragma mark - 及给产品设置默认值
- (void)setProductInfoModelArray:(NSMutableArray *)productInfoModelArray{
    if (!productInfoModelArray || productInfoModelArray.count <= 0) return;
    [_contentModelArray removeAllObjects];
    //对产品进行分组
    NSMutableArray *productGroupArray = [NSMutableArray array];
    NSMutableArray *currentArray = [NSMutableArray array];
    
    //过滤掉无库存的数据
    int dataIndex = 0;
    for (int i = 0; i < productInfoModelArray.count; i++) {
        MBAddShoppingProductInfoModel *firstModel = [productInfoModelArray objectAtIndex:i];
        if (firstModel.lisT_QTY.integerValue != 0 ) {
            //向产品分组中 添加第一个产品
            [currentArray addObject:productInfoModelArray[i]];
            [productGroupArray addObject:currentArray];
            dataIndex = i;
            break;
        }
    }
    
    //向分组添加数据
    if(productInfoModelArray.count > 1){
        for (int i = dataIndex+1; i < productInfoModelArray.count; i++) {
            //库存为0时结束本次循环
            MBAddShoppingProductInfoModel *listModel = [productInfoModelArray objectAtIndex:i];
            if (listModel.lisT_QTY.integerValue == 0) {
                continue;
            }
            
            NSMutableArray *preModelArray = [productGroupArray objectAtIndex:productGroupArray.count-1];
            MBAddShoppingProductInfoModel *groupModel = [preModelArray objectAtIndex:0];
            MBAddShoppingProductInfoModel *currentModel = productInfoModelArray[i];
            if ([groupModel.proD_CLS_NUM isEqual: currentModel.proD_CLS_NUM]) {
                [currentArray addObject:currentModel];
            }else{
                //创建新组 并添加到productGroupArray中
                currentArray = [NSMutableArray array];
                [currentArray addObject:currentModel];
                [productGroupArray addObject:currentArray];
            }
        }
    }
    
    _productInfoModelArray = productGroupArray;
    //初始化默认产品数据
    for (NSArray *array in _productInfoModelArray) {
        [self initDefultColor:array];
        //根据颜色和尺寸 设置选择的产品
        for (MBAddShoppingProductInfoModel *model in array) {
            if (model.isColorSelected.boolValue && model.isSizeSelected.boolValue) {
                model.isSelectProduct = @YES;
            }else{
                model.isSelectProduct = @NO;
            }
        }
    }
    [self.contentTableView reloadData];
}

//给每个产品都设置默认颜色
-(void)initDefultColor:(NSArray *)productArray{
        NSArray *colorArray = [self getColorArrWithArr:productArray];
        for (MBAddShoppingProductInfoModel *model in productArray) {
            if ([model.coloR_ID isEqual:colorArray[0][@"coloR_ID"]]) {
                model.isColorSelected = @YES;
                [self initDefultSize:colorArray[0][@"coloR_ID"] productArray:productArray];
            }else{
                model.isColorSelected = @NO;
            }
        }
}

//给每个产品都设置默认尺寸
-(void)initDefultSize:(NSString *)colorid productArray:(NSArray *)productArray{
    //如果没有选择商品 则设置默认size
    NSArray *sizeArray = [self getSizeArrWithColorid:colorid productArray:productArray];
    for (MBAddShoppingProductInfoModel *model in productArray) {
        if ([model.speC_NAME isEqual:sizeArray[0][@"speC_NAME"]]) {
            model.isSizeSelected = @YES;
        }else{
            model.isSizeSelected = @NO;
        }
    }
}

#pragma mark 获取所有颜色数组
- (NSArray *)getColorArrWithArr:(NSArray *)arr
{
    NSMutableDictionary *newDict = [@{} mutableCopy];
    NSMutableArray *tempArr =[@[] mutableCopy];
    [arr enumerateObjectsUsingBlock:^(MBAddShoppingProductInfoModel *obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *newDictM = [@{} mutableCopy];
        [newDictM setObject:obj.coloR_ID forKey:@"coloR_ID"];//不通的id 对应的 不通的图片地址 图片地址是随机的
        [newDictM setObject:obj.coloR_FILE_PATH forKey:@"coloR_FILE_PATH"];
        [newDictM setObject:obj.isColorSelected forKey:@"isColorSelected"];
        [newDict setObject:newDictM forKey:obj.coloR_ID];
        [tempArr addObject:newDictM];
    }];
    
    tempArr = [[newDict allValues] copy];
    return [self arrayWithMemberIsOnly:tempArr];
}

#pragma mark 根据颜色获取相应尺码数组
- (NSArray *)getSizeArrWithColorid:(NSString *)colorid  productArray:(NSArray *)productArray
{
    NSMutableDictionary *newDict = [@{} mutableCopy];
    NSMutableArray *tempArr = [@[] mutableCopy];
    [productArray enumerateObjectsUsingBlock:^(MBAddShoppingProductInfoModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.coloR_ID isEqual:colorid]) {
            NSMutableDictionary *newDictM = [@{} mutableCopy];
            [newDictM setObject:obj.speC_NAME forKey:@"speC_NAME"];
            [newDictM setObject:obj.isSizeSelected forKey:@"isSizeSelected"];
            [newDict setObject:newDictM forKey:obj.coloR_ID];
            [tempArr addObject:newDictM];
        }
    }];
    return tempArr;
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
    return tempArrM;
}

#pragma mark 加入购物袋
- (IBAction)addShoppingButtonAction:(UIButton *)sender {
    NSMutableArray *paramsArray = [[NSMutableArray alloc]init];
    for (NSArray *goodsDetailModelArray in _productInfoModelArray) {
        
        //筛选已选中的商品
        MBAddShoppingProductInfoModel *model = goodsDetailModelArray[0];
         if(model.isSelectedCurrent.boolValue){
             for (MBAddShoppingProductInfoModel *selectModel in goodsDetailModelArray) {
                 if (selectModel.isSelectProduct.boolValue) {
                     [paramsArray addObject:[self createParamsWithModel:selectModel]];
                 }
             }
         }
    }
    
    if (paramsArray.count <= 0) {
        [Toast makeToast:@"请选择商品！" duration:1.5 position:@"center"];
        return;
    }
    [TalkingData trackEvent:@"选择商品" label:@"按下'加入购物袋'按钮"];
    
    self.addShoppingBagButton.enabled = NO;
    __unsafe_unretained typeof(self) p = self;
    NSDictionary *params = @{@"lstCreateDto":paramsArray,@"userId":sns.ldap_uid};
    NSLog(@"paramds----%@",params);
    [HttpRequest orderPostRequestPath:@"Cart" methodName:@"ShoppingCartCreateList" params:params success:^(NSDictionary *dict) {
        p.addShoppingBagButton.enabled = YES;
        if([dict[@"isSuccess"] boolValue]){
            [self showSendMessageSuccess];
            //[Toast makeToastSuccess:@"成功添加到购物车！"];
            //[self requestCarCount];
            
            [TalkingData trackEvent:@"添加到购物车" label:@"添加到购物车成功"];
            [TalkingData trackEvent:@"填加购物车成功" label:[NSString stringWithFormat:@"商品信息来自:%@", _fromControllerName? _fromControllerName: @"模块获取失败"]];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"添加到购物车失败！" message:dict[@"message"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertView show];
            [TalkingData trackEvent:@"选择商品" label:@"添加到购物车失败(数据问题)" parameters:dict];
            [TalkingData trackEvent:@"填加购物车失败(数据导致)" label:[NSString stringWithFormat:@"商品信息来自:%@", _fromControllerName? _fromControllerName: @"模块获取失败"]];
        }
    } failed:^(NSError *error) {
        p.addShoppingBagButton.enabled = YES;
        [TalkingData trackEvent:@"选择商品" label:@"添加到购物车失败(网络问题)"];
        [TalkingData trackEvent:@"填加购物车失败(网络导致)" label:[NSString stringWithFormat:@"商品信息来自:%@", _fromControllerName? _fromControllerName: @"模块获取失败"]];
    }];
}

//添加到购物袋的动画效果
- (void)showSendMessageSuccess{
    /*
    UIGraphicsBeginImageContextWithOptions(self.tabBarContentView.bounds.size, NO, 3.0);  //NO，YES 控制是否透明
    [self.tabBarContentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = self.tabBarContentView.frame;
    [self.view addSubview:imageView];
    */
    
    
    UIImageView *picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/pic_addtobag"]];
    [picImageView setFrame:CGRectMake(UI_SCREEN_WIDTH/2-17, UI_SCREEN_HEIGHT/2-17, 35, 35)];
    [[UIApplication sharedApplication].keyWindow addSubview:picImageView];
    
    [UIView animateWithDuration:1.f animations:^(void){
        CAKeyframeAnimation *vibrateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        vibrateAnimation.values = @[@0.8,@1.2,@0.8,@1];
        vibrateAnimation.keyTimes = @[@0,@0.2,@.4,@0.5];
        vibrateAnimation.duration = .5;
        vibrateAnimation.beginTime= 0;
        vibrateAnimation.removedOnCompletion = YES;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:picImageView.center];
        [bezierPath addQuadCurveToPoint:CGPointMake(UI_SCREEN_WIDTH-30, 30) controlPoint:CGPointMake(UI_SCREEN_WIDTH/2-17, 30)];
        
        CAKeyframeAnimation * pathPositionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathPositionAnimation.path = bezierPath.CGPath;
        pathPositionAnimation.duration = .5;
        pathPositionAnimation.beginTime = vibrateAnimation.duration;
        pathPositionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        pathPositionAnimation.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
        scaleAnimation.duration = .5;
        scaleAnimation.beginTime = vibrateAnimation.duration;
        scaleAnimation.removedOnCompletion = YES;
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[vibrateAnimation, pathPositionAnimation, scaleAnimation];
        animationGroup.duration = vibrateAnimation.duration+pathPositionAnimation.duration;
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode=kCAFillModeForwards;
        [picImageView.layer addAnimation:animationGroup forKey:@"picImageAnimationGroup"];
        
        picImageView.alpha = 0.8;
    }completion:^(BOOL finished){
        [picImageView removeFromSuperview];
        [[SShoppingBagSharedInstance sharedInstance] requestCarCount];
    }];
    
    
    /*
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = CGRectMake(UI_SCREEN_WIDTH - 60, 20, 40, 40);
    }completion:^(BOOL finished) {
        [self requestCarCount];
        [imageView removeFromSuperview];
    }];
     */
}

#pragma mark 加入购物袋
- (NSDictionary*)createParamsWithModel:(MBAddShoppingProductInfoModel*)model{
    NSString *tmpmbcollocationID = @"0";
    if (_collocationInfoDic == nil) {
        tmpmbcollocationID = [Utils getSNSInteger:[NSString stringWithFormat:@"%ld",(long)_mbCollocationID.integerValue]];
        if (tmpmbcollocationID.length == 0) {
            tmpmbcollocationID = @"0";
        }
    }else{
        tmpmbcollocationID = _collocationInfoDic[@"mbfun_id"];
    }
    
    //Mark：改版本强行改变成0 无搭配和商品可分  add by  miao 6.13
    NSMutableDictionary *params = [NSMutableDictionary new];
    /*
     [params setObject:model.stockModel.aID forKey:@"PROD_ID"];
     [params setObject:model.stockModel.speC_ID forKey:@"SPEC_ID"];
     [params setObject:model.stockModel.coloR_ID forKey:@"COLOR_ID"];
     [params setObject:@(model.goodsNumber) forKey:@"qty"];
     [params setObject:[Utils getSNSString:sns.ldap_uid] forKey:@"userId"];
     [params setObject:[Utils getSNSString:_shareUser_ID] forKey:@"sharE_SELLER_ID"];
     
     if ([[Utils getSNSInteger:_promotion_ID.stringValue] integerValue] != 0) {
     //Mark: 该版本暂时不需要先注释  add by miao 6.13
     [params setObject:[Utils getSNSInteger:_promotion_ID.stringValue] forKey:@"PROMOTION_ID"];
     [params setObject:[Utils getSNSString:_collocationInfoDic[@"nick_name"]] forKey:@"designerName"];
     [params setObject:[Utils getSNSString:_collocationInfoDic[@"user_id"]] forKey:@"designerId"];
     [params setObject:[Utils getSNSInteger:[NSString stringWithFormat:@"%@", tmpmbcollocationID]] forKey:@"collocatioN_ID"];
     }
     */
    
    //826 新版本新接口
    [params setObject:[NSString stringWithFormat:@"%@",model.barcode_sys_code] forKey:@"barcode"];
    [params setObject:model.goodnumber forKey:@"Qty"];
    [params setObject:[NSString stringWithFormat:@"%@",model.salE_PRICE] forKey:@"Price"];
    
    if ([Utils getSNSString:_promotion_ID].length!=0) {
        [params setObject:[Utils getSNSString:_promotion_ID] forKey:@"aid"];
        [params setObject:[Utils getSNSString:[NSString stringWithFormat:@"%@", tmpmbcollocationID]] forKey:@"cid"];
    }
    
    return params;
}

#pragma mark 进入购物袋
- (IBAction)shoppingBagGoButtonAction:(UIButton *)sender {
    [self onCart];
}

//进入购物袋
- (void)onCart{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}
#pragma mark - Delegate and DataSource
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _productInfoModelArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBAddShoppingContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    cell.showProductArray=_productInfoModelArray[indexPath.row];

    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _contentModelArray.count - 1) {
        return 240.0;
    }
    return 253.0;
}

#pragma mark MBAddShoppingContentTableViewCellDelegate
// Mark : 修改成每次都计算全部的，否则自动选中有问题  fzh
- (void)shoppingContentTableCellSelectedModul:(MBAddShoppingProductInfoModel *)modul Button:(UIButton *)sender{
    // 每次全部重算
    _price = 0;
    _sale_price = 0;
    
    //循环整个购物车列表 计算全部
    for (NSInteger i=0; i<_productInfoModelArray.count; i++) {
        for (MBAddShoppingProductInfoModel *obj in _productInfoModelArray[i]) {
            //定位选中商品
            if (obj.isSelectedCurrent.boolValue&&obj.isSelectProduct.boolValue) {
                    [self calulateTotalPrice:obj];
            }
        }
    }
    
    NSString *showSalePrice = [NSString stringWithFormat:@"%.2f",_sale_price];
    NSString *showPrice =[NSString stringWithFormat:@"%.2f",_price];
    self.totalPirceLabel.text = [NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:showSalePrice]];
    self.pirceLabel.text = [NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:showPrice]];
    NSMutableAttributedString *attrbutdestring = [[NSMutableAttributedString alloc]initWithString:self.pirceLabel.text];
    
    [attrbutdestring addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                                     NSForegroundColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                                     NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                     NSFontAttributeName:FONT_t7
                                     }range:NSMakeRange(0,self.pirceLabel.text.length)];
    self.pirceLabel.attributedText =attrbutdestring;
    //一样的话 pricelabel要划掉
    if ([showPrice isEqualToString:showSalePrice]) {
        self.pirceLabel.hidden=YES;
    }else{
        self.pirceLabel.hidden=YES;
    }
//    self.totalPirceLabel.text = [NSString stringWithFormat:@"￥%.2f", _sale_price];
//    self.pirceLabel.text = [NSString stringWithFormat:@"￥%.2f", _price];
}

#pragma mark 计算总价格
- (void)calulateTotalPrice:(MBAddShoppingProductInfoModel *)model{
        CGFloat sale_price = model.goodnumber.integerValue * model.salE_PRICE.floatValue;
        CGFloat price = model.goodnumber.integerValue * model.price.floatValue;
        if (model.isSelectedCurrent.boolValue) {
            _price += price;
            _sale_price += sale_price;
        }

//    CGFloat sale_price = model.goodsNumber * model.clsInfo.sale_price.floatValue;
//    CGFloat price = model.goodsNumber * model.clsInfo.price.floatValue;
//    if (model.isSelectedCurrent) {
//        _price += price;
//        _sale_price += sale_price;
//    }
}

#pragma mark SShoppingBagSharedInstanceDelegate
- (void)returnShoppingBag:(SShoppingBagSharedInstance *)shoppingBag{
    [self onCart];
}

#pragma mark - ***备用方法 暂时弃用***
#pragma mark - 购物袋数量
- (void)requestCarCount{
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        }
        else
        {  [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
            
            self.shoppingBagButton.titleLabel.hidden=YES;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.shoppingBagButton.titleLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }completion:^(BOOL finished) {
            self.shoppingBagButton.titleLabel.transform = CGAffineTransformIdentity;
        }];
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark 获取数据
- (void)requestData{
    [self requestCarCount];
    if (_contentModel) {
        _contentModelArray = [NSMutableArray arrayWithObject:_contentModel];
    }
    NSMutableArray *modelArray = [NSMutableArray array];
    NSMutableArray *codeModelArray = [NSMutableArray array];
    
    for (int i = 0; i < _contentModelArray.count; i++) {
        MBGoodsDetailsModel *model = _contentModelArray[i];
        [codeModelArray addObject:model.clsInfo.code];
        [modelArray addObject:model.clsInfo.aID];
        
    }
    
    if ([self.itemAry count]!=0) {
        [codeModelArray  removeAllObjects];
        [codeModelArray addObjectsFromArray:self.itemAry];
        
    }
    if ([codeModelArray count]==0) {
        return;
    }
    // MARK：切换VC时候会闪退，所以尽量锁定交互，避免vc释放后引起的问题////////  zheli 882049
    [Toast makeToastActivity];
    
    NSString *codeStr = [codeModelArray componentsJoinedByString:@","];
    
    [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductFilter" params:@{@"prodClsIdList": codeStr} success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        NSLog(@"。。dic 选择颜色尺码。。。。%@",dict);
        self.productInfoModelArray = [MBAddShoppingProductInfoModel modelArrayForDataArray:dict[@"results"]];
    } failed:^(NSError *error) {
        NSLog(@"失败....");
        
        [Toast hideToastActivity];
    }];
}


/*
#pragma mark 获取商品关联信息
- (void)requestCollocationData{
    // MARK：尽量锁定交互，避免vc释放后引起的问题
    [Toast makeToastActivity];
    if (!self.itemAry) {
        [Toast hideToastActivity];
        return;
    }
    
    NSDictionary *params = @{@"ids": self.itemAry};
    NSString *codeStr = [self.itemAry componentsJoinedByString:@","];
    
    //    params = @{@"ids":codeStr};
    params = @{@"IDS": codeStr, @"loginUserId": sns.ldap_uid};
    
    //    //新接口
 
     [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductClsFilter" params:params success:^(NSDictionary *dict) {
     [Toast hideToastActivity];
     self.contentModelArray = [MBGoodsDetailsModel modelArrayForDataArray:dict[@"results"]];
     } failed:^(NSError *error) {
     [Toast makeToast:@"获取商品失败！" duration:3.0 position:@"center"];
     [Toast hideToastActivity];
     NSLog(@"单品详情请求错误---MBGoodsDetailsViewController---%@", error);
     }];
 
    
//    [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductFilter" params:@{@"prodClsIdList": codeStr} success:^(NSDictionary *dict) {
//        [Toast hideToastActivity];
//        NSLog(@"。。dic 选择颜色尺码。。。。%@",dict);
//        
//        self.productInfoModelArray = [MBAddShoppingProductInfoModel modelArrayForDataArray:dict[@"results"]];
//        NSLog(@"%@",_productInfoModelArray);
//        
//    } failed:^(NSError *error) {
//        NSLog(@"失败....");
//        
//        [Toast hideToastActivity];
//    }];
}


#pragma mark 获取数据
- (void)requestData{
    [self requestCarCount];
    if (_contentModel) {
        _contentModelArray = [NSMutableArray arrayWithObject:_contentModel];
    }
    NSMutableArray *modelArray = [NSMutableArray array];
    NSMutableArray *codeModelArray = [NSMutableArray array];
    
    for (int i = 0; i < _contentModelArray.count; i++) {
        MBGoodsDetailsModel *model = _contentModelArray[i];
        [codeModelArray addObject:model.clsInfo.code];
        [modelArray addObject:model.clsInfo.aID];
        
    }
    
    if ([self.itemAry count]!=0) {
        [codeModelArray  removeAllObjects];
        [codeModelArray addObjectsFromArray:self.itemAry];
        
    }
    if ([codeModelArray count]==0) {
        return;
    }
    // MARK：切换VC时候会闪退，所以尽量锁定交互，避免vc释放后引起的问题////////  zheli 882049
    [Toast makeToastActivity];
    
    NSString *codeStr = [codeModelArray componentsJoinedByString:@","];
    
    [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductFilter" params:@{@"prodClsIdList": codeStr} success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        NSLog(@"。。dic 选择颜色尺码。。。。%@",dict);
        self.productInfoModelArray = [MBAddShoppingProductInfoModel modelArrayForDataArray:dict[@"results"]];
    } failed:^(NSError *error) {
        NSLog(@"失败....");
        
        [Toast hideToastActivity];
    }];
    
}
 
#pragma mark - set get
- (void)setProductInfoModelArray:(NSArray *)productInfoModelArray{
    for (MBGoodsDetailsModel *detailModel in self.contentModelArray) {
     NSMutableArray *array = [NSMutableArray array];
     //        NSMutableArray *colorArray = [NSMutableArray array];
     
     for (MBAddShoppingProductInfoModel *productModel in productInfoModelArray) {
     //老得
     //            if (productModel.lM_PROD_CLS_ID.intValue == detailModel.clsInfo.aID.intValue) {
     //                [array addObject:productModel];
     //            }
     NSString *prod_cls_num = [NSString stringWithFormat:@"%@",productModel.proD_CLS_NUM];
     NSString *clsInfoCode = [NSString stringWithFormat:@"%@",detailModel.clsInfo.code];
     
     if ([clsInfoCode isEqualToString:prod_cls_num]) {
     [array addObject:productModel];
     
     }
     //防止 前面一个页面 没有name  这个页面有name
     detailModel.clsInfo.name=productModel.proD_NAME;
     }
     detailModel.stockList = array;
     
     }
     MBAddShoppingContentTableViewCell *cell = [MBAddShoppingContentTableViewCell new];
     [_contentModelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     cell.contentModel = obj;
     }];

 
    [self.contentTableView reloadData];
}


- (void)setContentModelArray:(NSMutableArray *)contentModelArray{
    
    if (!contentModelArray || contentModelArray.count <= 0) return;
    [_contentModelArray removeAllObjects];
    
    for (MBGoodsDetailsModel *model in contentModelArray) {
        //已下架 已售罄的也展示
        //        if (model.clsInfo.status.intValue == 2 && model.clsInfo.stockCount.intValue > 0) {
        [_contentModelArray addObject:model];
        //        }
    }
    [self.contentTableView reloadData];
    if (!_contentModel) [self requestData];
}

#pragma mark - 购物袋数量
- (void)requestCarCount{
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        }
        else
        {  [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
            
            self.shoppingBagButton.titleLabel.hidden=YES;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.shoppingBagButton.titleLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }completion:^(BOOL finished) {
            self.shoppingBagButton.titleLabel.transform = CGAffineTransformIdentity;
        }];
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - 加入购物袋
- (IBAction)addShoppingButtonAction:(UIButton *)sender {
    NSMutableArray *paramsArray = [[NSMutableArray alloc]init];
    for (MBGoodsDetailsModel *goodsDetailModel in _contentModelArray) {
        if(goodsDetailModel.isSelectedCurrent){
            [paramsArray addObject:[self createParamsWithModel:goodsDetailModel]];
        }
    }
    if (paramsArray.count <= 0) {
        [Toast makeToast:@"请选择商品！" duration:1.5 position:@"center"];
        return;
    }
    [TalkingData trackEvent:@"选择商品" label:@"按下'加入购物袋'按钮"];
    
    self.addShoppingBagButton.enabled = NO;
    __unsafe_unretained typeof(self) p = self;
    NSDictionary *params = @{@"lstCreateDto":paramsArray,@"userId":sns.ldap_uid};
    NSLog(@"paramds----%@",params);
    [HttpRequest orderPostRequestPath:@"Cart" methodName:@"ShoppingCartCreateList" params:params success:^(NSDictionary *dict) {
        p.addShoppingBagButton.enabled = YES;
        if([dict[@"isSuccess"] boolValue]){
            [self showSendMessageSuccess];
            [Toast makeToastSuccess:@"成功添加到购物车！"];
            [TalkingData trackEvent:@"添加到购物车" label:@"添加到购物车成功"];
            [TalkingData trackEvent:@"填加购物车成功" label:[NSString stringWithFormat:@"商品信息来自:%@", _fromControllerName? _fromControllerName: @"模块获取失败"]];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"添加到购物车失败！" message:dict[@"message"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertView show];
            [TalkingData trackEvent:@"选择商品" label:@"添加到购物车失败(数据问题)" parameters:dict];
            [TalkingData trackEvent:@"填加购物车失败(数据导致)" label:[NSString stringWithFormat:@"商品信息来自:%@", _fromControllerName? _fromControllerName: @"模块获取失败"]];
        }
    } failed:^(NSError *error) {
        p.addShoppingBagButton.enabled = YES;
        [TalkingData trackEvent:@"选择商品" label:@"添加到购物车失败(网络问题)"];
        [TalkingData trackEvent:@"填加购物车失败(网络导致)" label:[NSString stringWithFormat:@"商品信息来自:%@", _fromControllerName? _fromControllerName: @"模块获取失败"]];
    }];
}

//添加到购物袋的动画效果
- (void)showSendMessageSuccess{
    UIGraphicsBeginImageContextWithOptions(self.tabBarContentView.bounds.size, NO, 3.0);  //NO，YES 控制是否透明
    [self.tabBarContentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = self.tabBarContentView.frame;
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = CGRectMake(UI_SCREEN_WIDTH - 60, 20, 40, 40);
    }completion:^(BOOL finished) {
        [self requestCarCount];
        [imageView removeFromSuperview];
    }];
}

//加入购物袋
- (NSDictionary*)createParamsWithModel:(MBGoodsDetailsModel*)model{
    
    NSString *tmpmbcollocationID = @"0";
    if (_collocationInfoDic == nil) {
        tmpmbcollocationID = [Utils getSNSInteger:[NSString stringWithFormat:@"%ld",(long)_mbCollocationID.integerValue]];
        if (tmpmbcollocationID.length == 0) {
            tmpmbcollocationID = @"0";
        }
        
    }else{
        tmpmbcollocationID = _collocationInfoDic[@"mbfun_id"];
        
    }
 
    //Mark：改版本强行改变成0 无搭配和商品可分  add by  miao 6.13
    NSMutableDictionary *params = [NSMutableDictionary new];
//
//     [params setObject:model.stockModel.aID forKey:@"PROD_ID"];
//     [params setObject:model.stockModel.speC_ID forKey:@"SPEC_ID"];
//     [params setObject:model.stockModel.coloR_ID forKey:@"COLOR_ID"];
//     [params setObject:@(model.goodsNumber) forKey:@"qty"];
//     [params setObject:[Utils getSNSString:sns.ldap_uid] forKey:@"userId"];
//     [params setObject:[Utils getSNSString:_shareUser_ID] forKey:@"sharE_SELLER_ID"];
//     
//     if ([[Utils getSNSInteger:_promotion_ID.stringValue] integerValue] != 0) {
//     Mark: 该版本暂时不需要先注释  add by miao 6.13
//     [params setObject:[Utils getSNSInteger:_promotion_ID.stringValue] forKey:@"PROMOTION_ID"];
//     [params setObject:[Utils getSNSString:_collocationInfoDic[@"nick_name"]] forKey:@"designerName"];
//     [params setObject:[Utils getSNSString:_collocationInfoDic[@"user_id"]] forKey:@"designerId"];
//     [params setObject:[Utils getSNSInteger:[NSString stringWithFormat:@"%@", tmpmbcollocationID]] forKey:@"collocatioN_ID"];
//     }

    
    //826 新版本新接口
    [params setObject:[NSString stringWithFormat:@"%@",model.stockModel.barcode_sys_code] forKey:@"barcode"];
    [params setObject:@(model.goodsNumber) forKey:@"Qty"];
    [params setObject:[NSString stringWithFormat:@"%@",model.stockModel.salE_PRICE] forKey:@"Price"];
    
    if ([Utils getSNSString:_promotion_ID].length!=0) {
        
        [params setObject:[Utils getSNSString:_promotion_ID] forKey:@"aid"];
        [params setObject:[Utils getSNSString:[NSString stringWithFormat:@"%@", tmpmbcollocationID]] forKey:@"cid"];
    }
    
    return params;
}

#pragma mark - 进入购物袋
- (IBAction)shoppingBagGoButtonAction:(UIButton *)sender {
    [self onCart];
}

//进入购物袋
- (void)onCart{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBAddShoppingContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    
    
    //    if (!self.itemAry) {
    cell.contentModel = _contentModelArray[indexPath.row];
    //    }else
    //    {
    //        cell.showProductArray=_productInfoModelArray[indexPath.row];
    //    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _contentModelArray.count - 1) {
        return 240.0;
    }
    return 253.0;
}

#pragma mark - MBAddShoppingContentTableViewCellDelegate
// Mark : 修改成每次都计算全部的，否则自动选中有问题  fzh
- (void)shoppingContentTableCellSelected:(MBGoodsDetailsModel *)model button:(UIButton *)sender{
    // 每次全部重算
    _price = 0;
    _sale_price = 0;
    
    for (int i=0; i<_contentModelArray.count; i++) {
        MBGoodsDetailsModel *model = _contentModelArray[i];
        [self calulateTotalPrice:model];
    }
    NSString *showSalePrice = [NSString stringWithFormat:@"%.2f",_sale_price];
    NSString *showPrice =[NSString stringWithFormat:@"%.2f",_price];
    self.totalPirceLabel.text = [NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:showSalePrice]];
    self.pirceLabel.text = [NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:showPrice]];
    
    NSMutableAttributedString *attrbutdestring = [[NSMutableAttributedString alloc]initWithString:self.pirceLabel.text];
    
    [attrbutdestring addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                                     NSForegroundColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                                     NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                     NSFontAttributeName:FONT_t7
                                     }range:NSMakeRange(0,self.pirceLabel.text.length)];
    self.pirceLabel.attributedText =attrbutdestring;
    //一样的话 pricelabel要划掉
    if ([showPrice isEqualToString:showSalePrice]) {
        self.pirceLabel.hidden=YES;
    }
    else
    {
        self.pirceLabel.hidden=NO;
    }
    //    self.totalPirceLabel.text = [NSString stringWithFormat:@"￥%.2f", _sale_price];
    //    self.pirceLabel.text = [NSString stringWithFormat:@"￥%.2f", _price];
}

//总价格
- (void)calulateTotalPrice:(MBGoodsDetailsModel *)model{
    CGFloat sale_price = model.goodsNumber * model.clsInfo.sale_price.floatValue;
    CGFloat price = model.goodsNumber * model.clsInfo.price.floatValue;
    if (model.isSelectedCurrent) {
        _price += price;
        _sale_price += sale_price;
    }
}
*/

//立即购买方法
- (IBAction)buyNowButtonAction:(UIButton *)sender {
    NSMutableArray *payList=[[NSMutableArray alloc] init];
    void (^setPayListData)(MBGoodsDetailsModel*) = ^(MBGoodsDetailsModel *model){
        MyShoppingTrollyGoodsData *data=[[MyShoppingTrollyGoodsData alloc] init];
        data.value = @{@"productInfo": model.stockModel.dictionaryValue};
        data.collocationid = [NSString stringWithFormat:@"%@", _collocationID];
        data.designerid = [Utils getSNSString:_collocationModel.collocationInfo.userId];
        data.designername = [Utils getSNSString:_collocationModel.collocationInfo.creatE_USER];
        data.number = model.goodsNumber;
        
        data.shareUserId = [Utils getSNSString:_shareUser_ID];
        [payList addObject:data];
    };
    
    if (_contentModelArray){
        for (MBGoodsDetailsModel *detailModel in _contentModelArray) {
            if (detailModel.isSelectedCurrent) {
                setPayListData(detailModel);
            }
        }
    }
    if (payList.count == 0) {
        [Toast makeToast:@"请先选择需要购买的商品!" duration:2.0 position:@"center"];
        return;
    }
    MBCreateGoodsOrderViewController *orderVC = [[MBCreateGoodsOrderViewController alloc] initWithNibName:@"MBCreateGoodsOrderViewController" bundle:nil];
    orderVC.goodsArray = payList;
    orderVC.sumInfo = nil;
    //    [self addShoppingSuccessMothod];
    [self.navigationController pushViewController:orderVC animated:YES];
}

//添加渐变色
- (void)addGradientLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0, @0.9, @1];
    gradientLayer.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:1].CGColor,
                             (id)[[UIColor whiteColor] colorWithAlphaComponent:1].CGColor,
                             (id)[[UIColor whiteColor] colorWithAlphaComponent:0].CGColor,];
    _headerContentViewBackLayer = gradientLayer;
}

- (void)setShowBackImage:(UIImage *)showBackImage{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = showBackImage;
    [self.view insertSubview:imageView atIndex:0];
    
    CALayer *layer = [CALayer layer];
    layer.frame = imageView.bounds;
    [imageView.layer addSublayer:layer];
    _backImageLayer = layer;
}

//更改底部按钮
- (void)settingShowType{
    switch (_showType) {
        case typeBuyNow:
            self.buyNowButton.hidden = NO;
            [self.buyNowButton setTitle:@"去结算" forState:UIControlStateNormal];
            [self.addShoppingBagButton setTitle:@"加入购物袋" forState:UIControlStateNormal];
            break;
        case typeAddShopping:
            self.buyNowButton.hidden = YES;
            self.addShoppingBagButton.frame = self.buyNowButton.frame;
            [self.addShoppingBagButton setTitle:@"加入购物袋" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark 获取数据
- (void)requestAndJudge{
    
    if (_productID && !_itemAry) {
        _itemAry = @[_productID];
    }
    if (!_itemAry && !_contentModel) {
        [self requestForCollocation];
    }else{
        
        [self requestCollocationData];
        if (_contentModel){
            [self requestData];
        }
    }
}

- (void)requestForCollocation{
    NSDictionary *data = @{
                           @"m": @"Collocation",
                           @"a": @"getCollocationListById",
                           @"cid": _mbCollocationID
                           };
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        if ([responseObject[@"data"] count] == 0) {
            return ;
        }
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"data"][0][@"itemList"]) {
            [mutableArray addObject:dict[@"id"]];
        }
        _itemAry = mutableArray;
        [self requestCollocationData];
        [self requestData];
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        
    }];
    
}

- (void)setContentModelArray:(NSMutableArray *)contentModelArray{
    if (!contentModelArray || contentModelArray.count <= 0) return;
    [_contentModelArray removeAllObjects];
    for (MBGoodsDetailsModel *model in contentModelArray) {
        //已下架 已售罄的也展示
        //        if (model.clsInfo.status.intValue == 2 && model.clsInfo.stockCount.intValue > 0) {
        [_contentModelArray addObject:model];
        //        }
    }
    [self.contentTableView reloadData];
    if (!_contentModel) [self requestData];
}

@end
