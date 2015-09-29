//
//  DirectBuyOrderTableViewCell.m
//  Wefafa
//
//  Created by fafatime on 14-10-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "DirectBuyOrderTableViewCell.h"
#import "Utils.h"

#import "MBShoppingGuideInterface.h"
#import "Toast.h"
#import "AppSetting.h"
#import "CommMBBusiness.h"

@implementation DirectBuyOrderTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}


-(void)setData:(NSMutableArray *)data
{
    _productInfoList =data;
}


-(void)setCollocaInfo:(NSDictionary *)collocaInfo
{
    [self showTip];
    
    _collocaInfo = collocaInfo;
    NSMutableArray *sizeList=[[NSMutableArray alloc] initWithCapacity:5];
    if (_collocaInfo[@"proudctList"][@"specList"]!=nil){
        NSArray *sizearr=_collocaInfo[@"proudctList"][@"specList"];
        for(int i=0;i<[sizearr count];i++)
        {
            [sizeList addObject: sizearr[i][@"name"] ];
        }
    }
    
    UIColor *selectedcolor=[UIColor colorWithRed:255/255.0 green:27/255.0 blue:133/255.0 alpha:1];
    _goodsSizeView.listStyle=EALIST_STYLE_BUTTON_RADIOBUTTON;
    _goodsSizeView.dataArray=sizeList;
    [_goodsSizeView setDelegate:self selector:@selector(_sizeListView_onButtonClick:button:)];
    _goodsSizeView.contentVerticalAlignment=EALIST_VERTICAL_ALIGNMENT_CENTER;
    [_goodsSizeView setButtonActiveBorderColor:selectedcolor activeTextColor:selectedcolor];
    [_goodsSizeView reloadData];
    
    NSMutableArray *colorList = [[NSMutableArray alloc] initWithCapacity:10];
    if (_collocaInfo[@"proudctList"][@"colorList"]!=nil)
    {
        NSArray *colorarr=_collocaInfo[@"proudctList"][@"colorList"];
        for(int i=0;i<[colorarr count];i++)
        {
            [colorList addObject: colorarr[i][@"name"] ];
        }
    }
    
    
    _goodsColorView.listStyle=EALIST_STYLE_BUTTON_RADIOBUTTON;
    _goodsColorView.dataArray=colorList;
    [_goodsColorView setDelegate:self selector:@selector(_colorListView_onButtonClick:button:)];
    _goodsColorView.contentVerticalAlignment=EALIST_VERTICAL_ALIGNMENT_CENTER;
    [_goodsColorView setButtonActiveBorderColor:selectedcolor activeTextColor:selectedcolor];
    [_goodsColorView reloadData];
    
    if (_collocaInfo!=nil && _collocaInfo[@"proudctList"]!=nil)
    {
        if (_collocaInfo[@"proudctList"][@"clsInfo"]!=nil)
        {
            _goodsPriceLb.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSMoney:_collocaInfo[@"proudctList"][@"clsInfo"][@"sale_price"]]];
            NSString *desc=[Utils getSNSString:_collocaInfo[@"proudctList"][@"clsInfo"][@"name"]];
            _goodsNameLb.text=[NSString stringWithFormat:@"%@",desc.length>0?desc:@"暂无"];
        }
        if (_collocaInfo[@"proudctList"][@"clsPicUrl"]!=nil) {
            NSString *desc=[Utils getSNSString:_collocaInfo[@"proudctList"][@"clsPicUrl"][0][@"filE_PATH"]];
            _colloctionPic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:desc]]];
            if (desc.length == 0) {
                _colloctionPic.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
            }
        }
    }
}

-(void)selectColor:(NSString *)color
{
    int idx=-1;
    NSArray *arr=_collocaInfo[@"proudctList"][@"colorList"];
    for(int i=0;i<[arr count];i++)
    {
        NSString *colorstr=[arr[i][@"id"] stringValue];
        if ([colorstr isEqualToString:color])
        {
            idx=i;
            break;
        }
    }
    [_goodsColorView setActiveIndex:idx];
    [self setColorInfo:idx];
}
-(void)selectSize:(NSString *)size
{
    int idx=-1;
    NSArray *arr=_collocaInfo[@"proudctList"][@"specList"];
    for(int i=0;i<[arr count];i++)
    {
        NSString *sizestr=[arr[i][@"id"] stringValue];
        if ([sizestr isEqualToString:size])
        {
            idx=i;
            break;
        }
    }
    [_goodsSizeView setActiveIndex:idx];
    [self setSizeInfo:idx];
}

