//
//  GesturesView.m
//  newdesigner
//
//  Created by Miaoz on 14-9-19.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "GesturesView.h"
#import "AppDelegate.h"
#import "UIColor+extend.h"
#import "DataBase.h"
#import "TopImageView.h"
#import "DraftVO.h"
#import "GoodObj.h"
#import "MaterialMapping.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "Globle.h"
#define positionHeight 162+40
#define distanceWhight 55
#define belowwidth    60
#define buttondistanceY 7.5
@implementation GesturesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.backgroundColor = [UIColor clearColor];
        //        self.opaque = YES;
        _flipbool = NO;
        if (_subviewArray == nil) {
            _subviewArray = [NSMutableArray new];
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        [self addotherView];
        [self creattmpView];
        [self addTapRecognizer];
        [self creatCenterLable];
        [self addbottomScrollviewView];
        
//        [self creatPreviousAndNextButton];
    }
    return self;
}
//-(void)setPolyvoreVC:(PolyvoreViewController *)polyvoreVC{
//
//    _polyvoreVC = polyvoreVC;
//}
-(void)creattmpView {
    if (_clickSuperView == nil) {
        UIView *clickSuperView = [[UIView alloc] initWithFrame:self.frame];
        _clickSuperView = clickSuperView;
        clickSuperView.hidden = YES;
        clickSuperView.backgroundColor = [UIColor clearColor];
        [self addSubview:clickSuperView];
        [self addGestures];
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
//    _rotationG =tmprotationG;
    
    //缩放手势
    tmppinchGestureRecongnizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    tmppinchGestureRecongnizer.delegate = self;
//    _pinchGesture = tmppinchGestureRecongnizer;
    //拖动手势
    tmppanGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panpan:)];
    
    //点击手势
    tmpsingleFinger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    tmpsingleFinger.numberOfTouchesRequired = 1;
    tmpsingleFinger.numberOfTapsRequired = 1;
//    _singleFinger = tmpsingleFinger;
    
    [self.clickSuperView addGestureRecognizer:tmppinchGestureRecongnizer];
    [self.clickSuperView addGestureRecognizer:tmprotationG];
    [self.clickSuperView addGestureRecognizer:tmppanGesture];
    [self.clickSuperView addGestureRecognizer:tmpsingleFinger];
    
}
//处理单指事件
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender{

    
    [_clickGesturesImageView handleSingleFingerEvent:sender];

    [self resetRecoveryGesturesImageView];
    
}
- (void)panpan:(UIPanGestureRecognizer *)sender
{
    //    [self.view bringSubviewToFront:self];
    CGPoint translation = [sender translationInView:self.clickSuperView];
    _clickGesturesImageView.center = CGPointMake( _clickGesturesImageView.center.x + translation.x,
                                      _clickGesturesImageView.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:self.clickSuperView];

}
- (void)changeImage:(UIPinchGestureRecognizer*)pinchGestureRecognizer
{
    
    NSLog(@"scale %f",pinchGestureRecognizer.scale);
    
 
    NSString *str =  NSStringFromCGAffineTransform(_clickGesturesImageView.transform);
    NSLog(@"transform-str--%@",str);
    
    //解决缩放过小问题
    if (_clickGesturesImageView.transform.a <= 0.2 &&  pinchGestureRecognizer.scale<1.0f) {
          pinchGestureRecognizer.scale = 1;
        return;
    }
    
    _clickGesturesImageView.transform = CGAffineTransformScale(_clickGesturesImageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    pinchGestureRecognizer.scale = 1;
    
}

- (void)rotationImage:(UIRotationGestureRecognizer*)gesture
{
    //add by miao 11.18
//    float a = _clickGesturesImageView.transform.a;
//    
//    if (a < 0.000000) {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"1"}];//改变成-
//        _clickGesturesImageView.fliptagStr =@"1";
//        
//    }else{
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"0"}];//不改变
//        _clickGesturesImageView.fliptagStr =@"0";
//    }
//
    //add by miao 11.18
//    float a = self.transform.a;
//    float d = self.transform.d;
//    NSLog(@"self.transform.a------- %f",a);
//    
//    if (d*a < 0.000000) {
//        
//        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"1"}];//改变成-
//         _clickGesturesImageView.fliptagStr =@"1";
//    }else{
//        
//        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"0"}];//不改变
//         _clickGesturesImageView.fliptagStr = @"0";
//    }
    
    NSLog(@"rotation %f",gesture.rotation);
    if ([ _clickGesturesImageView.fliptagStr isEqualToString:@"1"]) {
      _clickGesturesImageView.transform = CGAffineTransformRotate(_clickGesturesImageView.transform, -gesture.rotation);
    
    }else{
         _clickGesturesImageView.transform = CGAffineTransformRotate(_clickGesturesImageView.transform, gesture.rotation);
    }
    
    gesture.rotation = 0;
}

-(void)creatPreviousAndNextButton{

    UIButton *previousbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousbutton.frame = CGRectMake(5, self.bounds.size.height-150, 25, 25);
    [previousbutton setBackgroundImage:[UIImage imageNamed:@"btn_create_back"] forState:UIControlStateNormal];
    [previousbutton addTarget:self action:@selector(previousbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:previousbutton];
    
    UIButton *nextbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextbutton.frame = CGRectMake(40, self.bounds.size.height-150, 25, 25);
    [nextbutton setBackgroundImage:[UIImage imageNamed:@"btn_create_forward"] forState:UIControlStateNormal];
    [nextbutton addTarget:self action:@selector(nextbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextbutton];

}

-(void)creatCenterLable{
//    if (_centerLable == nil) {
//        UILabel *lab;
//        lab = [UILabel new];
//        lab.frame = CGRectMake(0, 0, self.frame.size.width, 100);
//        CGFloat centerY = self.bounds.size.height - positionHeight;
//        lab.center = CGPointMake(self.bounds.size.width/2, centerY/2);
//        //    lab.center = self.center;
//        lab.text = @"创作一个新搭配";
//        lab.textAlignment = NSTextAlignmentCenter;
//        lab.textColor = [UIColor grayColor];
//        lab.font = [UIFont boldSystemFontOfSize:30.0f];
//        _centerLable = lab;
//        lab.hidden = NO;
//        [self addSubview:lab];
//    }
    if (_centerImgView == nil) {
        UIImageView *imgView;
        imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"creat_centerImg"]];
        imgView.frame = CGRectMake(0, 0,194 , 61);
        CGFloat centerY = self.bounds.size.height - positionHeight;
        imgView.center = CGPointMake(self.bounds.size.width/2, centerY/2);
        imgView.hidden = NO;
        _centerImgView = imgView;
        [self addSubview:imgView];
    }
    
  
}
-(void)addbottomScrollviewView{
    if (_belowScrollView == nil) {
        _belowScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, belowwidth)];
     
        _belowScrollView.userInteractionEnabled = YES;
        _belowScrollView.delegate = self;
//        _belowScrollView.backgroundColor = [UIColor colorWithHexString:@"#504d4d"];
         _belowScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_belowScrollView];
        
        _belowScrollView.contentSize =CGSizeMake(self.frame.size.width, belowwidth);
    }
    
   

}

