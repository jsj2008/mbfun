//
//  MBAddGoodsInTrollyViewController.m
//  Wefafa
//
//  Created by mac on 14-8-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
//废弃不用   加入购物车 
#import "MBAddGoodsInTrollyViewController.h"
#import "Utils.h"
#import "AppSetting.h"
#import "MBShoppingGuideInterface.h"
#import "Toast.h"
#import "CommMBBusiness.h"

@interface MBAddGoodsInTrollyViewController ()

@end

@implementation MBAddGoodsInTrollyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewHead.backgroundColor=TITLE_BG;
    SCROLLHEIGHT=_scrollView.frame.size.height;
    
    switch (_showViewType) {
        case ATTEND_CLICK_SHOW_VIEW_PUSH:
            
            break;
        case ATTEND_CLICK_SHOW_VIEW_MODAL:
            _viewHead.hidden=YES;
            self.view.backgroundColor=[UIColor clearColor];
            self.viewCenter.backgroundColor=[UIColor clearColor];
            break;
    }
    
    _lbGoodsName.textColor=[Utils HexColor:0x3333333 Alpha:1.0];
    _lbGoodsName.numberOfLines=1;
    _lbGoodsNo.textColor=[Utils HexColor:0x919191 Alpha:1.0];
    _lbStoreNum.textColor=[Utils HexColor:0x919191 Alpha:1.0];
    _lbSum.textColor=[Utils HexColor:0x333333 Alpha:1.0];
    _lbSumT.textColor=[Utils HexColor:0x333333 Alpha:1.0];
    _lbGoodsPrice.textColor=[Utils HexColor:0x333333 Alpha:1.0];
    _lbOriginSum.textColor=[UIColor lightGrayColor];
    [_btnNext setTitle:_titleStr forState:UIControlStateNormal];

    _btnNext.layer.cornerRadius = 3.0f;
    _btnNext.layer.masksToBounds = YES;
    if ([_titleStr isEqualToString:@"加入购物车"])
    {
        [_btnNext setBackgroundColor:[Utils HexColor:0x333333 Alpha:1.0]];
        [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if ([_titleStr isEqualToString:@"立即购买"]){
        [_btnNext setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1.0]];
        [_btnNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        [_btnNext setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1.0]];
        [_btnNext setTitleColor:[Utils HexColor:0x333333 Alpha:1.0] forState:UIControlStateNormal];
    }
    

    
    //查询商品
    productInfoList=[[NSMutableArray alloc] initWithCapacity:10];
    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//    goodsStockList=[[NSMutableArray alloc] initWithCapacity:10];
    [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSMutableArray *prodlist=[[NSMutableArray alloc] initWithCapacity:10];
        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"ProductFilter" param:@{@"lm_prod_cls_id":_goodsInfo[@"detailInfo"][@"productClsId"],@"pageIndex":@"1",@"pageSize":@"10000"} responseList:prodlist responseMsg:msg];
        //输出列表status参数值：
        //Edit = 1,"录入中"
        //Listing = 2,"上架"
        //Delete = 3，"删除"
//        for (NSDictionary *dictProd in prodlist) {
//            if ([dictProd[@"productInfo"][@"status"] intValue]==2)
//            {
//                [productInfoList addObject:dictProd];
//            }
//        }
        if(success)
        {
            
        }
        [productInfoList addObjectsFromArray:[self getProductInfo:prodlist prodclsid:_goodsInfo[@"detailInfo"][@"productClsId"]]];

//        int stockcount=[self getClsStockNum:productInfoList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            //显示界面
            [self showView];
        });
        
        
//        //获取商品各个款式库存
//        NSMutableArray *stocklist=[[NSMutableArray alloc] initWithCapacity:4];
//        NSMutableString *stockmsg=[[NSMutableString alloc] initWithFormat:@""];
//        BOOL success1=[SHOPPING_GUIDE_ITF requestGetUrlName:@"StockFilter" param:@{@"proD_CLS_ID":_goodsInfo[@"detailInfo"][@"productClsId"]} responseList:stocklist responseMsg:stockmsg];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (success1)
//            {
//                int stockcount=0;
//                for(NSDictionary *dict in stocklist)
//                {
//                    NSMutableDictionary *tDict=[[NSMutableDictionary alloc] initWithDictionary:dict copyItems:YES];
//                    if ([tDict[@"count"] intValue]<0)
//                    {
//                        [tDict setObject:@(0) forKey:@"count"];
//                    }
//                    [goodsStockList addObject:tDict];
//                    stockcount+=[tDict[@"count"] intValue];
//                }
//                
//                _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stockcount];
//                _numberStepper.maxValue=stockcount>20?20:stockcount;
//                _lbStoreNum.tag=stockcount;
//            }
//        });

    });
    
    [self setupForDismissKeyboard];
}

