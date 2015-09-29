//
//  DrawLineCropImageView.m
//  newdesigner
//
//  Created by Miaoz on 14-9-16.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "DrawLineCropImageView.h"
#import "Toast.h"
@implementation DrawLineCropImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
         self.userInteractionEnabled = YES;
        
        _pointsArray = [NSMutableArray new];
        if (_pointsView == nil) {
            _pointsView = [[JBCroppableLayer alloc] initWithImageView:self];
            
            [self addSubview:_pointsView];
        }
      
    }
    return self;
}
//对画面进行单次点击时所触发的函式
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //宣告一个UITouch的指标来存放事件触发时所撷取到的状态
//    UITouch *touch = [[event allTouches] anyObject];
//    [_pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake([touch locationInView:touch.view].x, [touch locationInView:touch.view].y)]];
    if (_pointsArray.count >=50) {
        [Toast makeToast:@"亲,点最大限制在50个"];
        return;
        
    }
    CGPoint point;
    point = [[touches anyObject] locationInView:self];
    [_pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
    [_pointsView addPointsAt:_pointsArray];
    [_pointsView setNeedsDisplay];
    
}
//对画面进行拖曳动做时所触发的函式
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //宣告一个UITouch的指标来存放事件触发时所撷取到的状态
//    UITouch *touch = [[event allTouches] anyObject];
  
}
//手指离开画面（结束操作）时所触发的函式
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //宣告一个UITouch的指标来存放事件触发时所撷取到的状态
//    UITouch *touch = [[event allTouches] anyObject];
    
}

- (void)removePoint{
    self.layer.mask = nil;
    NSMutableArray *oldPoints;
    oldPoints = [_pointsView.getPoints mutableCopy];
    if(oldPoints.count==0) return;
    [oldPoints removeLastObject];
    [_pointsArray removeLastObject];
    if (_pointsView != nil) {
        [_pointsView removeFromSuperview];
    }
    _pointsView = [[JBCroppableLayer alloc] initWithImageView:self];
    [_pointsView addPointsAt:[NSArray arrayWithArray:oldPoints]];
    [self addSubview:_pointsView];
}

-(void)resetPointWithpointarray:(NSMutableArray *)oldPoints{
    if (_pointsView != nil) {
        [_pointsView removeFromSuperview];
    }
    _pointsView = [[JBCroppableLayer alloc] initWithImageView:self];
    [_pointsView addPointsAt:[NSArray arrayWithArray:oldPoints]];
    [self addSubview:_pointsView];
}
-(void)crop{
    [_pointsView maskImageView:self];
    [_pointsView removeFromSuperview];
}

-(void)reverseCrop{
    self.layer.mask = nil;
    [self addSubview:_pointsView];
}

-(UIImage *)getCroppedImage{
    return [_pointsView getCroppedImageForView:self withTransparentBorders:NO];
}

-(UIImage *)getCroppedImageWithTransparentBorders:(BOOL)transparent{
    return [_pointsView getCroppedImageForView:self withTransparentBorders:transparent];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