#pragma mark-服务器模板添加
-(void)addBottombuttonwithindex:(int)index withServiceTemplateElement:(TemplateElement *)templateElement withtemplateElementArray:(NSMutableArray *)templateElementArray{
    _bottomtemplateElementArray = templateElementArray;
  
    //设置底部contentSize
    if (_bottomtemplateElementArray != nil) {
        _belowScrollView.contentSize =CGSizeMake(distanceWhight+_bottomtemplateElementArray.count*distanceWhight, belowwidth);
    }

//    __weak __typeof(self)weakSelf = self;
    //12.16 add by miao
    if (index == templateElementArray.count -1) {
        [UIView animateWithDuration:0.5 animations:^{
             _belowScrollView.frame =  CGRectMake(0, self.frame.size.height-positionHeight, self.frame.size.width, belowwidth);
        }];
       
    }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(distanceWhight+index*distanceWhight, buttondistanceY, 45, 45);
        button.tag = 70+index;
        if (button.layer.borderWidth != 0.5f) {
            button.layer.borderColor = [[UIColor colorWithHexString:@"#e2e2e2"] CGColor];//
            button.layer.borderWidth = 0.5f;
      
        }

       NSString *imageurl = [self changeStringWithurlString:templateElement.templateInfo.pictureUrl];
        NSString *url = [imageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIImageFromURLTOCache([NSURL URLWithString:url], url, ^(UIImage *image) {
               [button setBackgroundImage:image forState:UIControlStateNormal];
        }, ^{
            [button setBackgroundImage:[UIImage imageNamed:DEFAULT_LOADING_MEDIUM] forState:UIControlStateNormal];
        });
        [button addTarget:self action:@selector(belowScrollViewButtonclick:) forControlEvents:UIControlEventTouchUpInside];
        [_belowScrollView addSubview:button];
    
}


-(NSString *)changeStringWithurlString:(NSString *)imageurl{
    NSMutableString *mainurlString;
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:imageurl];
    NSRange range = [String1 rangeOfString:@"--"];
    
    int location = (int)range.location;
    int leight = (int)range.length;
    
    if (leight == 2) {////有--400x400
        mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
        [mainurlString appendString:[NSString stringWithFormat:@".png"]];
        
        
    }else{//没有--400x400 //有后缀.png
        NSRange range = [String1 rangeOfString:@".png"];
        
        int leight = (int)range.length;
        if (leight == 4){//有后缀.png
            
            mainurlString = [[NSMutableString alloc] initWithString:String1];
            
        }else{//没有后缀png
            
            //后缀jpg
            NSRange range2 = [String1 rangeOfString:@".jpg"];
            int location2 = (int)range2.location;
            int leight2 = (int)range2.length;
            if (leight2 == 4){//有后缀.jpg
                
                mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location2]];
                [mainurlString appendString:[NSString stringWithFormat:@".jpg"]];
            }else{//没有后缀
                
                mainurlString = [[NSMutableString alloc] initWithString:String1];
                [mainurlString appendString:[NSString stringWithFormat:@".png"]];
                
            }
            
            
        }
        
    }
    [mainurlString insertString:[NSString stringWithFormat:@"--%dx%d",(int)100,(int)100] atIndex:mainurlString.length -4];
    return mainurlString;
}

-(NSString *)changeStringWithurlString:(NSString *)imageurl width:(int)width{
    NSMutableString *mainurlString;
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:imageurl];
    NSRange range = [String1 rangeOfString:@"--"];
    
    int location = (int)range.location;
    int leight = (int)range.length;
    
    if (leight == 2) {////有--400x400
        NSRange tmprange = [String1 rangeOfString:@"$text_"];
        
        if (String1.length>100) {
            if (tmprange.length == 6) {//生成字体
                mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
                [mainurlString appendString:[NSString stringWithFormat:@".png"]];
                
            }else{
            mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:String1.length-12]];
            [mainurlString appendString:[NSString stringWithFormat:@".png"]];
            }
        }else{
            mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
            [mainurlString appendString:[NSString stringWithFormat:@".png"]];
            

        }
        
    }else{//没有--400x400 //有后缀.png
        NSRange range = [String1 rangeOfString:@".png"];
        
        int leight = (int)range.length;
        if (leight == 4){//有后缀.png
            
            mainurlString = [[NSMutableString alloc] initWithString:String1];
            
        }else{//没有后缀png
            
            //后缀jpg
            NSRange range2 = [String1 rangeOfString:@".jpg"];
            int location2 = (int)range2.location;
            int leight2 = (int)range2.length;
            if (leight2 == 4){//有后缀.jpg
                
                mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location2]];
                [mainurlString appendString:[NSString stringWithFormat:@".jpg"]];
            }else{//没有后缀
                
                mainurlString = [[NSMutableString alloc] initWithString:String1];
                [mainurlString appendString:[NSString stringWithFormat:@".png"]];
                
            }
            
            
        }
        
    }

    [mainurlString insertString:[NSString stringWithFormat:@"--%dx%d",(int)width,(int)width] atIndex:mainurlString.length -4];
    return mainurlString;
}


#pragma mark -- 更多模板按钮
-(void)addMoretemplateButtonTobelowScrollView{

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundImage:[UIImage imageNamed:@"btn_moremasterplate_normal@3x"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"leftmore"] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
//        if (button.layer.borderWidth != 1.0f) {
//            button.layer.borderColor = [[UIColor colorWithHexString:@"#ffffff"] CGColor];
//            button.layer.borderWidth = 1.0f;
//        
//        }
        button.frame = CGRectMake(1, buttondistanceY, 45, 45);
        button.tag = 69;

    [button addTarget:self action:@selector(belowScrollViewButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [_belowScrollView addSubview:button];

}

-(void)addotherView{
    
    CGRect rect =[AppDelegate shareAppdelegate].window.bounds;
    _topfuzzyView = [[TopImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rect.size.width, 65)];
     _topfuzzyView.hidden = YES;
    _topfuzzyView.userInteractionEnabled = YES;
    
    [[AppDelegate shareAppdelegate].window addSubview:_topfuzzyView];
    
    [self.topfuzzyView tapclickEventBlock:^{
       
        [self resetRecoveryGesturesImageView];
        
        
        if(_subviewArray.count==0 || _subviewArray == nil){
            
            [UIView animateWithDuration:0.3 animations:^{
                _belowScrollView.hidden = NO;
                _belowScrollView.frame = CGRectMake(0, self.frame.size.height-positionHeight, self.frame.size.width, belowwidth);
            } completion:^(BOOL finished) {
                
            }];
            
            
        }
    }];
    
    
    
    _fuzzyView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-100)];
    _fuzzyView.hidden = YES;
    [self addSubview:_fuzzyView];
    
    /*
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, belowwidth)];//self.frame.size.height-positionHeight
        _bottomView.hidden = YES;
    _bottomView.userInteractionEnabled = YES;
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#504d4d"];

    [self addSubview:_bottomView];
    */
    _bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, belowwidth)];//self.frame.size.height-positionHeight
    _bottomView.hidden = YES;
    _bottomView.userInteractionEnabled = YES;
//    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#504d4d"];
     _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.contentSize = CGSizeMake(self.frame.size.width, belowwidth);//+60
    [self addSubview:_bottomView];
//    NSArray *array = @[@"替换",@"移除",@"翻转",@"复制",@"剪裁",@"往前",@"往后"];
//    NSArray *imagearray = @[@"btn_create_replace.png",@"delete",@"btn_create_flip",@"btn_create_clone",@"btn_create_cutout",@"btn_create_layerdown",@"btn_create_layerup"];
//    NSArray *imagearray = @[@"btn_replace_normal@3x",@"btn_dustbin_normal@3x",@"btn_turn_normal@3x",@"btn_copy_normal@3x",@"btn_cut_normal@3x",@"btn_before_normal@3x",@"btn_after_normal@3x"];//@"wenzi@2x"
//    NSArray *pressedImagearray = @[@"btn_replace_pressed@3x",@"btn_dustbin_pressed@3x",@"btn_turn_pressed@3x",@"btn_copy_pressed@3x",@"btn_cut_pressed@3x",@"btn_before_pressed@3x",@"btn_after_pressed@3x"];//,@"wenzi@2x"
    
    NSArray *imagearray = @[@"icon_create_change",@"icon_create_trash",@"icon_create_mirror",@"icon_create_copy",@"icon_create_crop",@"icon_create_up",@"icon_create_down"];
    NSArray *pressedImagearray = @[@"icon_create_change",@"icon_create_trash",@"icon_create_mirror",@"icon_create_copy",@"icon_create_crop",@"icon_create_up",@"icon_create_down"];
    NSArray *titleArray = @[@"替换",@"移除",@"翻转",@"复制",@"剪裁",@"往前",@"往后"];
    for (int i = 0; i < 7; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:[imagearray objectAtIndex:i]]
                       forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[pressedImagearray objectAtIndex:i]]
                       forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -36, -40, 0);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(8+(10+_bottomView.bounds.size.width/7-10)*i, 0, 45, 45);
        btn.tag = 40+i;
        [btn addTarget:self action:@selector(buttonClickevent:)
      forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
    }

}

-(void)belowScrollViewButtonclick:(UIButton *)sender{
    if (sender.tag == 69) {
        if (_delegate && [_delegate respondsToSelector:@selector(callBackGesturesImageViewWithtemplateElement:withbuttonTag:)]) {
            [_delegate callBackGesturesImageViewWithtemplateElement:nil withbuttonTag:(int)sender.tag];
        }
    }else{
    
        //服务器
        TemplateElement *templateElement = [_bottomtemplateElementArray objectAtIndex:sender.tag -70] ;
        if (_delegate && [_delegate respondsToSelector:@selector(callBackGesturesImageViewWithtemplateElement:withbuttonTag:)]) {
            [_delegate callBackGesturesImageViewWithtemplateElement:templateElement withbuttonTag:(int)sender.tag];
        }
    
    }

  

}

-(void)previousbuttonclick:(UIButton *)sender{

    if (_delegate &&[_delegate respondsToSelector:@selector(callBackPreviousAndNextButtonClick:withtype:)]) {
//        [_delegate callBackPreviousAndNextButtonClick:<#(id)#> withtype:<#(NSString *)#>];
    }


}