-(NSMutableArray *)getProductInfo:(NSArray *)prodArr prodclsid:(NSString *)prodclsid
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (NSDictionary *dictProd in prodArr)
    {
        //输出列表status参数值：
        //Edit = 1,"录入中"
        //Listing = 2,"上架"
        //Delete = 3，"删除"
        if ([dictProd[@"productInfo"][@"lM_PROD_CLS_ID"] intValue]==[prodclsid intValue])
        {
            //20150107
            if (dictProd[@"productInfo"][@"coloR_FILE_PATH"]==nil)
            {
                continue;
            }
            else if ([dictProd[@"productInfo"][@"status"] intValue]==2)
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:dictProd copyItems:YES];
                [arr addObject:dict];
            }
            else
            {
                NSMutableDictionary *d2=[[NSMutableDictionary alloc] initWithDictionary:dictProd[@"productInfo"] copyItems:YES];;
                d2[@"lisT_QTY"]=[[NSNumber alloc] initWithInt:0];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:dictProd copyItems:YES];
                dict[@"productInfo"]=d2;
                [arr addObject:dict];
            }
        }
    }
    return arr;
}

-(int)getClsStockNum:(NSArray *)goodsarr
{
    int stockcount=0;
    for(NSDictionary *dict in goodsarr)
    {
        if ([dict[@"productInfo"][@"lisT_QTY"] intValue]<0)
        {
            continue;
        }
        stockcount+=[dict[@"productInfo"][@"lisT_QTY"] intValue];
    }
    return stockcount;
}

-(int)getGoodsStock:(NSArray*)stocklist prodid:(int)prodid
{
    int rst=0;
    for (NSDictionary *dict in stocklist)
    {
        if ([dict[@"productInfo"][@"id"] intValue] == prodid)
        {
            rst=[dict[@"productInfo"][@"lisT_QTY"] intValue];
        }
    }
    return rst;
}


