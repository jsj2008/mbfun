//
//  MentallySuperView.m
//  Wefafa
//
//  Created by Miaoz on 15/3/24.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//


#import "MentallySuperView.h"
#import "LayoutMapping.h"
#import "DetailMapping.h"
#import "GesturesImageView.h"

#import "Globle.h"
#import "TemplateElement.h"
#import "GoodObj.h"
#import "CollocationElement.h"
@interface MentallySuperView   ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,GesturesImageViewDelegate>
@property(nonatomic,strong)UILabel *centerLab;
@property(nonatomic,strong)UIActivityIndicatorView *spinner;
@end

@implementation MentallySuperView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
      
    }
    return self;
}
#pragma mark--UIActivityIndicatorView
-(void)createSpinner{
    if (_spinner== nil) {
        UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        testActivityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        testActivityIndicator.center = self.center;//只能设置中心，不能设置大小
        _spinner = testActivityIndicator;
        [self addSubview:testActivityIndicator];
        
        [testActivityIndicator startAnimating]; // 开始旋转
        //    [testActivityIndicator stopAnimating]; // 结束旋转
        //    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }
    
    
}
-(void)stopSpiner{
    
    [self.spinner stopAnimating];
    [self.spinner setHidesWhenStopped:YES ];
//    [self crossBorderDisappearevent];
    
}
-(void)createLab{
      [self createSpinner];
    if (_centerLab == nil) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        lab.textColor = [UIColor grayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont boldSystemFontOfSize:15.0f];
        lab.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        lab.text = @"";
        _centerLab = lab;
        [self addSubview:lab];
    }
}
-(void)addTapRecognizer
{
    //点击手势
    UITapGestureRecognizer *singleFinger;
    
    singleFinger = [[UITapGestureRecognizer alloc] initWithTarget:self action:
                    @selector(handleEventClick:)];
    singleFinger.numberOfTouchesRequired = 1;
    singleFinger.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleFinger];

//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor redColor];
//    button.frame = rect;
//    [button addTarget:self action:@selector(handleEventClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:button];
}

-(void)handleEventClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(callBackMentallySuperViewWithDetailMapping:LayoutMapping:withMentallView:)]) {
        [_delegate callBackMentallySuperViewWithDetailMapping:_detailMapping LayoutMapping:_layoutMapping withMentallView:self];
    }
}