-(void)nextbuttonclick:(UIButton *)sender{



}

-(void)buttonClickevent:(UIButton *)sender{
    switch (sender.tag-40) {
        case 0:
            [self resetRecoveryGesturesImageView];
            [self replaceClickevent:sender];
            break;
        case 1:
            [self removeClickevent:sender];
            break;
            
        case 2:
            [self flipClickevent:sender];
            
            break;
        case 3:
             [self cloneClickevent:sender];
           
            break;
        case 4:
            [self resetRecoveryGesturesImageView];
            [self cutoutClickevent:sender];

            break;
        case 5:
            [self forwardClickevent:sender];
            break;
        case 6:
            [self backClickevent:sender];
            break;
        case 7:
            [self fonttextClickevent:sender];
            break;
        default:
            break;
    }
    
}

-(void)addTapRecognizer
{
    //点击手势
    UITapGestureRecognizer *singleFinger;
    
    singleFinger = [[UITapGestureRecognizer alloc] initWithTarget:self action:
                    @selector(handleEvent:)];
    singleFinger.numberOfTouchesRequired = 1;
    singleFinger.numberOfTapsRequired = 1;
    [self.fuzzyView addGestureRecognizer:singleFinger];
}

-(void)handleEvent:(UITapGestureRecognizer *)sender
{
    [self datatransmissionForcoredata];
    [self resetRecoveryGesturesImageView];
    
    
    if(_subviewArray.count==0 || _subviewArray == nil){
        
        [UIView animateWithDuration:0.3 animations:^{
            _belowScrollView.hidden = NO;
            _belowScrollView.frame = CGRectMake(0, self.frame.size.height-positionHeight, self.frame.size.width, belowwidth);
        } completion:^(BOOL finished) {

        }];
        
    
    }
   
}