//clickedtype 0：点颜色, 1：点尺码 (colorid.length>0 && sizeid.length>0有效)
-(void)refreshProductViewWithColorId:(NSString *)colorid sizeid:(NSString *)sizeid returnStock:(int*)returnStock// clickedtype:(int)clickedtype
{
    NSArray *list=productInfoList;
    int stocknum=0;
    NSMutableArray *colorenablelist=[[NSMutableArray alloc] init];
    NSMutableArray *sizeenablelist=[[NSMutableArray alloc] init];
    float product_price1=-1;
    if (colorid.length==0 && sizeid.length==0)
    {
        stocknum=[self getClsStockNum:productInfoList];
    }
    else if (colorid.length>0 && sizeid.length==0)
    {
        for (int i=0;i<_sizeListView.dataArray.count;i++)
        {
            [sizeenablelist addObject:@"0"];
        }
        for (int i=0;i<list.count;i++)
        {
            if ([[list[i][@"productInfo"][@"coloR_ID"] stringValue] isEqualToString:colorid])
            {
                float curr_price=[list[i][@"productInfo"][@"salE_PRICE"] floatValue];
                if (product_price1==-1)
                    product_price1=curr_price;
                product_price1=curr_price>product_price1?product_price1:curr_price;
                
                int s1=[self getGoodsStock:productInfoList prodid:[list[i][@"productInfo"][@"id"] intValue]];
                stocknum+=s1;
                //选的颜色时：颜色都显示，尺码虚化
                int idx=[_sizeListView getCellIndex:list[i][@"productInfo"][@"speC_NAME"]];
                if (idx>=0)
                {
                    if (s1>0)
                        [sizeenablelist replaceObjectAtIndex:idx withObject:@"1"];
                    else
                        [sizeenablelist replaceObjectAtIndex:idx withObject:@"0"];
                }
            }
        }
    }
    else if (colorid.length==0 && sizeid.length>0)
    {
        for (int i=0;i<_colorListView.dataArray.count;i++)
        {
            [colorenablelist addObject:@"0"];
        }
        for (int i=0;i<list.count;i++)
        {
            if ([[list[i][@"productInfo"][@"speC_ID"] stringValue] isEqualToString:sizeid])
            {
                float curr_price=[list[i][@"productInfo"][@"salE_PRICE"] floatValue];
                if (product_price1==-1)
                    product_price1=curr_price;
                product_price1=curr_price>product_price1?product_price1:curr_price;
                
                int s1=[self getGoodsStock:productInfoList prodid:[list[i][@"productInfo"][@"id"] intValue]];
                stocknum+=s1;
                //选的尺码时：尺码都显示，颜色虚化[@"productInfo"][@"coloR_NAME"]
                int idx=-1;
                //20150107
//                if (list[i][@"productInfo"][@"coloR_FILE_PATH"]!=nil)
//                {
//                    idx=[_colorListView getCellIndex:[CommMBBusiness changeStringWithurlString:list[i][@"productInfo"][@"coloR_FILE_PATH"] size:SNS_IMAGE_ORIGINAL] ];
//                }
//                else
                if (_colorListView.keyArray.count>0)
                {
                    for (int jj=0;jj<_colorListView.keyArray.count;jj++)
                    {
                        if ([_colorListView.keyArray[jj] intValue]==[list[i][@"productInfo"][@"coloR_ID"] intValue])
                        {
                            idx=jj;
                        }
                    }
                }
                if (idx>=0)
                {
                    if (s1>0)
                        [colorenablelist replaceObjectAtIndex:idx withObject:@"1"];
                    else
                        [colorenablelist replaceObjectAtIndex:idx withObject:@"0"];
                }
            }
        }
        
    }
    if (colorid.length>0 && sizeid.length>0)
    {
        for (int i=0;i<_sizeListView.dataArray.count;i++)
        {
            [sizeenablelist addObject:@"0"];
        }
        for (int i=0;i<list.count;i++)
        {
            if ([[list[i][@"productInfo"][@"coloR_ID"] stringValue] isEqualToString:colorid])
            {
                int s1=[self getGoodsStock:productInfoList prodid:[list[i][@"productInfo"][@"id"] intValue]];
                //选的颜色时：颜色都显示，尺码虚化
                int idx=[_sizeListView getCellIndex:list[i][@"productInfo"][@"speC_NAME"]];
                if (idx>=0)
                {
                    if (s1>0)
                        [sizeenablelist replaceObjectAtIndex:idx withObject:@"1"];
                    else
                        [sizeenablelist replaceObjectAtIndex:idx withObject:@"0"];
                }
            }
        }
        
        for (int i=0;i<_colorListView.dataArray.count;i++)
        {
            [colorenablelist addObject:@"0"];
        }
        for (int i=0;i<list.count;i++)
        {
            if ([[list[i][@"productInfo"][@"speC_ID"] stringValue] isEqualToString:sizeid])
            {
                int s1=[self getGoodsStock:productInfoList prodid:[list[i][@"productInfo"][@"id"] intValue]];
                //选的尺码时：尺码都显示，颜色虚化[@"productInfo"][@"coloR_NAME"]
                int idx=-1;
                //20150107
//                if (list[i][@"productInfo"][@"coloR_FILE_PATH"]!=nil)
//                {
//                    idx=[_colorListView getCellIndex:[CommMBBusiness changeStringWithurlString:list[i][@"productInfo"][@"coloR_FILE_PATH"] size:SNS_IMAGE_ORIGINAL] ];
//                }
//                else
                if (_colorListView.keyArray.count>0)
                {
                    for (int jj=0;jj<_colorListView.keyArray.count;jj++)
                    {
                        if ([_colorListView.keyArray[jj] intValue]==[list[i][@"productInfo"][@"coloR_ID"] intValue])
                        {
                            idx=jj;
                        }
                    }
                }
                if (idx>=0)
                {
                    if (s1>0)
                        [colorenablelist replaceObjectAtIndex:idx withObject:@"1"];
                    else
                        [colorenablelist replaceObjectAtIndex:idx withObject:@"0"];
                }
            }
        }
        
        //计算库存
        for (int i=0;i<list.count;i++)
        {
            if ([[list[i][@"productInfo"][@"speC_ID"] stringValue] isEqualToString:sizeid] && [[list[i][@"productInfo"][@"coloR_ID"] stringValue] isEqualToString:colorid])
            {
                float curr_price=[list[i][@"productInfo"][@"salE_PRICE"] floatValue];
                if (product_price1==-1)
                    product_price1=curr_price;
                product_price1=curr_price>product_price1?product_price1:curr_price;
                
                int s1=[self getGoodsStock:productInfoList prodid:[list[i][@"productInfo"][@"id"] intValue]];
                stocknum+=s1;
                break;
            }
        }
        
    }
    
    _colorListView.enableArray=colorenablelist;
    _sizeListView.enableArray=sizeenablelist;
    
    _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
    _numberStepper.maxValue=stocknum>20?20:stocknum;
    _numberStepper.text=@"1";
    
    product_price=product_price1==-1?product_price:product_price1;
    _lbGoodsPrice.textColor=[Utils HexColor:0x333333 Alpha:1];
    
    _lbGoodsPrice.text=[NSString stringWithFormat:@"￥%0.2f",product_price];
    _lbSum.text=[NSString stringWithFormat:@"￥%0.2f",product_price*[_numberStepper.text intValue]];

    *returnStock=stocknum;
}

