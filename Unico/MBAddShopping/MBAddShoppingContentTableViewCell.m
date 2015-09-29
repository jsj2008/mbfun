//
//  MBAddShoppingContentTableViewCell.m
//  Wefafa
//
//  Created by unico_0 on 15/5/24.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBAddShoppingContentTableViewCell.h"

#import "MBGoodsDetailListModel.h"
#import "UIImageView+AFNetworking.h"
#import "SUtilityTool.h"

#import "Toast.h"

@interface MBAddShoppingContentTableViewCell () <MBAddShoppingColorViewDelegate, MBAddShoppingSizeViewDelegate, MBAddShoppingProductNumberViewDelegate>
{
    NSMutableArray *_showSizeArray;
    NSMutableArray *_showColorArray;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *showGoodsImageView;       //显示已选商品图
@property (weak, nonatomic) IBOutlet UILabel *showGoodsNameLabel;           //显示商品名称用
@property (weak, nonatomic) IBOutlet UILabel *showGoodsCodeLabel;           //显示商品编号用
@property (weak, nonatomic) IBOutlet UILabel *showGoodsPirceLabel;          //显示价格
@property (weak, nonatomic) IBOutlet UILabel *showGoodsStockLabel;          //显示库存
@property (weak, nonatomic) IBOutlet UIButton *showSelectedStateButton;     //选择商品button

@property (assign, nonatomic) NSInteger currentColorIndex; // 用于当前选择的颜色
@property (assign, nonatomic) NSInteger currentSizeIndex;  // 用于当前选择的尺寸

@property (nonatomic, strong) NSString *chooseColorStr;     //当前选择的颜色
@property (nonatomic, strong) NSString *chooseSizeStr;      //当前选择的尺寸

@property (nonatomic, strong) MBAddShoppingProductInfoModel *currentSelectProductModel; //当前选择的产品模型

@property (weak, nonatomic) IBOutlet UILabel *showStateLabel;


- (IBAction)selectedStateButtonAction:(UIButton *)sender;
@end

@implementation MBAddShoppingContentTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    _showSizeArray = [NSMutableArray array];
    _showColorArray = [NSMutableArray array];
    self.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.showColorCollectionView.colorCollectionDelegate = self;
    self.showSizeCollectionView.sizeCollectionDelegate = self;
    self.buyCountActionView.delegate = self;
    
    //默认选择第一个color
    //self.showColorCollectionView.selectedIndex = 0;
}

//初始化商品数据
-(void)setShowProductArray:(NSArray *)showProductArray
{
    _showProductArray= showProductArray;
    
    NSArray *colorArray = [self getColorArrWithArr:_showProductArray];
    _showColorCollectionView.contentModelArray = colorArray;
    [self updateData];
}

#pragma mark 更新库存等 页面数据
- (void)updateData
{
    //查看对应颜色是否已售罄
    //[self isHasbeensoldout];
    
    //更新数据
    _currentSelectProductModel = [self getSelectProduct];
    NSString *qty=[NSString stringWithFormat:@"%@",_currentSelectProductModel.lisT_QTY];
    NSString *prodName = [NSString stringWithFormat:@"%@",_currentSelectProductModel.proD_NAME];
    //设置图片
    NSString *urlString = _currentSelectProductModel.coloR_FILE_PATH;
    [self.showGoodsImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE] options:SDWebImageHighPriority];
    
    //设置库存数
    self.showGoodsStockLabel.text = [NSString stringWithFormat:@"库存%@件", [Utils getSNSString:qty]];
    //设置商品名称
    self.showGoodsNameLabel.text = prodName;
    //设置商品编号
    self.showGoodsCodeLabel.text = [NSString stringWithFormat :@"商品编号:%@", _currentSelectProductModel.proD_CLS_NUM];
    //设置价格
    NSString *salePrice =[NSString stringWithFormat:@"%@", _currentSelectProductModel.salE_PRICE];
    NSString *salePriceString =[Utils getSNSRMBMoney:salePrice];
    [self setCurrentPriceForScalePirce:salePriceString productInfoModel:_currentSelectProductModel];
    
    //商品购买
    self.buyCountActionView.stockCount = _currentSelectProductModel.lisT_QTY.intValue;
    self.buyCountActionView.number =  _currentSelectProductModel.goodnumber.intValue;
    
    //是否选中商品
    self.showSelectedStateButton.selected = _currentSelectProductModel.isSelectedCurrent.boolValue;
}

