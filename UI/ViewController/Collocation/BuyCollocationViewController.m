//
//  BuyCollocationViewController.m
//  Wefafa
//
//  Created by mac on 14-11-8.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
//废弃  以前的类似淘宝购买弹出框
#import "BuyCollocationViewController.h"
#import "Utils.h"
#import "AppSetting.h"
#import "MBShoppingGuideInterface.h"
#import "Toast.h"

#import "MyShoppingTrollyViewController.h"
#import "MBCreateGoodsOrderViewController.h"
#import "CommMBBusiness.h"

@interface BuyCollocationViewController (){
    NSMutableArray *viewListArr;
}

@property (nonatomic, strong) NSMutableArray *contentImageArray;

@end

@implementation BuyCollocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        goodsInfoList=[[NSMutableArray alloc] init];
        goodsSelectedList=[[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentImageArray = [NSMutableArray array];

    if (isInit) return;
    isInit=YES;
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
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
    
    _lbGoodsName.textColor=[Utils HexColor:0x333333 Alpha:1.0];
    _lbGoodsName.numberOfLines=1;
    _lbGoodsCode.textColor=[Utils HexColor:0x919191 Alpha:1.0];
    _lbStoreNum.textColor=[Utils HexColor:0x919191 Alpha:1.0];
    _lbSum.textColor=[Utils HexColor:0x333333 Alpha:1.0];
    _lbSumT.textColor=[Utils HexColor:0x333333 Alpha:1.0];
    _lbPrice.textColor=[Utils HexColor:0x333333 Alpha:1.0];
    _lbOriginSum.textColor=[UIColor lightGrayColor];
    [_btnBuy setTitle:_titleStr forState:UIControlStateNormal];
    _btnBuy.layer.cornerRadius = 3;
    _btnBuy.layer.masksToBounds=YES;
    if ([_titleStr isEqualToString:@"加入购物车"])
    {
        [_btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnBuy setBackgroundColor:[Utils HexColor:0x333333 Alpha:1.0]];
    }

    else
    {
         [_btnBuy setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1.0]];
        [_btnBuy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    _showScrollView.backgroundColor=[UIColor whiteColor];
    _showScrollView.showsHorizontalScrollIndicator = NO;
    
    _imageLine1.backgroundColor=[Utils HexColor:0XE2E2E2 Alpha:1.0];
    /*
    //create imagelist
    _viewImageList.backgroundColor=[Utils HexColor:0xffffff Alpha:0.9];
    _viewImageList.imageBorderColor=[Utils HexColor:0xacacac Alpha:1.0];
    _viewImageList.imageSelectedBorderColor=[Utils HexColor:0x353535 Alpha:1.0];
    _viewImageList.imageBorderWidth=1;
    _viewImageList.imageSelectedBorderWidth=2;
    _viewImageList.cornerRadius=0.0;
    _viewImageList.selectIndex=0;
    _viewImageList.imageSize=CGSizeMake(39,39);
    _viewImageList.imageSelectedSize=CGSizeMake(50,50);
    _viewImageList.margin=10;
    [_viewImageList.onDidSelectedCell addListener:[CommonEventListener listenerWithTarget:self withSEL:@selector(ImageListView_cellDidSelected:eventData:)]];
    
    _viewImageList.dataArray=[[NSMutableArray alloc] init];
    
*/
    
    
    
//    NSMutableString *productClsIDs=[[NSMutableString alloc] init];
    viewListArr = [NSMutableArray arrayWithCapacity:0];
    for (int i=0;i<_goodsArray.count;i++)
    {
//        if (i!=0)
//            [productClsIDs appendString:@","];
//        [productClsIDs appendString:[Utils getSNSInteger:_goodsArray[i][@"detailInfo"][@"productClsId"]]];
        NSArray *picArr=_goodsArray[i][@"proudctList"][@"clsPicUrl"];
        EAImageListGridData *griddata=[[EAImageListGridData alloc] init];
        if (picArr.count>0)
        {
            // 图片大小改为100
            NSString *filePath=[Utils getSNSString:picArr[0][@"filE_PATH"]];
                                
            griddata.url=[CommMBBusiness changeStringWithurlString:filePath size:SNS_IMAGE_Size];
//            griddata.url=[Utils getSNSString:picArr[0][@"filE_PATH"]];
        }
        [viewListArr addObject:griddata];
        
        
//        //init selectedlist
//        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
//        dict[@"ProdID"]=@"";
//        dict[@"SpecID"]=@"";
//        dict[@"ColorID"]=@"";
//        dict[@"StockNum"]=@"0";
//        dict[@"Qty"]=[[NSString alloc] initWithFormat:@"%d",_numberStepper.minValue];
//        dict[@"Object"]=[[NSDictionary alloc] init];
//        dict[@"SizeEnableArray"]=[[NSMutableArray alloc] init];
//        dict[@"ColorEnableArray"]=[[NSMutableArray alloc] init];
//        
//        [goodsSelectedList addObject:dict];
//        
//        goodsInfoList[i]=[[NSMutableArray alloc] init];
    }
//    [_viewImageList reloadData];
    
    for (int i=0;i<_goodsArray.count;i++)
    {
        NSArray *picArr=_goodsArray[i][@"proudctList"][@"clsPicUrl"];
        EAImageListGridData *griddata=[[EAImageListGridData alloc] init];
        if (picArr.count>0)
        {
            // 图片大小改为100
            NSString *filePath=[Utils getSNSString:picArr[0][@"filE_PATH"]];
            
            griddata.url=[CommMBBusiness changeStringWithurlString:filePath size:SNS_IMAGE_Size];
            //            griddata.url=[Utils getSNSString:picArr[0][@"filE_PATH"]];
        }
//        [_viewImageList.dataArray addObject:griddata];
        
        UIUrlImageView *goodImgV=[[UIUrlImageView alloc]initWithFrame:CGRectMake((5 + 45)*i,5, 45, 45)];
        [goodImgV setImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        goodImgV.userInteractionEnabled=YES;
        goodImgV.layer.borderColor=[Utils HexColor:0xe2e2e2e2 Alpha:1.0].CGColor;
        goodImgV.layer.borderWidth=0.5;
        goodImgV.tag=i;
        [goodImgV downloadImageUrl: griddata.url cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_IMAGE];
        [_showScrollView addSubview:goodImgV];
        
        UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickGoodView:)];
        [goodImgV addGestureRecognizer:tapGest];
        [self.contentImageArray addObject:goodImgV];
        
    }
//    if (_goodsArray.count>=5) {
//        
//    }
    [_showScrollView setContentSize:CGSizeMake(55*_goodsArray.count, _showScrollView.frame.size.height)];
    [_viewImageList reloadData];
    
    
    
    
    [self showGoodsInfoView:0];
    
//    [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableArray *productInfoList=[[NSMutableArray alloc] initWithCapacity:10];
//        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//        
//        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"ProductFilter" param:@{@"prodClsIdList": productClsIDs,@"pageIndex":@"1",@"pageSize":@"10000"} responseList:productInfoList responseMsg:msg];
//        
//        if (success)
//        for (int i=0;i<_goodsArray.count;i++)
//        {
//            NSDictionary *colldict=_goodsArray[i];
//            
//            //输出列表status参数值：
//            //Edit = 1,"录入中"
//            //Listing = 2,"上架"
//            //Delete = 3，"删除"
//            NSMutableArray *tmpArr=[self getProductInfo:productInfoList prodclsid:colldict[@"detailInfo"][@"productClsId"]];
//            [goodsInfoList[i] addObjectsFromArray:tmpArr];
//            
//            int stockcount=[self getClsStockNum:goodsInfoList[i]];
//            NSMutableDictionary *dict=goodsSelectedList[i];
//            dict[@"StockNum"]=[[NSString alloc] initWithFormat:@"%d",stockcount ];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (i==0)
//                {
////                    _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stockcount];
////                    _numberStepper.maxValue=stockcount>20?20:stockcount;
////                    
//                    [self showGoodsInfoView:0];
//                }
//            });
//            
////            //获取商品各个款式库存
////            NSMutableArray *stocklist=[[NSMutableArray alloc] initWithCapacity:4];
////            NSMutableString *stockmsg=[[NSMutableString alloc] initWithFormat:@""];
////            BOOL success1=[SHOPPING_GUIDE_ITF requestGetUrlName:@"StockFilter" param:@{@"proD_CLS_ID":colldict[@"detailInfo"][@"productClsId"]} responseList:stocklist responseMsg:stockmsg];
////            
////            dispatch_async(dispatch_get_main_queue(), ^{
////                
////                int stockcount=0;
////                NSMutableArray *tstocklist=[[NSMutableArray alloc] initWithCapacity:4];
////                for(NSDictionary *dict in stocklist)
////                {
////                    NSMutableDictionary *tDict=[[NSMutableDictionary alloc] initWithDictionary:dict copyItems:YES];
////                    if ([tDict[@"count"] intValue]<0)
////                    {
////                        [tDict setObject:@(0) forKey:@"count"];
////                    }
////                    [tstocklist addObject:tDict];
////                    stockcount+=[tDict[@"count"] intValue];
////                }
////                [goodsStockArray replaceObjectAtIndex:i withObject:tstocklist];//二维
////                
////                NSMutableDictionary *dict=goodsSelectedList[i];
////                dict[@"StockNum"]=[[NSString alloc] initWithFormat:@"%d",stockcount ];
////                if (success1 && i==0)
////                {
////                    _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stockcount];
////                    _numberStepper.maxValue=stockcount>20?20:stockcount;
////                }
////            });
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [Toast hideToastActivity];
//        });
//    });
    
    [self setupForDismissKeyboard];
    
}

- (void)updateImageList
{
    for (int i=0;i<_goodsArray.count;i++)
    {
        //        if (i!=0)
        //            [productClsIDs appendString:@","];
        //        [productClsIDs appendString:[Utils getSNSInteger:_goodsArray[i][@"detailInfo"][@"productClsId"]]];
        NSArray *picArr=_goodsArray[i][@"proudctList"][@"clsPicUrl"];
        EAImageListGridData *griddata=[[EAImageListGridData alloc] init];
        if (picArr.count>0)
        {
            // 图片大小改为100
            NSString *filePath=[Utils getSNSString:picArr[0][@"filE_PATH"]];
            
            griddata.url=[CommMBBusiness changeStringWithurlString:filePath size:SNS_IMAGE_Size];
            //            griddata.url=[Utils getSNSString:picArr[0][@"filE_PATH"]];
        }
        [_viewImageList.dataArray addObject:griddata];
        
        
        //        //init selectedlist
        //        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        //        dict[@"ProdID"]=@"";
        //        dict[@"SpecID"]=@"";
        //        dict[@"ColorID"]=@"";
        //        dict[@"StockNum"]=@"0";
        //        dict[@"Qty"]=[[NSString alloc] initWithFormat:@"%d",_numberStepper.minValue];
        //        dict[@"Object"]=[[NSDictionary alloc] init];
        //        dict[@"SizeEnableArray"]=[[NSMutableArray alloc] init];
        //        dict[@"ColorEnableArray"]=[[NSMutableArray alloc] init];
        //
        //        [goodsSelectedList addObject:dict];
        //
        //        goodsInfoList[i]=[[NSMutableArray alloc] init];
    }
    [_viewImageList reloadData];
    
    [self showGoodsInfoView:0];
}

-(void)goodsArrayLoadData:(NSMutableArray *)goodsArr
{
    NSMutableString *productClsIDs=[[NSMutableString alloc] init];
    for (int i=0;i<goodsArr.count;i++)
    {
        if (i!=0)
            [productClsIDs appendString:@","];
        [productClsIDs appendString:[Utils getSNSInteger:goodsArr[i][@"detailInfo"][@"productClsId"]]];
    }
    
//    [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *productInfoList=[[NSMutableArray alloc] initWithCapacity:10];
        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
        
        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"ProductFilter" param:@{@"prodClsIdList": productClsIDs,@"pageIndex":@"1",@"pageSize":@"10000"} responseList:productInfoList responseMsg:msg];
        
        if (success)
        {
            NSMutableArray *tmpGoodsArr=[[NSMutableArray alloc] init];
            for (int i=0;i<goodsArr.count;i++)
            {
                NSDictionary *colldict=goodsArr[i];
                
                //输出列表status参数值：
                //Edit = 1,"录入中"
                //Listing = 2,"上架"
                //Delete = 3，"删除"
                NSMutableArray *tmpProductArr=[self getProductInfo:productInfoList prodclsid:colldict[@"detailInfo"][@"productClsId"]];
                if (tmpProductArr.count<1)
                {
                    continue;
                }
                
                [tmpGoodsArr addObject:goodsArr[i]];
                goodsInfoList[i]=[[NSMutableArray alloc] init];
                [goodsInfoList[i] addObjectsFromArray:tmpProductArr];

                //init selectedlist
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                dict[@"ProdID"]=@"";
                dict[@"SpecID"]=@"";
                dict[@"ColorID"]=@"";
//                dict[@"StockNum"]=@"0";
                dict[@"Qty"]=[[NSString alloc] initWithFormat:@"%d",1];
                dict[@"Object"]=[[NSDictionary alloc] init];
                dict[@"SizeEnableArray"]=[[NSMutableArray alloc] init];
                dict[@"ColorEnableArray"]=[[NSMutableArray alloc] init];
                int stockcount=[self getClsStockNum:goodsInfoList[i]];
                dict[@"StockNum"]=[[NSString alloc] initWithFormat:@"%d",stockcount];
                
                [goodsSelectedList addObject:dict];
            }
            _goodsArray=tmpGoodsArr;
        }
//    if (_goodsArray.count > 0 && _viewImageList.dataArray.count == 0) {
//        
//        [self updateImageList];
//    }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [Toast hideToastActivity];
//        });
//    });
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
                NSMutableDictionary *d2=[[NSMutableDictionary alloc] initWithDictionary:dictProd[@"productInfo"] copyItems:YES];
                d2[@"lisT_QTY"]=[[NSNumber alloc] initWithInt:0];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:dictProd copyItems:YES];
                dict[@"productInfo"]=d2;
                [arr addObject:dict];
            }
        }
    }
    return arr;
}