-(NSDictionary *)getProductWithColorId:(NSString *)colorId specId:(NSString *)specId
{
    return [self getProduct:productInfoList colorId:colorId specId:specId];
}

-(NSDictionary *)getProduct:(NSArray *)list colorId:(NSString *)colorId specId:(NSString *)specId
{
    if (colorId.length>0 && specId.length>0)
    {
        for (int i=0;i<list.count;i++)
        {
            if ([[list[i][@"productInfo"][@"speC_ID"] stringValue] isEqualToString:specId] && [[list[i][@"productInfo"][@"coloR_ID"] stringValue] isEqualToString:colorId])
            {
                return list[i];
            }
        }
    }
    return nil;
}

-(NSString *)getProductId:(NSArray *)list colorId:(NSString *)colorId specId:(NSString *)specId imageUrl:(NSMutableString *)imageUrl
{
//    _numberStepper.text=@"1";
//    _numberStepper.maxValue=0;
//    _lbStoreNum.text=@"库存:0";
//    _lbStoreNum.tag=0;
    product_price=[_goodsInfo[@"proudctList"][@"clsInfo"][@"sale_price"] floatValue];
    _lbGoodsPrice.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:_goodsInfo[@"proudctList"][@"clsInfo"][@"sale_price"]]];
    _lbSum.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:_goodsInfo[@"proudctList"][@"clsInfo"][@"sale_price"]]];
    _lbOriginSum.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:_goodsInfo[@"detailInfo"][@"productPrice"]]];
    
    NSString *rst=@"";
    if (colorId.length>0 && specId.length>0)
    {
        BOOL existProduct=NO;
//        _lbStoreNum.text=@"刷新库存...";
        for (int i=0;i<list.count;i++)
        {
            if ([[list[i][@"productInfo"][@"speC_ID"] stringValue] isEqualToString:specId] && [[list[i][@"productInfo"][@"coloR_ID"] stringValue] isEqualToString:colorId])
            {
                existProduct=YES;
                rst=[list[i][@"productInfo"][@"id"] stringValue];
                if (list[i][@"productInfo"][@"coloR_FILE_PATH"]!=nil)
                {
                    [imageUrl setString:list[i][@"productInfo"][@"coloR_FILE_PATH"] ];
                }
                
                product_price=[list[i][@"productInfo"][@"salE_PRICE"] floatValue];
                _lbGoodsPrice.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:list[i][@"productInfo"][@"salE_PRICE"]]];
                _lbSum.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:list[i][@"productInfo"][@"salE_PRICE"]]];
                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    NSMutableArray *stocklist=[[NSMutableArray alloc] initWithCapacity:4];
//                    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//                    
//                    BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"StockFilter" param:@{@"PROD_ID":rst} responseList:stocklist responseMsg:msg];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (success &&stocklist!=nil &&stocklist.count>0 && [stocklist[0][@"count"] intValue]>0)
//                        {
//                            int stocknum=[stocklist[0][@"count"] intValue];
//                            _numberStepper.maxValue=stocknum>20?20:stocknum;
//                            _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
//                            _lbStoreNum.tag=stocknum;
//                        }
//                        else
//                        {
//                            _numberStepper.maxValue=0;
//                            _lbStoreNum.text=@"库存:0";
//                            _lbStoreNum.tag=0;
//                            [Toast makeToast:@"商品库存为不足，请选择购买！" duration:2 position:@"center"];
//                        }
//                    });
//                });
                break;
            }
        }
//        if (existProduct==NO)
//        {
//            _numberStepper.maxValue=0;
//            _lbStoreNum.text=@"库存:0";
//            _lbStoreNum.tag=0;
//            [Toast makeToast:@"商品库存为不足，请选择购买！" duration:2 position:@"center"];
//        }
    }
    return rst;
}

-(void)showView
{
    if (_goodsInfo!=nil && _goodsInfo[@"detailInfo"]!=nil)
        _lbGoodsName.text=_goodsInfo[@"detailInfo"][@"productName"];
    
    NSString *imageurl=nil;
    if (_goodsInfo!=nil && _goodsInfo[@"proudctList"]!=nil)
    {
        if (_goodsInfo[@"proudctList"][@"clsInfo"]!=nil)
        {
            _lbGoodsPrice.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:_goodsInfo[@"proudctList"][@"clsInfo"][@"sale_price"]]];//c1
            product_price=[[Utils getSNSMoney:_goodsInfo[@"proudctList"][@"clsInfo"][@"sale_price"]] floatValue];
        }
        if (_goodsInfo[@"proudctList"][@"clsPicUrl"]!=nil)
        {
            NSArray *picArr=_goodsInfo[@"proudctList"][@"clsPicUrl"];
            if (picArr.count>0)
            {
                imageurl=[Utils getSNSString:picArr[0][@"filE_PATH"]];//smalL_FILE_PATH
            }
        }
        NSMutableArray *colorList = [[NSMutableArray alloc] initWithCapacity:10];
