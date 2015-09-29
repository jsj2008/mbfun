//
//  TopImageView.m
//  newdesigner
//
//  Created by Miaoz on 14-9-24.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "TopImageView.h"

@implementation TopImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.backgroundColor = [UIColor clearColor];
        //        self.opaque = YES;
       
    
      
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //宣告一个UITouch的指标来存放事件触发时所撷取到的状态
    //    UITouch *touch = [[event allTouches] anyObject];
    //    [_pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake([touch locationInView:touch.view].x, [touch locationInView:touch.view].y)]];
//    CGPoint point;
//    point = [[touches anyObject] locationInView:self];
   
  
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
   
    if (_block) {
        _block();
    }
    
}

-(void)tapclickEventBlock:(TopImageViewBlock)topBlock{

    _block = topBlock;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