-(void)dealloc
{
    parentView=nil;
    returnParentViewAction=nil;
    nextParentViewAction=nil;
}

//-(void)getGoodsProductData:(int)index complete:(void (^)(void))complete
//{
//    [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
//    //    NSDictionary *cartxml=_functionXML[@"native"][@"shopping_cart"][@"load_product"];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        int i=index;
//        
//        NSDictionary *colldict=_goodsArray[i];
//        NSMutableArray *productInfoList=[[NSMutableArray alloc] initWithCapacity:10];
//        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//        
//        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"ProductFilter" param:@{@"lm_prod_cls_id": colldict[@"detailInfo"][@"productClsId"]} responseList:productInfoList responseMsg:msg];
//        //            [goodsInfoList addObject:productInfoList];//二维
//        //输出列表status参数值：
//        //Edit = 1,"录入中"
//        //Listing = 2,"上架"
//        //Delete = 3，"删除"
//        goodsInfoList[i]=[[NSMutableArray alloc] init];
//        for (NSDictionary *dictProd in productInfoList) {
//            if ([dictProd[@"productInfo"][@"status"] intValue]==2)
//            {
//                [goodsInfoList[i] addObject:dictProd];
//            }
//        }
//        
//        //获取商品各个款式库存
//        NSMutableArray *stocklist=[[NSMutableArray alloc] initWithCapacity:4];
//        NSMutableString *stockmsg=[[NSMutableString alloc] initWithFormat:@""];
//        BOOL success1=[SHOPPING_GUIDE_ITF requestGetUrlName:@"StockFilter" param:@{@"proD_CLS_ID":colldict[@"detailInfo"][@"productClsId"]} responseList:stocklist responseMsg:stockmsg];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            int stockcount=0;
//            NSMutableArray *tstocklist=[[NSMutableArray alloc] initWithCapacity:4];
//            for(NSDictionary *dict in stocklist)
//            {
//                NSMutableDictionary *tDict=[[NSMutableDictionary alloc] initWithDictionary:dict copyItems:YES];
//                if ([tDict[@"count"] intValue]<0)
//                {
//                    [tDict setObject:@(0) forKey:@"count"];
//                }
//                [tstocklist addObject:tDict];
//                stockcount+=[tDict[@"count"] intValue];
//            }
//            [goodsStockArray replaceObjectAtIndex:i withObject:tstocklist];//二维
//            
//            NSMutableDictionary *dict=goodsSelectedList[i];
//            dict[@"StockNum"]=[[NSString alloc] initWithFormat:@"%d",stockcount];
//        });
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [Toast hideToastActivity];
//            complete();
//        });
//    });
//}