-(void)repetitionGesturesImageView:(PhotoVO *)photovo{
    
    NSString *widthStr = [NSString stringWithFormat:@"%@",[photovo valueForKey:@"width"]];
    float width = [widthStr floatValue];
    NSString *heightStr = [NSString stringWithFormat:@"%@",[photovo valueForKey:@"height"]];
    float height = [heightStr floatValue];
    
        GesturesImageView *view;
        view = [[GesturesImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        view.delegate = self;
        view.parentView = self;
        view.center = CGPointFromString([photovo valueForKey:@"center"]);
        view.image = [UIImage imageWithData:[photovo valueForKey:@"imageData"]];
        view.alpha = 1.0;
        view.userInteractionEnabled = YES;
        view.transform = CGAffineTransformFromString([photovo valueForKey:@"transform"]);
        view.draftid = [NSString stringWithFormat:@"%@",[photovo valueForKey:@"draftid"]];
        view.savetag = [NSString stringWithFormat:@"%@",[photovo valueForKey:@"savetag"]];

//        view.draftname = [NSString stringWithFormat:@"%@",[photovo valueForKey:@"draftname"]];
        view.pinchGesturescale =[[NSString stringWithFormat:@"%@",[photovo valueForKey:@"pinchGesturescale"]] floatValue];
        view.rotationGesturerotation = [[NSString stringWithFormat:@"%@",[photovo valueForKey:@"rotation"]] floatValue];
        view.gesturePosition = [[NSString stringWithFormat:@"%@",[photovo valueForKey:@"position"]] intValue];
        [self addSubview:view];
    
    

    //先赋值再添加
    [_subviewArray addObject:(GesturesImageView *)view];
    NSLog(@"%ld",(unsigned long)_subviewArray.count);



}

-(void)repetitionGesturesImageView:(PhotoVO *)photovo withDraftVO:(DraftVO *)draftvo draftNum:(NSString *)draftNum{
    
    NSString *widthStr = [NSString stringWithFormat:@"%@",[photovo valueForKey:@"width"]];
    float width = [widthStr floatValue];
    NSString *heightStr = [NSString stringWithFormat:@"%@",[photovo valueForKey:@"height"]];
    float height = [heightStr floatValue];
    
    GesturesImageView *view;
    view = [[GesturesImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    view.delegate = self;
    view.parentView = self;
    view.center = CGPointFromString([photovo valueForKey:@"center"]);
    view.image = [UIImage imageWithData:[photovo valueForKey:@"imageData"]];
    view.alpha = 1.0;
    view.userInteractionEnabled = YES;
    view.transform = CGAffineTransformFromString([photovo valueForKey:@"transform"]);
//    view.draftid = [NSString stringWithFormat:@"%@",[photovo valueForKey:@"draftid"]];
//        view.savetag = [NSString stringWithFormat:@"%@",[photovo valueForKey:@"savetag"]];
//        view.jiepingImageData = [draftvo valueForKey:@"draftimageData"];
    view.draftid = draftNum;
    view.savetag = @"0";
    

    
    //        view.draftname = [NSString stringWithFormat:@"%@",[photovo valueForKey:@"draftname"]];
    view.pinchGesturescale =[[NSString stringWithFormat:@"%@",[photovo valueForKey:@"pinchGesturescale"]] floatValue];
    view.rotationGesturerotation = [[NSString stringWithFormat:@"%@",[photovo valueForKey:@"rotation"]] floatValue];
    view.gesturePosition = [[NSString stringWithFormat:@"%@",[photovo valueForKey:@"position"]] intValue];
    [self addSubview:view];
    
    
    
    //先赋值再添加
    [_subviewArray addObject:(GesturesImageView *)view];
    NSLog(@"%ld",(unsigned long)_subviewArray.count);
    
    //添加数据到coredata
    [self datatransmissionForcoredata];
    
}
#pragma mark--模板或者草稿、搭配添加  11.20修改

-(void)repetitionGesturesImageViewWithServicedata:(LayoutMapping *)layoutMapping withDetailMapping:(DetailMapping *)detailMapping withTemplateId:(NSString *)templateId rationalNum:(NSString *)rationalNumStr
{
    if (rationalNumStr == nil) {
         rationalNumStr = @"1";
    }
   

    NSString *widthStr = [NSString stringWithFormat:@"%@",layoutMapping.width];
    float width = [widthStr floatValue]/rationalNumStr.floatValue;
    NSString *heightStr = [NSString stringWithFormat:@"%@",layoutMapping.height];
    float height = [heightStr floatValue]/rationalNumStr.floatValue;
    
    
    NSString *xPositionStr = [NSString stringWithFormat:@"%@",layoutMapping.xPosition];
    float xPosition = [xPositionStr floatValue]/rationalNumStr.floatValue ;
    
    float yPosition;
    if (![rationalNumStr isEqualToString:@"1"]) {
        NSString *yPositionStr = [NSString stringWithFormat:@"%@",layoutMapping.yPosition];
        yPosition = [yPositionStr floatValue]/rationalNumStr.floatValue;
    }else{
        NSString *yPositionStr = [NSString stringWithFormat:@"%@",layoutMapping.yPosition];
        yPosition = [yPositionStr floatValue]/rationalNumStr.floatValue;
    }
    
    NSString *aStr = [NSString stringWithFormat:@"%@",layoutMapping.rectSx];
    float a = [aStr floatValue];
    NSString *bStr = [NSString stringWithFormat:@"%@",layoutMapping.rectRx];
    float b = [bStr floatValue];
    NSString *cStr = [NSString stringWithFormat:@"%@",layoutMapping.rectRy];
    float c = [cStr floatValue];
    NSString *dStr = [NSString stringWithFormat:@"%@",layoutMapping.rectSy];
    float d = [dStr floatValue];
    NSString *indexStr = [NSString stringWithFormat:@"%@",layoutMapping.index];
    int indext = [indexStr intValue];
    
    GesturesImageView *view;
    view = [[GesturesImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    
    view.delegate = self;
    view.parentView = self;
    NSLog(@"获得的Y的位置==%f",[Globle shareInstance].globleHeight - [Globle shareInstance].globleWidth+20 -120)  ;
    CGFloat contentoffsetY = [Globle shareInstance].globleHeight - ([Globle shareInstance].globleWidth-20 )-120;
    if (rationalNumStr.floatValue == 1.0f){
    
    view.center = CGPointMake(xPosition, yPosition);
    }else{
      view.center = CGPointMake(xPosition, yPosition+contentoffsetY/2);
    }
    
  
    //12.5 add by miao  复制放大缩小bug
    
//    NSMutableString *lastString = [[NSMutableString alloc] initWithString:[layoutMapping.pictureUrl substringToIndex:layoutMapping.pictureUrl.length-11]];
//        [lastString appendString:[NSString stringWithFormat:@"%dx%d.png",(int)width,(int)height]];
//    12.19 add by miao 解决图片保存再点击不显示bug
//     NSString *lastString = [self changeStringWithurlString:layoutMapping.pictureUrl width:(int)width];
//        NSLog(@"lastimageString-----lastString%@",lastString);
    //11.20 add by miao
    UIImageFromURL([NSURL URLWithString:[layoutMapping.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], ^(UIImage *image) {
        view.image = image;
        [self stopSpinerAnddisappearBorder:view];
    }, ^{
        
    });
    
   
//    view.image = [UIImage imageWithData:[photovo valueForKey:@"imageData"]];
//    [view setImageAFWithURL:[NSURL URLWithString:layoutMapping.pictureUrl] placeholderImage:[UIImage imageNamed:@"3.png"]];
    view.alpha = 1.0;
    view.userInteractionEnabled = YES;
    view.transform = CGAffineTransformMake(a, b, c, d, 0.0f, 0.0f);
    view.gesturePosition = indext;
    view.imageurl = layoutMapping.pictureUrl;
    view.detailMapping = detailMapping;
    view.layoutMapping = layoutMapping;
    view.templateId = templateId;
    [self addSubview:view];
    
    //先赋值再添加
    [_subviewArray addObject:(GesturesImageView *)view];
    //浮动框
    [self disposeBrlowScrollViewAndBottomView];
//    [self bringSubviewToFront:self.bottomView];
//    [self bringSubviewToFront:self.belowScrollView];
    NSLog(@"%ld",(unsigned long)_subviewArray.count);
    
}
//等比例压缩
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

#pragma mark----复制
-(void)addGesturesImageView:(CGRect)rect image:(UIImage *)image center:(CGPoint)centerpoint withdraftNum:(NSString *)draftNum withtransform:(NSString *)transform WithmainOldGesturesImageView:(GesturesImageView *)oldGesturesImageView
{
    
    
    GesturesImageView *gesturesImageView;
    //self.view.multipleTouchEnabled = YES;
    
    
  // add by miao 3.3  解决图片展示复制问题大小错乱
   static CGFloat rationalNum;
    static CGFloat sizeWidth;
      static CGFloat sizeHeight;
    
    
    if (oldGesturesImageView.goodObj.shearPicUrl != nil||oldGesturesImageView.detailMapping.shearPicUrl != nil ||oldGesturesImageView.materialMapping.shearPicUrl != nil||oldGesturesImageView.materialMapping.pictureUrl != nil) {
        rationalNum = 1;
        sizeWidth =image.size.width;
        sizeHeight = image.size.height;
    }else{
    // add by miao 3.4 解决
    if (_templateElement != nil) {//templateElement//从模板获得
        sizeWidth =image.size.width;
        sizeHeight = image.size.height;
        rationalNum= _templateElement.templateInfo.backWidth.floatValue/[Globle shareInstance].globleWidth;
        _collocationElement = nil;
        
    }else if (_collocationElement.collocationInfo != nil){//服务端//从草稿箱获得
        sizeWidth =image.size.width;
        sizeHeight = image.size.height;
        
        rationalNum= _collocationElement.collocationInfo.backWidth.floatValue/[Globle shareInstance].globleWidth;
        _templateElement = nil;
    }else if (oldGesturesImageView.goodObj != nil){
        if ([oldGesturesImageView.goodObj.isReplace isEqualToString:@"1"]) {
            sizeWidth = image.size.width;
            sizeHeight = image.size.height;
            rationalNum = 1;
        }else
        {
            sizeWidth =oldGesturesImageView.goodObj.clsPicUrl.width.floatValue;
            sizeHeight = oldGesturesImageView.goodObj.clsPicUrl.height.floatValue;
           
            if (oldGesturesImageView.goodObj.clsPicUrl.width.floatValue >=[Globle shareInstance].globleWidth) {
                rationalNum = (2.5*oldGesturesImageView.goodObj.clsPicUrl.width.floatValue)/[Globle shareInstance].globleWidth;
            }else{
                
//                if (oldGesturesImageView.goodObj.clsPicUrl.height.floatValue >[Globle shareInstance].globleWidth) {
//                    rationalNum = (2.5*oldGesturesImageView.goodObj.clsPicUrl.width.floatValue)/[Globle shareInstance].globleWidth;
//                }else{
                    rationalNum = 1/0.4;
//                }
                
            }
        }
    }
    
    }
    NSString *rationalNumStr = [NSString stringWithFormat:@"%f",rationalNum];
    
    float width = sizeWidth/rationalNumStr.floatValue;
    
    float height = sizeHeight/rationalNumStr.floatValue;
//
    NSLog(@"lastImage---------%f,%f",image.size.width,image.size.height);
//    CGRect rect2 = CGRectMake(rect.origin.x, rect.origin.y, image.size.width, image.size.height);
    CGRect rect2 = CGRectMake(rect.origin.x, rect.origin.y, width,height);
    gesturesImageView = [[GesturesImageView alloc] initWithFrame:rect2];
    gesturesImageView.delegate = self;
    gesturesImageView.contentMode = UIViewContentModeScaleAspectFit;
    gesturesImageView.center = centerpoint;
    
    
   
    gesturesImageView.parentView = self;
    
    NSLog(@"gesturesImageView .transform--------%@",transform);
//    CGAffineTransform tmpTransform = CGAffineTransformFromString(transform);
    gesturesImageView .transform = CGAffineTransformFromString(transform) ;//
    

    gesturesImageView.image = image;
    
    //初始赋值
    gesturesImageView.centerpoint =  gesturesImageView.center;
    gesturesImageView.savetag = @"0";
    gesturesImageView.draftid = draftNum;
    gesturesImageView.draftname = [NSString stringWithFormat:@"草稿%@",draftNum];
    
    //add by miao 11.18解决复制时候赋值问题及crash问题
    if (oldGesturesImageView.goodObj != nil ) {
        //
        if (oldGesturesImageView.goodObj.shearPicUrl != nil && ![oldGesturesImageView.goodObj.shearPicUrl isEqualToString:@""]) {
            gesturesImageView.imageurl = oldGesturesImageView.goodObj.shearPicUrl;
        }else{
            gesturesImageView.imageurl = oldGesturesImageView.goodObj.clsPicUrl.filE_PATH;
        }
        
        gesturesImageView.goodObj = oldGesturesImageView.goodObj;
    }
    if (oldGesturesImageView.materialMapping != nil ) {
        
        //add miao 11.5解决剪切替换问题
        if (oldGesturesImageView.materialMapping.shearPicUrl != nil && ![oldGesturesImageView.materialMapping.shearPicUrl isEqualToString:@""]) {
            gesturesImageView.imageurl = oldGesturesImageView.materialMapping.shearPicUrl;
        }else{
            gesturesImageView.imageurl = oldGesturesImageView.materialMapping.pictureUrl;
        }
        
        
        gesturesImageView.materialMapping = oldGesturesImageView.materialMapping;
    }
    if ( oldGesturesImageView.detailMapping!= nil ) {
        //add miao 11.5解决剪切替换问题
        if (oldGesturesImageView.detailMapping.shearPicUrl != nil && ![oldGesturesImageView.detailMapping.shearPicUrl isEqualToString:@""]) {
            gesturesImageView.imageurl = oldGesturesImageView.detailMapping.shearPicUrl;
        }else{
            gesturesImageView.imageurl = oldGesturesImageView.detailMapping.productPictureUrl;
        }
        
        
        gesturesImageView.detailMapping = oldGesturesImageView.detailMapping;
    }
    
    
    [self addSubview:gesturesImageView];


    //解决bug 旋转手势相反问题 3.6
    
    float a = gesturesImageView.transform.a;
//    float b = gesturesImageView.transform.b;
//    float c = gesturesImageView.transform.c;
    float d = gesturesImageView.transform.d;
    if (d*a < 0.000000) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"1"}];//改变成-
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"0"}];//不改变
    }
    
    
    [_subviewArray addObject:gesturesImageView];
//    //清空数组重新加入防止数据重复
//    if (_subviewArray!= nil) {
//        [_subviewArray removeAllObjects];
//    }
    
    //数组里添加GesturesImageView对象
//    for(UIView *view in self.subviews)
//    {
//        if ([view isKindOfClass:GesturesImageView.class])
//        {
//            [_subviewArray addObject:(GesturesImageView *)view];
//            GesturesImageView *sss = (GesturesImageView *)view;
//            NSLog(@"==========%@",sss.goodObj.shearPicUrl);
//        }
//        
//    }
    
    //    //初始化获得GesturesImageView位置
    for (int i = 0;i<_subviewArray.count ; i++) {
        GesturesImageView *view = _subviewArray[i];
        view.gesturePosition = i;
    }
    
    //添加数据到coredata
    [self datatransmissionForcoredata];
    
}

#pragma mark ---消除GesturesImageView上的spinner和线框
-(void)stopSpinerAnddisappearBorder:(GesturesImageView *)gesturesImageView{

    [gesturesImageView.spinner stopAnimating];
    [gesturesImageView.spinner setHidesWhenStopped:YES ];
    [gesturesImageView crossBorderDisappearevent];

}
#pragma mark --服务器商品添加
-(void)addGesturesImageView:(CGRect)rect image:(UIImage *)image center:(CGPoint)centerpoint withdraftNum:(NSString *)draftNum withtGoodObj:(GoodObj *)goodObj
{

    
    GesturesImageView *gesturesImageView;
    //self.view.multipleTouchEnabled = YES;
    
    gesturesImageView = [[GesturesImageView alloc] initWithFrame:
                         rect];
    gesturesImageView.delegate = self;
    gesturesImageView.contentMode = UIViewContentModeScaleAspectFit;

    gesturesImageView.center = centerpoint;
    gesturesImageView.parentView = self;
   
    
   
    //重新定义center
    CGPoint translation = [gesturesImageView.panGesture translationInView:self];
    gesturesImageView.center = CGPointMake(gesturesImageView.center.x + translation.x,
                                           gesturesImageView.center.y + translation.y);
    NSLog(@"center %f----%f",gesturesImageView.center.x,gesturesImageView.center.y);
    [gesturesImageView.panGesture setTranslation:CGPointZero inView:self];
    
    //初始赋值
    gesturesImageView.centerpoint =  gesturesImageView.center;
    gesturesImageView.savetag = @"0";
    gesturesImageView.draftid = draftNum;
    gesturesImageView.draftname = [NSString stringWithFormat:@"草稿%@",draftNum];
    
    
    //11.22 add by miao
    if (image== nil ) {
        NSMutableString *lastString = [[NSMutableString alloc] initWithString:[goodObj.clsPicUrl.filE_PATH substringToIndex:goodObj.clsPicUrl.filE_PATH.length-4]];
        [lastString appendString:[NSString stringWithFormat:@"--%dx%d.png",(int)rect.size.width,(int)rect.size.height]];
        NSLog(@"llllllllllllllll%@",lastString);
        UIImageFromURL([NSURL URLWithString:lastString], ^(UIImage *image) {
            gesturesImageView.image = image;
            CGAffineTransform tmptransform = CGAffineTransformFromString(draftNum);
            gesturesImageView.transform = tmptransform;
//            if (tmptransform.a == 1.0f) {
//               
//            }else{
//            
//             gesturesImageView.transform = CGAffineTransformMake(1.0f, tmptransform.b, tmptransform.c, 1.0f, 0, 0);
//            }
            

            [self stopSpinerAnddisappearBorder:gesturesImageView];
        }, ^{
            
        });
        
    }else{
        [self stopSpinerAnddisappearBorder:gesturesImageView];
        gesturesImageView.image = image;
        if (draftNum != nil) {
            // 12.5 add by miao
            CGAffineTransform tmpTransform =   CGAffineTransformFromString(draftNum);
            
            float a;
            float d;
            if (tmpTransform.a<0.000000) {
                a = -1;
            }else {
                a = 1;
            }
            if (tmpTransform.d<0.000000) {
                d = -1;
            }else {
                d = 1;
            }
            gesturesImageView.transform = CGAffineTransformMake(a, tmpTransform.b, tmpTransform.c, d, 0, 0);
//            gesturesImageView.transform = CGAffineTransformMake(1, tmpTransform.b, tmpTransform.c, 1, 0, 0);
        }
        
    }

    
    if (goodObj != nil ) {
        //add miao 11.5解决剪切替换问题
        
        if (goodObj.shearPicUrl != nil && ![goodObj.shearPicUrl isEqualToString:@""]) {
//            NSMutableString *lastString = [[NSMutableString alloc] initWithString:[goodObj.shearPicUrl  substringToIndex:goodObj.shearPicUrl .length-4]];
//            [lastString appendString:[NSString stringWithFormat:@"__250x250.png"]];
            gesturesImageView.imageurl = goodObj.shearPicUrl;
        }else{
//            NSMutableString *lastString = [[NSMutableString alloc] initWithString:[goodObj.clsPicUrl.filE_PATH substringToIndex:goodObj.clsPicUrl.filE_PATH.length-4]];
//            [lastString appendString:[NSString stringWithFormat:@"--250x250.png"]];
                gesturesImageView.imageurl = goodObj.clsPicUrl.filE_PATH;
        }

         gesturesImageView.goodObj = goodObj;
    }
    
    
    [self addSubview:gesturesImageView];
    

   
//    [_subviewArray addObject:gesturesImageView];
    //清空数组重新加入防止数据重复
    if (_subviewArray!= nil) {
        [_subviewArray removeAllObjects];
    }
    
    //数组里添加GesturesImageView对象
    for(UIView *view in self.subviews)
    {
        if ([view isKindOfClass:GesturesImageView.class])
        {
            [_subviewArray addObject:(GesturesImageView *)view];
            GesturesImageView *sss = (GesturesImageView *)view;
            NSLog(@"-------%@",sss.goodObj.shearPicUrl);
        }
        
    }
//
//    //初始化获得GesturesImageView位置
    for (int i = 0;i<_subviewArray.count ; i++) {
        GesturesImageView *view = _subviewArray[i];
        view.gesturePosition = i;
    }
  
    //本地数据库时调用
     //添加数据到coredata 不能删除
    [self datatransmissionForcoredata];
    //浮动框
    [self disposeBrlowScrollViewAndBottomView];
}

#pragma mark --素材添加
-(void)addGesturesImageView:(CGRect)rect image:(UIImage *)image center:(CGPoint)centerpoint withdraftNum:(NSString *)draftNum MaterialMapping:(MaterialMapping *)materialMapping
{

    
    GesturesImageView *gesturesImageView;
    //self.view.multipleTouchEnabled = YES;
    
    gesturesImageView = [[GesturesImageView alloc] initWithFrame:
                         rect];
    gesturesImageView.delegate = self;
    
//    gesturesImageView.image = image;
    gesturesImageView.center = centerpoint;
    gesturesImageView.parentView = self;
    
    
    //重新定义center
    CGPoint translation = [gesturesImageView.panGesture translationInView:self];
    gesturesImageView.center = CGPointMake(gesturesImageView.center.x + translation.x,
                                           gesturesImageView.center.y + translation.y);
    NSLog(@"center %f----%f",gesturesImageView.center.x,gesturesImageView.center.y);
    [gesturesImageView.panGesture setTranslation:CGPointZero inView:self];
    
    //初始赋值
    gesturesImageView.centerpoint =  gesturesImageView.center;
    gesturesImageView.savetag = @"0";
    gesturesImageView.draftid = draftNum;
    gesturesImageView.draftname = [NSString stringWithFormat:@"草稿%@",draftNum];
    //1.26 为了解决字体
    gesturesImageView.layoutMapping = materialMapping.layoutMapping;
    //11.22 add by miao
    if (image== nil ) {
        NSMutableString *lastString = [[NSMutableString alloc] initWithString:[materialMapping.pictureUrl substringToIndex:materialMapping.pictureUrl.length-4]];
       
        [lastString appendString:[NSString stringWithFormat:@"--%dx%d.png",(int)rect.size.width,(int)rect.size.height]];
        
        NSLog(@"llllllllllllllll%@",lastString);
        UIImageFromURL([NSURL URLWithString:[lastString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], ^(UIImage *image) {
            gesturesImageView.image = image;
            if (draftNum != nil) {
                
                // 12.5 add by miao
                CGAffineTransform tmpTransform =   CGAffineTransformFromString(draftNum);
                float a;
                float d;
                if (tmpTransform.a<0.000000) {
                    a = -1;
                }else {
                    a = 1;
                }
                if (tmpTransform.d<0.000000) {
                    d = -1;
                }else {
                    d = 1;
                }
                gesturesImageView.transform = CGAffineTransformMake(a, tmpTransform.b, tmpTransform.c, d, 0, 0);
//                gesturesImageView.transform = CGAffineTransformMake(1, tmpTransform.b, tmpTransform.c, 1, 0, 0);
                
            }
            [self stopSpinerAnddisappearBorder:gesturesImageView];
        }, ^{
            
        });
        
    }else{
        [self stopSpinerAnddisappearBorder:gesturesImageView];
        gesturesImageView.image = image;
        if (draftNum != nil) {
            
            // 12.5 add by miao
            CGAffineTransform tmpTransform =   CGAffineTransformFromString(draftNum);
            
            float a;
            float d;
            if (tmpTransform.a<0.000000) {
                a = -1;
            }else {
                a = 1;
            }
            if (tmpTransform.d<0.000000) {
                d = -1;
            }else {
                d = 1;
            }
            gesturesImageView.transform = CGAffineTransformMake(a, tmpTransform.b, tmpTransform.c, d, 0, 0);
//            gesturesImageView.transform = CGAffineTransformMake(1, tmpTransform.b, tmpTransform.c, 1, 0, 0);
            
        }
        
    }
    
    if (materialMapping != nil ) {
        
        //add miao 11.5解决剪切替换问题
        if (materialMapping.shearPicUrl != nil && ![materialMapping.shearPicUrl isEqualToString:@""]) {
            gesturesImageView.imageurl = materialMapping.shearPicUrl;
        }else{
            gesturesImageView.imageurl = materialMapping.pictureUrl;
        }


        gesturesImageView.materialMapping = materialMapping;
    }
    
    
    [self addSubview:gesturesImageView];
    
    
    //    [_subviewArray addObject:gesturesImageView];
    //清空数组重新加入防止数据重复
    if (_subviewArray!= nil) {
        [_subviewArray removeAllObjects];
    }
    
    //数组里添加GesturesImageView对象
    for(UIView *view in self.subviews)
    {
        if ([view isKindOfClass:GesturesImageView.class])
        {
            [_subviewArray addObject:(GesturesImageView *)view];
        }
        
    }
    //
    //    //初始化获得GesturesImageView位置
    for (int i = 0;i<_subviewArray.count ; i++) {
        GesturesImageView *view = _subviewArray[i];
        view.gesturePosition = i;
    }
    
    //本地数据库时调用
    //添加数据到coredata 不能删除
     [self datatransmissionForcoredata];
     
    
}

#pragma mark --detailMapping添加
-(void)addGesturesImageView:(CGRect)rect image:(UIImage *)image center:(CGPoint)centerpoint withdraftNum:(NSString *)draftNum withtDetailMapping:(DetailMapping *)detailMapping
{
    
    
    GesturesImageView *gesturesImageView;
    //self.view.multipleTouchEnabled = YES;
    
    gesturesImageView = [[GesturesImageView alloc] initWithFrame:
                         rect];
    gesturesImageView.delegate = self;
    
    
//    gesturesImageView.image = image;
    gesturesImageView.center = centerpoint;
    gesturesImageView.parentView = self;
    
    
    
    //重新定义center
    CGPoint translation = [gesturesImageView.panGesture translationInView:self];
    gesturesImageView.center = CGPointMake(gesturesImageView.center.x + translation.x,
                                           gesturesImageView.center.y + translation.y);
    NSLog(@"center %f----%f",gesturesImageView.center.x,gesturesImageView.center.y);
    [gesturesImageView.panGesture setTranslation:CGPointZero inView:self];
    
    //初始赋值
    gesturesImageView.centerpoint =  gesturesImageView.center;
    gesturesImageView.savetag = @"0";
    gesturesImageView.draftid = draftNum;
    gesturesImageView.draftname = [NSString stringWithFormat:@"草稿%@",draftNum];
    
    //11.22 add by miao
    if (image== nil ) {
        UIImageFromURL([NSURL URLWithString:detailMapping.productPictureUrl], ^(UIImage *image) {
            gesturesImageView.image = image;
            [self stopSpinerAnddisappearBorder:gesturesImageView];
        }, ^{
            
        });
        
    }else{
        [self stopSpinerAnddisappearBorder:gesturesImageView];
        gesturesImageView.image = image;
        if (draftNum != nil) {
            // 12.5 add by miao
            CGAffineTransform tmpTransform =   CGAffineTransformFromString(draftNum);
            NSLog(@" gesturesImageView.transform----------%@",NSStringFromCGAffineTransform(tmpTransform));
            gesturesImageView.transform = tmpTransform;
            

            float a;
            float d;
            if (tmpTransform.a<0.000000) {
                a = -1;
            }else {
                a = 1;
            }
            if (tmpTransform.d<0.000000) {
                d = -1;
            }else {
                d = 1;
            }
            gesturesImageView.transform = CGAffineTransformMake(a, tmpTransform.b, tmpTransform.c, d, 0, 0);
            //             gesturesImageView.transform = CGAffineTransformMake(1, tmpTransform.b,  tmpTransform.c, 1, 0, 0);
        }
        
    }
    
    if ( detailMapping!= nil ) {
        //add miao 11.5解决剪切替换问题
        if (detailMapping.shearPicUrl != nil && ![detailMapping.shearPicUrl isEqualToString:@""]) {
            gesturesImageView.imageurl = detailMapping.shearPicUrl;
        }else{
        gesturesImageView.imageurl = detailMapping.productPictureUrl;
        }


        gesturesImageView.detailMapping = detailMapping;
    }
    
    
    [self addSubview:gesturesImageView];
    
    
    //    [_subviewArray addObject:gesturesImageView];
    //清空数组重新加入防止数据重复
    if (_subviewArray!= nil) {
        [_subviewArray removeAllObjects];
    }
    
    //数组里添加GesturesImageView对象
    for(UIView *view in self.subviews)
    {
        if ([view isKindOfClass:GesturesImageView.class])
        {
            [_subviewArray addObject:(GesturesImageView *)view];
        }
        
    }
    //
    //    //初始化获得GesturesImageView位置
    for (int i = 0;i<_subviewArray.count ; i++) {
        GesturesImageView *view = _subviewArray[i];
        view.gesturePosition = i;
    }
    
    //本地数据库时调用
    //添加数据到coredata 不能删除
     [self datatransmissionForcoredata];
     
    
}
#pragma mark ---点击消失重置复原GesturesImageView
//点击消失重置复原GesturesImageView
-(void)resetRecoveryGesturesImageView{
   
    //去掉划线
    [_clickGesturesImageView crossBorderDisappearevent];
    
    
    
    for (int i = 0; i<_subviewArray.count; i++)
    {
        GesturesImageView *view = _subviewArray[i];
        view.alpha = 1.0;
        view.userInteractionEnabled = YES;
        view.transform = CGAffineTransformScale(view.pinchGesture.view.transform,
                                                view.pinchGesture.scale,view.
                                                pinchGesture.scale);
        view.pinchGesture.scale = 1;
        
        view.transform = CGAffineTransformRotate(view.transform, view.rotationG.
                                                 rotation);
        view.rotationG.rotation = 0;
        
        [view.panGesture setTranslation:CGPointZero inView:self];
        
        [self addSubview:view];
    }
    
    [self bringSubviewToFront:_bottomView];
    
    if (_bottomView.hidden == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            _bottomView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, belowwidth);
        } completion:^(BOOL finished) {
            //            _bottomView.hidden = YES;
        }];
        
    }
    //重置属性
    _clickGesturesImageView.isFirstClick = NO;
    _fuzzyView.hidden = YES;
    _topfuzzyView.hidden = YES;
    _clickSuperView.hidden = YES;
    
   
    
    
    
}
#pragma mark - Mark GesturesImageViewDelegate
-(void)callBackPreviousAndNextGesturesImageViewWithview:(id)sender{

    if (_delegate && [_delegate respondsToSelector:@selector(callBackPreviousAndNextGesturesViewWithGestureImageview:)]) {
        [_delegate callBackPreviousAndNextGesturesViewWithGestureImageview:sender];
    }

}

