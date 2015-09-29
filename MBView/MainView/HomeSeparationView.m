//
//  HomeSeparationView.m
//  Wefafa
//
//  Created by su on 15/4/3.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "HomeSeparationView.h"
#import "HttpRequest.h"
#import "Utils.h"

@implementation HomeSeparationView{
    UILabel *titleLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 20)/2, self.frame.size.width, 20)];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [titleLabel setText:@"有菜更有范"];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [self addSubview:titleLabel];
        
        [self requestTopicUrl];
    }
    return self;
}

- (void)requestTopicUrl
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpRequest collocationGetRequestPath:nil methodName:@"BSParamFilter" params:@{@"code":@"Log_TITLE"} success:^(NSDictionary *dict) {
            NSArray *listArr = [dict objectForKey:@"results"];
            if (listArr.count>0) {
                NSDictionary *dict = [listArr lastObject];
                NSString *collocationTitle = [[[dict objectForKey:@"paraM_VALUE"] componentsSeparatedByString:@"?"] firstObject];
                [weakSelf updateTitleLabel:collocationTitle];
            }
        } failed:^(NSError *error) {
            [weakSelf updateTitleLabel:nil];
        }];
    });
}

- (void)updateTitleLabel:(NSString *)title
{
    if (!title || [title length] == 0) {
        title = @"人人都有范";
    }
    [titleLabel setText:title];
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.0] set];
    UIRectFill([self bounds]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context, 0, 0);//设置起点
    
    CGContextAddLineToPoint(context, SCREEN_WIDTH, 0);
    
    CGContextAddLineToPoint(context, SCREEN_WIDTH, 45);
    CGContextAddLineToPoint(context, SCREEN_WIDTH/2.0+5, 45);
    CGContextAddLineToPoint(context, SCREEN_WIDTH/2, 50);
    CGContextAddLineToPoint(context, SCREEN_WIDTH/2-5, 45);
    CGContextAddLineToPoint(context, 0, 45);
    
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    
    [[Utils HexColor:0XE2E2E2 Alpha:1.0] setFill];
    //设置填充色
    
    
    [[Utils HexColor:0XE2E2E2 Alpha:1.0] setStroke];
    //设置边框颜色
    
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path

}
@end