-(void)showGoodsInfoView:(NSInteger)index
{
    if ([_goodsArray count]==0||_goodsArray==nil) {
        return;
    }
    NSDictionary *goodsdict=_goodsArray[index];
    if (goodsdict!=nil && goodsdict[@"detailInfo"]!=nil)
        _lbGoodsName.text=goodsdict[@"detailInfo"][@"productName"];
    
    NSString *imageurl=nil;
    if (goodsdict!=nil && goodsdict[@"proudctList"]!=nil)
    {
//        _imageLine1.backgroundColor=COLLOCATION_TABLE_LINE;
        //create imagelist
        _viewImageList.backgroundColor=[UIColor clearColor];

        if (goodsdict[@"proudctList"][@"clsInfo"]!=nil)
        {
            _lbPrice.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:goodsdict[@"proudctList"][@"clsInfo"][@"sale_price"]]];//c1
            product_price=[[Utils getSNSMoney:goodsdict[@"proudctList"][@"clsInfo"][@"sale_price"]] floatValue];
        }
//        if (goodsdict[@"proudctList"][@"clsPicUrl"]!=nil)
//        {
//            NSArray *picArr=goodsdict[@"proudctList"][@"clsPicUrl"];
//            if (picArr.count>0)
//            {
//                imageurl=[Utils getSNSString:picArr[0][@"filE_PATH"]];//smalL_FILE_PATH
//            }
//        }
        NSMutableArray *colorList = [[NSMutableArray alloc] initWithCapacity:10];
        NSMutableArray *colorKeyArr = [[NSMutableArray alloc] initWithCapacity:10];
        