-(void)callBackGesturesImageViewWithview:(id)sender isFirstClickmark:(BOOL)mark
{
    
    [self bringSubviewToFront:_bottomView];
    [UIView animateWithDuration:0.3 animations:^{
        _belowScrollView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, belowwidth);
        
    } completion:^(BOOL finished) {
        _belowScrollView.hidden = YES;
    }];


    //点击相同
    if (_clickGesturesImageView != nil && mark ==YES  && _clickGesturesImageView
        ==  (GesturesImageView *)sender) {
        [self resetRecoveryGesturesImageView];
        return;
    }
    
    _clickGesturesImageView = (GesturesImageView *)sender;
    
        float a = _clickGesturesImageView.transform.a;
        float d = _clickGesturesImageView.transform.d;
         NSLog(@"self.transform.a------- %f",a);
    
        if (d*a < 0.000000) {
    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"1"}];//改变成-
            
        }else{
    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"0"}];//不改变
           
        }
    
    
    if (mark == NO) {
        _clickGesturesImageView.isFirstClick = YES;
        for (int i = 0; i<_subviewArray.count; i++)
        {
            GesturesImageView *view = _subviewArray[i];
            //赋值位置层
            view.gesturePosition = i;
            if (view != _clickGesturesImageView)
            {
                view.userInteractionEnabled = NO;
                
            }
            //获得各个层的阴影
            if ( view.gesturePosition > _clickGesturesImageView.gesturePosition)
            {
                view.alpha = 0.5;
//                view.alpha = 1.0/_subviewArray.count*(_subviewArray.count-view.gesturePosition);
                
            }else{
                
                if (view != _clickGesturesImageView)
                {
                    view.userInteractionEnabled = NO;
                    
                    view.transform = CGAffineTransformScale(
                                                            view.pinchGesture.view.transform,
                                                            view.pinchGesture.scale,
                                                            view.pinchGesture.scale);
                    view.pinchGesture.scale = 1;
                    view.transform = CGAffineTransformRotate(
                                                             view.transform,
                                                             view.rotationG.rotation);
                    view.rotationG.rotation = 0;
                    [view.panGesture setTranslation:CGPointZero inView:self];
                    [_fuzzyView addSubview:view];
                    
                }else{
                
//                    view.userInteractionEnabled = NO;
//                    
//                    view.transform = CGAffineTransformScale(
//                                                            view.pinchGesture.view.transform,
//                                                            view.pinchGesture.scale,
//                                                            view.pinchGesture.scale);
//                    view.pinchGesture.scale = 1;
//                    view.transform = CGAffineTransformRotate(
//                                                             view.transform,
//                                                             view.rotationG.rotation);
//                    view.rotationG.rotation = 0;
//                    [view.panGesture setTranslation:CGPointZero inView:self];
                    _clickSuperView.hidden = NO;
                    [_clickSuperView addSubview:view];
                
                
                }
            }
            
        }
        
        _fuzzyView.backgroundColor = [UIColor whiteColor];
        _fuzzyView.alpha = 0.5;
        _fuzzyView.hidden = NO;
        _topfuzzyView.backgroundColor = [UIColor whiteColor];
        _topfuzzyView.alpha = 0.5;
        _topfuzzyView.hidden = NO;
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            _bottomView.hidden = NO;
            _bottomView.frame = CGRectMake(0, self.frame.size.height-positionHeight, self.frame.size.width, belowwidth);
        } completion:^(BOOL finished) {

        }];
        
    }else{
        
        _clickGesturesImageView.isFirstClick = NO;
        for (int i = 0; i<_subviewArray.count; i++)
        {
            GesturesImageView *view = _subviewArray[i];
            //赋值位置层
            view.gesturePosition = i;
            
            view.transform = CGAffineTransformScale(
                                                    view.pinchGesture.view.transform,
                                                    view.pinchGesture.scale,
                                                    view.pinchGesture.scale);
            view.pinchGesture.scale = 1;
            view.transform = CGAffineTransformRotate(
                                                     view.transform,
                                                     view.rotationG.rotation);
            view.rotationG.rotation = 0;
            [view.panGesture setTranslation:CGPointZero inView:self];
            
            [self addSubview:view];
            
        }
        
        _fuzzyView.hidden = YES;
        _topfuzzyView.hidden = YES;
       
        [UIView animateWithDuration:0.3 animations:^{
           
            _bottomView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, belowwidth);
        } completion:^(BOOL finished) {
             _bottomView.hidden = YES;
        }];
        
    }
    
}
-(void)datatransmissionForcoredata{
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackGesturesImageViewWithPhotovoArray:)])
    {
        [_delegate callBackGesturesImageViewWithPhotovoArray:self.subviewArray];
        

    }

}

