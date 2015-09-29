//
//  FontTextEditViewController.m
//  Wefafa
//
//  Created by Miaoz on 15/1/16.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//
//废弃 不用 
#import "FontTextEditViewController.h"
#import "Globle.h"
#import "FontInfo.h"
#import "ScratchableButtonsView.h"
#import "HcCustomKeyboard.h"
#import "ColorMapping.h"
#import "MaterialMapping.h"
#import "GesturesImageView.h"


#define MENU_POPOVER_FRAME  CGRectMake(8, 0, 320, 132)


#define textfont_fid        @"fid"
#define textfont_fc         @"fc"
#define textfont_ps         @"ps"
#define textfont_sw         @"sw"
#define textfont_mw         @"mw"
#define textfont_base64text @"txt"

#define textfont_normaltext            @"normaltext"
#define textfont_pictureurl @"pictureurl"

@interface FontTextEditViewController ()<MLKMenuPopoverDelegate,ScratchableButtonsViewDelegate,HcCustomKeyboardDelegate,GesturesImageViewDelegate,UIGestureRecognizerDelegate>
//@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
//@property (weak, nonatomic) IBOutlet UIButton *fontButton;
//@property (weak, nonatomic) IBOutlet UIButton *styleButton;

@property (strong, nonatomic) UIScrollView *bottomScrollView;
@property (strong, nonatomic) UIButton *fontButton;
@property (strong, nonatomic) UIButton *styleButton;

@property (strong, nonatomic) MLKMenuPopover   *stylePopover;
@property (strong, nonatomic)ScratchableButtonsView *fontView;
@property (strong, nonatomic)ScratchableButtonsView *colorView;
@property (strong,nonatomic) NSMutableArray *dataFontarray;
@property (strong,nonatomic) NSMutableArray *dataColorarray;
@property (strong,nonatomic) GesturesImageView *currentGesturesImgView;
@property (strong,nonatomic) UIView *clickSuperView;
@property (strong,nonatomic)UIImageView *backGroundImgView;

@property (strong,nonatomic) NSMutableDictionary *dataDic;
@property (strong,nonatomic) NSMutableDictionary *otherDic;




@end
/*
//http://img.51mb.com:5659/sources/$text_{"txt":"QWJjZA","fid":1001,"fc":"000000","ps":30,"sw":0,"mw":0}.png
//http://img.51mb.com:5659/sources/$text_{"mw":0,"fid":1001,"sw":0,"txt":"amhoaGpoamhq","fc":"000000","ps":100}.png
http://127.0.0.1:8080/sources/$text_{"txt":"5Lit5Zu9","fid":1002,"fc":"567890","ps":30,"sw":0,"mw":0}.png

String txt; //文字，需要base64编码
Integer fid; // 字体id，目前只上传了1001-1015 15种字体
String fc; // 文字颜色
int ps; // 文字大小
// 上面4个参数必填
String b; // 背景色
String sc; // 文字边框颜色
Integer sw; // 文字边框宽
Integer mw; // 最大宽度限制
 */
@implementation FontTextEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    if (_dataFontarray == nil) {
        _dataFontarray = [NSMutableArray new];
    }
    if (_dataColorarray == nil) {
        _dataColorarray = [NSMutableArray new];
    }
    
    if (_dataDic == nil) {
        _dataDic = [NSMutableDictionary new];
        
        [_dataDic setObject:[NSNumber numberWithInteger:30] forKey:textfont_ps];
        [_dataDic setObject:[NSNumber numberWithInteger:0] forKey:textfont_sw];
        [_dataDic setObject:[NSNumber numberWithInteger:0] forKey:textfont_mw];
        
        [_dataDic setObject:[NSNumber numberWithInteger:1001] forKey:textfont_fid];
        [_dataDic setObject:@"000000" forKey:textfont_fc];
    }
    if (_otherDic == nil) {
        _otherDic = [NSMutableDictionary new];
        

    }
    if (_backGroundImgView == nil) {
        _backGroundImgView = [[UIImageView alloc] initWithImage:nil];
        _backGroundImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-120);
        _backGroundImgView.backgroundColor = [UIColor yellowColor];
        self.backGroundImgView.image = _backGroundImage;
        [self.view addSubview:_backGroundImgView];
    }
    [self createScrollView];
    [self creattmpView];
    if (_currentGesturesImgView == nil ) {
        
        GesturesImageView *view;
        view = [[GesturesImageView alloc] initWithFrame:CGRectMake(0, 0.0f, 100, 40)];
        view.center = CGPointMake(self.view.center.x, 30.0f);
      
//        [view removeGestureRecognizer:view.singleFinger];
        [self.clickSuperView addSubview:view];
        
        view.delegate   = self;
//        view.spinner.hidden = YES;
        [view.spinner stopAnimating]; // 结束旋转
        [view.spinner setHidesWhenStopped:YES]; //当旋转
        _currentGesturesImgView = view;
        view.parentView = self.clickSuperView;
        view.alpha = 1.0;
       
    }
    
    [[HcCustomKeyboard customKeyboard]textViewShowView:self customKeyboardDelegate:self];
    
    [self requestGetTextFontInfoFilterWithDic:nil];
   
   
    [self.view bringSubviewToFront:_bottomScrollView];
}
-(void)setBackGroundImage:(UIImage *)backGroundImage{
    _backGroundImage = backGroundImage;

}