//        if (goodsdict[@"proudctList"][@"colorList"]!=nil)
//        {
//            NSArray *colorarr=goodsdict[@"proudctList"][@"colorList"];
//            for(int i=0;i<[colorarr count];i++)
//            {
//                [colorList addObject: colorarr[i][@"name"] ];
//            }
//        }
        if (goodsdict[@"proudctList"][@"colorList"]!=nil)
        {
            NSArray *colorarr=goodsdict[@"proudctList"][@"colorList"];
            for(int i=0;i<[colorarr count];i++)
            {
                NSString *colorid=[colorarr[i][@"id"] stringValue];
                BOOL find=NO;
                for (NSDictionary *dict in goodsInfoList[index])
                {
                    if ([colorid isEqualToString:[dict[@"productInfo"][@"coloR_ID"] stringValue]])
                    {
                        //20150107
                        if (dict[@"productInfo"][@"coloR_FILE_PATH"]!=nil)
                        {
                            [colorList addObject:[CommMBBusiness changeStringWithurlString:dict[@"productInfo"][@"coloR_FILE_PATH"] size:SNS_IMAGE_Size]];
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
        
        NSMutableArray *sizeList=[[NSMutableArray alloc] initWithCapacity:5];
        if (goodsdict[@"proudctList"][@"specList"]!=nil)
        {
            NSArray *sizearr=goodsdict[@"proudctList"][@"specList"];
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
        
        _lbGoodsCode.text=[NSString stringWithFormat:@"款号:%@",[Utils getSNSString:goodsdict[@"detailInfo"][@"productCode"]]];
        
        if (index<goodsInfoList.count)
        {
            int stockcount=[self getClsStockNum:goodsInfoList[index]];
            _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stockcount];
            _numberStepper.maxValue=stockcount>20?20:stockcount;
        }
        
//        _lbStoreNum.text=[NSString stringWithFormat:@"库存:%@",[Utils getSNSInteger:goodsdict[@"proudctList"][@"clsInfo"][@"stockCount"]]];//@"0"];
//        _numberStepper.maxValue=0;
        _lbSum.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:goodsdict[@"proudctList"][@"clsInfo"][@"sale_price"]]];
   
        _lbOriginSum.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:goodsdict[@"detailInfo"][@"productPrice"]]];
        
//        _colorListView.enableArray=[[NSMutableArray alloc] init];
//        _sizeListView.enableArray=[[NSMutableArray alloc] init];
    }
    [self downloadImage:imageurl];
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
-(void)refreshProductView:(NSInteger)index colorid:(NSString *)colorid sizeid:(NSString *)sizeid returnStock:(int*)returnStock// clickedtype:(int)clickedtype
{
    EAImageListGridData *data = viewListArr[index];

    NSArray *list=goodsInfoList[index];
    int stocknum=0;
    NSMutableArray *colorenablelist=[[NSMutableArray alloc] init];
    NSMutableArray *sizeenablelist=[[NSMutableArray alloc] init];
    float product_price1=-1;
    if (colorid.length==0 && sizeid.length==0)
    {
        stocknum=[self getClsStockNum:goodsInfoList[index]];
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
                
                int s1=[self getGoodsStock:goodsInfoList[index] prodid:[list[i][@"productInfo"][@"id"] intValue]];
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
        
        if (data.checked!=NO) //商品选择完成显示小沟
        {
            data.checked=NO;
            [_viewImageList reloadData];
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
                
                int s1=[self getGoodsStock:goodsInfoList[index] prodid:[list[i][@"productInfo"][@"id"] intValue]];
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
        
        if (data.checked!=NO) //商品选择完成显示小沟
        {
            data.checked=NO;
            [_viewImageList reloadData];
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
                int s1=[self getGoodsStock:goodsInfoList[index] prodid:[list[i][@"productInfo"][@"id"] intValue]];
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
                int s1=[self getGoodsStock:goodsInfoList[index] prodid:[list[i][@"productInfo"][@"id"] intValue]];
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
                
                int s1=[self getGoodsStock:goodsInfoList[index] prodid:[list[i][@"productInfo"][@"id"] intValue]];
                stocknum+=s1;
                break;
            }
        }
        
        if (stocknum>0)
        {
            if (data.checked!=YES)
            {
                data.checked=YES;
                [_viewImageList reloadData];
            }
        }
        else
        {
            if (data.checked!=NO) //商品选择完成显示小沟
            {
                data.checked=NO;
                [_viewImageList reloadData];
            }
        }
    }
    
    _colorListView.enableArray=colorenablelist;
    _sizeListView.enableArray=sizeenablelist;
    
    _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
    _numberStepper.maxValue=stocknum>20?20:stocknum;
    _numberStepper.text=@"1";
    
    product_price=product_price1==-1?product_price:product_price1;
    _lbPrice.text=[NSString stringWithFormat:@"￥%0.2f",product_price];
    _lbSum.text=[NSString stringWithFormat:@"￥%0.2f",product_price*[_numberStepper.text intValue]];
    
    *returnStock=stocknum;
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
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidDisappear:animated];
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

-(void)clickGoodView:(UITapGestureRecognizer *)sender
{
    @synchronized(self)
    {
        for (int i = 0; i < self.contentImageArray.count; i++) {
            UIUrlImageView *imageView = self.contentImageArray[i];
            imageView.layer.borderColor = [Utils HexColor:0xe2e2e2 Alpha:1].CGColor;
            imageView.frame = CGRectMake((5 + 45)*i,5, 45, 45);
        }
        
        UIUrlImageView *clickImgView=(UIUrlImageView *)sender.view;
//          NSLog(@"clickImgVIew想-----%ld",clickImgView.tag);
        clickImgView.layer.borderColor = [Utils HexColor:0x333333 Alpha:1].CGColor;
        CGRect rect = clickImgView.layer.frame;
        rect.origin.y -= 5;
        rect.size.height += 10;
        rect.size.width += 10;
        [UIView animateWithDuration:0.25 animations:^{
            clickImgView.layer.frame = rect;
        }];
        
        for (UIUrlImageView *imageView in self.contentImageArray) {
            if(imageView.tag > clickImgView.tag){
                CGPoint point = imageView.layer.position;
                point.x += 10;
                imageView.layer.position = point;
            }
        }
        NSInteger index=clickImgView.tag;
        [self imageListViewClicked:sender index:index];
    }

}
-(void)ImageListView_cellDidSelected:(id)sender eventData:(NSIndexPath *)idx
{
    @synchronized(self)
    {
        NSInteger index=idx.row;
        [self imageListViewClicked:sender index:index];
    }
}