//        if (_goodsInfo[@"proudctList"][@"colorList"]!=nil)
//        {
//            NSArray *colorarr=_goodsInfo[@"proudctList"][@"colorList"];
//            for(int i=0;i<[colorarr count];i++)
//            {
//                [colorList addObject: colorarr[i][@"name"] ];
//            }
//        }
        NSMutableArray *colorKeyArr = [[NSMutableArray alloc] initWithCapacity:10];
        
        if (_goodsInfo[@"proudctList"][@"colorList"]!=nil)
        {
            NSArray *colorarr=_goodsInfo[@"proudctList"][@"colorList"];
            for(int i=0;i<[colorarr count];i++)
            {
                NSString *colorid=[colorarr[i][@"id"] stringValue];
                BOOL find=NO;
                for (NSDictionary *dict in productInfoList)
                {
                    if ([colorid isEqualToString:[dict[@"productInfo"][@"coloR_ID"] stringValue]])
                    {
                        //20150107
                        if (dict[@"productInfo"][@"coloR_FILE_PATH"]!=nil)
                        {
                            [colorList addObject:[CommMBBusiness changeStringWithurlString:dict[@"productInfo"][@"coloR_FILE_PATH"] size:SNS_IMAGE_ORIGINAL] ];
                            [colorKeyArr addObject:colorid];
                        }
//                        else
//                        {
//                            [colorList addObject:@""];
//                        }
//                        find=YES;
//                        [colorKeyArr addObject:colorid];
                        break;
                    }
                }
                
                if (find==NO)
                {
//                    [colorList addObject:@""];
//                    [colorKeyArr addObject:colorid];
//                    NSLog(@"colorid=%@",colorid);
                }
            }
        }

        
        
        UIColor *selectedcolor=[Utils HexColor:0x333333 Alpha:1.0];
        _colorListView.cellType=EALIST_CELL_TYPE_IMAGE;
        _colorListView.listStyle=EALIST_STYLE_BUTTON_CHECKBUTTON;
        _colorListView.dataArray=colorList;
        _colorListView.keyArray=colorKeyArr;
        _colorListView.margin=10;
        _colorListView.textFont=[UIFont boldSystemFontOfSize:11];
        [_colorListView setDelegate:self selector:@selector(_colorListView_onButtonClick:button:)];
        //        _colorListView.contentVerticalAlignment=EALIST_VERTICAL_ALIGNMENT_CENTER;
        _colorListView.cellSize=CGSizeMake(39, 39);
        _colorListView.textFont=[UIFont boldSystemFontOfSize:11];
        [_colorListView setButtonActiveBorderColor:selectedcolor activeTextColor:selectedcolor];
        [_colorListView setButtonBorderColor:[Utils HexColor:0xe2e2e2 Alpha:1.0] textColor:selectedcolor];
        
        [_colorListView reloadData];
        _colorListView.frame=CGRectMake(_colorListView.frame.origin.x, _colorListView.frame.origin.y, _colorListView.frame.size.width, [_colorListView getListViewHeight]);
        if (colorList.count>0)
        {
            _colorListView.hidden=NO;
        }
        else
        {
            _colorListView.hidden=YES;
        }

//        UIColor *selectedcolor=[Utils HexColor:0x353535 Alpha:1.0];
//        _colorListView.listStyle=EALIST_STYLE_BUTTON_RADIOBUTTON;
//        _colorListView.dataArray=colorList;
//        _colorListView.margin=10;
//        [_colorListView setDelegate:self selector:@selector(_colorListView_onButtonClick:button:)];
////        _colorListView.contentVerticalAlignment=EALIST_VERTICAL_ALIGNMENT_CENTER;
//        _colorListView.cellSize=CGSizeMake(80, 27);
//        _colorListView.textFont=[UIFont boldSystemFontOfSize:11];
//        [_colorListView setButtonActiveBorderColor:selectedcolor activeTextColor:selectedcolor];
//        [_colorListView setButtonBorderColor:[Utils HexColor:0xacacac Alpha:1.0] textColor:selectedcolor];
//        [_colorListView reloadData];
//        _colorListView.frame=CGRectMake(_colorListView.frame.origin.x, _colorListView.frame.origin.y, _colorListView.frame.size.width, [_colorListView getListViewHeight]);
//        if (colorList.count>0)
//        {
//            _colorListView.hidden=NO;
//        }
//        else
//        {
//            _colorListView.hidden=YES;
//        }
        
        NSMutableArray *sizeList=[[NSMutableArray alloc] initWithCapacity:5];
        if (_goodsInfo[@"proudctList"][@"specList"]!=nil)
        {
            NSArray *sizearr=_goodsInfo[@"proudctList"][@"specList"];
            for(int i=0;i<[sizearr count];i++)
            {
                [sizeList addObject: sizearr[i][@"name"] ];
            }
        }
        _sizeListView.listStyle=EALIST_STYLE_BUTTON_CHECKBUTTON;
        _sizeListView.dataArray=sizeList;
        _sizeListView.margin=10;
        [_sizeListView setDelegate:self selector:@selector(_sizeListView_onButtonClick:button:)];