- (void)setCurrentPriceForScalePirce:(NSString*)salePriceString  productInfoModel:(MBAddShoppingProductInfoModel *)module{
    NSString *priceString = [NSString stringWithFormat:@"%.2f", module.price.floatValue];
    priceString =[Utils getSNSRMBMoney:priceString];
    if ([priceString isEqualToString:salePriceString]) {
        priceString = @"";
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", salePriceString, priceString]];
    [attributeString addAttributes:@{NSStrikethroughColorAttributeName: COLOR_C6,
                                     NSForegroundColorAttributeName:  COLOR_C6,
                                     NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                     NSFontAttributeName: [UIFont systemFontOfSize:11]
                                     }range:NSMakeRange(salePriceString.length + 1, priceString.length)];
    self.showGoodsPirceLabel.attributedText = attributeString;
}


#pragma mark - 尺寸数据设置默认值方法
//选取默认尺寸
-(void)initDefultSize:(NSString *)colorid{
    //如果没有选择商品 则设置默认size
    NSArray *sizeArray = [self getSizeArrWithColorid:colorid];
    for (MBAddShoppingProductInfoModel *model in _showProductArray) {
        if ([model.speC_NAME isEqual:sizeArray[0][@"speC_NAME"]]) {
            model.isSizeSelected = @YES;
        }else{
            model.isSizeSelected = @NO;
        }
    }
}

//是否有已选择的商品
- (BOOL)isSelectProduct{
    for (MBAddShoppingProductInfoModel *obj in _showProductArray) {
        if (obj.isSelectProduct.boolValue) {
            return YES;
        }
    }
    return NO;
}

//是否用户已选尺寸
-(BOOL)isCustomSelectSize:(MBAddShoppingColorCell *)cell{
    for (MBAddShoppingProductInfoModel *obj in _showProductArray) {
        if (obj.saveCustomSelectSpeC_NAME != nil &&![obj.saveCustomSelectSpeC_NAME isEqual: @""]&& [obj.coloR_ID isEqual:cell.coloR_ID]&&[obj.speC_NAME isEqual:obj.saveCustomSelectSpeC_NAME]) {
            for (MBAddShoppingProductInfoModel *model in _showProductArray) {
                if ([model.speC_NAME isEqual:obj.speC_NAME]) {
                    model.isSizeSelected = @YES;
                }else{
                    model.isSizeSelected = @NO;
                }
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - 数据的处理
#pragma mark - 获取所有颜色数组
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
- (NSArray *)getSizeArrWithColorid:(NSString *)colorid
{
    NSMutableDictionary *newDict = [@{} mutableCopy];
    NSMutableArray *tempArr = [@[] mutableCopy];
    [_showProductArray enumerateObjectsUsingBlock:^(MBAddShoppingProductInfoModel *obj, NSUInteger idx, BOOL *stop) {
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

#pragma mark 获取当前选择的产品model
- (MBAddShoppingProductInfoModel *)getSelectProduct
{
    MBAddShoppingProductInfoModel *showProductInfoModel = [MBAddShoppingProductInfoModel new];
    
    for (MBAddShoppingProductInfoModel *obj in _showProductArray) {
        //获取选择的产品model
        if (obj.isSelectProduct.boolValue) {
            showProductInfoModel = obj;
            return showProductInfoModel;
        }else{
            showProductInfoModel = obj;
        }
    }
    return showProductInfoModel;
}

#pragma mark - 点击选中
- (IBAction)selectedStateButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_showProductArray enumerateObjectsUsingBlock:^(MBAddShoppingProductInfoModel *obj, NSUInteger idx, BOOL *stop) {
        [obj setValue:[NSNumber numberWithBool:sender.selected] forKey:@"isSelectedCurrent"];
    }];
    
    if ([self.delegate respondsToSelector:@selector(shoppingContentTableCellSelectedModul:Button:)]) {
        MBAddShoppingProductInfoModel *model = _showProductArray[0];
        [self.delegate shoppingContentTableCellSelectedModul:model Button:sender];
    }
}

#pragma mark - 设置选择颜色和尺寸的代理
#pragma mark MBAddShoppingColorViewDelegate
- (void)colorViewContentCollectionCell:(MBAddShoppingColorCell *)cell
              didSelectItemAtIndexPath:(NSInteger)index{
    //*如果选择的颜色相同 return
    for (MBAddShoppingProductInfoModel *obj in _showProductArray) {
        if ([obj.coloR_ID isEqual:cell.coloR_ID]&&obj.isColorSelected.boolValue&&obj.isSelectProduct.boolValue) {
            //更新SizeCollectionView数据
            self.showSizeCollectionView.contentModelArray = [self getSizeArrWithColorid:cell.coloR_ID];
            [self updateData];
            return;
        }
    }
    
    //根据选择的颜色初始化数据
    [_showProductArray enumerateObjectsUsingBlock:^(MBAddShoppingProductInfoModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.coloR_ID isEqual:cell.coloR_ID]) {
            obj.isColorSelected = @YES;
        }else{
            obj.isColorSelected = @NO;
        }
    }];
    
    //重置颜色cell 数组数据
    NSArray *colorArray = [self getColorArrWithArr:_showProductArray];
    _showColorCollectionView.contentModelArray = colorArray;
    
    //重置产品数据
    for (MBAddShoppingProductInfoModel *obj in _showProductArray) {
        obj.isSelectProduct = @NO;
    }

    //用户是否已选尺寸
    if (![self isCustomSelectSize:cell]) {
        //根据颜色 设置默认尺寸
        if (![self isSelectProduct]) {
            [self initDefultSize:cell.coloR_ID];
        }
    }

    //根据颜色和尺寸 设置选择的产品
    for (MBAddShoppingProductInfoModel *model in _showProductArray) {
        if (model.isColorSelected.boolValue && model.isSizeSelected.boolValue) {
            model.isSelectProduct = @YES;
        }else{
            model.isSelectProduct = @NO;
        }
    }
    
    //更新SizeCollectionView数据
    _showSizeCollectionView.contentModelArray = [self getSizeArrWithColorid:cell.coloR_ID];
    [self updateData];
}

#pragma mark MBAddShoppingSizeViewDelegate
- (void)sizeViewContentCollectionCell:(MBAddShoppingSizeCell*)cell
             didSelectItemAtIndexPath:(NSInteger)index{

    //更新尺寸数据
    for (MBAddShoppingProductInfoModel *model in _showProductArray) {
        if ([model.speC_NAME isEqual:cell.showSizeLabel.text]) {
            model.isSizeSelected = @YES;
        }else{
            model.isSizeSelected = @NO;
        }
        model.saveCustomSelectSpeC_NAME = cell.showSizeLabel.text;
    }
    
    //根据颜色和尺寸 设置选择的产品
    for (MBAddShoppingProductInfoModel *model in _showProductArray) {
        if (model.isColorSelected.boolValue && model.isSizeSelected.boolValue) {
            model.isSelectProduct = @YES;
        }else{
            model.isSelectProduct = @NO;
        }
    }
    
    //根据颜色和尺寸 设置选择的产品
    for (MBAddShoppingProductInfoModel *model in _showProductArray) {
        if (model.isColorSelected.boolValue) {
            self.showSizeCollectionView.contentModelArray = [self getSizeArrWithColorid:[NSString stringWithFormat:@"%@",model.coloR_ID]];
            break;
        }
    }

    [self updateData];
}

#pragma mark MBAddShoppingProductNumberViewDelegate 购买数修改代理接收
- (void)shoppingProductNumberChange:(int)number{
    __weak typeof(self) weakself = self;
    [_showProductArray enumerateObjectsUsingBlock:^(MBAddShoppingProductInfoModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.barcode_sys_code isEqualToString:_currentSelectProductModel.barcode_sys_code]) {
            [obj setValue:[NSNumber numberWithInt:number] forKey:@"goodnumber"];
            
            //计算价格
            if ([weakself.delegate respondsToSelector:@selector(shoppingContentTableCellSelectedModul:Button:)]) {
                [weakself.delegate shoppingContentTableCellSelectedModul:obj Button:_showSelectedStateButton];
                
            }
        }
    }];
    
    if (number <= 0) {
        self.showSelectedStateButton.selected = NO;
    }
}


#pragma mark - ***备用方法 暂时弃用***
- (void)setContentModel:(MBGoodsDetailsModel *)contentModel{
    if (!contentModel.stockList || contentModel.stockList.count <= 0) return;
    [_showColorArray removeAllObjects];
    
    if (contentModel.stockList){
        for (MBGoodsDetailsColorModel *colorModel in contentModel.colorList) {
            int count = 0;
            //         正确做法
            for (MBAddShoppingProductInfoModel *stockModel in colorModel.stockList) {
                
                if (stockModel.status.intValue == 2) {
                    count += stockModel.lisT_QTY.intValue;
                }
            }
            
            
            //调试专用 错误做法
            //            for (MBAddShoppingProductInfoModel *stockModel in contentModel.stockList) {
            //
            //                if (stockModel.status.intValue == 2) {
            //                    count += stockModel.lisT_QTY.intValue;
            //                }
            //            }
            
            BOOL isExit=NO;//去重  先暂时这么样
            if (count > 0) {
                
                for (int k=0; k<[_showColorArray count]; k++) {
                    MBGoodsDetailsColorModel *colorModels=_showColorArray[k];
                    if ([[NSString stringWithFormat:@"%@",colorModels.code] isEqualToString:[NSString stringWithFormat:@"%@",colorModel.code]])
                    {
                        isExit=YES;
                    }
                    else
                    {
                        
                    }
                }
                if (!isExit) {
                    [_showColorArray addObject:colorModel];
                }
                
            }
        }
    }
    // 将已售磬的已下架的也展示。
    
    //    if (_showColorArray.count <= 0) return;
    
    //脏数据处理wwp
    self.showGoodsNameLabel.text = contentModel.clsInfo.name;
    
    _contentModel = contentModel;
    NSString *urlString = @"";
    if (contentModel.clsPicUrl.count > 0) {
        MBGoodsDetailsPictureModel *model = contentModel.clsPicUrl[0];
        urlString = model.filE_PATH;
    }
    
    self.showGoodsCodeLabel.text = [NSString stringWithFormat :@"商品编号:%@", contentModel.clsInfo.code];
    [self.showGoodsImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageHighPriority];
    self.showSelectedStateButton.selected = contentModel.isSelectedCurrent;
    
    
    self.buyCountActionView.stockCount = contentModel.stockModel.lisT_QTY.intValue;
    self.buyCountActionView.number = contentModel.goodsNumber;
    
    // 将已售磬的已下架的也展示。
    if(_showColorArray.count<=0){
        self.showSelectedStateButton.hidden=YES;
        [_showStateLabel setBackgroundColor:[Utils HexColor:0xe2e2e2e2 Alpha:1]];
        self.showSizeCollectionView.hidden=YES;
        _showStateLabel.hidden = NO;
        NSString *stateStr=@"已售罄";
        for (MBGoodsDetailsColorModel *colorModel in contentModel.colorList) {
            
            [_showColorArray addObject:colorModel];
        }
        if ([_contentModel.clsInfo.status intValue]!=2) {
            stateStr =@"已下架";
        }else if([_contentModel.clsInfo.stockCount intValue]<=0){
            stateStr =@"已售罄";
        }
        _showStateLabel.text=stateStr;
    }else {
        _showStateLabel.hidden=YES;
        self.showSizeCollectionView.hidden=NO;
        self.showSelectedStateButton.hidden=NO;
    }
    //
    self.showColorCollectionView.contentModelArray = _showColorArray;
    self.showSizeCollectionView.contentModelArray = _showSizeArray;
    
    //----------向尺码列表，颜色列表传递数据
    if (contentModel.colorSelectedIndex == -1 && contentModel.stockList) {
        //脏数据 崩溃wwp813
        if ([_showColorArray count]==0&&[_showSizeArray count]==0) {
            return;
        }
        self.showColorCollectionView.selectedIndex = contentModel.colorSelectedIndex;
        [self selectedColorForIndex:0];
    }else if(contentModel.colorSelectedIndex >= 0 ){
        
        if ([_showColorArray count]==0&&[_showSizeArray count]==0) {
            return;
        }
        [self selectedColorForIndex:(int)contentModel.colorSelectedIndex];
    }else
    {    //默认第一个wwp813
        if ([_showColorArray count]==0&&[_showSizeArray count]==0) {
            return;
        }
        [self selectedColorForIndex:0];
    }
}


#pragma mark collectionView delegate
- (void)selectedColorForIndex:(int)index{
    _contentModel.isEdit = NO;
    _buyCountActionView.isEdit = NO;
    [_showSizeArray removeAllObjects];
    _contentModel.colorSelectedIndex = index;
    
    for (MBGoodsDetailsColorModel *colorModel in _showColorArray) {
        colorModel.isUnStock = NO;
    }
    int stockCount = 0;
    MBGoodsDetailsColorModel *colorModel = _showColorArray[index];
    for (MBAddShoppingProductInfoModel *stockModel in colorModel.stockList) {
        
        if (stockModel.status.intValue == 2){
            stockCount += stockModel.lisT_QTY.intValue;
        }
        
        for (MBGoodsDetailesSpecModel *sizeModel in _contentModel.specList) {
            //code 比较
            if (stockModel.speC_ID.intValue == sizeModel.code.intValue) {
                
                if (stockModel.status.intValue != 2 || stockModel.lisT_QTY.intValue == 0) {
                    sizeModel.isUnStock = YES;
                }else{
                    sizeModel.isUnStock = NO;
                    
                    BOOL isExit=NO;//去重  先暂时这么样
                    for (int k=0; k<[_showSizeArray count]; k++) {
                        MBGoodsDetailesSpecModel *sizeModels=_showSizeArray[k];
                        if ([[NSString stringWithFormat:@"%@",sizeModels.code] isEqualToString:[NSString stringWithFormat:@"%@",sizeModel.code]])
                        {
                            isExit=YES;
                        }
                        else
                        {
                            
                        }
                    }
                    if (!isExit) {
                        [_showSizeArray addObject:sizeModel];
                    }
                    
                    //                    NSLog(@"picurl----%@",colorModel.picurl);
                    
                    [self.showGoodsImageView sd_setImageWithURL:[NSURL URLWithString:colorModel.picurl]];
                    
                    
                }
            }
            /*老得
             if (stockModel.speC_ID.intValue == sizeModel.aID.intValue) {
             if (stockModel.status.intValue != 2 || stockModel.lisT_QTY.intValue == 0) {
             sizeModel.isUnStock = YES;
             }else{
             sizeModel.isUnStock = NO;
             [_showSizeArray addObject:sizeModel];
             
             [self.showGoodsImageView sd_setImageWithURL:[NSURL URLWithString:colorModel.picurl]];
             
             }
             }
             */
        }
    }
    
    self.showGoodsNameLabel.text = _contentModel.clsInfo.name;
    self.showGoodsStockLabel.text = [NSString stringWithFormat:@"库存%d件", stockCount];
    NSString *salePrice =[NSString stringWithFormat:@"%@", _contentModel.clsInfo.sale_price];
    NSString *salePriceString =[Utils getSNSRMBMoney:salePrice];
    
    [self setCurrentPriceForScalePirce:salePriceString];
    
    _showColorCollectionView.selectedIndex = _contentModel.colorSelectedIndex;
    [_showSizeCollectionView reloadData];
    
    if (!_contentModel.isUserOpration) {
        MBGoodsDetailesSpecModel *currentSize = [_showSizeArray firstObject];
        //        老得 根据id比较
        //        colorModel.selectedSizeId = currentSize.aID.integerValue;
        //新的 根据 code
        colorModel.selectedSizeId = currentSize.code.integerValue;
    }else{
        colorModel.selectedSizeId = _contentModel.sizeSelectedId;
    }
    [self selectedSizeForId];
    MBGoodsDetailsColorModel *selectedColorModel = _showColorArray[_contentModel.colorSelectedIndex];
    for (MBGoodsDetailesSpecModel *sizeModel in _showSizeArray) {
        //老的
        //        if (sizeModel.aID.intValue == selectedColorModel.selectedSizeId) {
        //            _showSizeCollectionView.selectedIndex = [_showSizeArray indexOfObject:sizeModel];
        //        }
        //新的
        if (sizeModel.code.intValue == selectedColorModel.selectedSizeId) {
            _showSizeCollectionView.selectedIndex = [_showSizeArray indexOfObject:sizeModel];
        }
    }
    if (_contentModel.isUserOpration) {
        int count = 0;
        for (MBGoodsDetailesSpecModel *sizeModel in _showSizeArray) {
            //老得
            //            count += sizeModel.aID.intValue == _contentModel.sizeSelectedId? 1: 0;
            //新的
            count += sizeModel.code.intValue == _contentModel.sizeSelectedId? 1: 0;
        }
        if (count == 0) {
            NSString *alertString = [NSString stringWithFormat:@"此颜色无%@对应尺码！", _contentModel.stockModel.speC_NAME];
            [Toast makeToast:alertString duration:1.5 position:@"center"];
            MBGoodsDetailesSpecModel *currentSize = [_showSizeArray firstObject];
            //老得
            //            colorModel.selectedSizeId = currentSize.aID.integerValue;
            //新的
            colorModel.selectedSizeId = currentSize.code.integerValue;
            [self selectedSizeForId];
            for (MBGoodsDetailesSpecModel *sizeModel in _showSizeArray) {
                //老得
                //                if (sizeModel.aID.intValue == selectedColorModel.selectedSizeId) {
                //                    _showSizeCollectionView.selectedIndex = [_showSizeArray indexOfObject:sizeModel];
                //                }
                //新的
                if (sizeModel.code.intValue == selectedColorModel.selectedSizeId) {
                    _showSizeCollectionView.selectedIndex = [_showSizeArray indexOfObject:sizeModel];
                }
            }
        }
    }
}


- (NSString *)getColorArrWithUrlStr:(NSString *)urlStr sizeStr:(NSString *)sizeStr
{
    __block NSString *colorStr = nil;
    NSMutableArray *newArr = [@[] mutableCopy];
    [_showProductArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([urlStr isEqualToString:obj[@"coloR_FILE_PATH"]]) {
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
    [_showProductArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([colorStr isEqualToString:obj[@"coloR_NAME"]]&&[sizeStr isEqualToString:obj[@"speC_NAME"]]) {
            [newArr addObject:obj];
            barcode_sys_codeStr = [NSString stringWithFormat:@"%@",obj[@"barcode_sys_code"]];
            
        }
    }];
    
    
    return barcode_sys_codeStr;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.contentView.frame;
    frame.size.height = height;
    self.contentView.frame = frame;
}
- (void)setCurrentPriceForScalePirce:(NSString*)salePriceString {
    NSString *priceString = [NSString stringWithFormat:@"%.2f", _contentModel.clsInfo.price.floatValue];
    priceString =[Utils getSNSRMBMoney:priceString];
    
    if ([priceString isEqualToString:salePriceString]) {
        priceString = @"";
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", salePriceString, priceString]];
    [attributeString addAttributes:@{NSStrikethroughColorAttributeName: COLOR_C6,
                                     NSForegroundColorAttributeName:  COLOR_C6,
                                     NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                     NSFontAttributeName: [UIFont systemFontOfSize:11]
                                     }range:NSMakeRange(salePriceString.length + 1, priceString.length)];
    self.showGoodsPirceLabel.attributedText = attributeString;
}



- (void)selectedSizeForId{
    _contentModel.isEdit = NO;
    _buyCountActionView.isEdit = NO;
    MBGoodsDetailsColorModel *selectedColorModel = _showColorArray[_contentModel.colorSelectedIndex];
    for (MBAddShoppingProductInfoModel *stock in selectedColorModel.stockList) {
        if (stock.speC_ID.intValue == selectedColorModel.selectedSizeId) {
            _contentModel.stockModel = stock;
            
            self.showGoodsStockLabel.text = [NSString stringWithFormat:@"库存%@", stock.lisT_QTY];
            NSString *salePrice = [NSString stringWithFormat:@"%.2f", stock.salE_PRICE.floatValue];
            NSString *salePriceString=[NSString stringWithFormat:@"%@",[Utils getSNSRMBMoney:salePrice]];
            
            [self setCurrentPriceForScalePirce:salePriceString];
            _buyCountActionView.stockCount = stock.lisT_QTY.intValue;
            _contentModel.isEdit = YES;
            _buyCountActionView.isEdit = YES;
            _buyCountActionView.number = 1;
            _contentModel.isSelectedCurrent = YES;
            self.showSelectedStateButton.selected = YES;
            if ([self.delegate respondsToSelector:@selector(shoppingContentTableCellSelectedModul:Button:)]) {
                [self.delegate shoppingContentTableCellSelectedModul:nil Button:self.showSelectedStateButton];
            }
        }
    }
}



//商品是否已售罄
-(void)isHasbeensoldout{
    _showStateLabel.hidden = YES;
    _showStateLabel.backgroundColor = COLOR_C11;
    _showSizeCollectionView.hidden = NO;
    if (![_chooseColorStr isEqualToString:@""]) {
        NSInteger lisT_QTYCount = 0;
        for (MBAddShoppingProductInfoModel *obj in _showProductArray) {
            if ([_chooseColorStr isEqualToString: [NSString stringWithFormat:@"%@",obj.coloR_ID]]) {
                lisT_QTYCount += obj.lisT_QTY.integerValue;
            }
        }
        
        //显示已售罄
        if (lisT_QTYCount == 0) {
            _showStateLabel.hidden = NO;
            _showSizeCollectionView.hidden = YES;
        }
    }
}

#pragma mark 设置选择颜色和尺寸的代理
#pragma mark MBAddShoppingColorViewDelegate
- (void)colorViewContentCollection:(UICollectionView *)collection didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_contentModel.colorSelectedIndex == indexPath.row) return;
    [self selectedColorForIndex:(int)indexPath.row];
}

#pragma mark MBAddShoppingSizeViewDelegate
- (void)sizeViewContentCollection:(UICollectionView *)collection didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBGoodsDetailsColorModel *selectedColorModel = nil;
    if (_contentModel.colorSelectedIndex >= 0) {
        selectedColorModel = _showColorArray[_contentModel.colorSelectedIndex];
    }
    if (!selectedColorModel) return;
    MBGoodsDetailesSpecModel *sizeModel = _showSizeArray[indexPath.row];
    //新的
    if (_contentModel.sizeSelectedId == sizeModel.code.intValue) return;
    _contentModel.sizeSelectedId = sizeModel.code.intValue;
    selectedColorModel.selectedSizeId = sizeModel.code.intValue;
    _contentModel.isUserOpration = YES;
    [self selectedSizeForId];
}

#pragma mark 弃用 颜色置灰用MBAddShoppingColorViewDelegate
- (void)QYcolorViewContentCollectionCell:(MBAddShoppingColorCell *)cell
                didSelectItemAtIndexPath:(NSInteger)index{
    _currentColorIndex = index;
    NSMutableArray *tempArray = [self QYreloadSizeWithText:cell.coloR_ID];
    _showSizeCollectionView.tempSizeArray = tempArray;
    _chooseColorStr = cell.coloR_ID;
    [self updateSelectProduct];
    [self updateData];
}

#pragma mark MBAddShoppingSizeViewDelegate
- (void)QYsizeViewContentCollectionCell:(MBAddShoppingSizeCell*)cell
               didSelectItemAtIndexPath:(NSInteger)index{
    _currentSizeIndex = index;
    _showColorCollectionView.tempColorArray = [self QYreloadColorWithText:cell.showSizeLabel.text];
    _chooseSizeStr = cell.showSizeLabel.text;
    [self updateSelectProduct];
    [self updateData];
}


#pragma mark 根据颜色获取可用尺寸数组
- (NSMutableArray *)QYreloadSizeWithText:(NSString *)text
{
    NSMutableArray *canUseColorArray = [@[] mutableCopy];    // 尺码大小数组
    [_showProductArray enumerateObjectsUsingBlock:^(MBAddShoppingProductInfoModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.coloR_ID isEqual:text]&&![obj.lisT_QTY isEqualToNumber:@0]&&[obj.status isEqualToNumber:@2]) {
            [canUseColorArray addObject:obj.speC_NAME];
            
            NSDictionary *colorDic=@{@"speC_NAME":obj.speC_NAME,
                                     @"isSizeSelected":obj.isSizeSelected};
            [canUseColorArray addObject:colorDic];
        }
    }];
    
    return canUseColorArray;
}