-(void)imageListViewClicked:(id)sender index:(NSInteger)index
{
    if ([goodsInfoList count]>index)
    {
//        EAImageListGridData *griddata= _viewImageList.dataArray[index];
        
        [_viewImageList setSelectIndex:index];
        
        [self showGoodsInfoView:index];
        
        NSMutableDictionary *dict=goodsSelectedList[index];
        if (dict!=nil && dict[@"ColorEnableArray"]!=nil)
            _colorListView.enableArray=dict[@"ColorEnableArray"];
        if (dict!=nil && dict[@"SizeEnableArray"]!=nil)
            _sizeListView.enableArray=dict[@"SizeEnableArray"];

        if (dict!=nil && dict[@"ColorID"]!=nil)
            [self selectColor:dict[@"ColorID"] index:index];
        if (dict!=nil && dict[@"SpecID"]!=nil)
            [self selectSize:dict[@"SpecID"] index:index];
        if (dict!=nil && dict[@"Qty"]!=nil)
            [self setGoodsNumber:dict[@"Qty"] index:index];
        int stocknum=[dict[@"StockNum"] intValue];
        _numberStepper.maxValue=stocknum>20?20:stocknum;
        _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
        
//        [self getGoodsProductData:index complete:^(void){
//            [self showGoodsInfoView:index];
//            NSMutableDictionary *dict=goodsSelectedList[index];
//            if (dict!=nil && dict[@"ColorEnableArray"]!=nil)
//                _colorListView.enableArray=dict[@"ColorEnableArray"];
//            if (dict!=nil && dict[@"SizeEnableArray"]!=nil)
//                _sizeListView.enableArray=dict[@"SizeEnableArray"];
//            
//            if (dict!=nil && dict[@"ColorID"]!=nil)
//                [self selectColor:dict[@"ColorID"] index:index];
//            if (dict!=nil && dict[@"SpecID"]!=nil)
//                [self selectSize:dict[@"SpecID"] index:index];
//            if (dict!=nil && dict[@"Qty"]!=nil)
//                [self setGoodsNumber:dict[@"Qty"] index:index];
//            int stocknum=[dict[@"StockNum"] intValue];
//            _numberStepper.maxValue=stocknum>20?20:stocknum;
//            _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
//        }];
    }
}

