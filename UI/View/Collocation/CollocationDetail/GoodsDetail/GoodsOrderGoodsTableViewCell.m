//
//  GoodsOrderGoodsTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "GoodsOrderGoodsTableViewCell.h"
#import "Utils.h"
#import "AppSetting.h"
#import "CommMBBusiness.h"

//static const int TableViewCellHeight=44;
//static const int LabelHeight=18;
//static const int LabelWidth=222;

@implementation GoodsOrderGoodsTableViewCell

- (void)awakeFromNib
{
    [self innerInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)innerInit
{
//    self.backgroundColor=COLLOCATION_TABLE_LINE;
//    _imageGoods.delegate=self;
    _imageGoods.contentMode = UIViewContentModeScaleAspectFit;
    _imageGoods.layer.borderColor=[UIColor grayColor].CGColor;
    _imageGoods.layer.borderWidth=0;
}

-(void)downloadImage:(NSString *)url
{
    NSString *defaultImg=DEFAULT_LOADING_IMAGE;//@"defaultDownload.png"
    if (_imageGoods==nil)
    {
        _imageGoods.image=[UIImage imageNamed:defaultImg];
        return;
    }

    [_imageGoods downloadImageUrl:[CommMBBusiness changeStringWithurlString:url size:SNS_IMAGE_SMALL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
}

//[{"cartInfo":{"id":519,"accounT_ORIGANIAL_CODE":"gh_d6e75bc5e759","opeN_ID":"o2AHRjg4BinO9oA8fxQ1w3sDH_OU","topiC_ID":198,"proD_ID":1101,"coloR_ID":0,"speC_ID":0,"qty":1,"price":100.0000},"proudctList":{"productInfo":{"id":1101,"lM_PROD_CLS_ID":432,"proD_NUM":"12400905","inneR_CODE":"","coloR_ID":1110,"speC_ID":988,"status":"1"},"clsList":[{"id":432,"accounT_ORIGINAL_CODE":"gh_d6e75bc5e759","code":"124009","name":"asjdflkj","price":100.0000,"uP_COUNT":0,"brand":"Metersbonwe品牌","category":"配饰","salE_ATTRIBUTE":"零售","description":"aldfjakljf","status":"1","remark":"adfasf","scenE_FLAG":1}],"colorList":[{"id":1110,"lM_PROD_CLS_ID":432,"code":"05","name":"浅灰色","value":"#D3D3D3"}],"specList":[{"id":988,"lM_PROD_CLS_ID":432,"code":"01","name":"L"}],"clsPicUrl":[{"id":1064,"srC_TYPE":"ProdCls","srC_ID":432,"filE_PATH":"C:\\ProdCls\\432\\b2fbd3e2-00ae-451a-a774-827875e4ba53t.jpg","smalL_FILE_PATH":"http://222.66.95.239/MB.WeiXin.Management.External/PicHandler.ashx?type=ProdCls&id=432&s=1","custoM_FILE_PATH":"http://222.66.95.239/MB.WeiXin.Management.External/PicHandler.ashx?type=ProdCls&id=432&s=2","isMainImage":0}
-(void)setData:(MyShoppingTrollyGoodsData *)data1
{
    _data=data1;
    if (_data==nil) return;
    
    _lbName.text=[Utils getSNSString:_data.prodname];
//    [Utils resizeLabel:_lbName defaultHeight:LabelHeight defaultWidth:LabelWidth];
    if ( data1.shopProdprice != nil) {
        _lbPrice.text=[NSString stringWithFormat:@"￥%0.2f",data1.shopProdprice.floatValue];
    }else{
    _lbPrice.text=[NSString stringWithFormat:@"￥%0.2f",data1.saleprice];
    }
    
    _lbColor.text=[NSString stringWithFormat:@"颜色:%@ 尺码:%@",data1.colorname,data1.sizename];
    _lbAmount.text=[NSString stringWithFormat:@"小计: ￥%0.2f",data1.saleprice*(float)data1.number];
    _lbNumber.text=[NSString stringWithFormat:@"x%d",data1.number];
    _lbProductCode.text=[NSString stringWithFormat:@"款号: %@",data1.productcode];
//    if (_data.promotionGoodsInfo != nil) {
//        _preferentialLab.text = [NSString stringWithFormat:@"活动优惠:¥%0.2f 只需支付:¥%0.2f",_data.promotionGoodsInfo.diS_AMOUNT.floatValue,_data.promotionGoodsInfo.amount.floatValue];
//    }else{
//     _preferentialLab.text = @"";
//    }
    if (_data.prodInfo != nil) {
//        _preferentialLab.text = [NSString stringWithFormat:@"活动优惠:¥%0.2f       支付金额:¥%0.2f",_data.prodInfo.dec_price.floatValue,_data.prodInfo.total_price.floatValue];
        _preferentialLab.text = [NSString stringWithFormat:@"活动优惠:¥%0.2f",_data.prodInfo.dec_price.floatValue];
        _onlyPayLabel.text= [NSString stringWithFormat:@"支付金额:¥%0.2f",_data.prodInfo.total_price.floatValue];
    }else{
//        _preferentialLab.text = [NSString stringWithFormat:@"活动优惠:¥%0.2f       支付金额:¥%0.2f",_data.prodInfo.dec_price.floatValue,data1.saleprice*(float)data1.number];
           _preferentialLab.text = [NSString stringWithFormat:@"活动优惠:¥%0.2f",_data.prodInfo.dec_price.floatValue];
        _onlyPayLabel.text = [NSString stringWithFormat:@"支付金额:¥%0.2f",data1.saleprice*(float)data1.number];
        
    }
    [self downloadImage:_data.imageurl];
}

+(int)getCellHeight:(id)data1
{
    GoodsOrderGoodsTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsOrderGoodsTableViewCell" owner:self options:nil] objectAtIndex:0];
    return cell.frame.size.height;
}


@end
