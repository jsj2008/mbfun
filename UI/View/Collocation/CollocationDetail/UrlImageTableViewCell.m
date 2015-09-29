//
//  UrlImageTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "UrlImageTableViewCell.h"
#import "AppSetting.h"
#import "utils.h"
#import "CommMBBusiness.h"

//static const int UrlImageTableViewCellHeight=300+38;
//static const int UrlImageTableViewCellHeight=300;
static const int UrlImageTableViewCellHeight=320;
static const int ImageHeight=320;

@implementation UrlImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

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
    self.backgroundColor=[UIColor whiteColor];
    self.frame=CGRectMake(0,0,self.frame.size.width,UrlImageTableViewCellHeight);
    int heigt=15;
    if (imageView==nil)
    {
        imageView=[[UIUrlImageView alloc] initWithFrame:CGRectMake(15,0+heigt,self.frame.size.width-15*2,ImageHeight-heigt*2)];
        //上部大图
        imageView.image=[UIImage imageNamed:DEFAULT_LOADING_IMAGE];
//        imageView.layer.borderColor = [Utils HexColor:0xc7c7c7 Alpha:1.0].CGColor;
//        imageView.layer.borderWidth =1.0;
//        imageView.layer.masksToBounds=YES;
        [self.contentView addSubview:imageView];
        
//        UIImageView *imagebk=[[UIImageView alloc] initWithFrame:CGRectMake(10,imageView.frame.origin.y+imageView.frame.size.height,SCREEN_WIDTH,38)];
//        imagebk.backgroundColor=[Utils HexColor:0xfcfcfc Alpha:1.0];
//        [self.contentView addSubview: imagebk];
        
//        _lbTitle=[[UILabel alloc] init];
//        _lbTitle.frame=CGRectMake(15, imageView.frame.origin.y+imageView.frame.size.height+11, SCREEN_WIDTH,16);
//        _lbTitle.textColor=[Utils HexColor:0x353535 Alpha:1.0];
//        _lbTitle.font=[UIFont systemFontOfSize:14];
//        [self.contentView addSubview:_lbTitle];
    }
}
-(void)dealloc
{
    imageView.delegate=nil;
}
-(void)downloadImage:(NSString *)url
{
    if (imageView==nil) return;
    
    //@"http://www.metersbonwe.net/mb.boutiquemall/Images/01.jpg"
    NSString *defaultImg=DEFAULT_LOADING_IMAGE;//@"defaultDownload.png"
    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.backgroundColor=[Utils HexColor:0xe2e2e2 Alpha:1];
    imageView.backgroundColor=[UIColor clearColor];
    imageView.delegate=self;
    //[CommMBBusiness changeStringWithurlString:url size:SNS_IMAGE_ORIGINAL]
    [imageView downloadImageUrl:url cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
}

-(void)setData:(id)imageurl
{
    [self downloadImage:imageurl];
}

-(void)completeDownloadImage:(id)sender imageLocalPath:(NSString *)imageLocalPath
{
//    UIImage *img=[UIImage imageNamed:imageLocalPath];
//    img.size.height
}

-(void)setCollocationInfo:(NSDictionary *)collocationDict
{
//    _lbTitle.text=[Utils getSNSString:collocationDict[@"collocationInfo"][@"name"]];
}

//-(void)setCollocationGoodsInfo:(NSMutableArray *)collocationArr andFunctionXml:(NSDictionary*)functionXML orRootXml:(NSDictionary*)rootXml
//{
//    //接口方法，在子类实现（搭配购买 传上下级参数）
//}

+(int)getCellHeight:(id)data1
{
    return UrlImageTableViewCellHeight;
}

@end