-(void)selectColor:(NSString *)color index:(NSInteger)index
{
    int idx=-1;
    NSArray *arr=_goodsArray[index][@"proudctList"][@"colorList"];
    for(int i=0;i<[arr count];i++)
    {
        NSString *colorstr=[arr[i][@"id"] stringValue];
        if ([colorstr isEqualToString:color])
        {
            idx=i;
            break;
        }
    }
    [_colorListView setActiveIndex:idx];
    
}
-(void)selectSize:(NSString *)size index:(NSInteger)index
{
    int idx=-1;
    NSArray *arr=_goodsArray[index][@"proudctList"][@"specList"];
    for(int i=0;i<[arr count];i++)
    {
        NSString *sizestr=[arr[i][@"id"] stringValue];
        if ([sizestr isEqualToString:size])
        {
            idx=i;
            break;
        }
    }
    [_sizeListView setActiveIndex:idx];
}
-(void)setGoodsNumber:(NSString *)size index:(NSInteger)index
{
    NSMutableDictionary *dict=goodsSelectedList[index];
    if (((NSString*)dict[@"Qty"]).length>0)
    {
        _numberStepper.text=dict[@"Qty"];
        
        NSString *price=[Utils getSNSMoney:_goodsArray[index][@"proudctList"][@"clsInfo"][@"sale_price"]];
        float sum=((float)[_numberStepper.text intValue])*((float)[price floatValue]);
        _lbSum.text=[NSString stringWithFormat:@"￥%0.2f",sum];
        
        NSString *price2=[Utils getSNSMoney:_goodsArray[index][@"detailInfo"][@"productPrice"]];
        float sum2=((float)[_numberStepper.text intValue])*((float)[price2 floatValue]);
        _lbOriginSum.text=[NSString stringWithFormat:@"￥%0.2f",sum2];
    }
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

- (IBAction)btnBuyClick:(id)sender {
//    [Toast makeToastActivity:@"核对商品数量..." hasMusk:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (int i=0;i<_goodsArray.count;i++)
//        {
//            NSDictionary *colldict = _goodsArray[i];
//            //获取商品各个款式库存
//            NSMutableArray *stocklist=[[NSMutableArray alloc] initWithCapacity:4];
//            NSMutableString *stockmsg=[[NSMutableString alloc] initWithFormat:@""];
//            BOOL success1=[SHOPPING_GUIDE_ITF requestGetUrlName:@"StockFilter" param:@{@"proD_CLS_ID":colldict[@"detailInfo"][@"productClsId"]} responseList:stocklist responseMsg:stockmsg];
//            if (success1)
//            {
//                NSMutableArray *tstocklist=[[NSMutableArray alloc] initWithCapacity:4];
//                for(NSDictionary *dict in stocklist)
//                {
//                    NSMutableDictionary *tDict=[[NSMutableDictionary alloc] initWithDictionary:dict copyItems:YES];
//                    if ([tDict[@"count"] intValue]<0)
//                    {
//                        [tDict setObject:@(0) forKey:@"count"];
//                    }
//                    [tstocklist addObject:tDict];
//                }
//                [goodsStockArray replaceObjectAtIndex:i withObject:tstocklist];//二维
//            }
//            
//            //获取商品状态
//            NSMutableArray *productInfoList=[[NSMutableArray alloc] initWithCapacity:10];
//            NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//            BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"ProductFilter" param:@{@"lm_prod_cls_id": colldict[@"detailInfo"][@"productClsId"]} responseList:productInfoList responseMsg:msg];
//            if (success)
//            {
//                NSMutableArray *arr1=[[NSMutableArray alloc] init];
//                for (NSDictionary *dictProd in productInfoList)
//                {
//                    if ([dictProd[@"productInfo"][@"status"] intValue]==2)
//                    {
//                        [arr1 addObject:dictProd];
//                    }
//                }
//                [goodsInfoList replaceObjectAtIndex:i withObject:arr1];
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (success1 && i==0)
//                {
//                }
//            });
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [Toast hideToastActivity];
//            int row=0;
//            [self checkSelectedGoods:&row];
//        });
//    });
    
    int row=0;
    [self checkSelectedGoods:&row];
}

//-(void)refreshData
//{
//    [Toast makeToastActivity:@"核对商品数量..." hasMusk:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (int i=0;i<_goodsArray.count;i++)
//        {
//            NSDictionary *colldict = _goodsArray[i];
//            //获取商品各个款式库存
//            NSMutableArray *stocklist=[[NSMutableArray alloc] initWithCapacity:4];
//            NSMutableString *stockmsg=[[NSMutableString alloc] initWithFormat:@""];
//            BOOL success1=[SHOPPING_GUIDE_ITF requestGetUrlName:@"StockFilter" param:@{@"proD_CLS_ID":colldict[@"detailInfo"][@"productClsId"]} responseList:stocklist responseMsg:stockmsg];
//            if (success1)
//            {
//                NSMutableArray *tstocklist=[[NSMutableArray alloc] initWithCapacity:4];
//                for(NSDictionary *dict in stocklist)
//                {
//                    NSMutableDictionary *tDict=[[NSMutableDictionary alloc] initWithDictionary:dict copyItems:YES];
//                    if ([tDict[@"count"] intValue]<0)
//                    {
//                        [tDict setObject:@(0) forKey:@"count"];
//                    }
//                    [tstocklist addObject:tDict];
//                }
//                [goodsStockArray replaceObjectAtIndex:i withObject:tstocklist];//二维
//            }
//            
//            //获取商品状态
//            NSMutableArray *productInfoList=[[NSMutableArray alloc] initWithCapacity:10];
//            NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//            BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"ProductFilter" param:@{@"lm_prod_cls_id": colldict[@"detailInfo"][@"productClsId"]} responseList:productInfoList responseMsg:msg];
//            if (success)
//            {
//                NSMutableArray *arr1=[[NSMutableArray alloc] init];
//                for (NSDictionary *dictProd in productInfoList)
//                {
//                    if ([dictProd[@"productInfo"][@"status"] intValue]==2)
//                    {
//                        [arr1 addObject:dictProd];
//                    }
//                }
//                [goodsInfoList replaceObjectAtIndex:i withObject:arr1];
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (success1 && i==0)
//                {
//                }
//            });
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [Toast hideToastActivity];
//        });
//    });
//}

-(void)buyCollocation
{
    if (_shareUserId.length==0) {
        // add by miao 3.7 解决分享人问题
        _shareUserId = @"";
//        _shareUserId=sns.ldap_uid;
    }
    if ([_titleStr isEqual:@"加入购物车"]) {
        //批量加入购物车
        NSMutableArray *goodsarr=[[NSMutableArray alloc] init];
        for (int i=0;i<goodsSelectedList.count;i++)
        {
            NSMutableDictionary *dict=goodsSelectedList[i];
            NSString *p1=dict[@"ProdID"];
            NSString *s1=dict[@"SpecID"];
            NSString *c1=dict[@"ColorID"];
            if (p1.length==0 || s1.length==0 || c1.length==0)
            {
                continue;
            }
            NSMutableDictionary *goodsdict=[[NSMutableDictionary alloc] initWithDictionary:@{@"proD_ID":dict[@"ProdID"],@"source":@"2",@"qty":dict[@"Qty"],@"userId":sns.ldap_uid,@"sharE_SELLER_ID":_shareUserId,@"collocatioN_ID":[Utils getSNSInteger:_data[@"collocationId"]],@"designerId":_data[@"userId"],@"designerName":_data[@"creatE_USER"]}];
            [goodsarr addObject:goodsdict];
        }
        
        NSMutableDictionary *urlparam=[[NSMutableDictionary alloc] init];
        [urlparam setObject:goodsarr forKey:@"lstCreateDto"];
        
        //{"lstCreateDto":[{"id":0,"proD_ID":0,"source":"String","qty":0,"userId":"String","sharE_SELLER_ID":"String","collocatioN_ID":"String","designerId":"String","designerName":"String"}]}
        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
        [Toast makeToastActivity:@"加入购物车..." hasMusk:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success=[SHOPPING_GUIDE_ITF requestPostUrlName:@"ShoppingCartCreateList" param:urlparam responseAll:nil responseMsg:msg];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success)
                {
//                    MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
//                    
//                    [((UIViewController*)parentView).navigationController pushViewController:vc1 animated:YES];
                    [self btnCloseClick:nil];
                }
                else
                {
                    NSString *productid=nil;
                    NSString *messagestr=nil;
                    NSArray *paraArr=[msg componentsSeparatedByString:@";"];
                    if (paraArr.count==2)
                    {
                        productid=paraArr[0];
                        messagestr=paraArr[1];
                        [Utils alertMessage:[NSString stringWithFormat:@"加入购物车失败！(%@)",messagestr]];
                    }
                    else
                        [Utils alertMessage:@"加入购物车失败！"];
                }
                [Toast hideToastActivity];
            });
        });
        
    }
    else
    {
        NSMutableArray *payList=[[NSMutableArray alloc] init];
        for (int i=0;i<goodsSelectedList.count;i++)
        {
            NSMutableDictionary *dict=goodsSelectedList[i];
            
            NSString *p1=dict[@"ProdID"];
            NSString *s1=dict[@"SpecID"];
            NSString *c1=dict[@"ColorID"];
            if (p1.length==0 || s1.length==0 || c1.length==0)
            {
                continue;
            }
            
            NSDictionary *goodsinfo=[self getProduct:goodsInfoList[i] colorId:dict[@"ColorID"] specId:dict[@"SpecID"]];
            
            MyShoppingTrollyGoodsData *data=[[MyShoppingTrollyGoodsData alloc] init];
            data.value=goodsinfo;
            data.collocationid=[Utils getSNSInteger:_data[@"collocationId"]];
            data.designerid=_data[@"userId"];
            data.designername=_data[@"creatE_USER"];
            data.number=[dict[@"Qty"] intValue];

            data.shareUserId=[[NSString alloc] initWithFormat:@"%@",_shareUserId];
            [payList addObject:data];
        }
        
        if (payList.count==0)
        {
            [Utils alertMessage:@"请您选择商品后再购买！"];
            return;
        }
        
        MBCreateGoodsOrderViewController *orderVC=[[MBCreateGoodsOrderViewController alloc] initWithNibName:@"MBCreateGoodsOrderViewController" bundle:nil];
        orderVC.goodsArray=payList;
        orderVC.sumInfo=nil;
        [((UIViewController*)parentView).navigationController pushViewController:orderVC animated:YES];
        [self btnCloseClick:nil];
    }
}

- (IBAction)textValueChanged:(id)sender {
    NSInteger index_goods=_viewImageList.selectIndex;
//    NSString *price=[Utils getSNSMoney:_goodsArray[index_goods][@"proudctList"][@"clsInfo"][@"sale_price"]];
    float sum=((float)[_numberStepper.text intValue])*product_price;
    _lbSum.text=[NSString stringWithFormat:@"￥%0.2f",sum];

    NSString *price2=[Utils getSNSMoney:_goodsArray[index_goods][@"detailInfo"][@"productPrice"]];
    float sum2=((float)[_numberStepper.text intValue])*((float)[price2 floatValue]);
    _lbOriginSum.text=[NSString stringWithFormat:@"￥%0.2f",sum2];

    NSMutableDictionary *dict=goodsSelectedList[index_goods];
    dict[@"Qty"]=_numberStepper.text;
}

- (IBAction)textEditingDidEnd:(id)sender {
    NSInteger index_goods=_viewImageList.selectIndex;
    NSMutableDictionary *dict=goodsSelectedList[index_goods];
    int stocknum=[dict[@"StockNum"] intValue];
    
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
    
    [Toast makeToast:[NSString stringWithFormat:@"商品数量修改为%@!",_numberStepper.text] duration:2 position:@"center"];
//    [Toast makeToast:[NSString stringWithFormat:@"商品数量修改为%@!",_numberStepper.text]  mask:YES];
}

