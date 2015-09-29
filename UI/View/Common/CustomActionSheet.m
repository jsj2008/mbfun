//
//  CustomActionSheet.m
//  Wefafa
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomActionSheet.h"
#import "Utils.h"


#define WINDOW_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.25f



@implementation CustomActionSheet

//viewHeight:上方自定义区域的高度
-(id)initWithTitle:(NSString *)title viewHeight:(int)viewHeight
{
    self = [super init];
    if (self) {
        int buttonHeight=45;
//        _viewHeight=viewHeight+buttonHeight+15;
        _viewHeight = 176;

        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        //        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
//        int h=[[UIScreen mainScreen] bounds].size.height;
//        self.frame=CGRectMake(0,h-(_viewHeight+buttonHeight+15),SCREEN_WIDTH,_viewHeight+buttonHeight+15);
        
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height), SCREEN_WIDTH, 120)];
        self.view.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 15, SCREEN_WIDTH, 0.5)];
//        [line setBackgroundColor:[Utils HexColor:0X919191 Alpha:1.0]];
//        [_view addSubview:line];
        
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, SCREEN_WIDTH, buttonHeight)];
        _btnCancel.backgroundColor = [UIColor whiteColor];
        [_btnCancel setTitleColor:[Utils HexColor:0X919191 Alpha:1.0] forState:UIControlStateNormal];
//        [_btnCancel setTitleColor:[Utils HexColor:0x353535 Alpha:1.0] forState:UIControlStateHighlighted];
        _btnCancel.titleLabel.font=[UIFont systemFontOfSize:16];
//        _btnCancel.layer.cornerRadius=4;
        [_btnCancel addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:_btnCancel];
        
//        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height), 320, height)];
//        self.view.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
//        
//        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        toolBar.barStyle = UIBarStyleDefault;
//        
//        
//        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStyleDone target: self action: @selector(done)];
//        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(docancel)];
//        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
//        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton,rightButton, nil];
//        [toolBar setItems: array];
        
        
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
        [self.view addGestureRecognizer:tapGesture1];
        
        
//        [self addSubview:self.view];
//        [self.view addSubview:toolBar];
//        [self.view addSubview:view];
        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            [self.view setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-_viewHeight, [UIScreen mainScreen].bounds.size.width, 120)];
            [_btnCancel setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 45, SCREEN_WIDTH, buttonHeight)];
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
    return self;
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.view setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        [_btnCancel setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.backgroundColor=[UIColor clearColor];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)showInView:(UIView *)view{
    
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
//    [self.view addSubview:self];
}

- (void)tappedBackGroundView
{
    //
}

-(void)btnCancelClick:(id)sender
{
    [self tappedCancel];
}

-(void)done{
    [self tappedCancel];
}

-(void)docancel
{
    [self tappedCancel];
}
-(void)dismissWithClickedButtonIndex:(int)index animated:(BOOL)animated
{
    [self tappedCancel];
}
@end




//ios7以前可以用
@implementation CustomActionSheetOld

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(id)initWithTitle:(NSString *)title viewHeight:(int)viewHeight
{
    _viewHeight=viewHeight;
//    self=[super init];
    self=[super initWithTitle:@" " delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
//    self = [super initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,viewHeight+buttonHeight+15)];
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor=[UIColor whiteColor];
    
    int buttonHeight=40;
    int h=[[UIScreen mainScreen] bounds].size.height;
    self.frame=CGRectMake(0,h-(_viewHeight+buttonHeight+15),SCREEN_WIDTH,_viewHeight+buttonHeight+15);
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _viewHeight)];
    [self addSubview:_view];
    
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(15, _viewHeight, SCREEN_WIDTH-15*2, buttonHeight)];
    _btnCancel.backgroundColor = [Utils HexColor:0xacacac Alpha:1.0];
    [_btnCancel setTitleColor:[Utils HexColor:0x353535 Alpha:1.0] forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[Utils HexColor:0x353535 Alpha:1.0] forState:UIControlStateHighlighted];
    _btnCancel.titleLabel.font=[UIFont systemFontOfSize:16];
    _btnCancel.layer.cornerRadius=4;
    [_btnCancel addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [self addSubview:_btnCancel];
    
    if (_loadActionViewEvent!=nil)
    {
        [_loadActionViewEvent fire:self eventData:nil];
    }
}

-(void)btnCancelClick:(id)sender
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

//-(void)showInView:(UIView *)view
//{
//    [super showInView:view];
//}
@end
