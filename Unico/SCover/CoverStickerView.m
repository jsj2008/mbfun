//
//  CoverStickerView.m
//  StoryCam
//
//  Created by Ryan on 15/4/2.
//  Copyright (c) 2015年 Unico. All rights reserved.
//  TODO: 移动和缩放不是特别好
//        各种分辨率的识别。
//

#import "CoverStickerView.h"
#import "CoverEditViewController.h"
#import "NSDictionary+StickerData.h"
#import "UIImage+SizeColor.h"
#import "DoImagePickerController.h"
#import <QuartzCore/QuartzCore.h>
#import "SUtilityTool.h"

CG_INLINE CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

// 暂时没用到
//CG_INLINE CGPoint CGPointRorate(CGPoint point, CGPoint basePoint, CGFloat angle)
//{
//    CGFloat x = cos(angle) * (point.x - basePoint.x) - sin(angle) * (point.y - basePoint.y) + basePoint.x;
//    CGFloat y = sin(angle) * (point.x - basePoint.x) + cos(angle) * (point.y - basePoint.y) + basePoint.y;
//
//    return CGPointMake(x, y);
//}
//
//CG_INLINE CGRect CGRectSetCenter(CGRect rect, CGPoint center)
//{
//    return CGRectMake(center.x - CGRectGetWidth(rect) / 2, center.y - CGRectGetHeight(rect) / 2, CGRectGetWidth(rect), CGRectGetHeight(rect));
//}

CG_INLINE CGRect CGRectScale(CGRect rect, CGFloat wScale, CGFloat hScale)
{
    return CGRectMake(rect.origin.x * wScale, rect.origin.y * hScale, rect.size.width * wScale, rect.size.height * hScale);
}

CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2)
{
    //Saving Variables.
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);

    return sqrt((fx * fx + fy * fy));
}

CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t)
{
    return atan2(t.b, t.a);
}

CG_INLINE CGSize CGAffineTransformGetScale(CGAffineTransform t)
{
    return CGSizeMake(sqrt(t.a * t.a + t.c * t.c), sqrt(t.b * t.b + t.d * t.d));
}

__strong static CoverStickerView* lastTouchedView;

@implementation CoverStickerView {
    CGFloat _globalInset;

    CGRect initialBounds;
    CGFloat initialDistance;
    
    CGRect initialTagViewBounds;

    CGPoint beginningPoint;
    CGPoint beginningCenter;

    CGPoint prevPoint;
    CGPoint touchLocation;

    CGFloat deltaAngle;

    CGAffineTransform startTransform;
    CGRect beginBounds;

    CAShapeLayer* border;

    CAShapeLayer* svgLayer;
}

@synthesize contentView = _contentView;
@synthesize enableClose = _enableClose;
@synthesize enableResize = _enableResize;
@synthesize enableRotate = _enableRotate;
@synthesize delegate = _delegate;
@synthesize showContentShadow = _showContentShadow;

+ (CoverStickerView*)currentEditView
{
    return lastTouchedView;
}

- (void)refresh
{
    if (self.superview) {
        
        if (_type != CoverStickerTypeText) {
            [self adjustsWidthToFillItsContents];
        }
        
        CGSize scale = CGAffineTransformGetScale(self.superview.transform);
        CGAffineTransform t = CGAffineTransformMakeScale(scale.width, scale.height);
        [closeView setTransform:CGAffineTransformInvert(t)];
        [resizeView setTransform:CGAffineTransformInvert(t)];
        [rotateView setTransform:CGAffineTransformInvert(t)];

        _contentView.alpha = _contentAlpha;

        if (_isShowingEditingHandles)
            [_contentView.layer setBorderWidth:1 / scale.width];
        else
            [_contentView.layer setBorderWidth:0.0];
        
        if (_shape) {
            // 更改颜色也需要update shape。
            UIImage* img = [UIImage imageNamed:_shape];
//            [img changeColor:_textColor];
            [(UIImageView*)self.contentView setImage:img];
        }
        
        if (_type == CoverStickerTypeTag) {
            [_contentView.layer setBorderWidth:0.0];
        }
        
        [self setNeedsDisplay];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self refresh];
}

- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    [self refresh];
}