-(void)createScrollView{

    if (_bottomScrollView == nil) {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-120, self.view.frame.size.width, 60)];
        [_bottomScrollView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:_bottomScrollView];
    }

    if (_fontButton == nil) {
        _fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fontButton.frame = CGRectMake(_bottomScrollView.frame.origin.x, 10, 50, 30);
        [_fontButton setTitle:@"样式" forState:UIControlStateNormal];
        [_fontButton addTarget:self action:@selector(fontButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomScrollView addSubview:_fontButton];
        
    }
    if (_styleButton == nil) {
        _styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _styleButton.frame = CGRectMake(_bottomScrollView.frame.size.width - 50, 10, 50, 30);
        [_styleButton setTitle:@"颜色" forState:UIControlStateNormal];
        [_styleButton addTarget:self action:@selector(styleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomScrollView addSubview:_styleButton];
    }

}

-(void)creattmpView {
    if (_clickSuperView == nil) {
        UIView *clickSuperView = [[UIView alloc] initWithFrame:self.view.frame];
        _clickSuperView = clickSuperView;
//        clickSuperView.hidden = YES;
        clickSuperView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:clickSuperView];
        [self addGestures];
    }
    
}
-(void)addGestures
{
    
    
    UIRotationGestureRecognizer *tmprotationG;
    UIPinchGestureRecognizer *tmppinchGestureRecongnizer;
    UIPanGestureRecognizer *tmppanGesture;
  
    
 
    
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
    

    
    [self.clickSuperView addGestureRecognizer:tmppinchGestureRecongnizer];
    [self.clickSuperView addGestureRecognizer:tmprotationG];
    [self.clickSuperView addGestureRecognizer:tmppanGesture];
    
    
}