//        _sizeListView.contentVerticalAlignment=EALIST_VERTICAL_ALIGNMENT_CENTER;
//        _sizeListView.cellSize=CGSizeMake(80, 27);
                _sizeListView.cellSize=CGSizeMake(88, 25);
        _sizeListView.textFont=[UIFont boldSystemFontOfSize:12];
        [_sizeListView setButtonActiveBorderColor:selectedcolor activeTextColor:selectedcolor];
        [_sizeListView setButtonBorderColor:[Utils HexColor:0xe2e2e2 Alpha:1.0] textColor:selectedcolor];
        [_sizeListView reloadData];
        _sizeListView.frame=CGRectMake(_sizeListView.frame.origin.x, _sizeListView.frame.origin.y, _sizeListView.frame.size.width, [_sizeListView getListViewHeight]);
        if (sizeList.count>0)
        {
            _sizeListView.hidden=NO;
        }
        else
        {
            _sizeListView.hidden=YES;
        }
        
        UIView *view1=[_scrollView viewWithTag:1001];
        view1.frame=CGRectMake(0, _sizeListView.frame.origin.y+_sizeListView.frame.size.height+3, view1.frame.size.width, view1.frame.size.height);
        UIView *view2=[_scrollView viewWithTag:1002];
        view2.frame=CGRectMake(0, _colorListView.frame.origin.y+_colorListView.frame.size.height+3, view2.frame.size.width, view2.frame.size.height);
        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, view1.frame.origin.y+view2.frame.origin.y+view2.frame.size.height);
        
        _lbGoodsNo.text=[NSString stringWithFormat:@"款号:%@",[Utils getSNSString:_goodsInfo[@"detailInfo"][@"productCode"]]];
        
//        int stockcount=0;
//        for (NSDictionary *dict in goodsStockList)
//        {
//            stockcount+=[dict[@"count"] intValue];
//        }
        int stockcount=[self getClsStockNum:productInfoList];
        _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stockcount];
        _lbStoreNum.tag=stockcount;
        _numberStepper.maxValue=stockcount>20?20:stockcount;

//        _lbStoreNum.text=[NSString stringWithFormat:@"库存:%@",[Utils getSNSInteger:_goodsInfo[@"proudctList"][@"clsInfo"][@"stockCount"]]];//@"0"];
//        _lbStoreNum.tag=0;
//        _numberStepper.maxValue=0;
        _lbSum.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:_goodsInfo[@"proudctList"][@"clsInfo"][@"sale_price"]]];
        _lbOriginSum.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:_goodsInfo[@"detailInfo"][@"productPrice"]]];
    }
    
    [self downloadImage:imageurl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)setupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    [self setFrameWithHeight:0];
}