- (id)initWithFrame:(CGRect)frame
{
    /*(1+_globalInset*2)*/
    if (frame.size.width < (1 + 12 * 2))
        frame.size.width = 25;
    if (frame.size.height < (1 + 12 * 2))
        frame.size.height = 25;

    self = [super initWithFrame:frame];
    if (self) {
        _globalInset = 12;
        _text = nil;
        _font = nil;
        _textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _contentAlpha = 1.0;
        _textVerticalPadding = 1.0;
        _textHorizontalPadding = 1.0;

        //        self = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
        self.backgroundColor = [UIColor clearColor];

        //Close button view which is in top left corner
        closeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _globalInset * 2, _globalInset * 2)];
        [closeView setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
        closeView.backgroundColor = [UIColor clearColor];
        closeView.image = [UIImage imageNamed:@"Unico/stick_delete"];
        closeView.userInteractionEnabled = YES;
        [self addSubview:closeView];

        //Rotating view which is in bottom left corner
        rotateView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - _globalInset * 2, self.bounds.size.height - _globalInset * 2, _globalInset * 2, _globalInset * 2)];
        [rotateView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin)];
        rotateView.backgroundColor = [UIColor clearColor];
        rotateView.image = [UIImage imageNamed:@"Unico/stick_resize"];
        rotateView.userInteractionEnabled = YES;
        [self addSubview:rotateView];

        //Resizing view which is in bottom right corner
        resizeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - _globalInset * 2, _globalInset * 2, _globalInset * 2)];
        [resizeView setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin)];
        resizeView.backgroundColor = [UIColor clearColor];
        resizeView.userInteractionEnabled = YES;
        resizeView.image = [UIImage imageNamed:@"Unico/stick_resize"];

        //        if (_text) {
        //            // 这里_text没有初始化，所以要么用type实现
        //            resizeView.image = [UIImage imageNamed:@"btn_stick_edit"];
        //        }
        //        else {
        //            resizeView.image = [UIImage imageNamed:@"btn_stick_scale"];
        //        }
        [self addSubview:resizeView];

        //        UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
        //        doubleTapGesture.numberOfTapsRequired = 2;
        //        [self addGestureRecognizer:doubleTapGesture];

        UILongPressGestureRecognizer* moveGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
        // for double tap
        [moveGesture setMinimumPressDuration:0];
        [self addGestureRecognizer:moveGesture];
        

        UITapGestureRecognizer* singleTapShowHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)];
        [self addGestureRecognizer:singleTapShowHide];
        
        [moveGesture requireGestureRecognizerToFail:singleTapShowHide];

        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [closeView addGestureRecognizer:singleTap];

        UILongPressGestureRecognizer* panResizeGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(resizeTranslate:)];
        [panResizeGesture setMinimumPressDuration:0];
        [resizeView addGestureRecognizer:panResizeGesture];

        UILongPressGestureRecognizer* panRotateGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rotateViewPanGesture:)];
        [panRotateGesture setMinimumPressDuration:0];
        [rotateView addGestureRecognizer:panRotateGesture];

        //        [panRotateGesture requireGestureRecognizerToFail:moveGesture];
        [moveGesture requireGestureRecognizerToFail:singleTap];

        [self setEnableClose:YES];
        [self setEnableResize:NO];// 其实是编辑按钮，暂时关闭。
        [self setEnableRotate:YES];
        [self setShowContentShadow:NO];

        [self hideEditingHandles];
    }
    return self;
}

#define kTagViewTag 100

- (void)setFlip:(BOOL)flip
{
    [self setFlip:flip animated:NO];
}


