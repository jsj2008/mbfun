//
//  GesturesImageView.m
//  newdesigner
//
//  Created by Miaoz on 14-9-11.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "GesturesImageView.h"


@implementation GesturesImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _height = self.bounds.size.height;
        _width  = self.bounds.size.width;
        self.contentMode = UIViewContentModeScaleAspectFit;
        [self addlineView];
        [self addGestures];
        
        [self createSpinner];
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGesturesImageViewRotate:) name:@"updateGesturesImageViewRotate" object:nil];
      
    }
    return self;
}

-(void)addlineView{
    
    CGFloat borderWidth = 0.5f;
 
    self.layer.borderColor = [UIColor redColor].CGColor;
   
    self.layer.borderWidth = borderWidth;
    
    

//    if (_toplineview==nil) {
//        _toplineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
//        _toplineview.backgroundColor = [UIColor redColor];
////        _toplineview.hidden = YES;
//        [self addSubview:_toplineview];
//    }
//    if (_rightlineview == nil) {
//        _rightlineview = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-0.5, 0, 0.5, self.frame.size.height)];
//        _rightlineview.backgroundColor = [UIColor redColor];
////        _rightlineview.hidden = YES;
//        [self addSubview:_rightlineview];
//    }
//    if (_bottomlineview == nil) {
//        _bottomlineview = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
//        _bottomlineview.backgroundColor = [UIColor redColor];
////        _bottomlineview.hidden = YES;
//        [self addSubview:_bottomlineview];
//    }
//    
//    if (_leftlineview == nil) {
//        _leftlineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
//        _leftlineview.backgroundColor = [UIColor redColor];
////        _leftlineview.hidden = YES;
//        [self addSubview:_leftlineview];
//    }
}

#pragma mark--UIActivityIndicatorView
-(void)createSpinner{
    if (_spinner== nil) {
        UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        testActivityIndicator.center = self.center;//只能设置中心，不能设置大小
        _spinner = testActivityIndicator;
        [self addSubview:testActivityIndicator];
        
        [testActivityIndicator startAnimating]; // 开始旋转
        //    [testActivityIndicator stopAnimating]; // 结束旋转
        //    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }
    

}
-(void)addGestures
{
    
  
    UIRotationGestureRecognizer *tmprotationG;
    UIPinchGestureRecognizer *tmppinchGestureRecongnizer;
    UIPanGestureRecognizer *tmppanGesture;
    UITapGestureRecognizer *tmpsingleFinger;
    
    self.userInteractionEnabled = NO;
    [self setUserInteractionEnabled:YES];
    
    //旋转手势
    tmprotationG = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationImage:)];
    tmprotationG.delegate = self;
    _rotationG =tmprotationG;
    
    //缩放手势
    tmppinchGestureRecongnizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    tmppinchGestureRecongnizer.delegate = self;
    _pinchGesture = tmppinchGestureRecongnizer;
    //拖动手势
    tmppanGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panpan:)];
   
    //点击手势
    tmpsingleFinger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    tmpsingleFinger.numberOfTouchesRequired = 1;
    tmpsingleFinger.numberOfTapsRequired = 1;
    _singleFinger = tmpsingleFinger;
    
    [self addGestureRecognizer:tmppinchGestureRecongnizer];
    [self addGestureRecognizer:tmprotationG];
    [self addGestureRecognizer:tmppanGesture];
    [self addGestureRecognizer:tmpsingleFinger];
    
}
- (void)panpan:(UIPanGestureRecognizer *)sender
{
//    [self.view bringSubviewToFront:self];
    CGPoint translation = [sender translationInView:self.parentView];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x,
                                     sender.view.center.y + translation.y);
    NSLog(@"center %f----%f",sender.view.center.x,sender.view.center.y);
    [sender setTranslation:CGPointZero inView:self.parentView];
   
    //赋值
    _centerpoint =  sender.view.center;
    
    _height = self.bounds.size.height;
    _width  = self.bounds.size.width;
    if (_delegate) {
        [_delegate callBackPreviousAndNextGesturesImageViewWithview:self];
    }
    
}

- (void)changeImage:(UIPinchGestureRecognizer*)pinchGestureRecognizer
{

    NSLog(@"scale %f",pinchGestureRecognizer.scale);
    
//    //解决缩放过小问题
//    if (pinchGestureRecognizer.view.transform.a <= 0.2 &&  pinchGestureRecognizer.scale<1.0f) {
//        pinchGestureRecognizer.scale = 1;
//        return;
//    }
    
    pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    
    //赋值
    _publictransform = pinchGestureRecognizer.view.transform;
    _pinchGesturescale = pinchGestureRecognizer.scale;
    _height = self.bounds.size.height;
    _width  = self.bounds.size.width;
    if (_delegate && [_delegate respondsToSelector:@selector(callBackPreviousAndNextGesturesImageViewWithview:)]) {
        [_delegate callBackPreviousAndNextGesturesImageViewWithview:self];
    }
    pinchGestureRecognizer.scale = 1;
    
}

