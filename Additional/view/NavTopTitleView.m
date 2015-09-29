//
//  NavTopTitleView.m
//  newdesigner
//
//  Created by Miaoz on 14/11/3.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "NavTopTitleView.h"
#import "UIColor+extend.h"
#define buttontag 110

@implementation NavTopTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _buttonarray = [NSMutableArray new];
        
        if (_buttonWide == nil) {
            _buttonWide = @"49";
        }
        
    }
    return self;
}
-(void)setTitlearray:(NSArray *)titlearray{
    _titlearray = titlearray;
    [self createButtonWithtitlearray:_titlearray];
}

-(void)navTopTitleViewBlockWithbuttontag:(NavTopTitleViewBlock) block{
    _myblock = block;
}
-(void)createButtonWithtitlearray:(NSArray *)titlearray{
    
    for (int i = 0; i<titlearray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0+i*(_buttonWide.intValue-1), 2, _buttonWide.intValue, 30);
        button.tag = buttontag +i;
        [button setTitle:titlearray[i] forState:UIControlStateNormal];
        if (i==0) {
            if ([titlearray[i] isEqualToString:@""])
            {
                //点击操作
                button.layer.borderColor = [[UIColor colorWithHexString:@"#"] CGColor];//#acacac
                button.layer.borderWidth = 1.0f;
                button.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                if (_blackImageArray != nil)
                {
                    [button setImage:[UIImage imageNamed:_blackImageArray[0]] forState:UIControlStateNormal];
                }
            }else{
                button.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] CGColor];//#acacac
                button.layer.borderWidth = 0.5f;
                button.backgroundColor = [UIColor colorWithHexString:@"#ffde00"];
                button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];

            
            }
           
           
        }else{

            if ([titlearray[i] isEqualToString:@""]) {
                button.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] CGColor];//#acacac
                button.layer.borderWidth = 1.0f;
                button.backgroundColor = [UIColor colorWithHexString:@"#333333"];
                button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                if (_whiteImageArray != nil) {
                    [button setImage:[UIImage imageNamed:_whiteImageArray[i]] forState:UIControlStateNormal];
                }
                
            }else{
                button.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] CGColor];//#acacac
                button.layer.borderWidth = 0.5f;
                button.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
                button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            
            }
           
            
        
        }
        [button addTarget:self action:@selector(topNavTitleButtonclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttonarray   addObject:button];
    }
    



}
-(void)topNavTitleButtonclick:(UIButton *)sender
{
       
    NSString *str = [NSString stringWithFormat:@"%d",(sender.tag - buttontag)];
    //遍历恢复初始化
    for ( int i = 0 ; i < _buttonarray.count; i ++) {
        
        UIButton *btn = _buttonarray[i];
        if ([_titlearray[i] isEqualToString:@""]) {
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] CGColor];//#acacac
            btn.layer.borderWidth = 0.5f;
            btn.backgroundColor = [UIColor colorWithHexString:@"#333333"];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            if (_whiteImageArray != nil) {
                [btn setImage:[UIImage imageNamed:_whiteImageArray[i]] forState:UIControlStateNormal];
            }
        }else{
          
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] CGColor];//#acacac
            btn.layer.borderWidth = 0.5f;
            btn.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        }
        
    }
      //点击操作
     if ([_titlearray[0] isEqualToString:@""]) {
  
    sender.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] CGColor];//#acacac
    sender.layer.borderWidth = 1.0f;
    sender.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    sender.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sender setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    if (_blackImageArray != nil) {
             [sender setImage:[UIImage imageNamed:_blackImageArray[str.integerValue]] forState:UIControlStateNormal];
         }
     }
     else
     {
    sender.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] CGColor];//#acacac
    sender.layer.borderWidth = 0.5f;
    sender.backgroundColor = [UIColor colorWithHexString:@"#ffde00"];
    sender.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sender setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    
  
     }
    if (_myblock) {
        _myblock(str);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
