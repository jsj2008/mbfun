//
//  GeneralView.m
//  BanggoPhone
//
//  Created by Juvid on 14-8-1.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "GeneralView.h"
/**********************************************通用控件初始化**********************************************/
#import "Utils.h"

@implementation BalckLable

-(void)awakeFromNib{
    self.font=[UIFont systemFontOfSize:12];
    self.textColor=kUIColorFromRGB(0x313131);
}

@end
@implementation GrayLable

-(void)awakeFromNib{
    self.font=[UIFont systemFontOfSize:11];
    self.textColor=kUIColorFromRGB(0x919191);
}

@end
/**********************************************输入框下划线**********************************************/


@implementation MBTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
   
    UIView *vieLeft=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 30)];
    self.leftView=vieLeft;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.borderStyle=UITextBorderStyleNone;
    
    self.font=[UIFont systemFontOfSize:16];
    self.textColor=kUIColorFromRGB(0x333333);
    
    UIView *vieLine=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
    vieLine.backgroundColor=kUIColorFromRGB(0x888888);
    [self addSubview:vieLine];
    
//    [self.layer setCornerRadius:3];
//    [self.layer setBorderWidth:0.5];
//    [self.layer setBorderColor:kUIColorFromRGB(0xcccccc).CGColor];
    self.clearButtonMode=UITextFieldViewModeWhileEditing;
   
}
-(void)setLeftViewImg:(NSString *)imgName{
    UIView *vieLeft=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 39, self.frame.size.height)];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, self.frame.size.height)];
    [img setContentMode:UIViewContentModeScaleAspectFit];
    img.image=[UIImage imageNamed:imgName];
    [vieLeft addSubview:img];
    self.leftView=vieLeft;
    
}
@end

@implementation BaseButton

- (void)awakeFromNib
{
    self.backgroundColor=DEFAULTCOLOR;
   
    [self setTitleColor:kUIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self.layer setCornerRadius:3];
    if (self.frame.size.width>200) {
        self.titleLabel.font=BUTTONBIGFONT;
        
    }
    else{
        self.titleLabel.font=BUTTONSMALLRFONT;
    }
    
}

@end

/**********************************************黑色按钮**********************************************/
@implementation OrangeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/*-(id)initWithCoder:(NSCoder *)aDecoder{
 self=[super initWithCoder:aDecoder];
 if (self) {
 NSLog(@"%f",self.frame.size.width);
 }
 return self;
 }*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundImage:[UIImage imageNamed:@"btnTouchDefault"] forState:UIControlStateNormal];
    
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



@implementation BlackButtton
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor=[UIColor blackColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
/**********************************************橙色不可点按钮**********************************************/
@implementation EnableButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.enabled=NO;
    self.titleLabel.font=BUTTONBIGGIGFONT;