- (void)setFlip:(BOOL)flip animated:(BOOL)animated
{
    _flip = flip;
    
    if (animated)
    {
        if (flip)
        {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.layer.transform = CATransform3DRotate(self.layer.transform, 3.1415926, 0, 1, 0);
                
                UIView *tagView = [self.contentView viewWithTag:kTagViewTag];
                
                for (UIView *subView in [tagView subviews])
                {
                    if ([subView class] == [UILabel class])//保证标签里面得到字不要翻转
                    {
                        subView.layer.transform = CATransform3DRotate(subView.layer.transform, 3.1415926, 0, 1, 0);
                    }
                }
                
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.layer.transform = CATransform3DIdentity;
                
                UIView *tagView = [self.contentView viewWithTag:kTagViewTag];
                
                for (UIView *subView in [tagView subviews])
                {
                    if ([subView class] == [UILabel class])//保证标签里面得到字不要翻转
                    {
                        subView.layer.transform = CATransform3DIdentity;
                    }
                }
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else
    {
        if (flip)
        {
            self.layer.transform = CATransform3DRotate(self.layer.transform, 3.1415926, 0, 1, 0);
            
            UIView *tagView = [self.contentView viewWithTag:kTagViewTag];
            
            for (UIView *subView in [tagView subviews])
            {
                if ([subView class] == [UILabel class])//保证标签里面得到字不要翻转
                {
                    subView.layer.transform = CATransform3DRotate(subView.layer.transform, 3.1415926, 0, 1, 0);
                }
            }
        }
        else
        {
            self.layer.transform = CATransform3DIdentity;
            
            UIView *tagView = [self.contentView viewWithTag:kTagViewTag];
            
            for (UIView *subView in [tagView subviews])
            {
                if ([subView class] == [UILabel class])//保证标签里面得到字不要翻转
                {
                    subView.layer.transform = CATransform3DIdentity;
                }
            }
        }
    }
}

- (void)contentTapped:(UITapGestureRecognizer*)tapGesture
{
    //这里的逻辑现在变成：单击一下、如果是标签、水平翻转一次，如果是贴纸则不用处理 - 陈诚 2015-07-01
    if (self.type == CoverStickerTypeTag)
    {
        if (!_isShowingEditingHandles)
        {
            [self showEditingHandles];
        }
        [self setFlip:!_flip animated:YES];
    }
    else
    {
        if (_isShowingEditingHandles)
        {
            [self hideEditingHandles];
            [self.superview bringSubviewToFront:self];
        }
        else
        {
            [self showEditingHandles];
        }
    }
}

- (void)setEnableClose:(BOOL)enableClose
{
    _enableClose = enableClose;
    [closeView setHidden:!_enableClose];
    [closeView setUserInteractionEnabled:_enableClose];
}

- (void)setEnableResize:(BOOL)enableResize
{
    _enableResize = enableResize;
    [resizeView setHidden:!_enableResize];
    [resizeView setUserInteractionEnabled:_enableResize];
}

- (void)setEnableRotate:(BOOL)enableRotate
{
    _enableRotate = enableRotate;
    [rotateView setHidden:!_enableRotate];
    [rotateView setUserInteractionEnabled:_enableRotate];
}

- (void)setShowContentShadow:(BOOL)showContentShadow
{
    _showContentShadow = showContentShadow;

    if (_showContentShadow) {
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOffset:CGSizeMake(0, 1)];
        [self.layer setShadowOpacity:1.0];
        [self.layer setShadowRadius:1.0];
    }
    else {
        [self.layer setShadowColor:[UIColor clearColor].CGColor];
        [self.layer setShadowOffset:CGSizeZero];
        [self.layer setShadowOpacity:0.0];
        [self.layer setShadowRadius:0.0];
    }
}

- (void)hideEditingHandles
{
    if (lastTouchedView == self) {
        lastTouchedView = nil;
    }

    _isShowingEditingHandles = NO;

    if (_enableClose)
        closeView.hidden = YES;
    if (_enableResize)
        resizeView.hidden = YES;
    if (_enableRotate)
        rotateView.hidden = YES;

    [self refresh];

//    if ([_delegate respondsToSelector:@selector(stickerViewDidHideEditingHandles:)])
//        [_delegate stickerViewDidHideEditingHandles:self];
}

- (void)showEditingHandles
{
    [lastTouchedView hideEditingHandles];

    _isShowingEditingHandles = YES;

    __strong __typeof(self) strongSelf = self;
    lastTouchedView = strongSelf;
    

    if (_enableClose)
        closeView.hidden = NO;
    if (_enableResize)
        resizeView.hidden = NO;
    if (_enableRotate)
        rotateView.hidden = NO;

    [self refresh];

    border = [CAShapeLayer layer];
    border.strokeColor = [UIColor whiteColor].CGColor;
    border.fillColor = nil;
    border.lineDashPattern = @[ @4, @3 ];

    if ([_delegate respondsToSelector:@selector(stickerViewDidShowEditingHandles:)])
        [_delegate stickerViewDidShowEditingHandles:self];
}

- (BOOL)isTextVertical{
    if (_type == CoverStickerTypeText && [_text rangeOfString:@"\n"].length > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)textDirection{
    if (_type == CoverStickerTypeText && [_text rangeOfString:@"\n"].length > 0) {
        return YES;
    }
    return NO;
}

// YES = 竖直。
- (void)setTextDirection:(BOOL)textDirection{
    if (textDirection) {
        // 竖方向
        NSString* text = _text;
        if (text) {
            // 临时处理。
            NSString* str1 = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, text.length)];
            NSMutableString* str = [NSMutableString stringWithString:str1];
            for (long i = [str length]; i > 0; i--) {
                [str insertString:@"\n" atIndex:i];
            }
            self.text = str;
        }
    } else {
        NSString* text = [CoverStickerView currentEditView].text;
        NSString* str = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, text.length)];
        self.text = str;
    }
}

