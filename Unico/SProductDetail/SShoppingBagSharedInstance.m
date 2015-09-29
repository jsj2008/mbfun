//
//  SShoppingBagSharedInstance.m
//  SUIView
//
//  Created by PHM on 9/23/15.
//  Copyright (c) 2015 haoming pei. All rights reserved.
//

#import "SShoppingBagSharedInstance.h"
#import "WeFaFaGet.h"
#import "HttpRequest.h"
static SShoppingBagSharedInstance *sharedInstance = nil;
static dispatch_once_t once;
@implementation SShoppingBagSharedInstance
#pragma mark 创建购物袋单例
+ (instancetype)sharedInstance{
    dispatch_once(&once, ^{
        sharedInstance = [self new];
        [sharedInstance setFrame:CGRectMake(0, 0, 22, 22)];
        [sharedInstance initViews];
    });
    return sharedInstance;
}

#pragma mark 初始化Views
- (void)initViews{
    _badgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _badgeButton.frame = self.bounds;
    [_badgeButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [_badgeButton addTarget:self action:@selector(shoppingBagClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_badgeButton];
    
    //设置badgeLabel
    _badgeLabel = [UILabel new];
    _badgeLabel.font = [UIFont boldSystemFontOfSize:9];
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabel.backgroundColor = [UIColor redColor];
    _badgeLabel.layer.cornerRadius = 7;
    _badgeLabel.layer.masksToBounds = YES;
    [_badgeButton addSubview:_badgeLabel];
    
    //获取购物袋数据
    [self requestCarCount];
}

#pragma mark - Get Data
#pragma mark - 获取购物袋数量信息
- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return;
        }
        self.badgeNumber = [dict[@"results"][0][@"count"] intValue];
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark 点击购物袋触发的事件
- (IBAction)shoppingBagClick:(id)sender{
    if ([_delegate respondsToSelector:@selector(returnShoppingBag:)]) {
        [_delegate returnShoppingBag:self];
    }
}

#pragma mark 添加动画效果
-(void)addShoppingBagAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@1.1, @1];
    animation.keyTimes = @[@0.1, @0.2];
    animation.duration = 0.2;
    animation.beginTime = 0;
    [_badgeLabel.layer addAnimation:animation forKey:nil];
}

#pragma mark - setting set and get
@synthesize badgeNumber = _badgeNumber;
-(void)setBadgeNumber:(NSInteger)badgeNumber{
    _badgeNumber = badgeNumber;
    
    if (badgeNumber > 0) {
        _badgeLabel.hidden = NO;
        //刷新购物袋数量
        _badgeLabel.text = [NSString stringWithFormat: @"%ld", (long)badgeNumber];
        switch (_badgeLabel.text.length) {
            case 1:
                [_badgeLabel setFrame:CGRectMake(13, -5, 14, 14)];
                [self addShoppingBagAnimation];
                break;
            case 2:
                [_badgeLabel setFrame:CGRectMake(11, -5, 19, 14)];
                [self addShoppingBagAnimation];
                break;
            case 3:
                [_badgeLabel setFrame:CGRectMake(10, -5, 22, 14)];
                _badgeLabel.text = @"99+";
                [self addShoppingBagAnimation];
                break;
            default:
                break;
        }
    }else{
        _badgeLabel.hidden = YES;
    }
}



@end
