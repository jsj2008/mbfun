//
//  SelfImageVIew.h
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "SelfImageVIew.h"
#import "Utils.h"
#import "UIUrlImageView.h"
#import "AppSetting.h"
#import "CommMBBusiness.h"

@interface SelfImageVIew ()

@property (nonatomic, assign) CGPoint locationPoint;

@end
@implementation SelfImageVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithImageInfo:(ImageInfo*)imageInfo y:(float)y  withA:(int)a withShowHeight:(BOOL)show withMyLike:(BOOL)isMyLike//SHOW 高低不同 //no 同样高度 ISMYLIKE 我的喜欢 实心 no 为空心
{
    float imageW;
    float imageH;
    
    if (show) {
        
        imageW = imageInfo.width;
        imageH = imageInfo.height;
        
        if (!(imageH>0&&imageW>0))
        {
            imageW= (UI_SCREEN_WIDTH-10)/2-5;
            imageH = 200;
        }
    }
    else
    {
        imageW= (UI_SCREEN_WIDTH-10)/2-5;
        imageH = 180-47+UPSPACE;
    }
    //缩略图宽度和宽度
    float width = WIDTH - SPACE;//*2
    float height = width * imageH / imageW;

    self = [super initWithFrame:CGRectMake(0, y, WIDTH, height+47)];
    if (self) {
        self.data = imageInfo;
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE / 2 , SPACE / 2 , width, height)];
        
        
//        UIUrlImageView *imageView = [[UIUrlImageView alloc]initWithFrame:CGRectMake(20 ,12 , width-40, height)];
        UIUrlImageView *imageView = [[UIUrlImageView alloc]initWithFrame:CGRectMake(SPACE  , UPSPACE , width, height)];
        NSString *thumrUrl =[CommMBBusiness changeStringWithurlString:imageInfo.thumbURL size:SNS_IMAGE_Size];
        [imageView downloadImageUrl:[Utils getSNSString:thumrUrl]
                          cachePath:[AppSetting getMBCacheFilePath]
                   defaultImageName:DEFAULT_LOADING_MEDIUM];
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        
        //如果想加别的信息在此可加
        UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(SPACE , height, width, 20)];
        labe.textColor=[Utils HexColor:0x353535 Alpha:1];
        labe.font=[UIFont systemFontOfSize:14.0f];
        labe.text = [NSString stringWithFormat:@"   %@",imageInfo.titleName];
        labe.backgroundColor = [UIColor whiteColor];
        [self addSubview:labe];
        UIImageView *imaViews=[[UIImageView alloc]initWithFrame:CGRectMake(SPACE, labe.frame.origin.y+labe.frame.size.height,width, 27)];
//        imaViews.layer.masksToBounds=YES;
//        imaViews.layer.borderColor = [Utils HexColor:0xe2e2e2 Alpha:1.0].CGColor;
//        imaViews.layer.borderWidth =1.0;
        imaViews.userInteractionEnabled=YES;
//        [imaViews setBackgroundColor:[Utils HexColor:0xf4f4f4 Alpha:1]];
        [imaViews setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:imaViews];
        
//        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 25)];
//        timeLabel.backgroundColor=[UIColor clearColor];
//        timeLabel.textColor= [Utils HexColor:0xacacac Alpha:1];
//        timeLabel.font=[UIFont systemFontOfSize:11.0f];
//        timeLabel.text=@"30分钟前";
//        [imaViews addSubview:timeLabel];
        UILabel *favriteNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(imaViews.frame.size.width-26, 1,26, 25)];
        
        favriteNumLabel.backgroundColor=[UIColor clearColor];
        favriteNumLabel.textColor=[Utils HexColor:0x919191 Alpha:1];
        favriteNumLabel.font=[UIFont systemFontOfSize:11.0f];
        favriteNumLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[NSString stringWithFormat:@"%@",imageInfo.favriteCount]]];
        [imaViews addSubview:favriteNumLabel];
        UIButton *likeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //(imaViews.frame.size.width-30, 2, 22, 22)]
        [likeBtn setFrame:CGRectMake(favriteNumLabel.frame.origin.x-14-3, 2+5, 14, 12)];
        if(isMyLike)
        {
            [likeBtn setBackgroundImage:[UIImage imageNamed:@"ico_home_favor_pressed"] forState:UIControlStateNormal];
       
        }
        else
        {
            [likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_like_normal"] forState:UIControlStateNormal];
         
        }
        [likeBtn addTarget:self
                    action:@selector(favriteBtn:)
          forControlEvents:UIControlEventTouchUpInside];
        [imaViews addSubview:likeBtn];
        
        UILabel *numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(37, 1, 50, 25)];
        numberLabel.backgroundColor=[UIColor clearColor];
        numberLabel.textAlignment=NSTextAlignmentLeft;
        numberLabel.font=[UIFont systemFontOfSize:11.0f];
        numberLabel.textColor=[Utils HexColor:0xacacac Alpha:1];
        NSString *number = [NSString stringWithFormat:@"%@",imageInfo.stockCount];
        numberLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:number]];
        [imaViews addSubview:numberLabel];
        
        if (show)
        {
            UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 1, 100, 25)];
            priceLabel.backgroundColor=[UIColor clearColor];
            priceLabel.textAlignment=NSTextAlignmentLeft;
            priceLabel.font=[UIFont systemFontOfSize:12.0f];
//            priceLabel.text=imageInfo.price;
            priceLabel.text=[NSString stringWithFormat:@"￥%@",imageInfo.price];
            priceLabel.textColor=[UIColor colorWithRed:250.0/255.0 green:125.0/255.0 blue:110.0/255.0 alpha:1];
            priceLabel.frame=CGRectMake(5, 1, 60, 25);
            [imaViews addSubview:priceLabel];

//            [likeBtn setFrame:CGRectMake(imaViews.frame.size.width-55, 2, 22, 22)];
//            likeBtn.frame = CGRectMake(imaViews.frame.size.width-30, 2, 22, 22);
//            numberLabel.hidden=YES;
//            numberLabel.frame = CGRectMake(imaViews.frame.size.width-30, 1, 40, 25);
        }
        else
        {
//            UIImageView *returnImgView=[[UIImageView alloc]initWithFrame:CGRectMake(timeLabel.frame.size.width+timeLabel.frame.origin.x+18,1+5, 14, 12)];
            
            UIImageView *returnImgView=[[UIImageView alloc]initWithFrame:CGRectMake(18,1+5, 14, 12)];
            [returnImgView setImage:[UIImage imageNamed:@"icon_favor_bubble"]];
      
            [imaViews addSubview:returnImgView];

            [numberLabel setFrame:CGRectMake(returnImgView.frame.origin.x+returnImgView.frame.size.width+3, numberLabel.frame.origin.y, 26, numberLabel.frame.size.height)];
            
        }

        
        [self setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
//        self.backgroundColor = [UIColor whiteColor];
        
//        self.layer.borderColor = [Utils HexColor:0xe2e2e2 Alpha:1.0].CGColor;
//        self.layer.borderWidth =0.3;
        
    }
    return self;
}
-(void)favriteBtn:(UIButton *)sender
{
    [self.delegate favriteBtnClick:self.data];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.locationPoint = [touch locationInView:self];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat x = fabsf(self.locationPoint.x - point.x);
    if (x < 10.0) {
        [self.delegate clickImage:self.data];
    }
}
@end