// 不带换行的文字。
- (NSString*)plainText {
    NSString* text = [CoverStickerView currentEditView].text;
    NSString* str = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, text.length)];
    return str;
}


#pragma mark - tag的info根据数据库结构来返回
/*
 +-------+    +-------------------+
 |       |  /                     |
 |   o   | o       label          |
 |       |  \                     |
 +-------+    +-------------------+
左上角为 (0,0)，所以需要加上一个偏移
 */
- (NSDictionary*)getInfo{
    if (_type == CoverStickerTypeTag) {
        
        
        NSString *flipString = nil;
        
        float x = 0;
        
        NSLog(@"getInfo self.frame.origin.x = %f", self.frame.origin.x);
        
        if (self.flip)
        {
            flipString = @"1";
            x = self.frame.origin.x - 20;
        }
        else
        {
            flipString = @"0";
            x = self.frame.origin.x + _globalInset;
        }
        
        
        return @{
                 @"x":@(x),
                 @"y":@(self.frame.origin.y + _globalInset),
                 @"text":_tagName,
                 @"attributes":@{
                         @"type":@(_tagType),
                         @"id":_tagKey,
                         @"flip":flipString
                         }
                 };
    }
    
    
    // frame,bounds,transform,text,font,uiimage,shadow
    NSMutableDictionary* info = [NSMutableDictionary dictionary];
    [info setValue:[NSNumber numberWithInt:_type] forKey:@"type"];
    [info setValue:[NSNumber numberWithInt:_lock] forKey:@"lock"];
    //frame不需要存储
    //    [info setValue:[NSDictionary dictionaryWithCGRect:self.frame] forKey:@"frame"];
    [info setValue:[NSDictionary dictionaryWithCGPoint:self.center] forKey:@"center"];
    [info setValue:[NSDictionary dictionaryWithCGRect:self.bounds] forKey:@"bounds"];
    [info setValue:[NSDictionary dictionaryWithCGAffineTransform:self.transform] forKey:@"transform"];
    [info setValue:[NSNumber numberWithFloat:_contentAlpha] forKey:@"alpha"];
    [info setValue:[NSNumber numberWithBool:_showContentShadow] forKey:@"shadow"];
    
    [info setValue:[NSNumber numberWithFloat:_textHorizontalPadding] forKey:@"textHorizontalPadding"];
    [info setValue:[NSNumber numberWithFloat:_textVerticalPadding] forKey:@"textVerticalPadding"];

    // 不管是不是text、，都记录颜色
    [info setValue:[NSDictionary dictionaryWithUIColor:self.textColor] forKey:@"textColor"];

    if (self.text && self.text.length > 0) {
        NSData* nsdata = [self.text
            dataUsingEncoding:NSUTF8StringEncoding];
        NSString* base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        [info setValue:base64Encoded forKey:@"text"];
    }
    if (self.font) {
        [info setValue:[NSDictionary dictionaryWithUIFont:self.font] forKey:@"font"];
    }

    if (self.shape) {
        [info setValue:self.shape forKey:@"shape"];
    }
    else {
        UIImage* img = ((UIImageView*)self.contentView).image;
        if (img) {
            [info setValue:[NSDictionary dictionaryWithCGSize:img.size] forKey:@"imageSize"];
            // just save a place holder is OK.
        }
    }

    NSLog(@"%@", info);

    return info;
}