-(void)downloadImage:(NSString *)url
{
    NSString *defaultImg=DEFAULT_LOADING_IMAGE;//@"defaultDownload.png"
    _imageGoods.contentMode = UIViewContentModeScaleAspectFit;
    _imageGoods.backgroundColor=[UIColor whiteColor];
    _imageGoods.delegate=self;
    [_imageGoods downloadImageUrl:[CommMBBusiness changeStringWithurlString:url size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
}
-(void)completeDownloadImage:(id)sender imageLocalPath:(NSString *)imageLocalPath
{
    //    UIImage *img=[UIImage imageNamed:imageLocalPath];
    //    img.size.height
}

- (IBAction)btnBackClick:(id)sender {
    [self btnCloseClick:nil];
}

- (IBAction)btnCloseClick:(id)sender {
    switch (_showViewType) {
        case ATTEND_CLICK_SHOW_VIEW_PUSH:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case ATTEND_CLICK_SHOW_VIEW_MODAL:
            if (parentView!=nil && [parentView respondsToSelector:returnParentViewAction])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [parentView performSelector:returnParentViewAction withObject:self];
#pragma clang diagnostic pop
            }
    }
}

- (IBAction)btnNextClick:(id)sender {
    if (_colorid.length==0)
    {
        [Utils alertMessage:@"请选择购买商品的颜色!"];
        return;
    }
    else if (_sizeid.length==0)
    {
        [Utils alertMessage:@"请选择购买商品的尺寸!"];
        return;
    }
    else if (_productid.length==0)
    {
        [Utils alertMessage:@"您选择的商品已售完!"];
        return;
    }
    
    if (_lbStoreNum.tag==0||[_numberStepper.text intValue] > _lbStoreNum.tag)
    {
        [Utils alertMessage:@"商品的库存不足!"];
        return;
    }
    
    if ([_numberStepper.text intValue]>20)
    {
        [Utils alertMessage:@"最多购买20件商品!"];
        return;
    }
    
//    [Toast makeToastActivity:@"核对商品数量..." hasMusk:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSDictionary *colldict = _goodsInfo;
//        //获取商品各个款式库存
//        NSMutableArray *stocklist=[[NSMutableArray alloc] initWithCapacity:4];
//        NSMutableString *stockmsg=[[NSMutableString alloc] initWithFormat:@""];
//        BOOL success1=[SHOPPING_GUIDE_ITF requestGetUrlName:@"StockFilter" param:@{@"proD_CLS_ID":colldict[@"detailInfo"][@"productClsId"]} responseList:stocklist responseMsg:stockmsg];
//        
//        if (success1)
//        {
//            [goodsStockList removeAllObjects];
//            for(NSDictionary *dict in stocklist)
//            {
//                NSMutableDictionary *tDict=[[NSMutableDictionary alloc] initWithDictionary:dict copyItems:YES];
//                if ([tDict[@"count"] intValue]<0)
//                {
//                    [tDict setObject:@(0) forKey:@"count"];
//                }
//                [goodsStockList addObject:tDict];
//            }
//        }
//        
//        //获取商品状态
//        NSMutableArray *prodlist=[[NSMutableArray alloc] initWithCapacity:10];
//        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"ProductFilter" param:@{@"lm_prod_cls_id": colldict[@"detailInfo"][@"productClsId"]} responseList:prodlist responseMsg:msg];
//        if (success)
//        {
//            NSMutableArray *arr1=[[NSMutableArray alloc] init];
//            for (NSDictionary *dictProd in prodlist)
//            {
//                if ([dictProd[@"productInfo"][@"status"] intValue]==2)
//                {
//                    [arr1 addObject:dictProd];
//                }
//            }
//            productInfoList=arr1;
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [Toast hideToastActivity];
//            int row=0;
//            [self checkSelectedGoods:&row];
//        });
//    });

    //检查最新库存
//    __block int stocknum=0;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableArray *stocklist=[[NSMutableArray alloc] initWithCapacity:4];
//        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//        
//        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"StockFilter" param:@{@"PROD_ID":_productid} responseList:stocklist responseMsg:msg];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (success &&stocklist!=nil &&stocklist.count>0 && [stocklist[0][@"count"] intValue]>0)
//            {
//                stocknum=[stocklist[0][@"count"] intValue];
//                _numberStepper.maxValue=stocknum>20?20:stocknum;
//                _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
//            }
//        });
//    });
    
    int row=0;
    [self checkSelectedGoods:&row];
}

-(BOOL)checkSelectedGoods:(int*)row
{
    //判断商品上架
    NSDictionary *dictProd=[self getProduct:productInfoList colorId:_colorid specId:_sizeid];
    if (dictProd==nil)
    {
        [Utils alertMessage:@"商品已下架了!"];
        return NO;
    }
    else if ([dictProd[@"productInfo"][@"status"] intValue]==1)
    {
        [Utils alertMessage:@"商品已下架!"];
        return NO;
    }
    else if ([dictProd[@"productInfo"][@"status"] intValue]==3)
    {
        [Utils alertMessage:@"商品已经下架!"];
        return NO;
    }
    
    //刷新库存
    int stocknum=[self getGoodsStock:productInfoList prodid:[_productid intValue]];
    if (_lbStoreNum.tag!=stocknum)
    {
        _lbStoreNum.tag=stocknum;
        _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
        _numberStepper.maxValue=stocknum>20?20:stocknum;
    }
    
    //判断库存
    if (stocknum<1||[_numberStepper.text intValue]>stocknum)
    {
        //_goodsArray[i][@"productName"]
        [Utils alertMessage:@"商品的库存不足!"];
        return NO;
    }
    
    //判断购买数量
   
    if ([_numberStepper.text intValue]>20)
    {
        [Utils alertMessage:@"最多购买20件商品!"];
        return NO;
    }
    
//    [self btnCloseClick:nil];
//    
//    return YES;
    //调用加入购物车
    switch (_showViewType)
    {
        case ATTEND_CLICK_SHOW_VIEW_PUSH:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case ATTEND_CLICK_SHOW_VIEW_MODAL:
            if (parentView!=nil && [parentView respondsToSelector:nextParentViewAction])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [parentView performSelector:nextParentViewAction withObject:self];
#pragma clang diagnostic pop
            }
    }
   
    return YES;
}
- (IBAction)textValueBeginChange:(id)sender
{
    [self setFrameWithHeight:216];
}
- (IBAction)textValueChanged:(id)sender {
//    NSString *price=[Utils getSNSMoney:_goodsInfo[@"proudctList"][@"clsInfo"][@"sale_price"]];
    
    float sum=((float)[_numberStepper.text intValue])*product_price;
    _lbSum.text=[NSString stringWithFormat:@"￥%0.2f",sum];
}