- (IBAction)textValueChanged:(id)sender {
    [self setGoodsNumber:_goodsNumFiled.text];
}

-(void)setGoodsNumber:(NSString *)numstr
{
    if (numstr.length>0)
    {
        _goodsNumFiled.text=[NSString stringWithFormat:@"%@",numstr];
        _goodsNum=[NSString stringWithFormat:@"%@",numstr];
    }
    [_mainview updateGoodsSelected:self];
}

-(void)showTip
{
    _lbTip.text=@"";
    if (_colorid.length==0 &&_sizeid.length==0)
    {
        _lbTip.text=[NSString stringWithFormat:@"请选择颜色和尺寸!"];
    }
    if (_colorid.length==0)
    {
        _lbTip.text=[NSString stringWithFormat:@"请选择产品颜色!"];
    }
    else if (_sizeid.length==0)
    {
        _lbTip.text=[NSString stringWithFormat:@"请选择产品尺寸!"];
    }
    else if (_productid.length==0)
    {
        _lbTip.text=[NSString stringWithFormat:@"该产品已售空!"];
    }
}

-(void)_sizeListView_onButtonClick:(id)sender button:(id)button
{
    EACellListView *list=(EACellListView*)sender;
//    NSLog(@"%d",list.activeIndex);
    [self setSizeInfo:list.activeIndex];
}
-(void)setSizeInfo:(int)index
{
    if (index<0) {
        _sizeid=@"";
        _goodsSizeLb.text = @"";
    }
    else
    {
        _sizeid=[_collocaInfo[@"proudctList"][@"specList"][index][@"id"] stringValue];
        _goodsSizeLb.text = _collocaInfo[@"proudctList"][@"specList"][index][@"name"];
    }
    NSMutableString *imgurl=[[NSMutableString alloc] init];
    _productid=[self getProductId:_productInfoList colorId:_colorid specId:_sizeid imageUrl:imgurl];
    if (imgurl.length>0)
        [_colloctionPic downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgurl size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:nil];
    [self showTip];
    [_mainview updateGoodsSelected:self];
}
-(void)_colorListView_onButtonClick:(id)sender button:(id)button
{
    EACellListView *list=(EACellListView*)sender;
//    NSLog(@"%d",list.activeIndex);
    [self setColorInfo:list.activeIndex];
}

-(void)setColorInfo:(int)index
{
    if (index<0) {
        _colorid=@"";
        _goodsColorLb.text = @"";
    }
    else
    {
        _colorid=[_collocaInfo[@"proudctList"][@"colorList"][index][@"id"] stringValue];
        _goodsColorLb.text = _collocaInfo[@"proudctList"][@"colorList"][index][@"name"];
    }
    NSMutableString *imgurl=[[NSMutableString alloc] init];
    _productid=[self getProductId:_productInfoList colorId:_colorid specId:_sizeid imageUrl:imgurl];
    if (imgurl.length>0)
        [_colloctionPic downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgurl size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:nil];
    [self showTip];
    [_mainview updateGoodsSelected:self];
}
-(NSString *)getProductId:(NSArray *)list colorId:(NSString *)colorId specId:(NSString *)specId imageUrl:(NSMutableString *)imageUrl
{
    NSString *rst=@"";
    if (colorId.length>0 && specId.length>0)
    {
        for (int i=0;i<list.count;i++)
        {
            if ([[list[i][@"productInfo"][@"speC_ID"] stringValue] isEqualToString:specId] && [[list[i][@"productInfo"][@"coloR_ID"] stringValue] isEqualToString:colorId])
            {
                rst=[list[i][@"productInfo"][@"id"] stringValue];
                [imageUrl setString:list[i][@"productInfo"][@"coloR_FILE_PATH"] ];
//                _goodsNumFiled.maxValue=[list[i][@"productInfo"][@"lisT_QTY"] intValue];
                break;
            }
        }
    }
    return rst;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