- (void)panpan:(UIPanGestureRecognizer *)sender
{
    //    [self.view bringSubviewToFront:self];
    CGPoint translation = [sender translationInView:self.clickSuperView];
    _currentGesturesImgView.center = CGPointMake( _currentGesturesImgView.center.x + translation.x,
                                                 _currentGesturesImgView.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:self.clickSuperView];
   
    
}
- (void)changeImage:(UIPinchGestureRecognizer*)pinchGestureRecognizer
{
    
    NSLog(@"scale %f",pinchGestureRecognizer.scale);
    _currentGesturesImgView.transform = CGAffineTransformScale(_currentGesturesImgView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
 
    pinchGestureRecognizer.scale = 1;
    
}

- (void)rotationImage:(UIRotationGestureRecognizer*)gesture
{
   
    NSLog(@"rotation %f",gesture.rotation);

    _currentGesturesImgView.transform = CGAffineTransformRotate(_currentGesturesImgView.transform, gesture.rotation);
    gesture.rotation = 0;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---GesturesImageViewDelegate

-(void)callBackGesturesImageViewWithview:(id)sender isFirstClickmark:(BOOL)mark{
        [_currentGesturesImgView crossBorderevent];
    
//    [_currentGesturesImgView crossBorderDisappearevent];
    if ([HcCustomKeyboard customKeyboard].mBackView.hidden == NO) {
        
        [HcCustomKeyboard customKeyboard].mBackView.hidden = YES;
        
    }else{
        [HcCustomKeyboard customKeyboard].mBackView.hidden = NO;
        [[HcCustomKeyboard customKeyboard].mTextView becomeFirstResponder];
    }

    NSString *normalstr = [_otherDic objectForKey:textfont_normaltext];
    if (normalstr.length != 0) {
         [HcCustomKeyboard customKeyboard].mTextView.text = normalstr;
    }
   
    
}
#pragma mark --- 获取文字信息接口

-(void)requestGetTextFontInfoFilterWithDic:(NSMutableDictionary *)dic{

    [[HttpRequest shareRequst] httpRequestGetTextFontInfoFilterWithDic:dic success:^(id obj)
    {
        
        id data = [obj objectForKey:@"results"];
      
        if ([data isKindOfClass:[NSArray class]])
        {
            if (data != nil)
            {
                for (NSDictionary *dic  in data)
                    
                {
                    FontInfo *fontInfo =[JsonToModel objectFromDictionary:dic className:@"FontInfo"];
                    
                    
                    
                    UIImageFromURLTOCache([NSURL URLWithString:fontInfo.imagePath], fontInfo.imagePath, ^(UIImage *image) {
                        fontInfo.showImage = image;
                        [_dataFontarray addObject:fontInfo];
                    }, ^{
                        
                    });
                }
            }
             [self requestProductColorFilterWithpageindex:@"1"];
        }
    } fail:^(NSString *errorMsg) {
        
    }];
    
}

#pragma mark-请求商品颜色
-(void)requestProductColorFilterWithpageindex:(NSString *)pageindex{
    [[HttpRequest shareRequst] httpRequestGetBaseColorFilterWithDic:(NSMutableDictionary *)@{@"pageIndex":[NSNumber numberWithInt:pageindex.intValue],@"pageSize":[NSNumber numberWithInt:100]} success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dic in data)
                {
                    ColorMapping*colorMapping;
                    colorMapping=[JsonToModel objectFromDictionary:dic className:@"ColorMapping"];
                    [_dataColorarray addObject:colorMapping];
                }
               
            }
        }
        
    } ail:^(NSString *errorMsg) {
        
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)fontTextEditVCBlockWithGesturesImgView:(FontTextEditVCBlock)block{
    _myblock = block;

}
#pragma mark -
#pragma mark HcCustomKeyboardDelegate
-(void)talkBtnClick:(UITextView *)textViewGet
{
    
    if (textViewGet.text.length > 10) {
        [Toast makeToast:@"亲,不能超过10个字"];
        return;
    }
//    NSString *normalstr = [_otherDic objectForKey:textfont_normaltext];
//    if (normalstr.length != 0 ) {
//        textViewGet.text = normalstr;
//        [_otherDic removeObjectForKey: textfont_normaltext];
//    }
    NSLog(@"%@",textViewGet.text);
    NSData *data = [textViewGet.text dataUsingEncoding:NSUTF8StringEncoding];
     NSString *base64Imagepath =[ASIHTTPRequest base64forData:data];
//    "+","-" "=",""
    NSString *str1 = [base64Imagepath stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *str3=[str2 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString *str4=[str3 stringByReplacingOccurrencesOfString:@"=" withString:@""];
    NSString *str5=[str4 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
  
    
    
    
    
    [_dataDic setObject:str5 forKey:textfont_base64text];
    [_otherDic setObject:textViewGet.text forKey:textfont_normaltext];
    
    NSString * str=[NSString arrayAnddictoJSONDataStr:_dataDic];
        
      NSMutableString *  laststring = [[NSMutableString alloc] initWithString:[WORDFONTURL substringToIndex:WORDFONTURL.length]];
        [laststring appendString:[NSString stringWithFormat:@"%@.png",str]];
    
      NSString *str6=[laststring stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
        UIImageFromURLTOCache([NSURL URLWithString:[str6 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], laststring, ^(UIImage *image) {
            [_otherDic setObject:laststring forKey:textfont_pictureurl];
            
            [UIView animateWithDuration:0.5f animations:^{
            
                self.currentGesturesImgView.frame = CGRectMake(self.currentGesturesImgView.frame.origin.x, self.currentGesturesImgView.frame.origin.y, image.size.width, image.size.height);
                
            } completion:^(BOOL finished) {
                
            }];
            self.currentGesturesImgView.image = image;
        }, ^{
            
        });
    
  
}

#pragma mark -
#pragma mark MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.stylePopover dismissMenuPopover];
    

}


#pragma mark -- ScratchableButtonsViewDelegate

- (void)scratchablePopover:(ScratchableButtonsView *)scratchableView didSelectMenuItemAtIndex:(NSInteger)selectedIndex{

  
    NSMutableString *  laststring;
    if (scratchableView.tag == 2000) {
        [self.fontView dismissScratchPopover];
        FontInfo *fontinfo = self.dataFontarray[selectedIndex];
        [_dataDic setObject:[NSNumber numberWithInteger:fontinfo.fontId.integerValue] forKey:textfont_fid];
        
        
        NSString * str=[NSString arrayAnddictoJSONDataStr:_dataDic];
        
         laststring = [[NSMutableString alloc] initWithString:[WORDFONTURL substringToIndex:WORDFONTURL.length]];
        [laststring appendString:[NSString stringWithFormat:@"%@.png",str]];
        

    }
    if (scratchableView.tag == 3000) {
        [self.colorView dismissScratchPopover];
        ColorMapping *colorMapping = self.dataColorarray[selectedIndex];
        [_dataDic setObject:colorMapping.coloR_VALUE forKey:textfont_fc];
        
        NSString * str=[NSString arrayAnddictoJSONDataStr:_dataDic];
        
        laststring = [[NSMutableString alloc] initWithString:[WORDFONTURL substringToIndex:WORDFONTURL.length]];
        [laststring appendString:[NSString stringWithFormat:@"%@.png",str]];
        
    }
    
    UIImageFromURLTOCache([NSURL URLWithString:[laststring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], laststring, ^(UIImage *image) {
         [_otherDic setObject:laststring forKey:textfont_pictureurl];
        [UIView animateWithDuration:0.5f animations:^{
        
            self.currentGesturesImgView.frame = CGRectMake(self.currentGesturesImgView.frame.origin.x, self.currentGesturesImgView.frame.origin.y, image.size.width, image.size.height);

        } completion:^(BOOL finished) {
            
        }];
        self.currentGesturesImgView.image = image;
    }, ^{
        
    });
    
}

-(void)styleButtonClick:(id)sender{
     [self.colorView dismissScratchPopover];
    self.colorView = [[ScratchableButtonsView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60-50, self.view.frame.size.width, 50)];
    _colorView.tag = 3000;
    [self.colorView addbuttonsWithdataarray:self.dataColorarray buttonoffsetY:10 width:50 height:25 isimage:NO];
    self.colorView.delegate = self;
    [self.colorView showInView:self.view];

    // Hide already showing popover
//    [self.stylePopover dismissMenuPopover];
//    
//    self.stylePopover = [[MLKMenuPopover alloc] initWithFrame:MENU_POPOVER_FRAME menuItems:@[@"加粗",@"倾斜",@"阴影"]];
//    self.stylePopover.center = CGPointMake(self.view.centerX, 200);
//    self.stylePopover.menuPopoverDelegate = self;
//    [self.stylePopover showInView:self.view];
//    
//   
    
    

}
-(void)fontButtonClick:(id)sender{

    [self.fontView dismissScratchPopover];
//    
//    self.fontView = [[ScratchableButtonsView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60 -150-10, 250, 150)];
//    self.fontView.dataarray = self.dataFontarray;
//
//    self.fontView.delegate = self;
//    [self.fontView showInView:self.view];

        self.fontView = [[ScratchableButtonsView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60-50, self.view.frame.size.width, 50)];
        _fontView.tag = 2000;
        [self.fontView addbuttonsWithdataarray:self.dataFontarray buttonoffsetY:10 width:50 height:25 isimage:YES];
        self.fontView.delegate = self;
        [self.fontView showInView:self.view];
 
    

}
- (IBAction)leftBarButtonItemClickevent:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonItemClickevent:(UIBarButtonItem *)sender {
    
    MaterialMapping *materialMapping = [MaterialMapping new];
    LayoutMapping *layoutMapping = [LayoutMapping new];
  
    materialMapping.width = [NSString stringWithFormat:@"%f",_currentGesturesImgView.frame.size.width];
    materialMapping.height = [NSString stringWithFormat:@"%f",_currentGesturesImgView.frame.size.height];
  
    materialMapping.pictureUrl =  [_otherDic objectForKey:textfont_pictureurl];
    if (materialMapping.pictureUrl==nil) {
        return;
    }
    layoutMapping.textFont_Id = [_dataDic objectForKey:textfont_fid];
    layoutMapping.textPoint = @"0";
    layoutMapping.textScale = @"1";
    layoutMapping.textContent  = [_otherDic objectForKey:textfont_normaltext];
    layoutMapping.textColor = [_dataDic objectForKey:textfont_fc];
    
    materialMapping.layoutMapping = layoutMapping;
    
    if (materialMapping.layoutMapping.textContent == nil) {
        return;
    }
   materialMapping.sourceType = @"3";//3是文字
    _currentGesturesImgView.materialMapping = materialMapping;

    if (_myblock) {
        _myblock(_currentGesturesImgView);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
