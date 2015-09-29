//
//  CollocationDetailGridView.m
//  Wefafa
//
//  Created by mac on 14-9-18.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CollocationDetailGridView.h"
#import "Utils.h"
#import "AppSetting.h"
#import "CommMBBusiness.h"

@implementation CollocationDetailGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self innerInit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)innerInit
{
//    self.backgroundColor=COLLOCATION_TABLE_LINE;
    self.backgroundColor= [Utils HexColor:0xe2e2e2 Alpha:1.0];
    if (_backgroundView==nil)
    {
        int height=15;
        _backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0.5,0.5,self.frame.size.width-1,self.frame.size.height-1)];
        [self addSubview: _backgroundView];
        _backgroundView.backgroundColor=COLLOCATION_TABLE_BG;

        //width<height,下方有标题。
        _imageView=[[UIUrlImageView alloc] initWithFrame:CGRectMake(0,0+height,_backgroundView.frame.size.width,_backgroundView.frame.size.height-4*height)];
     
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.backgroundColor=COLLOCATION_TABLE_BG;
        _imageView.delegate=self;
        [_backgroundView addSubview: _imageView];
        
        int y=_imageView.frame.origin.y+_imageView.frame.size.height;
        _lbTitle=[[UILabel alloc] initWithFrame:CGRectMake(_backgroundView.frame.size.width/2+20,y,_backgroundView.frame.size.width/2-20,_backgroundView.frame.size.height-y)];
        _lbTitle.font=[UIFont systemFontOfSize:11.0];
//        _lbTitle.backgroundColor=COLLOCATION_TABLE_BG;
        _lbTitle.backgroundColor=[UIColor clearColor];
        _lbTitle.textColor=[Utils HexColor:0x6b6b6b Alpha:1.0];
        [_lbTitle setTextAlignment:NSTextAlignmentRight];
//        [_backgroundView addSubview: _lbTitle];
        _lbPrice=[[UILabel alloc] initWithFrame:CGRectMake(10,_backgroundView.frame.size.height-15-15,_backgroundView.frame.size.width-20,15)];

        _lbPrice.font=[UIFont systemFontOfSize:14.0];
        _lbPrice.textColor=[Utils HexColor:0x333333 Alpha:1.0];
        _lbPrice.backgroundColor=[UIColor clearColor];
        [_lbPrice setTextAlignment:NSTextAlignmentCenter];
        [_backgroundView addSubview: _lbPrice];
        
        _lbStatus=[[UILabel alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x,_imageView.frame.origin.y+_imageView.frame.size.height,_imageView.frame.size.width,25)];
        [_lbStatus setFrame:CGRectMake(_imageView.frame.origin.x,_lbPrice.frame.origin.y-5-25,_imageView.frame.size.width,25)];
        
        _lbStatus.font=[UIFont systemFontOfSize:14.0];
        _lbStatus.backgroundColor=[Utils HexColor:0xb2b2b2 Alpha:1];
        _lbStatus.textAlignment=NSTextAlignmentCenter;
        _lbStatus.alpha=0.6;
        _lbStatus.text=@"已下架";
        _lbStatus.hidden=YES;
        _lbStatus.textColor=[UIColor whiteColor];
        [_backgroundView addSubview: _lbStatus];
        
        _lbNoneStock=[[UILabel alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x,_imageView.frame.origin.y+_imageView.frame.size.height,_imageView.frame.size.width,25)];
        [_lbNoneStock setFrame:_lbStatus.frame];
        
        _lbNoneStock.font=[UIFont systemFontOfSize:14.0];
        _lbNoneStock.backgroundColor=[Utils HexColor:0xb2b2b2 Alpha:1];
        _lbNoneStock.textAlignment=NSTextAlignmentCenter;
        _lbNoneStock.alpha=0.6;
        _lbNoneStock.text=@"已售罄";
        _lbNoneStock.hidden=YES;
        _lbNoneStock.textColor=[UIColor whiteColor];
        [_backgroundView addSubview: _lbNoneStock];

        
    }
}

-(void)downloadImage:(NSString *)url
{
    if (_imageView==nil) return;
    NSString *defaultImg=DEFAULT_LOADING_MEDIUM;
//    NSString *defaultImg=DEFAULT_LOADING_IMAGE;//@"defaultDownload.png"
    [_imageView downloadImageUrl:[CommMBBusiness changeStringWithurlString:url size:SNS_IMAGE_SMALL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
}
-(void)dealloc
{
    _imageView.delegate=nil;
}
-(void)setData:(NSDictionary *)data1
{
    _data=data1;
    if (_data==nil) return;
    
    _lbTitle.hidden=NO;
    _lbPrice.hidden=NO;
    _lbStatus.hidden=YES;
    _lbNoneStock.hidden=YES;
    _lbTitle.text=@"";
    if (_data!=nil && _data[@"detailInfo"]!=nil)
    {
        //素材
        if ([[Utils getSNSInteger:_data[@"detailInfo"][@"sourceType"]] intValue]==2)
        {
            _lbTitle.hidden=YES;
            _lbPrice.hidden=YES;
        }
    }
    
    NSString *imgname=@"";
    if (_data!=nil && _data[@"proudctList"]!=nil)
    {
        if (_data[@"proudctList"][@"clsPicUrl"]!=nil &&[_data[@"proudctList"][@"clsPicUrl"] count]>0)
        {
            NSString *productPictureUrl = [NSString stringWithFormat:@"%@",_data[@"detailInfo"][@"productPictureUrl"]];
            productPictureUrl = [Utils getSNSString: productPictureUrl];
            
            if(productPictureUrl.length==0)
            {
                 imgname=[Utils getSNSString: _data[@"proudctList"][@"clsPicUrl"][0][@"filE_PATH"]];
            }
            else
            {
                  imgname=productPictureUrl;
            }
            
          
        }
        if (_data[@"proudctList"][@"clsInfo"]!=nil &&[_data[@"proudctList"][@"clsInfo"] count]>0)
        {
            _lbPrice.text=[[NSString alloc] initWithFormat:@"￥%@",[Utils getSNSMoney: _data[@"proudctList"][@"clsInfo"][@"sale_price"]]];
            if (_data[@"proudctList"][@"clsInfo"][@"stockCount"]!=nil && [[Utils getSNSInteger:_data[@"proudctList"][@"clsInfo"][@"stockCount"]] intValue]<=0)
            {
                _lbStatus.hidden=YES; //只显示售罄
                _lbNoneStock.hidden=NO;
            }
            if (_data[@"proudctList"][@"clsInfo"][@"status"]!=nil && [[Utils getSNSInteger:_data[@"proudctList"][@"clsInfo"][@"status"]] intValue]!=2)
            {
                _lbStatus.hidden=NO; //
                _lbNoneStock.hidden=YES;
            }
        }
    }
    [self downloadImage:imgname];
}

-(void)completeDownloadImage:(id)sender imageLocalPath:(NSString *)imageLocalPath
{
    //    UIImage *img=[UIImage imageNamed:imageLocalPath];
    //    img.size.height
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UIView *touched = [[touches anyObject] view];
    if (_data!=nil)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notif_tvCollectionDetailGoods_OnDidSelected" object:self userInfo:@{@"data":_data, @"index":@(_index)}];
}

@end