- (void)setParentView:(id)pview returnAction:(SEL)returnAction nextAction:(SEL)nextAction
{
    parentView=pview;
    returnParentViewAction=returnAction;
    nextParentViewAction=nextAction;
}

//-(void)updateGoodsSelected
//{
////    NSMutableDictionary *dict=goodsSelectedList[index];
////    NSString *specid=[Utils getSNSString:cell.sizeid];
////    if (specid.length>0)
////        dict[@"SpecID"]=specid;
////    NSString *colorid=[Utils getSNSString:cell.colorid];
////    if (colorid.length>0)
////        dict[@"ColorID"]=colorid;
////    NSString *prodid=[Utils getSNSString:cell.productid];
////    if (prodid.length>0)
////        dict[@"ProdID"]=prodid;
////    NSString *num=[Utils getSNSString:cell.goodsNum];
////    if (num.length>0)
////        dict[@"Qty"]=num;
////    
////    if ([Utils getSNSString:cell.productid].length>0)
////    {
////        dict[@"Object"]=[self getProduct:goodsInfoList[cell.row] colorId:cell.colorid specId:cell.sizeid];
////    }
////    else
////    {
////        dict[@"Object"]=[[NSDictionary alloc] init];
////    }
//}

-(BOOL)checkSelectedGoods:(int*)row
{
    NSInteger index_goods=_viewImageList.selectIndex;
    int count=0;
    int unselectedindex=-1;
    for (int i=0;i<goodsSelectedList.count;i++)
    {
        NSMutableDictionary *dict=goodsSelectedList[i];
        //        dict[@"ID"]=[Utils getSNSString:cell.shoppingcartid];
        
        NSString *p1=dict[@"ProdID"];
        NSString *s1=dict[@"SpecID"];
        NSString *c1=dict[@"ColorID"];
        if (p1.length==0 && s1.length==0 && c1.length==0)
        {
            unselectedindex=i;
            continue;
        }
        if (c1.length>0 && s1.length==0)
        {
            [Utils alertMessage:@"请选择购买商品的尺寸!"];
            [self imageListViewClicked:nil index:i];
            return NO;
        }
        if (s1.length>0 && c1.length==0)
        {
            [Utils alertMessage:@"请选择购买商品的颜色!"];
            [self imageListViewClicked:nil index:i];
            return NO;
        }

//        NSString *str_name=@"";
//        NSDictionary *goodsdict=_goodsArray[i];
//        if (goodsdict!=nil && goodsdict[@"detailInfo"]!=nil)
//            str_name=goodsdict[@"detailInfo"][@"productName"];
//        
//        NSString *s1=[Utils getSNSString:dict[@"SpecID"]];
//        if (s1.length==0)
//        {
//            [Utils alertMessage:[NSString stringWithFormat:@"%@,尺码已售空！",str_name]];
//            return NO;
//        }
//        
//        NSString *c1=dict[@"ColorID"];
//        if (c1.length==0)
//        {
//            [Utils alertMessage:[NSString stringWithFormat:@"%@,颜色已售空！",str_name]];
//            return NO;
//        }
//        
//        NSString *p1=dict[@"ProdID"];
//        if (p1.length==0)
//        {
//            [Utils alertMessage:[NSString stringWithFormat:@"%@,商品已售空！",str_name]];
//            return NO;
//        }
        
        //判断商品上架
        NSDictionary *dictProd=[self getProduct:goodsInfoList[i] colorId:c1 specId:s1];
        if (dictProd==nil)
        {
            [Utils alertMessage:@"商品已下架了!"];
            [self imageListViewClicked:nil index:i];
            return NO;
        }
        else if ([dictProd[@"productInfo"][@"status"] intValue]==1)
        {
            [Utils alertMessage:@"商品已下架!"];
            [self imageListViewClicked:nil index:i];
            return NO;
        }
        else if ([dictProd[@"productInfo"][@"status"] intValue]==3)
        {
            [Utils alertMessage:@"商品已经下架!"];
            [self imageListViewClicked:nil index:i];
            return NO;
        }
        
        //刷新库存
        int stocknum=[self getGoodsStock:goodsInfoList[i] prodid:[p1 intValue]];
        if ([dict[@"StockNum"] intValue]!=stocknum)
        {
            dict[@"StockNum"]=[[NSString alloc] initWithFormat:@"%d",stocknum];
            if (index_goods==i)
            {
                //是当前显示界面，需要刷新
                _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
                _numberStepper.maxValue=stocknum>20?20:stocknum;
            }
        }
        
        //判断库存
        if ([dict[@"StockNum"] intValue]<1||[dict[@"Qty"] intValue]>[dict[@"StockNum"] intValue])
        {
            //_goodsArray[i][@"productName"]
            [Utils alertMessage:@"商品的库存不足!"];
            [self imageListViewClicked:nil index:i];
            return NO;
        }
        
        //判断购买数量
        
        if ([dict[@"Qty"] intValue]>20)
        {
            [Utils alertMessage:@"最多购买20件商品!"];
            [self imageListViewClicked:nil index:i];
            return NO;
        }
       
        count++;
    }
    
    *row=count;
    if (count==0)
        [Utils alertMessage:@"请选择要购买的商品款式！"];
    else if (count<goodsSelectedList.count&&unselectedindex>=0)
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"此搭配中还有商品未选择款式！" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:@"继续购买", nil];
        alertView.tag=unselectedindex;
        [alertView show];
    }
    else
    {
        [self buyCollocation];
    }
    return (count>0);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [self buyCollocation];
    }
    else if (buttonIndex==1) {
        [self imageListViewClicked:nil index:alertView.tag];
    }
}

-(NSString *)getProductId:(NSArray *)list colorId:(NSString *)colorId specId:(NSString *)specId imageUrl:(NSMutableString *)imageUrl
{
//    _numberStepper.text=@"1";
//    _numberStepper.maxValue=0;
//    _lbStoreNum.text=[NSString stringWithFormat:@"库存:%@",@"0"];
    
    NSInteger index_goods=_viewImageList.selectIndex;
//    EAImageListGridData *data = _viewImageList.dataArray[index_goods];
    NSDictionary *goodsdict=_goodsArray[index_goods];
    product_price=[goodsdict[@"proudctList"][@"clsInfo"][@"sale_price"] floatValue];
    _lbPrice.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:goodsdict[@"proudctList"][@"clsInfo"][@"sale_price"]]];
    _lbSum.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:goodsdict[@"proudctList"][@"clsInfo"][@"sale_price"]]];
    _lbOriginSum.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:goodsdict[@"detailInfo"][@"productPrice"]]];

    NSString *rst=@"";
    if (list.count>0 && colorId.length>0 && specId.length>0)
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
                _lbPrice.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:list[i][@"productInfo"][@"salE_PRICE"]]];
                _lbSum.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:list[i][@"productInfo"][@"salE_PRICE"]]];
                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    NSMutableArray *stocklist=[[NSMutableArray alloc] initWithCapacity:4];
