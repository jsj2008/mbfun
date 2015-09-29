//
//  LaunchScreenView.m
//  Wefafa
//
//  Created by Jiang on 3/12/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "LaunchScreenView.h"

@implementation LaunchScreenView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *wenziImage = [UIImage imageNamed:@"wenziImageNew.png"];
        UIImage *shiziImage = [UIImage imageNamed:@"shiziImageNew.png"];
//        UIImage *shiziImageWhite = [UIImage imageNamed:@"shiziImageWhite.png"];
        UIImage *wenzijiaAll = nil;
        if (UI_SCREEN_HEIGHT == 480) {
            wenzijiaAll = [UIImage imageNamed:@"wenzinone4s.png"];
        }else{
            wenzijiaAll = [UIImage imageNamed:@"wenzinone5s.png"];
        }
        UIImageView *wenziImageView = [[UIImageView alloc]initWithImage:wenziImage];
        UIImageView *shiziImageView = [[UIImageView alloc]initWithImage:shiziImage];
//        UIImageView *shiziImageViewWhite = [[UIImageView alloc]initWithImage:shiziImageWhite];
//        UIImageView *wenzijiaAllView = [[UIImageView alloc]initWithImage:wenzijiaAll];
        
        wenziImageView.bounds = CGRectMake(0, 0, 75.0, 50.0);
        wenziImageView.center = self.center;
//        wenzijiaAllView.frame = self.bounds;
        
        CGRect rect = CGRectMake(0, 0, 13.0, 13.0);
        rect.origin = CGPointMake(self.centerX + 25, self.centerY - 23);
        shiziImageView.frame = rect;
//        shiziImageViewWhite.frame = rect;
        
        shiziImageView.layer.magnificationFilter = kCAFilterNearest;
        shiziImageView.layer.minificationFilter = kCAFilterNearest;
//        shiziImageViewWhite.layer.magnificationFilter = kCAFilterNearest;
//        shiziImageViewWhite.layer.minificationFilter = kCAFilterNearest;
        [self addSubview:wenziImageView];
        [self addSubview:shiziImageView];
//        [self addSubview:shiziImageViewWhite];
//        [self addSubview:wenzijiaAllView];
        self.shiziImageView = shiziImageView;
//        self.shiziImageWhiteView = shiziImageViewWhite;
        self.wenziImageView = wenziImageView;
//        self.wenzijiaAllView = wenzijiaAllView;
    }
    return self;
}

@end
