//
//  TotalGroupView.m
//  Wefafa
//
//  Created by Miaoz on 14/12/9.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "TotalGroupView.h"
#import "SingleGroupView.h"
#define ViewOffset 140

#define viewwh 140

@implementation TotalGroupView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (_viewImageArray == nil)
        {
            _viewImageArray  = [NSArray new];
        }
        if (_viewArray == nil)
        {
            _viewArray = [NSMutableArray new];
        }
        [self creatMainView];
    }
    return self;
}

-(void)creatMainView{
    _viewImageArray = @[[UIImage imageNamed:DEFAULT_APPLICATION_ICON],[UIImage imageNamed:DEFAULT_APPLICATION_ICON],[UIImage imageNamed:DEFAULT_APPLICATION_ICON],[UIImage imageNamed:DEFAULT_APPLICATION_ICON]];
    for (int i = 0;i < 4 ; i++) {
        
        SingleGroupView *singleGroupView = [[SingleGroupView alloc] initWithFrame:CGRectMake(0, 0, viewwh, viewwh)];
        singleGroupView.image = _viewImageArray[i];
        singleGroupView.tag = 666+i;
        
        [self addSubview:singleGroupView];
        [_viewArray addObject:singleGroupView];
        
    }

    switch (_viewArray.count) {
        case 1:{
            SingleGroupView *vi =  _viewArray[0];
            vi.center = CGPointMake(viewwh/2+ViewOffset/2, viewwh/2+ViewOffset/2);
            break;
        }
        case 2:{
            SingleGroupView *vi =  _viewArray[0];
            SingleGroupView *vi1 =  _viewArray[1];
            vi.center = CGPointMake(viewwh/2+ViewOffset/6, viewwh/2+ViewOffset/6);
            vi1.center = CGPointMake(vi.center.x+viewwh/2+ViewOffset/8,vi.center.y+viewwh/2+ViewOffset/8);
            break;
        }
        case 3:{
            SingleGroupView *vi =  _viewArray[0];
            SingleGroupView *vi1 =  _viewArray[1];
            SingleGroupView *vi2 =  _viewArray[2];
            vi.center = CGPointMake(viewwh/2+ViewOffset/2, viewwh/2 );
            vi1.center = CGPointMake(viewwh/2+ViewOffset, viewwh/2+ViewOffset);
            vi2.center = CGPointMake(viewwh/2, viewwh/2+ ViewOffset);
            
            break;
        }
        case 4:{
            SingleGroupView *vi  =  _viewArray[0];
            SingleGroupView *vi1 =  _viewArray[1];
            SingleGroupView *vi2 =  _viewArray[2];
            SingleGroupView *vi3 =  _viewArray[3];
            vi.center = CGPointMake(viewwh/2, viewwh/2 );
            vi1.center = CGPointMake(viewwh/2+ViewOffset, viewwh/2+ViewOffset);
            vi2.center = CGPointMake(viewwh/2, viewwh/2+ ViewOffset);
            vi3.center = CGPointMake(viewwh/2+ViewOffset, viewwh/2);
            break;
        }
        default:
            break;
    }
    [self.layer addAnimation:[self scaleAnimation] forKey:@"transform"];
}

- (CAAnimation*)scaleAnimation{
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.duration = 0.1;
    scaleAnim.repeatCount = 1;
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)];
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.fillMode = kCAFillModeForwards;
    return scaleAnim;
}



@end
