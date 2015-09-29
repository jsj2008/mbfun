//
//  CustomScrollView.m
//  newdesigner
//
//  Created by Miaoz on 14/10/20.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "CustomScrollView.h"
#import "Globle.h"
@implementation CustomScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.backgroundColor = [UIColor clearColor];
        //        self.opaque = YES;
      
        [self createLabelAndbutton];
    }
    return self;
}
-(void)customScrollViewBlockWithscrollView:(CustomScrollViewBlock) block{

    _myblock = block;

}
-(void)createLabelAndbutton{
    
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 40, 20)];
        _label.font = [UIFont systemFontOfSize:10.0f];
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 0;
        _label.text = @"筛选返回结果";
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
        
    }
   
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//        _button.backgroundColor = [UIColor yellowColor];
        _button.frame = CGRectMake(self.frame.size.width-40, -5, 40, 35);
        [_button setTitle:@"删除" forState:UIControlStateNormal];
//        [_button setTitleColor:[UIColor colorWithHexString:@"#353535"] forState:UIControlStateNormal];
         [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _label.textColor = [UIColor whiteColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
   
    
}
-(void)buttonClick:(id)sender{

    _myblock(self);
}

@end