#pragma mark -- 添加改变模板容器
-(void)changeMentallySuperViewWithLayoutMapping:(LayoutMapping *)layoutMapping withDetailMapping:(DetailMapping *)detailMapping withtemplateElement:(TemplateElement *)templateElement{
    
    _detailMapping = detailMapping;
    _layoutMapping = layoutMapping;
    _templateInfo = templateElement.templateInfo;
  
    CGFloat rationalNum = templateElement.templateInfo.backWidth.intValue/[Globle shareInstance].globleWidth;
    NSString *rationalNumStr = [NSString stringWithFormat:@"%f",rationalNum];
    
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
    self.transform = CGAffineTransformMake(a, b, c, d, 0.0f, 0.0f);
    self.frame = CGRectMake(0.0f, 0.0f, width, height);
    
    
     [self addTapRecognizer];
    CGFloat contentoffsetY = [Globle shareInstance].globleHeight - ([Globle shareInstance].globleWidth);
     self.center = CGPointMake(xPosition, yPosition+contentoffsetY/2);
    UIImageFromURL([NSURL URLWithString:[layoutMapping.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], ^(UIImage *image) {
        self.image = image;
        [self stopSpiner];
    }, ^{
        
    });
    [self createLab];
      _centerLab.text = _layoutMapping.textContent;
  


}

#pragma mark -- 添加容器里商品
-(void)addGesturesImageViewToMentallySuperView:(CGRect)rect image:(UIImage *)image center:(CGPoint)centerpoint withTransformStr:(NSString *)draftNum withtGoodObj:(GoodObj *)goodObj
{
    
//    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    backgroudView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:backgroudView];
    _goodObj = goodObj;
    
    GesturesImageView *gesturesImageView;
    //self.view.multipleTouchEnabled = YES;
  
    CGFloat width;
    CGFloat height;
    if (self.frame.size.width<=self.frame.size.height) {
        width = self.frame.size.width;
        height = self.frame.size.width;;
    }else{
        width = self.frame.size.height;
        height = self.frame.size.height;
    }
    gesturesImageView = [[GesturesImageView alloc] initWithFrame:CGRectMake(0, 0, _bankWidth.integerValue-10 ,_bankHeight.integerValue-10)];
    gesturesImageView.rotationG.enabled = NO;//去除旋转
    gesturesImageView.contentMode = UIViewContentModeScaleAspectFit;
   
    [gesturesImageView crossBorderDisappearevent];
    gesturesImageView.parentView = self;
    gesturesImageView.delegate = self;
    _gesturesImageView = gesturesImageView;
    [self addSubview:gesturesImageView];
    //11.22 add by miao
    if (image== nil ) {
        NSMutableString *lastString = [[NSMutableString alloc] initWithString:[goodObj.clsPicUrl.filE_PATH substringToIndex:goodObj.clsPicUrl.filE_PATH.length-4]];
       
        [lastString appendString:[NSString stringWithFormat:@"--%dx%d.png",(int)_bankWidth.integerValue-10,(int)_bankHeight.integerValue-10]];
        NSLog(@"llllllllllllllll%@",lastString);
        UIImageFromURL([NSURL URLWithString:lastString], ^(UIImage *image) {
            gesturesImageView.image = image;
           [gesturesImageView stopSpinerAnddisappearBorderWithgesturesImageView:gesturesImageView];
//            [gesturesImageView.spinner stopAnimating]; // 结束旋转
//            [gesturesImageView.spinner setHidesWhenStopped:YES]; //当旋转结束时隐藏
        }, ^{
            
        });
        
    }else{

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
           
        }
        
    }
    
    if (goodObj != nil ) {
        //add miao 11.5解决剪切替换问题
        
        if (goodObj.shearPicUrl != nil && ![goodObj.shearPicUrl isEqualToString:@""]) {
     
            gesturesImageView.imageurl = goodObj.shearPicUrl;
        }else{
       
            gesturesImageView.imageurl = goodObj.clsPicUrl.filE_PATH;
        }
        
        gesturesImageView.goodObj = goodObj;
    }
    
   
}