- (void)rotationImage:(UIRotationGestureRecognizer*)gesture
{
    //add by miao 11.18
    float a = self.transform.a;
    float d = self.transform.d;
     NSLog(@"self.transform.a------- %f",a);
    
    if (d*a < 0.000000) {
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"1"}];//改变成-
         _fliptagStr =@"1";
    }else{
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"0"}];//不改变
        _fliptagStr = @"0";
    }
    
    

    NSLog(@"rotation_fliptagStr%f %@",gesture.rotation,_fliptagStr);
    if ([_fliptagStr isEqualToString:@"1"]) {
        gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, -gesture.rotation);
    }else{
        gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
    }
    
    
    //赋值
    _publictransform =  gesture.view.transform;
    _rotationGesturerotation = gesture.rotation;
    
    _height = self.bounds.size.height;
    _width  = self.bounds.size.width;
    if (_delegate && [_delegate respondsToSelector:@selector(callBackPreviousAndNextGesturesImageViewWithview:)]) {
        [_delegate callBackPreviousAndNextGesturesImageViewWithview:self];
    }
    gesture.rotation = 0;
}

-(void)crossBorderevent
{
   
//    
    CGFloat borderWidth = 0.5f;
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = borderWidth;

//    _toplineview.hidden = NO;
//    _rightlineview.hidden = NO;
//    _bottomlineview.hidden = NO;
//    _leftlineview.hidden = NO;
//    self.clearsContextBeforeDrawing = YES;
//    CGContextClearRect(UIGraphicsGetCurrentContext(), self.frame);
//    // Drawing code.
//    UIGraphicsBeginImageContext(self.frame.size);
//    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //边缘样式
//    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);  //线宽
//    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);  //颜色
//    CGContextBeginPath(UIGraphicsGetCurrentContext());
//    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 0);  //起点坐标
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.frame.size.width, 0);   //终点坐标
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.frame.size.width, self.frame.size.height);   //终点坐标
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 0, self.frame.size.height);
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 0, 0);
//    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    self.image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
}
-(void)crossBorderDisappearevent
{
//    _toplineview.hidden = YES;
//    _rightlineview.hidden = YES;
//    _bottomlineview.hidden = YES;
//    _leftlineview.hidden = YES;

    CGFloat borderWidth = 0.5f;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = borderWidth;
    
//    self.clearsContextBeforeDrawing = YES;
//    CGContextClearRect(UIGraphicsGetCurrentContext(), self.frame);
    // Drawing code
//    UIGraphicsBeginImageContext(self.frame.size);
//    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //边缘样式
//    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);  //线宽
//    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 255.0, 255.0, 255.0, 255.0);  //颜色
//    CGContextBeginPath(UIGraphicsGetCurrentContext());
//    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 0);  //起点坐标
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.frame.size.width, 0);   //终点坐标
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.frame.size.width, self.frame.size.height);   //终点坐标
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 0, self.frame.size.height);
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 0, 0);
//    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    self.image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

}

//处理单指事件
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
 
    if (_isFirstClick == NO) {
        [self crossBorderevent];
        _isFirstClick = YES;
    }else{
    [self crossBorderDisappearevent];
        _isFirstClick = NO;
    }
    
    if (sender.numberOfTapsRequired == 1) {
        
        //单指单击
        NSLog(@"单指单击");
        if (_delegate && [_delegate respondsToSelector:@selector(callBackGesturesImageViewWithview:isFirstClickmark:)]) {
            [_delegate callBackGesturesImageViewWithview:self isFirstClickmark:!_isFirstClick];
         
            
        }
    }
}

//模型剪切
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return  YES;
}
-(void)updateGesturesImageViewRotate:(NSNotification *)notification{
   NSDictionary *dic =  notification.userInfo;
   _fliptagStr = [dic valueForKey:@"ischange"];//1是改变

}

-(void)stopSpinerAnddisappearBorderWithgesturesImageView:(GesturesImageView *)gesturesImageView{
    
    [gesturesImageView.spinner stopAnimating];
    [gesturesImageView.spinner setHidesWhenStopped:YES ];
    [gesturesImageView crossBorderDisappearevent];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateGesturesImageViewRotate" object:nil];

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//  
//  
//}


@end