#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return  NO;
}

#pragma mark-ScrollViewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
}

-(void)replaceClickevent:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackGesturesImageViewWithClickButton:)]) {
        [_delegate callBackGesturesImageViewWithClickButton:sender];
    }



}
- (void)removeClickevent:(id)sender
{
    
    
    [self removeAnimation];
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackGesturesImageViewWithClickButton:)]) {
        [_delegate callBackGesturesImageViewWithClickButton:sender];
    }
   
    
}

- (void)flipClickevent:(id)sender
{
    [self flipimageMothel];
}

- (void)cloneClickevent:(id)sender
{

 
        [self addGesturesImageView:_clickGesturesImageView.frame image:_clickGesturesImageView.image center:CGPointMake(_clickGesturesImageView.center.x +20, _clickGesturesImageView.center.y+10) withdraftNum:@"clone" withtransform:NSStringFromCGAffineTransform(_clickGesturesImageView.transform) WithmainOldGesturesImageView:_clickGesturesImageView];
        
   
    

   //add by miao 3.2
    [self bringSubviewToFront:_bottomView];
    //重置
    [_clickGesturesImageView crossBorderDisappearevent];
    _clickGesturesImageView.isFirstClick = NO;
    
    _clickGesturesImageView.alpha = 0.7;
    _clickGesturesImageView.userInteractionEnabled = NO;
    
    _clickGesturesImageView = [_subviewArray lastObject];
    
   
    //1.15 add by miao
    _clickGesturesImageView.isFirstClick = YES;
    
    [self stopSpinerAnddisappearBorder:_clickGesturesImageView];
    [_clickGesturesImageView crossBorderevent];
}