// TODO: 存储后读取还是坐标不对。
- (void)setInfo:(NSDictionary*)info
{
    NSLog(@"Load info:%@", info);
    //注意 矩阵变换不要使用frame
    //矩阵只要注意transform bounds 和 anchorPoint
    //在没有修改过anchorPoint情况下默认是{0.5,0.5}
    //注意顺序
    self.bounds = [[info objectForKey:@"bounds"] CGRectValue];
    self.center = [[info objectForKey:@"center"] CGPointValue];
    self.transform = [[info objectForKey:@"transform"] CGAffineTransformValue];

    self.lock = [[info objectForKey:@"lock"] intValue];
    self.type = [[info objectForKey:@"type"] intValue];
    self.textColor = [[info objectForKey:@"textColor"] UIColorValue];
    self.font = [[info objectForKey:@"font"] UIFontValue];
    self.showContentShadow = [[info objectForKey:@"shadow"] boolValue];
    
    self.textHorizontalPadding = [[info objectForKey:@"textHorizontalPadding"] floatValue];
    self.textVerticalPadding = [[info objectForKey:@"textVerticalPadding"] floatValue];


    UIImage* img = nil;
    UIImageView* imageView = [[UIImageView alloc] initWithImage:img];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self setContentView:imageView];
    if ([info objectForKey:@"shape"]) {

        [self setShape:[info objectForKey:@"shape"]];
    }
    if ([info objectForKey:@"imageSize"]) {
        CGSize size = [[info objectForKey:@"imageSize"] CGSizeValue];
        img = [UIImage imageWithSize:size andColor:[UIColor whiteColor]];
        [self setImage:img];
    }

    self.contentAlpha = [[info objectForKey:@"alpha"] floatValue];

    // todo: fixme 这里解决一下问题。

    // 尝试再设一次
    //因为emoji的缘故 用base64
    if ([info objectForKey:@"text"]) {
        NSData* nsdataFromBase64String = [[NSData alloc]
            initWithBase64EncodedString:[info objectForKey:@"text"]
                                options:0];

        // Decoded NSString from the NSData
        NSString* base64DecodedStr = [[NSString alloc]
            initWithData:nsdataFromBase64String
                encoding:NSUTF8StringEncoding];
        self.text = base64DecodedStr;
    }

    [self setNeedsDisplay];
    //    [self refresh];
}

- (id)initWithInfo:(NSDictionary*)info
{
    self = [self init];
    if (self != nil) {
        [self setInfo:info];
    }
    return self;
}

- (void)setContentView:(UIView*)contentView
{
    [_contentView removeFromSuperview];

    _contentView = contentView;

    _contentView.frame = CGRectInset(self.bounds, _globalInset, _globalInset);

    [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    // 红色的背景调试下感觉感觉。
//    _contentView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.0];
//     189, 244, 255, 0.9
    _contentView.layer.borderColor = [UIColor blackColor].CGColor;
    _contentView.layer.borderWidth = 1.0f;
    [self insertSubview:_contentView atIndex:0];
}

- (void)singleTap:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"singleTap");
    
    [self hideEditingHandles];
    if (lastTouchedView == self) {
        lastTouchedView = nil;
    }
    [self removeFromSuperview];

    if ([_delegate respondsToSelector:@selector(stickerViewDidClose:)]) {
        [_delegate stickerViewDidClose:self];
    }
}

- (void)moveGesture:(UIPanGestureRecognizer*)recognizer
{
    NSLog(@"moveGesture");
    touchLocation = [recognizer locationInView:self.superview];

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self showEditingHandles];
        [[self superview] bringSubviewToFront:self];
        //        [lastTouchedView hideEditingHandles];
        beginningPoint = touchLocation;
        beginningCenter = self.center;

       // [self setCenter:CGPointMake(beginningCenter.x + (touchLocation.x - beginningPoint.x), beginningCenter.y + (touchLocation.y - beginningPoint.y))];

        beginBounds = self.bounds;

        //        [UIView animateWithDuration:0.1 animations:^{
        //            [self setBounds:CGRectMake(0, 0, 100, 100)];
        //        }];

        if ([_delegate respondsToSelector:@selector(stickerViewDidBeginEditing:)])
            [_delegate stickerViewDidBeginEditing:self];
    }

    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        //self.layer.borderColor = [UIColor redColor].CGColor;
        //self.layer.borderWidth = 2;
        
        
        
        
        CGPoint newCenter;
        
        newCenter.x = beginningCenter.x + (touchLocation.x - beginningPoint.x);
        newCenter.y = beginningCenter.y + (touchLocation.y - beginningPoint.y);
        
        self.center = [self adjustCenter:newCenter];

        if ([_delegate respondsToSelector:@selector(stickerViewDidChangeEditing:)])
            [_delegate stickerViewDidChangeEditing:self];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {

       // [self setCenter:CGPointMake(beginningCenter.x + (touchLocation.x - beginningPoint.x), beginningCenter.y + (touchLocation.y - beginningPoint.y))];

        //        [UIView animateWithDuration:0.1 animations:^{
        //            [self setBounds:beginBounds];
        //        }];

        if ([_delegate respondsToSelector:@selector(stickerViewDidEndEditing:)])
            [_delegate stickerViewDidEndEditing:self];
    }

    prevPoint = touchLocation;
}

