//
//  RTNoDataView.m
//  RTUIStyle
//
//  Created by yintengxiang on 13-5-27.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "RTResultMessageView.h"
#import "UIView+BGFrame.h"
#import "UIColor+BGHexColor.h"
//#import "RTButton.h"
#import "NSString+RTSizeWithFont.h"

typedef NS_ENUM(NSInteger, RTResultMessageViewState) {
    RTResultMessageViewStateNormal = 0,
    RTResultMessageViewStateDismiss,
    RTResultMessageViewStateShow,
};

@interface RTResultMessageView ()

@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UIView *visibleView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, assign) __block RTResultMessageViewState state;
@property (nonatomic, unsafe_unretained) id btnTarget;
@property (nonatomic, assign) SEL btnAction;

@end

@implementation RTResultMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        self.visibleView = [[UIView alloc] init];
        self.visibleView.backgroundColor = self.backgroundColor;
        [self addSubview:self.visibleView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
        self.titleLab.numberOfLines = 0;
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.backgroundColor = self.backgroundColor;
        self.titleLab.textColor = [UIColor colorWithHex:0x7B7B7B alpha:1];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        [self.visibleView addSubview:self.titleLab];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.userInteractionEnabled = YES;
        [self.visibleView addSubview:self.imageView];
        
        self.subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        self.subTitleLab.numberOfLines = 0;
        self.subTitleLab.textAlignment = NSTextAlignmentCenter;
        self.subTitleLab.backgroundColor = self.backgroundColor;
        self.subTitleLab.textColor = [UIColor colorWithHex:0x727272 alpha:1];
        self.subTitleLab.font = TABLECELLFONT;
        [self.visibleView addSubview:self.subTitleLab];
        
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
        
        
        self.actionBtn = [[UIButton alloc] initWithFrame:self.bounds];
        self.actionBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.actionBtn];
        
    }
    return self;
}

- (void)showInView:(UIView *)view type:(RTMessageType)type target:(id)target action:(SEL)action{
    [self showInView:view type:type target:target action:action withMsg:nil];
}

- (void)showInView:(UIView *)view type:(RTMessageType)type target:(id)target action:(SEL)action withMsg:(NSString*)sMsg{
    NSString *subTitle = [self subTitleForType:type];
    NSString *title = [self messageForType:type];
    if (sMsg.length > 0) {
        title = sMsg;
    }
    [self showInView:view title:title image:[self imageForType:type] subTitle:subTitle target:target action:action];
}

- (NSString *)subTitleForType:(RTMessageType)type{
    switch (type) {
        case RTMessageTypeNoData:
        {
            return @"请检查网络或点击屏幕重试";
        }
            break;
        case RTMessageTypeCarNoData:
        {
            return @"";
        }
            break;
        case RTMessageTypeDiscountNodata:
        {
            return @"";
        }
            break;
        case RTMessageTypeFavNodata:
        {
            return @"";
        }
            break;
        case RTMessageTypeHomeListNodata:
        {
            return @"";
        }
            break;
        case RTMessageTypeOrderNodata:
        {
            return @"";
        }
            break;
        case RTMessageTypePackNodata:
        {
            return @"";
        }
            break;
        case RTMessageTypeSearchNodata:
        {
            return @"";
        }
        case RTMessageTypeAddressNodata:
        {
            return @"";
        }
            break;
        case RTMessageTypeCommentNodata:
        {
            return @"";
        }
            break;
        case RTMessageTypePointNodata:
        {
            return @"";
        }
            break;
        case RTMessageTypeNoNetwork:
        {
            return @"";
        }
            break;
        default:
        {
            return @"";
        }
            break;
    }
}

- (NSString *)messageForType:(RTMessageType)type{
    switch (type) {
        case RTMessageTypeNoData:
        {
            return  @"暂无数据";
        }
            break;
        case RTMessageTypeCarNoData:
        {
            return  @"购物车无商品，去逛逛吧";
        }
            break;
        case RTMessageTypeSearchNodata:
        {
            return  @"未能找到商品";
        }
            break;
        case RTMessageTypePackNodata:
        {
            return  @"暂无红包";
        }
            break;
        case RTMessageTypeOrderNodata:
        {
            return  @"暂无订单";
        }
            break;
        case RTMessageTypeHomeListNodata:
        {
            return  @"暂无此类商品";
        }
            break;
        case RTMessageTypeFavNodata:
        {
            return  @"暂无收藏商品";
        }
            break;
        case RTMessageTypeDiscountNodata:
        {
            return  @"暂无打折券";
        }
            break;
        case RTMessageTypeAddressNodata:
        {
            return @"暂无收货地址";
        }
            break;
        case RTMessageTypeCommentNodata:
        {
            return @"暂无评论";
        }
            break;
        case RTMessageTypePointNodata:
        {
            return @"暂无积分";
        }
            break;
        case RTMessageTypeNoNetwork:
        {
            return @"";
        }
            break;
        default:
            return @"";
    }
}