#pragma mark -- 复原草稿 搭配
-(void)repetitionMentallyGesturesImageViewWithServicedata:(LayoutMapping *)layoutMapping withdetailMapping:(DetailMapping *)detailMapping withCollocationInfo:(CollocationInfo *)collocationInfo withtemplateInfo:(TemplateInfo *)templateInfo withContentInfo:(ContentInfo *)contentInfo
{
    
    //容器
    _detailMapping = detailMapping;
    _layoutMapping = layoutMapping;
    
    //容器内部内容
    _contentInfo = contentInfo;
    
    CGFloat rationalNum;
    if (collocationInfo != nil) {
        _collocationInfo = collocationInfo;
        rationalNum = collocationInfo.backWidth.intValue/[Globle shareInstance].globleWidth;
//    ;
    }else{
        _templateInfo = templateInfo;
        rationalNum = templateInfo.backWidth.intValue/[Globle shareInstance].globleWidth;

    }
    
    
    
   
    NSString *rationalNumStr = [NSString stringWithFormat:@"%f",rationalNum];
    
    if (rationalNumStr == nil) {
        rationalNumStr = @"1";
    }
    
    
    NSString *widthStr = [NSString stringWithFormat:@"%@",layoutMapping.width];
    float width = [widthStr floatValue]/rationalNumStr.floatValue;
    NSString *heightStr = [NSString stringWithFormat:@"%@",layoutMapping.height];
    float height = [heightStr floatValue]/rationalNumStr.floatValue;
    _bankWidth = [NSString stringWithFormat:@"%0.0f",width];
    _bankHeight = [NSString stringWithFormat:@"%0.0f",height];
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
    
//    //暂时重新赋值
    layoutMapping.rectSx = [NSString stringWithFormat:@"%f",1.0f];
    layoutMapping.rectSy = [NSString stringWithFormat:@"%f",1.0f];
    
    NSString *aStr = [NSString stringWithFormat:@"%@",layoutMapping.rectSx];
    float a = [aStr floatValue];
    NSString *bStr = [NSString stringWithFormat:@"%@",layoutMapping.rectRx];
    float b = [bStr floatValue];
    NSString *cStr = [NSString stringWithFormat:@"%@",layoutMapping.rectRy];
    float c = [cStr floatValue];
    NSString *dStr = [NSString stringWithFormat:@"%@",layoutMapping.rectSy];
    float d = [dStr floatValue];
    
    self.frame = CGRectMake(0.0f, 0.0f, width, height);
    self.transform = CGAffineTransformMake(a, b, c, d, 0.0f, 0.0f);
  
    
    CGFloat borderWidth = 1.0f;
    self.layer.borderColor = [UIColor yellowColor].CGColor;
    self.layer.borderWidth = borderWidth;
    
    
    [self addTapRecognizer];
//    CGFloat contentoffsetY = [Globle shareInstance].globleHeight - ([Globle shareInstance].globleWidth);//+contentoffsetY/2
    
    self.center = CGPointMake(xPosition, yPosition);
    
    NSString *bankPicUrl =layoutMapping.pictureUrl;
    NSRange tmpRange = [bankPicUrl rangeOfString:@"$blank_"];
    if (tmpRange.length== 7) {
    NSString * bankdicString = [[bankPicUrl componentsSeparatedByString:@"$blank_"] objectAtIndex:1];
    NSArray *bankdicArray =    [bankdicString   componentsSeparatedByString:@"--"];
    NSString *lastBankdicStr ;
    if(bankdicArray.count == 2){
        
        lastBankdicStr = bankdicArray[0];
    }else{
        NSString *tmpStr = [bankdicArray objectAtIndex:0];
        NSMutableString *tmpBankString = [[NSMutableString alloc] initWithString:[tmpStr substringToIndex:tmpStr.length-4]];
        lastBankdicStr = tmpBankString;
    }
    //                {"w":200,"h":200,"b":1,"bc":"FF0000"}
    NSDictionary *oldBankdic = [NSString dictionaryWithJsonString:lastBankdicStr];
    
    NSMutableDictionary *bankDic = [NSMutableDictionary new];
    [bankDic setObject:[oldBankdic objectForKey:@"w"] forKey:@"w"];
    [bankDic setObject:[oldBankdic objectForKey:@"h"] forKey:@"h"];
    [bankDic setObject:[NSNumber numberWithInt:0] forKey:@"b"];
    [bankDic setObject:@"FF0000" forKey:@"bc"];
    NSString *lastMainBankStr = [NSString stringWithFormat:@"$blank_%@.png",[NSString stringByJson:bankDic]];
        bankPicUrl = [NSString stringWithFormat:@"%@%@",[[bankPicUrl componentsSeparatedByString:@"$blank_"] objectAtIndex:0],lastMainBankStr];
    }
    
    UIImageFromURL([NSURL URLWithString:[bankPicUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], ^(UIImage *image) {
        self.image = image;
        [self stopSpiner];
    }, ^{
        
    });
    [self createLab];
    _centerLab.text = _layoutMapping.textContent;
    

    if (contentInfo != nil) {
    
        CGFloat borderWidth = 0.0f;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = borderWidth;
        //容器内部内容
        
        CGFloat rationalNum2 = contentInfo.width.intValue /width;
        NSString *rationalNumStr2 = [NSString stringWithFormat:@"%f",rationalNum2];
        if (rationalNumStr2 == nil) {
            rationalNumStr2 = @"1";
        }
        
        
        NSString *widthStr2 = [NSString stringWithFormat:@"%@",contentInfo.width];
        float width2 = [widthStr2 floatValue]/rationalNumStr.floatValue;
        NSString *heightStr2 = [NSString stringWithFormat:@"%@",contentInfo.height];
        float height2 = [heightStr2 floatValue]/rationalNumStr.floatValue;
        
    
//        NSString *xPositionStr2 = [NSString stringWithFormat:@"%d",contentInfo.xPosition.intValue-(layoutMapping.xPosition.intValue - layoutMapping.width.intValue/2)];//
//        float xPosition2 = [xPositionStr2 floatValue]/rationalNumStr2.floatValue ;
//
//        NSString *yPositionStr2 = [NSString stringWithFormat:@"%d",contentInfo.yPosition.intValue-(layoutMapping.yPosition.intValue - layoutMapping.height.intValue/2)];
//        float yPosition2 = [yPositionStr2 floatValue]/rationalNumStr2.floatValue;

        //暂时重新赋值
        contentInfo.rectSx = [NSString stringWithFormat:@"%f",1.0f];
        contentInfo.rectSy = [NSString stringWithFormat:@"%f",1.0f];

        NSString *aStr2 = [NSString stringWithFormat:@"%@",contentInfo.rectSx];
        float a2 = [aStr2 floatValue];
        NSString *bStr2 = [NSString stringWithFormat:@"%@",contentInfo.rectRx];
        float b2 = [bStr2 floatValue];
        NSString *cStr2 = [NSString stringWithFormat:@"%@",contentInfo.rectRy];
        float c2 = [cStr2 floatValue];
        NSString *dStr2 = [NSString stringWithFormat:@"%@",contentInfo.rectSy];
        float d2 = [dStr2 floatValue];
        NSString *indexStr2 = [NSString stringWithFormat:@"%@",contentInfo.index];
        int indext2 = [indexStr2 intValue];

//
        GesturesImageView *view;
        view = [[GesturesImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width2, height2)];
        view.rotationG.enabled = NO;//去除旋转
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.delegate = self;
        view.parentView = self;
       
//        view.center = CGPointMake(xPosition2, yPosition2);
        NSLog(@"layoutMapping--%f-----%f",layoutMapping.xPosition.floatValue,
              layoutMapping.yPosition.floatValue);
        NSLog(@"contentInfo --%f-----%f",contentInfo.crossInfo.x.floatValue,contentInfo.crossInfo.y.floatValue);
//        130 63
       static float xPosition2;
       static float yPosition2;
//        左边
//        "crossInfo" : {
//            "y" : 64,
//            "p" : "$blank_{"w":128,"b":0,"bc":"FF0000","h":128}.png",
//            "w" : 128,
//            "x" : 127,
//            "iw" : 128
//        },
        //右边
//        "contentList" : [
//                         {
//                             "id" : 72860,
//                             "crossInfo" : {
//                                 "y" : 69,
//                                 "p" : "$blank_{"w":128,"b":0,"bc":"FF0000","h":128}.png",
//                                 "w" : 128,
//                                 "x" : 1,
//                                 "iw" : 128
//                             },
        
      
        
        if (contentInfo.crossInfo.w.intValue/2 == contentInfo.crossInfo.x.intValue) {
            xPosition2 = contentInfo.crossInfo.x.floatValue/rationalNumStr2.floatValue;
        }else if(contentInfo.crossInfo.x.intValue > contentInfo.crossInfo.w.intValue/2 ){//左边-
           
            xPosition2 = (contentInfo.crossInfo.w.intValue - contentInfo.crossInfo.x.floatValue)/rationalNumStr2.floatValue;
        
        }else if(contentInfo.crossInfo.x.intValue < contentInfo.crossInfo.w.intValue/2 ){//右边

            xPosition2 = abs((int)(contentInfo.crossInfo.w.intValue - contentInfo.crossInfo.x.floatValue))/rationalNumStr2.floatValue;
            }



        //上边
//        "contentList" : [
//                         {
//                             "id" : 72872,
//                             "crossInfo" : {
//                                 "y" : 136,
//                                 "p" : "$blank_{"w":128,"b":0,"bc":"FF0000","h":128}.png",
//                                 "w" : 128,
//                                 "x" : 64,
//                                 "iw" : 128
//                             },
        //下边
//        "contentList" : [
//                         {
//                             "id" : 72873,
//                             "crossInfo" : {
//                                 "y" : 13,
//                                 "p" : "$blank_{"w":128,"b":0,"bc":"FF0000","h":128}.png",
//                                 "w" : 128,
//                                 "x" : 65,
//                                 "iw" : 128
//                             },

        
        if (contentInfo.crossInfo.w.intValue/2 == contentInfo.crossInfo.y.intValue) {
            yPosition2 = contentInfo.crossInfo.y.floatValue/rationalNumStr2.floatValue;
        }else if(contentInfo.crossInfo.y.intValue > contentInfo.crossInfo.w.intValue/2 ){//上边-
            yPosition2 = (contentInfo.crossInfo.w.intValue - contentInfo.crossInfo.y.floatValue)/rationalNumStr2.floatValue;
            
        }else if(contentInfo.crossInfo.y.intValue < contentInfo.crossInfo.w.intValue/2 ){//下边+
            yPosition2 = abs(contentInfo.crossInfo.w.intValue - contentInfo.crossInfo.y.floatValue)/rationalNumStr2.floatValue;
            
        }

         view.center = CGPointMake(xPosition2,yPosition2);
//        view.frame = CGRectMake(xPosition2, yPosition2, view.frame.size.width, view.frame.size.height);
        //11.20 add by miao
        UIImageFromURL([NSURL URLWithString:[contentInfo.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], ^(UIImage *image) {
            view.image = image;
            [view stopSpinerAnddisappearBorderWithgesturesImageView:view];
        }, ^{
            
        });

        view.alpha = 1.0;
        view.userInteractionEnabled = YES;
        if (b2>0 && b2<0 ) {
        view.transform = CGAffineTransformMake(a2, b2, c2, d2, 0.0f, 0.0f);
        }else{
        view.transform = CGAffineTransformMake(a2, 0, 0, d2, 0.0f, 0.0f);
        
        }
        view.gesturePosition = indext2;
        view.imageurl = contentInfo.pictureUrl ;
        _gesturesImageView = view;
        [self addSubview:view];
        
       
//        view.center = [self convertPoint:view.center fromView:self.mainSuperView];
//        view.transform = CGAffineTransformMake(a2, 0, 0, d2, 0.0f, 0.0f);
//        [self addSubview:view];
        

    }
    
}


#pragma mark -- GesturesImageViewDelegate
-(void)callBackGesturesImageViewWithview:(id)sender isFirstClickmark:(BOOL)mark{

    //点击相同
//    if (_gesturesImageView != nil && mark ==YES  && _gesturesImageView
//        ==  (GesturesImageView *)sender) {
//        [self resetRecoveryGesturesImageView];
//        return;
//    }
    float a = _gesturesImageView.transform.a;
    float d = _gesturesImageView.transform.d;
    NSLog(@"self.transform.a------- %f",a);
    
    if (d*a < 0.000000) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"1"}];//改变成-
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"0"}];//不改变
        
    }

    if (mark == NO) {
       
        
        if ( self.layer.borderWidth != 1.0f) {
            CGFloat borderWidth = 1.0f;
            self.layer.borderColor = [UIColor yellowColor].CGColor;
            self.layer.borderWidth = borderWidth;
        }
        
    }else{
        CGFloat borderWidth = 0.0f;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = borderWidth;
        
        
       
    }

    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackMentallySuperViewWithMentallView:withGesturesImageView:isFirstClickmark:)]) {
        [_delegate callBackMentallySuperViewWithMentallView:self withGesturesImageView:sender isFirstClickmark:mark];
    }


}
-(void)callBackPreviousAndNextGesturesImageViewWithview:(id)sender{

    if ( self.layer.borderWidth != 1.0f) {
        CGFloat borderWidth = 1.0f;
        self.layer.borderColor = [UIColor yellowColor].CGColor;
        self.layer.borderWidth = borderWidth;
    }
  

}

#pragma mark ---点击消失重置复原GesturesImageView
//点击消失重置复原GesturesImageView
-(void)resetRecoveryGesturesImageView{
    
    //去掉划线
    [_gesturesImageView crossBorderDisappearevent];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