//调整中心，避免出现在图片或视频区域之外
- (CGPoint)adjustCenter:(CGPoint)center
{
    float k = 0;
    
    if (self.moveSize.height > 0 && self.moveSize.width > 0)
    {
        k = self.moveSize.height/self.moveSize.width;
    }
    
    NSLog(@"k = %f", k);
    
    float maxHeight = k * self.superview.width;
    
    CGPoint newCenter;
    
    newCenter.x = center.x;
    newCenter.y = center.y;
    
    if (self.type == CoverStickerTypeTag && k > 0)
    {
        if (self.flip)
        {
            
            if (newCenter.x < self.width/2.0+20)
            {
                newCenter.x = self.width/2.0+20;
            }
            if (newCenter.x > self.superview.width - self.width/2.0)
            {
                newCenter.x = self.superview.width - self.width/2.0;
            }
        }
        else
        {
            if (newCenter.x < self.width/2.0)
            {
                newCenter.x = self.width/2.0;
            }
            if (newCenter.x > self.superview.width - self.width/2.0 - 20)
            {
                newCenter.x = self.superview.width - self.width/2.0 - 20;
            }
        }
        
        if (newCenter.y < (self.superview.height/2.0 - maxHeight/2.0) + self.height/2.0)
        {
            newCenter.y = (self.superview.height/2.0 - maxHeight/2.0) + self.height/2.0;
        }
        if (newCenter.y > (self.superview.height/2.0 + maxHeight/2.0) - self.height/2.0 + 15)
        {
            newCenter.y = (self.superview.height/2.0 + maxHeight/2.0) - self.height/2.0 + 15;
        }
    }

    return newCenter;
}

- (void)resizeTranslate:(UIPanGestureRecognizer*)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        // 确保再次选中自己。
        [self showEditingHandles];

        if (_type == CoverStickerTypeText) {
            // text
            [[CoverEditViewController sharedVC] editText];
        }
        else if (_type == CoverStickerTypeShape) {
            // shape
            [[CoverEditViewController sharedVC] showShapeSelect];
        }
        else {
            // image
            [[CoverEditViewController sharedVC] showCustomLibray];
        }
    }
}

- (void)rotateViewPanGesture:(UIPanGestureRecognizer*)recognizer
{
    touchLocation = [recognizer locationInView:self.superview];

    CGPoint center = CGRectGetCenter(self.frame);

    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        deltaAngle = atan2(touchLocation.y - center.y, touchLocation.x - center.x) - CGAffineTransformGetAngle(self.transform);

        initialBounds = self.bounds;
        
        initialDistance = CGPointGetDistance(center, touchLocation);

        if ([_delegate respondsToSelector:@selector(stickerViewDidBeginEditing:)])
            [_delegate stickerViewDidBeginEditing:self];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        
        float ang = atan2(touchLocation.y - center.y, touchLocation.x - center.x);

        float angleDiff = deltaAngle - ang;
        //        float angleDiff = -ang;
        [self setTransform:CGAffineTransformMakeRotation(-angleDiff)];
        
        [self setNeedsDisplay];

        //Finding scale between current touchPoint and previous touchPoint
        double scale = sqrtf(CGPointGetDistance(center, touchLocation) / initialDistance);

        CGRect scaleRect = CGRectScale(initialBounds, scale, scale);

        if (scaleRect.size.width >= (1 + _globalInset * 2) && scaleRect.size.height >= (1 + _globalInset * 2)) {
            
            [self setBounds:scaleRect];

            [self adjustsFontSizeToFillRect:scaleRect];
        }

        if ([_delegate respondsToSelector:@selector(stickerViewDidChangeEditing:)])
            [_delegate stickerViewDidChangeEditing:self];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
        // end后，重设字体尺寸
        if (_type == CoverStickerTypeText) {
            [self adjustsWidthToFillItsContents];
        }
        if ([_delegate respondsToSelector:@selector(stickerViewDidEndEditing:)])
            [_delegate stickerViewDidEndEditing:self];
    }
}


#pragma mark - 绘制文字

- (void)drawRect:(CGRect)rect
{

    [super drawRect:rect];

    if (self.text == nil || [self.text length] <= 0 || !self.font) {
        return;
    }
    //画文字，设置文字内容

    NSDictionary* attr = [self getTextAttr];

    CGSize size = [_text sizeWithAttributes:attr];
    

    [_text drawAtPoint:self.contentView.frame.origin withAttributes:attr];
}

- (NSDictionary*)getTextAttr
{
    return [self textAttrWithFontSize:_font.pointSize];
}