- (void)cutoutClickevent:(id)sender
{
   
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackGesturesImageViewWithClickButton:)]) {
        [_delegate callBackGesturesImageViewWithClickButton:sender];
    }
 
}

- (void)forwardClickevent:(id)sender
{
    
    
    //将Subview往前移动一个图层（与它的前一个图层对调位置）
    for (int i = 0; i<_subviewArray.count; i++)
    {
        GesturesImageView *view = _subviewArray[i];
        //赋值位置层
        view.gesturePosition = i;
        if (view == _clickGesturesImageView)
        {
            _position = i;
        }
    }
    if (_position == _subviewArray.count-1) {
        return;
    }
    GesturesImageView *topGesturesImageView =  _subviewArray[_position+1];
    
    
    NSLog(@"%d-----%d",topGesturesImageView.gesturePosition,_position);
   
    
    NSLog(@"%d--qweqe---%d",_clickGesturesImageView.gesturePosition,_position+1);
    NSInteger index1 = [[self subviews] indexOfObject:_clickGesturesImageView];
    NSInteger index2 = [[self subviews] indexOfObject:topGesturesImageView];
    [self exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
    
    topGesturesImageView.gesturePosition = _position;
    _clickGesturesImageView.gesturePosition = _position+1;
    
    //赋值交换层的位置
    
    [_subviewArray replaceObjectAtIndex: _position withObject:topGesturesImageView];//指定索引修改
    [_subviewArray replaceObjectAtIndex: _position+1 withObject:_clickGesturesImageView];//指定索引
    
  
    
    [self datatransmissionForcoredata];
    
    //向后一层设置
    topGesturesImageView.userInteractionEnabled = NO;
    topGesturesImageView.alpha = 1.0;
    topGesturesImageView.transform = CGAffineTransformScale(
                                                            topGesturesImageView.pinchGesture.view.transform,
                                                            topGesturesImageView.pinchGesture.scale,
                                                            topGesturesImageView.pinchGesture.scale);
    topGesturesImageView.pinchGesture.scale = 1;
    topGesturesImageView.transform = CGAffineTransformRotate(
                                                             topGesturesImageView.transform,
                                                             topGesturesImageView.rotationG.rotation);
    topGesturesImageView.rotationG.rotation = 0;
    [topGesturesImageView.panGesture setTranslation:CGPointZero inView:self];
    [self.fuzzyView addSubview:topGesturesImageView];
    
}

- (void)backClickevent:(id)sender
{
    
    //将Subview往后移动一个图层（与它的后一个图层对调位置）
    for (int i = 0; i<_subviewArray.count; i++)
    {
        GesturesImageView *view = _subviewArray[i];
        //赋值位置层
        view.gesturePosition = i;
        
        if (view == _clickGesturesImageView)
        {
            _position = i;
        }
    }
    if (_position == 0)
    {
        return;
    }
    
    GesturesImageView *topGesturesImageView =  _subviewArray[_position-1];
   
    NSInteger index1 = [[self subviews] indexOfObject:_clickGesturesImageView];
    NSInteger index2 = [[self subviews] indexOfObject:topGesturesImageView];
    [self exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
    

    topGesturesImageView.gesturePosition = _position;
    _clickGesturesImageView.gesturePosition = _position-1;
  
    [_subviewArray replaceObjectAtIndex: _position withObject:topGesturesImageView];//指定索引修改
    [_subviewArray replaceObjectAtIndex: _position-1 withObject:_clickGesturesImageView];//指定索引
  
    
   
    [self datatransmissionForcoredata];
    
    //向后一层设置
    topGesturesImageView.userInteractionEnabled = NO;
    topGesturesImageView.alpha = 0.5;
    topGesturesImageView.transform = CGAffineTransformScale(
                                                            topGesturesImageView.pinchGesture.view.transform,
                                                            topGesturesImageView.pinchGesture.scale,
                                                            topGesturesImageView.pinchGesture.scale);
    topGesturesImageView.pinchGesture.scale = 1;
    topGesturesImageView.transform = CGAffineTransformRotate(
                                                             topGesturesImageView.transform,
                                                             topGesturesImageView.rotationG.rotation);
    topGesturesImageView.rotationG.rotation = 0;
    [topGesturesImageView.panGesture setTranslation:CGPointZero inView:self];
    [self addSubview:topGesturesImageView];
    
   
    
}

-(void)fonttextClickevent:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackGesturesImageViewWithClickButton:)]) {
        [_delegate callBackGesturesImageViewWithClickButton:sender];
    }


}
- (void)saveImageClickevent:(id)sender
{
    [self save];
}