- (UIImage *)imageForType:(RTMessageType)type{
    switch (type) {
        case RTMessageTypeNoData:
        {
            return  [UIImage imageNamed:@""];
        }
            break;
        case RTMessageTypeCarNoData:
        {
            return  [UIImage imageNamed:@"icon_shopping bag_not"];
        }
            break;
        case RTMessageTypeDiscountNodata:
        {
            return  [UIImage imageNamed:@"icon_ticket_not"];
        }
            break;
        case RTMessageTypeFavNodata:
        {
            return  [UIImage imageNamed:@"icon_collect_not"];
        }
            break;
        case RTMessageTypeHomeListNodata:
        {
            return  [UIImage imageNamed:@"icon_merchandise_not"];
        }
            break;
        case RTMessageTypeOrderNodata:
        {
            return  [UIImage imageNamed:@"icon_order_not"];
        }
            break;
        case RTMessageTypePackNodata:
        {
            return  [UIImage imageNamed:@"icon_red_not"];
        }
            break;
        case RTMessageTypeSearchNodata:
        {
            return  [UIImage imageNamed:@"icon_search_not"];
        }
            break;
        case RTMessageTypeAddressNodata:
        {
            return [UIImage imageNamed:@"icon_address_not"];
        }
            break;
        case RTMessageTypeCommentNodata:
        {
            return [UIImage imageNamed:@"icon_comment_not"];
        }
            break;
        case RTMessageTypePointNodata:
        {
            return [UIImage imageNamed:@"icon_point_not"];
        }
            break;
        case RTMessageTypeNoNetwork:
        {
            return [UIImage imageNamed:@"img_loading_failure"];
        }
            break;
        default:
            return nil;
    }
}

- (void)showInView:(UIView *)view title:(NSString *)title image:(UIImage *)image subTitle:(NSString *)subTitle target:(id)target action:(SEL)action{
    self.state = RTResultMessageViewStateShow;
    if (view != nil) {
        self.frame = view.bounds;
        self.backgroundColor = [UIColor whiteColor];
        [view addSubview:self];
        if ([view isKindOfClass:[UITableView class]]) {
            [(UITableView *)view setScrollEnabled:NO];
        }
        self.frame = CGRectMake(0, 0, view.width, view.height);
        self.alpha = 1;
    }
    CGSize visibleViewSize = CGSizeZero;    
    [self.imageView setSize:image.size];
    self.imageView.image = image;
    self.imageView.top = visibleViewSize.height;
    
    visibleViewSize = CGSizeMake(MAX(visibleViewSize.width, self.imageView.width), MAX(visibleViewSize.height, self.imageView.bottom));
    
    CGSize titleSize = [title rtSizeWithFont:self.titleLab.font constrainedToSize:CGSizeMake(self.titleLab.width, 100)];
    self.titleLab.text = title;
    self.titleLab.height = titleSize.height;
    self.titleLab.top = self.imageView.bottom+self.imageEdgeInsets.bottom+self.titleEdgeInsets.top;
    if (titleSize.height == 0) {
        self.titleLab.top -= self.imageEdgeInsets.bottom+self.titleEdgeInsets.top;
    }
    
    visibleViewSize = CGSizeMake(MAX(visibleViewSize.width, titleSize.width), self.titleLab.bottom);

    titleSize = [subTitle rtSizeWithFont:self.subTitleLab.font constrainedToSize:CGSizeMake(self.subTitleLab.width, 100)];
    self.subTitleLab.text = subTitle;
//    self.subTitleLab.height = titleSize.height;
    if (titleSize.height>0) {
        self.subTitleLab.top = self.titleLab.bottom+4;
        visibleViewSize = CGSizeMake(MAX(visibleViewSize.width, titleSize.width), self.subTitleLab.bottom);
    }

    [self.visibleView setSize:visibleViewSize];
    
    if (action == nil) {
        self.actionBtn.hidden = YES;
    }else{
        self.actionBtn.hidden = NO;
        [self.actionBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
  
    self.visibleView.center = CGPointMake(self.center.x, self.center.y - 50);//self.center;
    
    self.imageView.centerX = self.visibleView.width/2;
    self.titleLab.centerX = self.visibleView.width/2;
    self.subTitleLab.centerX = self.visibleView.width/2;
    

}

- (void)dismiss{
    [self dismissAnimation:NO];
}

- (void)dismissAnimation:(BOOL)animation{
    if (self.state == RTResultMessageViewStateDismiss) {
        return;
    }
    self.state = RTResultMessageViewStateDismiss;
    if (self.superview != nil) {
        if (animation) {
            [UIView animateWithDuration:.35 animations:^{
            } completion:^(BOOL finished) {
                if ([self.superview isKindOfClass:[UITableView class]]) {
                    [(UITableView *)self.superview setScrollEnabled:YES];
                }
                if (finished) {
                    [self removeFromSuperview];
                    self.state = RTResultMessageViewStateNormal;
                }
            }];
        }else{
            if ([self.superview isKindOfClass:[UITableView class]]) {
                [(UITableView *)self.superview setScrollEnabled:YES];
            }
            [self removeFromSuperview];
            self.state = RTResultMessageViewStateNormal;
        }
    }
}


@end