- (NSDictionary*)textAttrWithFontSize:(float)size
{
    //画文字，设置文字内容
    //设置字体大小
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentJustified;
    paragraph.lineHeightMultiple = _textVerticalPadding;
    paragraph.hyphenationFactor = 1.0;
    UIFont* font = [UIFont fontWithName:self.font.fontName size:size];

    NSDictionary* attr = @{
        NSFontAttributeName : font,
        NSForegroundColorAttributeName : _textColor,
        NSParagraphStyleAttributeName : paragraph,
        NSKernAttributeName : [NSNumber numberWithFloat:_textHorizontalPadding]
    };
    return attr;
}


#pragma mark - 计算字体大小，适应自己的bounds
#define CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE 200
#define CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE 1

- (void)adjustsFontSizeToFillRect:(CGRect)newBounds
{
    if (!_text) {
        return;
    }
    
    NSLog(@"Bound x:%f",newBounds.origin.x);
    NSLog(@"Bound y:%f",newBounds.origin.y);
    NSLog(@"Bound w:%f",newBounds.size.width);
    NSLog(@"Bound h:%f",newBounds.size.height);

    for (int i = CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE; i > CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE; i--) {
        //        UIFont* font = [UIFont fontWithName:self.font.fontName size:(CGFloat)i];
        NSDictionary* attr = [self textAttrWithFontSize:(float)i];
        NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:_text
                                                                             attributes:attr];
        CGSize fitSize;
        if ([self isTextVertical]) {
            fitSize = CGSizeMake( CGFLOAT_MAX, CGRectGetHeight(newBounds) - _globalInset*2);
            CGRect rectSize = [attributedText boundingRectWithSize:fitSize
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil];
            if (CGRectGetWidth(rectSize) <= CGRectGetWidth(newBounds) - _globalInset*2) {
                _font = [UIFont fontWithName:self.font.fontName size:(CGFloat)i];
                break;
            }
        } else {
            fitSize = CGSizeMake(CGRectGetWidth(newBounds) - _globalInset*2, CGFLOAT_MAX);
            CGRect rectSize = [attributedText boundingRectWithSize:fitSize
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil];
            if (CGRectGetHeight(rectSize) <= CGRectGetHeight(newBounds) - _globalInset*2) {
                _font = [UIFont fontWithName:self.font.fontName size:(CGFloat)i];
                break;
            }
        }

    }
}