-(void)disappearClickevent:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [btn.superview removeFromSuperview];
    
    for (int i = 0; i<_subviewArray.count; i++)
    {
        GesturesImageView *view = _subviewArray[i];
        view.transform = CGAffineTransformScale(
                                                view.pinchGesture.view.transform,
                                                view.pinchGesture.scale,
                                                view.pinchGesture.scale);
        view.pinchGesture.scale = 1;
        
        view.transform = CGAffineTransformRotate(view.transform, view.rotationG.rotation);
        view.rotationG.rotation = 0;
        
        [view.panGesture setTranslation:CGPointZero inView:self];
        
        [self addSubview:view];
    }
    
}
- (void)save{
    //    UIImage *image = [self getNormalImage:self.view];
    UIImage *image ;
    UIAlertView *alert;
    
    image = [self imageFromView:self atFrame:
             CGRectMake(0, 50,self.frame.size.width, self.frame.size.height-100)];

    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:@"" delegate:self
                             cancelButtonTitle:nil otherButtonTitles:@"确定",
             nil];
    [alert show];
    
}

//获取当前屏幕内容
- (UIImage *)getNormalImage:(UIView *)view
{
    float width;
    float height;
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height-100;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//获得某个范围内的屏幕图像
- (UIImage *)imageFromView:(UIView *) theView  atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}

//保存到本地磁盘
- (void)saveToDisk:(UIImage *)image
{
    NSString *dir;
    NSString *path;
    NSData *data;
    
    dir = [NSSearchPathForDirectoriesInDomains(
                                               NSDocumentationDirectory,
                                               NSUserDomainMask,
                                               YES) objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/pic_%f.png",dir,[NSDate timeIntervalSinceReferenceDate]];
    data = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data writeToFile:path atomically:YES];
    
    NSLog(@"保存完毕");
}

-(void)flipimageMothel{
    
    NSLog(@"%@",NSStringFromCGAffineTransform(_clickGesturesImageView.transform));
    float a = _clickGesturesImageView.transform.a;
    float b = _clickGesturesImageView.transform.b;
    float c = _clickGesturesImageView.transform.c;
    float d = _clickGesturesImageView.transform.d;
    
    _clickGesturesImageView.transform = CGAffineTransformMake(-a, -b, c, d, 0, 0);
    NSLog(@"%@",NSStringFromCGAffineTransform(_clickGesturesImageView.transform));
        a = _clickGesturesImageView.transform.a;
        b = _clickGesturesImageView.transform.b;
        c = _clickGesturesImageView.transform.c;
        d = _clickGesturesImageView.transform.d;
    
    _clickGesturesImageView.transform = CGAffineTransformMake(a, -b, -c, d, 0, 0);

     NSLog(@"%@",NSStringFromCGAffineTransform(_clickGesturesImageView.transform));
//    if (a < 0.000000 && d > 0.000000) {
//   
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"1"}];//改变成-
//
//    }else{
//
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"0"}];//不改变
//    }
    if (d*a < 0.000000) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"1"}];//改变成-
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"0"}];//不改变
    }
    

   

    NSLog(@"%@",NSStringFromCGAffineTransform(_clickGesturesImageView.transform));
}



-(void)removeAnimation{
//    NSTimer *connectionTimer;  //timer对象
    
    //实例化timer
    [_clickGesturesImageView crossBorderDisappearevent];
//    float x = _clickGesturesImageView.frame.origin.x;
//    float y = _clickGesturesImageView.frame.origin.y;
  
//    _clickGesturesImageView.frame = CGRectMake(x, y, 30, 30);
//    connectionTimer=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
//    _repeatingTimer = connectionTimer;
    [UIView animateWithDuration:0.5 animations:^{
        _clickGesturesImageView.transform = CGAffineTransformMakeScale(0.05, 0.05);
        _clickGesturesImageView.center = CGPointMake(self.frame.size.width, -10);
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
          self.userInteractionEnabled = YES;
          [self animationFinished];
    }];
 


}
-(void)timerFired:(id)sender{
    if (_clickGesturesImageView == nil) {
        [_repeatingTimer invalidate];
        self.repeatingTimer = nil;
        return;
    }
    float y = _clickGesturesImageView.center.y -90;
   float x = _clickGesturesImageView.center.x +50;
    
    //获取当前画图的设备上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.05f];
    _clickGesturesImageView.center = CGPointMake(x, y);
    [UIView setAnimationDelegate:self];
    //当动画执行结束，执行animationFinished方法
//        [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    //提交动画
    [UIView commitAnimations];
    
    if (_clickGesturesImageView.center.x>400) {
        [_repeatingTimer invalidate];
        self.repeatingTimer = nil;
        _clickGesturesImageView.hidden = YES;
        [self animationFinished];
        
    }

}
-(void)animationFinished{
//    NSString *draftid = _clickGesturesImageView.draftid;
    [_subviewArray removeObject:_clickGesturesImageView];
    [_clickGesturesImageView removeFromSuperview];
    _clickGesturesImageView = nil;

  /* 本地存储数据库
    if (_subviewArray == nil || _subviewArray.count == 0) {//说明最后一个
        [[DataBase sharedDataBaseManager] deleteDraftVObydraftid:draftid];
        [[DataBase sharedDataBaseManager] deletephotoVObydraftid:draftid];
    }else{
        
     [[DataBase sharedDataBaseManager] addAndupdatePothVOSourceWithGesturesImageViewArray:_subviewArray withGestureView:self];
    }
    */
    //与handleEvent相同
    [self resetRecoveryGesturesImageView];
    
    [self disposeBrlowScrollViewAndBottomView];

}

#pragma mark -- 处理下方浮动框
-(void)disposeBrlowScrollViewAndBottomView{
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        
        _bottomView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, belowwidth);
    } completion:^(BOOL finished) {
//        _bottomView.hidden = YES;
    }];
    

    if(_subviewArray.count>0){
        _belowScrollView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, belowwidth);
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            _belowScrollView.hidden = NO;
            _belowScrollView.frame = CGRectMake(0, self.frame.size.height-positionHeight, self.frame.size.width, belowwidth);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    



}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*
-(void)removeAnimation{
    UIImageView *imageView=[[UIImageView alloc]initWithImage:_clickGesturesImageView.image];
    imageView.contentMode=UIViewContentModeScaleToFill;
    imageView.frame=CGRectMake(0, 0, 20, 20);
    imageView.hidden=YES;
    
    CGPoint point= _clickGesturesImageView.center;
    imageView.center=point;
    
    CALayer *layer=[[CALayer alloc]init];
    layer.contents=imageView.layer.contents;
    layer.frame=imageView.frame;
    layer.opacity=1;
    [self.layer addSublayer:layer];
    
    CGPoint point1=CGPointMake(self.bounds.size.width, self.bounds.size.height);
    //动画 终点 都以sel.view为参考系
    CGPoint endpoint=[self convertPoint:point1 fromView:self];
    UIBezierPath *path=[UIBezierPath bezierPath];
    //动画起点
    CGPoint startPoint=[self convertPoint:point1 fromView:self];
    [path moveToPoint:startPoint];
    //贝塞尔曲线中间点
    float sx=startPoint.x;
    float sy=startPoint.y;
    float ex=endpoint.x;
    float ey=endpoint.y;
    float x=sx+(ex-sx)/5;
    float y=sy+(ey-sy)*0.5-400;
    CGPoint centerPoint=CGPointMake(x,y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration=0.8;
    animation.delegate=self;
    animation.autoreverses= NO;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animation forKey:@"buy"];
    
    
    
}
*/



@end