- (IBAction)textEditingDidEnd:(id)sender {
    int stocknum=(int)_lbStoreNum.tag;
    
    if (stocknum<1||[_numberStepper.text intValue]>stocknum)
    {
        [Toast makeToast:@"商品的库存不足!" duration:2 position:@"center"];
        return;
    }
    
    //判断购买数量

    if ([_numberStepper.text intValue]>20)
    {
        [Toast makeToast:@"最多购买20件商品!" duration:2 position:@"center"];
        return;
    }
    
//    [Toast makeToast:[NSString stringWithFormat:@"商品数量修改为%@!",_numberStepper.text] duration:2 position:@"center"];
    [Toast makeToastSuccess:[NSString stringWithFormat:@"商品数量修改为%@!",_numberStepper.text]];
}

- (void)setParentView:(id)pview returnAction:(SEL)returnAction nextAction:(SEL)nextAction
{
    parentView=pview;
    returnParentViewAction=returnAction;
    nextParentViewAction=nextAction;
}

-(void)_sizeListView_onButtonClick:(id)sender button:(id)button
{
    EACellListView *list=(EACellListView*)sender;
    if (list.activeIndex>=0)
        _sizeid=[_goodsInfo[@"proudctList"][@"specList"][list.activeIndex][@"id"] stringValue];
    else
        _sizeid=@"";
    
    NSMutableString *imgurl=[[NSMutableString alloc] init];
    _productid=[self getProductId:productInfoList colorId:_colorid specId:_sizeid imageUrl:imgurl];
    
    int stocknum=0;
    [self refreshProductViewWithColorId:_colorid sizeid:_sizeid returnStock:&stocknum];
    _lbStoreNum.tag=stocknum;
    _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
    _numberStepper.maxValue=stocknum>20?20:stocknum;

    if (imgurl.length>0)
        [_imageGoods downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgurl size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:nil];
    [self showTip];
}

-(void)_colorListView_onButtonClick:(id)sender button:(id)button
{
    EACellListView *list=(EACellListView*)sender;
    if (list.activeIndex>=0)
        //20150107
//        _colorid=[_goodsInfo[@"proudctList"][@"colorList"][list.activeIndex][@"id"] stringValue];
        _colorid=_colorListView.keyArray[list.activeIndex];
    else
        _colorid=@"";

    NSMutableString *imgurl=[[NSMutableString alloc] init];
    _productid=[self getProductId:productInfoList colorId:_colorid specId:_sizeid imageUrl:imgurl];
    
    int stocknum=0;
    [self refreshProductViewWithColorId:_colorid sizeid:_sizeid returnStock:&stocknum];
    _lbStoreNum.tag=stocknum;
    _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
    _numberStepper.maxValue=stocknum>20?20:stocknum;

    if (imgurl.length>0)
        [_imageGoods downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgurl size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:nil];
    [self showTip];
}

-(void)showTip
{
//    _lbTip.text=@"";
//    _btnNext.enabled=YES;
//    if (_colorid.length==0)
//    {
//        _btnNext.enabled=NO;
//        _lbTip.text=[NSString stringWithFormat:@"请选择产品颜色!"];
//    }
//    else if (_sizeid.length==0)
//    {
//        _btnNext.enabled=NO;
//        _lbTip.text=[NSString stringWithFormat:@"请选择产品尺寸!"];
//    }
//    else if (_productid.length==0)
//    {
//        _btnNext.enabled=NO;
//        _lbTip.text=[NSString stringWithFormat:@"该产品已售空!"];
//    }
}

- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self setFrameWithHeight:keyboardRect.size.height];
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self setFrameWithHeight:0];
}

- (void)setFrameWithHeight:(int)height {
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    
	_scrollView.frame = CGRectMake(_scrollView.frame.origin.x,_scrollView.frame.origin.y,_scrollView.frame.size.width, (float)(SCROLLHEIGHT+(height>0?49:0)-height));
    int y1=height-49;
    [_scrollView setContentOffset:CGPointMake(0, (float)(y1<=0?0:y1)) animated:YES];
    [UIView commitAnimations];
}

@end