//    self.alpha=0.6;
    self.backgroundColor=[UIColor clearColor];
    [self setBackgroundImage:[UIImage imageNamed:@"btnTouchUnSelect"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
-(void)SetUnSelectBg{
    self.enabled=NO;
    //    self.alpha=0.6;
//    self.backgroundColor = BtnUnSelColor;
    [self setBackgroundImage:[UIImage imageNamed:@"btnTouchUnSelect"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
-(void)setSelectBg{
    self.enabled=YES;
    //    self.alpha=0.6;
    [self setBackgroundImage:[UIImage imageNamed:@"btnTouchDefault"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.backgroundColor = [UIColor blackColor];
}
// albert
/*
-(void)setAlpha:(CGFloat)alpha{
    
    if (alpha == 0.6) {
        self.backgroundColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1];
        
    }else if (alpha == 1){
        self.backgroundColor = [UIColor blackColor];
    }else{

        [super setAlpha:alpha];
    }
}
 */
/*/
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
@implementation BlackEnableButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
   
    [super awakeFromNib];
     self.titleLabel.font=BUTTONBIGFONT;
    self.enabled=NO;
    self.alpha=0.6;
}
-(void)SetUnSelectBg{
    self.enabled=NO;
    self.alpha=0.6;
}
-(void)setSelectBg{
    self.enabled=YES;
    self.alpha=1;
    //    self.backgroundColor = kUIColorFromRGB(0x4376de);
}
// albert
/*
 -(void)setAlpha:(CGFloat)alpha{
 
 if (alpha == 0.6) {
 self.backgroundColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1];
 
 }else if (alpha == 1){
 self.backgroundColor = [UIColor blackColor];
 }else{
 
 [super setAlpha:alpha];
 }
 }
 */
/*/
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

@implementation BorderButton
- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self.layer setCornerRadius:2];
//    [self.layer setBorderWidth:1];
    self.backgroundColor=[UIColor clearColor];
    
//    [self setTitleColor:kUIColorFromRGB(0xe2e2e2) forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    
    self.titleLabel.font=[UIFont systemFontOfSize:11];
    
    
    _labNum=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 16)];
    _labNum.font=[UIFont boldSystemFontOfSize:13];
    _labNum.textAlignment=NSTextAlignmentCenter;
    _labNum.textColor=[UIColor whiteColor];
    
//    _labNum.textColor=[UIColor blackColor];
    _labNum.tag=111;
    _labNum.text=@"";
    [self addSubview:_labNum];
}
-(void)setLabTitle:(NSString *)nums{
    _labNum.text=nums;
}

@end


@implementation BorderLineButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor=[UIColor clearColor];
    //背景
    self.backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.backImgView];
    
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.titleLabel.font=[UIFont systemFontOfSize:11];
    
    self.layer.borderColor = [Utils HexColor:0xE2E2E2 Alpha:1].CGColor;
    self.layer.borderWidth =0.5;
    _labNum=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 16)];
    _labNum.font=[UIFont boldSystemFontOfSize:13];
    _labNum.textAlignment=NSTextAlignmentCenter;
    _labNum.textColor=[UIColor whiteColor];
    _labNum.tag=111;
    _labNum.text=@"";
    [self addSubview:_labNum];
    
    //右侧线
    self.rightLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-1,self.frame.origin.y,1, self.frame.size.height)];
    [self.rightLineImgView setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    self.rightLineImgView.hidden=YES;
    [self addSubview:self.rightLineImgView];
    
}
-(void)setLabTitle:(NSString *)nums{
    _labNum.text=nums;
}

- (void)setSelected:(BOOL)isSelect
{
    if (isSelect) {
        self.backImgView.backgroundColor=[Utils HexColor:0xe2e2e2 Alpha:1];
    }
    else
    {
        self.backImgView.backgroundColor=[UIColor whiteColor];
    }
    
}

@end


@implementation NumButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    //    [self.layer setCornerRadius:2];
    //    [self.layer setBorderWidth:1];
    labNum=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-17, 0, 16, 16)];
    labNum.font=[UIFont boldSystemFontOfSize:9];
    labNum.textAlignment=NSTextAlignmentCenter;
//    labNum.backgroundColor=DEFAULTCOLOR;
    labNum.backgroundColor=[Utils HexColor:0xE52027 Alpha:1];
    
    labNum.tag=111;
    labNum.text=@"";
    labNum.textColor=[UIColor whiteColor];
    [labNum.layer setCornerRadius:8];
    [labNum setClipsToBounds:YES];
    [self addSubview:labNum];
}
-(void)setLabTitle:(NSString *)nums{
    if ([nums integerValue]<=0) {
        labNum.hidden=YES;
    }
    else{
        labNum.hidden=NO;
         labNum.text=nums;
    }
}

@end
@implementation CircleImg

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.layer setCornerRadius:CGRectGetHeight(self.bounds)/2];
    [self setClipsToBounds:YES];
   
}
@end

@implementation MBMyStoreButton
- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundColor=[UIColor whiteColor];
    
    self.titleLabel.font=[UIFont systemFontOfSize:11];
    CGFloat height = CGRectGetHeight(self.bounds);
    labText = [[UILabel alloc]initWithFrame:CGRectMake(0, height * 0.2, CGRectGetWidth(self.bounds), height * 0.3)];
    labText.font=[UIFont boldSystemFontOfSize:15];
    labText.textAlignment=NSTextAlignmentCenter;
    labText.textColor=[UIColor blackColor];
    labText.backgroundColor=[UIColor clearColor];
    [self addSubview:labText];
    
    labNum=[[UILabel alloc]initWithFrame:CGRectMake(0, height * 0.5, CGRectGetWidth(self.bounds), height * 0.3)];
    labNum.font=[UIFont boldSystemFontOfSize:15];
    labNum.textAlignment=NSTextAlignmentCenter;
    labNum.textColor=[UIColor blackColor];
    labNum.tag=111;
    labNum.backgroundColor=[UIColor clearColor];
    labNum.text=@"";
    [self addSubview:labNum];
}
-(void) setlabTitle:(NSString *)nums
{
    labNum.text=nums;
}
-(void) setTextTitle:(NSString *)text
{
    labText.text=text;
}

@end


