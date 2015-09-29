//
//  SAgilityNavigationBarTool.m
//  Wefafa
//
//  Created by Mr_J on 15/9/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SAgilityNavigationBarTool.h"
#import "MyShoppingTrollyViewController.h"
#import "SMenuBottomModel.h"
#import "SUtilityTool.h"

@interface SAgilityNavigationBarTool ()

@property (nonatomic, assign) UIViewController *target;

@end

@implementation SAgilityNavigationBarTool

- (UIButton *)createNavigationBarButtonWithType:(int)type target:(UIViewController *)target{
    _target = target;
    UIButton *button = nil;
    switch (type) {
        case 1:
        {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 33, 33)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [button setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(openMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 2:
            button = [target valueForKey:@"shoppingBagButton"];
            break;
        case 3:
        {
            button =[UIButton buttonWithType:UIButtonTypeCustom] ;
            [button setFrame:CGRectMake(0, 0, 33, 33)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [button setImage:[UIImage imageNamed:@"Unico/icon_navigation_share"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 4:
        {
            button =[UIButton buttonWithType:UIButtonTypeCustom] ;
            [button setFrame:CGRectMake(0, 0, 33, 33)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [button setImage:[UIImage imageNamed:@"Unico/icon_navigation_search"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 5:
        {
            button =[UIButton buttonWithType:UIButtonTypeCustom] ;
            [button setFrame:CGRectMake(0, 0, 33, 33)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [button setImage:[UIImage imageNamed:@"Unico/community_camera"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
    return button;
}
-(void)cameraButtonClick
{
    
}
-(void)searchButtonClick
{
    
}
-(void)shareButtonClick
{
    
}
-(void)openMenuAction
{
    
}
- (void)createNavigationTitleViewWithModel:(SMenuBottomModel*)layoutModel{
    if (layoutModel.top_img.length > 0) {
        [self setTitleViewUrl:layoutModel.top_img];
    }else{
        self.navigationTitleView = [self createNavigationCenterView];
    }
}

- (void)openMenuAction:(UIButton *)sender
{
    [[SUtilityTool shared] showOrHideLeftSideView];
}

- (void)setNavigationTitleView:(UIView *)navigationTitleView{
    CGRect leftViewbounds = _target.navigationItem.leftBarButtonItem.customView.bounds;
    CGRect rightViewbounds = _target.navigationItem.rightBarButtonItem.customView.bounds;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 2 * MAX(leftViewbounds.size.width, rightViewbounds.size.width), 30)];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:navigationTitleView];
    _target.tabBarController.navigationItem.titleView = titleView;
}

- (void)setTitleViewUrl:(NSString *)titleViewUrl{
    CGRect leftViewbounds = _target.navigationItem.leftBarButtonItem.customView.bounds;
    CGRect rightViewbounds = _target.navigationItem.rightBarButtonItem.customView.bounds;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 2 * MAX(leftViewbounds.size.width, rightViewbounds.size.width), 30)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:titleViewUrl]];
    [self setNavigationTitleView:imageView];
}

- (UIView *)createNavigationCenterView{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(-5, 0, UI_SCREEN_WIDTH -100, 30)];
    titleLabel.text=@"有范";
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

@end
