//
//  MBBannerView.m
//  Wefafa
//
//  Created by su on 15/4/1.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBBannerView.h"
#import "AppDelegate.h"
#import "BrandListViewController.h"
#import "UIImageView+AFNetworking.h"

//#import "SOrderSelectViewController.h"


@implementation MBBannerView{
    UIView *coverView;
    CGFloat _yPoint;
}

- (instancetype)initWithBannerArray:(NSArray *)array yPoint:(CGFloat)yPoint
{
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _yPoint = yPoint;
        self.backgroundColor = [UIColor colorWithRed:0.886 green:0.886 blue:0.886 alpha:1.0];
        [self updateSubViewWithArray:array];
    }
    return self;
}

- (void)updateSubViewWithArray:(NSArray *)array
{
    NSInteger count = array.count;
    CGFloat height = 80;
    CGFloat btnHeight = height-1;
    if (count > 4) {
        height = 160;
        btnHeight = (height - 2.0)/2.0;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGRect aFrame = CGRectMake(0, _yPoint, width, height);
    [self setFrame:aFrame];
    int i = 0;
    CGFloat btnWith = (width - 1.5) / 4.0;
    if (array.count == 0) {
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-0.5)];
        [coverView setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.0]];
        [self addSubview:coverView];
    }else{
        _bannerArray = array;
        if (coverView) {
            [coverView removeFromSuperview];
            coverView = nil;
        }
        for(NSDictionary *dict in array){
            
            UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [iconBtn setTag:100 + i];
            [iconBtn setClipsToBounds:YES];
            [iconBtn setBackgroundColor:[UIColor whiteColor]];
            [iconBtn setFrame:CGRectMake((i%4) * (btnWith+0.5), i / 4 * (btnHeight + 0.5)+0.5, btnWith, btnHeight)];
            [iconBtn addTarget:self action:@selector(indexIconClick:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *subImg = [[UIImageView alloc] initWithFrame:iconBtn.bounds];
            [subImg setContentMode:UIViewContentModeScaleAspectFit];
            [subImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"logO_URL"]] placeholderImage:[UIImage imageNamed:@"big_loading@3x.png"]];
            [iconBtn addSubview:subImg];
            [self addSubview:iconBtn];
            i ++;
            if (i == 7) {
                break;
            }
        }
        if (count > 7) {
            UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreBtn setFrame:CGRectMake((btnWith + 0.5)*3, btnHeight + 1.0, btnWith, btnHeight)];
            [moreBtn setImage:[UIImage imageNamed:@"home_more@2x.png"] forState:UIControlStateNormal];
            [moreBtn setBackgroundColor:[UIColor whiteColor]];
            [moreBtn addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];//34 6
            [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(30, (btnWith - 34)/2, btnHeight - 36, (btnWith - 34)/2)];
            UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, btnWith, 30)];
            [moreLabel setTextAlignment:NSTextAlignmentCenter];
            [moreLabel setFont:[UIFont systemFontOfSize:14.0f]];
            [moreLabel setTextColor:[UIColor blackColor]];
            [moreLabel setText:@"more"];
            [moreBtn addSubview:moreLabel];
            [self addSubview:moreBtn];
        }
        else{
            if (array.count != 4) {
                UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake((i%4) * (btnWith+0.5), i / 4 * (btnHeight + 0.5)+0.5, self.frame.size.width - (i%4) * (btnWith+0.5), btnHeight)];
                [tempView setBackgroundColor:[UIColor whiteColor]];
                [self addSubview:tempView];
            }
        }
    }
}

- (void)setBannerArray:(NSArray *)bannerArray
{
    [self updateSubViewWithArray:bannerArray];
}

- (void)indexIconClick:(UIButton *)btn
{
    /*
     字典里面字段
     "branD_CODE" = 1;
     "branD_NAME" = 1;
     id = 72689;
     "logO_URL" = "http://img.51mb.com:5659/sources/designer/Brand/2b16a77c-38a3-461f-8d7d-bde9b1710d61.jpg";
     */
//    NSInteger index = btn.tag-100;
//    if (_bannerArray.count > index) {
//        NSDictionary *dict = [_bannerArray objectAtIndex:index];
//        MBBrandViewController *mbbrand=[[MBBrandViewController alloc]initWithNibName:@"MBBrandViewController" bundle:nil];
//        mbbrand.brandId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
//        mbbrand.brandName =[NSString stringWithFormat:@"%@",[dict objectForKey:@"branD_NAME"]];
//        [[AppDelegate rootViewController] pushViewController:mbbrand animated:YES];
//    }
//    SOrderSelectViewController * vc = [[SOrderSelectViewController alloc]init];
//    [[AppDelegate rootViewController] pushViewController:vc animated:YES];
}

- (void)moreButtonClick
{
   // BrandListViewController *mbBrandList=[[BrandListViewController alloc]init];
//    SOrderSelectViewController * vc = [[SOrderSelectViewController alloc]init];
//    [[AppDelegate rootViewController] pushViewController:vc animated:YES];
}

@end