#pragma mark 根据尺寸获取可用颜色数组
- (NSMutableArray *)QYreloadColorWithText:(NSString *)text
{
    NSMutableArray *canUseSizeArray = [@[] mutableCopy];    // 颜色数组
    [_showProductArray enumerateObjectsUsingBlock:^(MBAddShoppingProductInfoModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.speC_NAME isEqualToString:text]&&![obj.lisT_QTY isEqualToNumber:@0]&&[obj.status isEqualToNumber:@2]) {
            
            NSDictionary *colorDic=@{@"coloR_FILE_PATH":obj.coloR_FILE_PATH,
                                     @"coloR_ID":obj.coloR_ID,
                                     @"isColorSelected":obj.isColorSelected};
            [canUseSizeArray addObject:colorDic];
        }
    }];
    return canUseSizeArray;
}

//更新选择的商品
-(void)updateSelectProduct{
    for (MBAddShoppingProductInfoModel *obj in _showProductArray) {
        if ([obj.coloR_ID isEqual:_chooseColorStr]&&[obj.speC_NAME isEqualToString:_chooseSizeStr]) {
            [obj setValue:[NSNumber numberWithBool:YES] forKey:@"isSelectProduct"];
        }else{
            [obj setValue:[NSNumber numberWithBool:NO] forKey:@"isSelectProduct"];
        }
        
        if ([obj.coloR_ID isEqual:_chooseColorStr]) {
            [obj setValue:[NSNumber numberWithBool:YES] forKey:@"isColorSelected"];
        }else{
            [obj setValue:[NSNumber numberWithBool:NO] forKey:@"isColorSelected"];
        }
        
        if ([obj.speC_NAME isEqualToString:_chooseSizeStr]) {
            [obj setValue:[NSNumber numberWithBool:YES] forKey:@"isSizeSelected"];
        }else{
            [obj setValue:[NSNumber numberWithBool:NO] forKey:@"isSizeSelected"];
        }
    }
    //向CollectionView中初始化颜色及尺寸数据
    //self.showColorCollectionView.contentModelArray = [[self getColorArrWithArr:_showProductArray] mutableCopy];
    //self.showSizeCollectionView.contentModelArray = [[self getSizeArrWithArr:_showProductArray] mutableCopy];
}
@end
