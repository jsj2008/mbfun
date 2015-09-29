//
//  JSWebAgilityNavigationViewController.m
//  Wefafa
//
//  Created by Mr_J on 15/9/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "JSWebAgilityNavigationViewController.h"
#import "ShoppIngBagShowButton.h"
#import "SAgilityNavigationBarTool.h"
#import "SMenuBottomModel.h"
#import "WeFaFaGet.h"
#import "Utils.h"
#import "HttpRequest.h"

@interface JSWebAgilityNavigationViewController ()

@end

@implementation JSWebAgilityNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestCarCount];
}

- (void)setupNavbar{
    [super setupNavbar];
    SAgilityNavigationBarTool *tool = [SAgilityNavigationBarTool new];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    NSMutableArray *leftItemArray = [NSMutableArray array];
    [leftItemArray addObject:negativeSpacer];
    for (NSNumber *number in _layoutModel.button_config.left) {
        UIButton *leftButton = [tool createNavigationBarButtonWithType:number.intValue target:self];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        [leftItemArray addObject:leftItem];
    }
    self.navigationItem.leftBarButtonItems = leftItemArray;
    
    NSMutableArray *rightItemArray = [NSMutableArray array];
    for (NSNumber *number in _layoutModel.button_config.right) {
        UIButton *rightButton = [tool createNavigationBarButtonWithType:number.intValue target:self];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        [rightItemArray addObject:rightItem];
    }
    self.navigationItem.rightBarButtonItems = rightItemArray;
    
    [tool createNavigationTitleViewWithModel:_layoutModel];
}

- (ShoppIngBagShowButton *)shoppingBagButton{
    if (!_shoppingBagButton) {
        _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
        [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
        [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shoppingBagButton;
}

- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        }else
        {
            self.shoppingBagButton.titleLabel.hidden=YES;
            [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
        }
    } failed:^(NSError *error) {
        
    }];
}

@end