- (void)adjustsWidthToFillItsContents
{
    if (!_type == CoverStickerTypeText) {

        UIImage* image = ((UIImageView*)self.contentView).image;
        if (!image) {
            return;
        }
        CGImageRef imgRef = image.CGImage;
        float imgW = CGImageGetWidth(imgRef);
        float imgH = CGImageGetHeight(imgRef);
        CGRect bounds = self.bounds;
        bounds.size.width = bounds.size.height / imgH * imgW;
        self.bounds = bounds;
        return;
    }
    if (!_text || !_font) {
        return;
    }
    
    NSDictionary* attr = [self getTextAttr];
    NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:_text
                                                                        attributes:attr];
    
    CGSize fitSize;
    CGRect rectSize;
    if (![self isTextVertical]) {
        fitSize = CGSizeMake( CGFLOAT_MAX, _font.pointSize );
        rectSize = [attributedText boundingRectWithSize:fitSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
        
    } else {
        fitSize = CGSizeMake(_font.pointSize, CGFLOAT_MAX);
        rectSize = [attributedText boundingRectWithSize:fitSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
        
    }

//    CGSize size = CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.frame) - 24);
//    if ([_text rangeOfString:@"\n"].length > 0) {
//        size = CGSizeMake(CGRectGetWidth(self.frame) - 24, CGFLOAT_MAX);
//    }
//    CGRect rectSize = [attributedText boundingRectWithSize:size
//                                                   options:NSStringDrawingUsesLineFragmentOrigin
//                                                   context:nil];

//    float w1 = (ceilf(rectSize.size.width) + 24 < 50) ? self.frame.size.width : ceilf(rectSize.size.width) + 24;
//    float h1 = (ceilf(rectSize.size.height) + 24 < 50) ? 50 : ceilf(rectSize.size.height) + 24;

    CGRect viewFrame = self.bounds;
    viewFrame.size.width = rectSize.size.width + _globalInset*2;
    viewFrame.size.height = rectSize.size.height + _globalInset*2;
    self.bounds = viewFrame;
}

- (void)setFont:(UIFont*)font
{
    _font = font;
    if (_font && _text) {
        [self setImage:nil];
        [self adjustsWidthToFillItsContents];
        [self refresh];
    }
}

// 用于内容编辑时候。
- (void)setPlainText:(NSString*)text{
    // 新设置的文字没有\n但是本来是竖直方向的，则重新设置方向。
    if ([self textDirection]) {
        _text = text;
        [self setTextDirection:YES];
    } else {
        _text = text;
    }
    if (_font && _text) {
        [self setImage:nil];
        [self adjustsWidthToFillItsContents];
        [self refresh];
    }
}

- (void)setText:(NSString*)text{
    
    _text = text;
    if (_font && _text) {
        [self setImage:nil];
        [self adjustsWidthToFillItsContents];
        [self refresh];
    }
}

- (void)setTextColor:(UIColor*)textColor{
    CGFloat red, green, blue, alpha;
    [textColor getRed:&red green:&green blue:&blue alpha:&alpha];
    _textColor = [UIColor colorWithRed:red green:green blue:blue alpha:_contentAlpha];
    [self refresh];
}

- (void)setContentAlpha:(float)contentAlpha
{
    _contentAlpha = contentAlpha;
    if (_textColor) {
        [self setTextColor:_textColor];
    }
    [self refresh];
}

- (void)setTextHorizontalPadding:(float)textHorizontalPadding
{
    // 把另一个设回来
    if (textHorizontalPadding != 1.0) {
        _textVerticalPadding = 1.0;
    }
    
    _textHorizontalPadding = textHorizontalPadding;
    [self refresh];
}

- (void)setTextVerticalPadding:(float)textVerticalPadding
{
    // 把另一个设回来
    if (textVerticalPadding != 1.0) {
        _textHorizontalPadding = 1.0;
    }
    _textVerticalPadding = textVerticalPadding;
    [self refresh];
}

- (void)setLock:(BOOL)lock
{
    _lock = lock;
    if (_lock) {
        // update button
    }
    else {
    }
}

- (void)setImage:(UIImage*)image
{
    // 这里也修正下
    [(UIImageView*)self.contentView setImage:image];
    if (image) {
        //        resizeView.alpha = 0;
        self.shape = nil;
        self.text = nil;
        [self adjustsWidthToFillItsContents];
        [self refresh];
    }
}

- (void)setShape:(NSString*)shape
{
    _shape = shape;
    //    UIImage* img = [UIImage imageNamed:shape];
    //    [(UIImageView*)self.contentView setImage:img];
    if (shape) {
        //        resizeView.alpha = 0;
        self.text = nil;
        [self refresh];
        // refresh 后再调整。
        [self adjustsWidthToFillItsContents];
    }
}

- (void)setSVG:(NSString*)fileName
{
    //    SVGKImage* newImage = [SVGKImage imageNamed:fileName];
    //    SVGKImageView* imageView = [[SVGKFastImageView alloc] initWithSVGKImage:newImage];
    //    float width = CGRectGetWidth(imageView.bounds);
    //    float scale = 200/width;
    //    self.bounds = CGRectScale(imageView.bounds, scale, scale) ;
    //    self.contentView = imageView;
    //    // 注意顺序
    //
    //    [self refresh];
}

// TODO 这一段要重构。

- (void)setTagName:(NSString*)tag withKey:(NSString*)key withType:(CoverTagType)type{
   UIView *view = [self.contentView viewWithTag:kTagViewTag];
    if (view) {
        [view removeFromSuperview];
    }
    
    
    //CGSize labelSize  = [tag sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    
    if ([tag length] > 15)
    {
        tag = [NSString stringWithFormat:@"%@...", [tag substringWithRange:NSMakeRange(0, 15)]];
    }
    
    
     UIImageView* tagView = [SUTILITY_TOOL_INSTANCE addTag:tag
                                                fontStyle:[UIFont systemFontOfSize:12]
                                                boardingView:(UIImageView*)self.contentView
                                                    point:CGPointZero];
    tagView.tag = kTagViewTag;

    CGRect bounds = tagView.bounds;
    bounds.size.height = bounds.size.height < 40?40:bounds.size.height;
    bounds.size.width = bounds.size.width < 80?80:bounds.size.width;
    
    self.bounds = bounds;
    
    
    resizeView.alpha = 0;
    rotateView.alpha = 0;
    
    _tagName = tag;
    _tagKey = key;
    _tagType = type;
    
    [self refresh];
}

- (void)dealloc
{
    if (lastTouchedView == self) {
        lastTouchedView = nil;
    }
}
@end