//                    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//                    BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"StockFilter" param:@{@"PROD_ID":rst} responseList:stocklist responseMsg:msg];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (success && stocklist!=nil && stocklist.count>0 && [stocklist[0][@"count"] intValue]>0)
//                        {
//                            int stocknum=[stocklist[0][@"count"] intValue];
//                            _numberStepper.maxValue=stocknum>20?20:stocknum;
//                            _lbStoreNum.text=[NSString stringWithFormat:@"库存:%d",stocknum];
//                            
//                            NSMutableDictionary *dict=goodsSelectedList[index_goods];
//                            dict[@"StockNum"]=[NSString stringWithFormat:@"%d",stocknum];
//                            if (data.checked!=YES)
//                            {
//                                data.checked=YES;
//                                [_viewImageList reloadData];
//                            }
//                        }
//                        else
//                        {
//                            if (data.checked!=NO)
//                            {
//                                data.checked=NO;
//                                [_viewImageList reloadData];
//                            }
//                            _numberStepper.maxValue=0;
//                            _lbStoreNum.text=[NSString stringWithFormat:@"库存:%@",@"0"];
//                        }
//                    });
//                });
                break;
            }
        }
//        if (existProduct==NO)
//        {
//            if (data.checked!=NO)
//            {
//                data.checked=NO;
//                [_viewImageList reloadData];
//            }
//            _numberStepper.maxValue=0;
//            _lbStoreNum.text=[NSString stringWithFormat:@"库存:%@",@"0"];
//        }
    }
    return rst;
}

-(void)_sizeListView_onButtonClick:(id)sender button:(id)button
{
    EACellListView *list=(EACellListView*)sender;
    
    NSInteger index_goods=_viewImageList.selectIndex;
    NSDictionary *goodsdict=_goodsArray[index_goods];
    NSMutableDictionary *dict=goodsSelectedList[index_goods];
    if (list.activeIndex>=0)
        dict[@"SpecID"]=[goodsdict[@"proudctList"][@"specList"][list.activeIndex][@"id"] stringValue];
    else
        dict[@"SpecID"]=@"";
    NSMutableString *imgurl=[[NSMutableString alloc] init];
//    dict[@"StockNum"]=@"0";
    dict[@"ProdID"]=[self getProductId:goodsInfoList[index_goods] colorId:dict[@"ColorID"] specId:dict[@"SpecID"] imageUrl:imgurl];
    
    //
    int stocknum=0;
    [self refreshProductView:index_goods colorid:dict[@"ColorID"] sizeid:dict[@"SpecID"] returnStock:&stocknum];
    dict[@"StockNum"]=[[NSString alloc] initWithFormat:@"%d", stocknum ];
    dict[@"SizeEnableArray"]=_sizeListView.enableArray;
    dict[@"ColorEnableArray"]=_colorListView.enableArray;
//    if (imgurl.length>0)
//        [_imageGoods downloadImageUrl:imgurl cachePath:[AppSetting getMBCacheFilePath] defaultImageName:nil];
    [self showTip:index_goods];
}

-(void)_colorListView_onButtonClick:(id)sender button:(id)button
{
    EACellListView *list=(EACellListView*)sender;
    
    NSInteger index_goods=_viewImageList.selectIndex;
//    NSDictionary *goodsdict=_goodsArray[index_goods];
    NSMutableDictionary *dict=goodsSelectedList[index_goods];
    if (list.activeIndex>=0)
        //20150107
//        dict[@"ColorID"]=[goodsdict[@"proudctList"][@"colorList"][list.activeIndex][@"id"] stringValue];
        dict[@"ColorID"]=_colorListView.keyArray[list.activeIndex];
    else
        dict[@"ColorID"]=@"";
    NSMutableString *imgurl=[[NSMutableString alloc] init];
    dict[@"ProdID"]=[self getProductId:goodsInfoList[index_goods] colorId:dict[@"ColorID"] specId:dict[@"SpecID"] imageUrl:imgurl];
    
    int stocknum=0;
    [self refreshProductView:index_goods colorid:dict[@"ColorID"] sizeid:dict[@"SpecID"] returnStock:&stocknum];
    dict[@"StockNum"]=[[NSString alloc] initWithFormat:@"%d", stocknum ];
    dict[@"SizeEnableArray"]=_sizeListView.enableArray;
    dict[@"ColorEnableArray"]=_colorListView.enableArray;

//    if (imgurl.length>0)
//        [_imageGoods downloadImageUrl:imgurl cachePath:[AppSetting getMBCacheFilePath] defaultImageName:nil];
    [self showTip:index_goods];
}

-(void)showTip:(NSInteger)index
{
//    _lbTip.text=@"";
//    NSMutableDictionary *dict=goodsSelectedList[index];
//    if (((NSString*)dict[@"ColorID"]).length==0)
//    {
//        _lbTip.text=[NSString stringWithFormat:@"请选择产品颜色!"];
//    }
//    else if (((NSString*)dict[@"SpecID"]).length==0)
//    {
//        _lbTip.text=[NSString stringWithFormat:@"请选择产品尺寸!"];
//    }
//    else if (((NSString*)dict[@"ProdID"]).length==0)
//    {
//        _lbTip.text=[NSString stringWithFormat:@"该产品已售空!"];
//    }
}

-(void)downloadImage:(NSString *)url
{
//    NSString *defaultImg=DEFAULT_LOADING_IMAGE;//@"defaultDownload.png"
//    _imageGoods.contentMode = UIViewContentModeScaleAspectFit;
//    _imageGoods.backgroundColor=[UIColor whiteColor];
//    _imageGoods.delegate=self;
//    [_imageGoods downloadImageUrl:[CommMBBusiness changeStringWithurlString:url] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
}

-(void)completeDownloadImage:(id)sender imageLocalPath:(NSString *)imageLocalPath
{
    //    UIImage *img=[UIImage imageNamed:imageLocalPath];
    //    img.size.height
}

@end
