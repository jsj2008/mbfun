//
//  SwipeSaveGoodsViewController.m
//  Wefafa
//
//  Created by Miaoz on 15/1/8.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//
//废弃  以前的滑酷
#import "SwipeSaveGoodsViewController.h"
#import "Globle.h"
#import "CollocationInfo.h"

#define positionX 40
#define positionY 230
#define buttonwidth 60

@interface SwipeSaveGoodsViewController ()<ZLSwipeableViewDataSource,
ZLSwipeableViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic)  UIButton *skipButton;
@property (strong, nonatomic)  UIButton *saveButton;
@property (strong, nonatomic)   UIButton *centerButton;
@property (strong, nonatomic)   UILabel *topLabel;
@property (nonatomic, strong) ZLSwipeableView *swipeableView;
@property (nonatomic, strong) NSMutableArray *dataarray;
@property (nonatomic,strong) NSMutableArray *postarray;
@property (nonatomic) NSUInteger dataIndex;

@property (nonatomic) BOOL loadCardFromXib;
@property (nonatomic,strong)NSString *totalStr;


@end

@implementation SwipeSaveGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self createButtons];
    // Do any additional setup after loading the view from its nib.
    if (_swipeableView == nil) {
        ZLSwipeableView *swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width -250)/2, 70, 250, 250)];
//        swipeableView.center = CGPointMake(self.view.center.x, self.view.center.y-80);
        _swipeableView = swipeableView;
        [self.view addSubview:swipeableView];
    }
    if (_dataarray == nil) {
        _dataarray = [NSMutableArray new];
    }
    if (_postarray == nil) {
        _postarray = [NSMutableArray new];
    }
   
    [self requestRequestGetWxCollocationRandomFilterWithDic:(NSMutableDictionary *)@{@"pageIndex":[NSNumber numberWithInt:1],
        @"pageSize":[NSNumber numberWithInt:10],@"UserId":sns.ldap_uid}];
    self.dataIndex = 0;
    // Optional Delegate
    self.swipeableView.delegate = self;
    
}
-(void)createButtons{

    if (_skipButton == nil) {
        UIButton *skipbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        skipbutton.frame = CGRectMake(positionX, self.view.bounds.size.height -positionY, buttonwidth, buttonwidth);
        [skipbutton setBackgroundImage:[UIImage imageNamed:@"btn_skip_normal@3x"] forState:UIControlStateNormal];
        [skipbutton setBackgroundImage:[UIImage imageNamed:@"btn_skip_pressed@3x"] forState:UIControlStateHighlighted];
        
        [skipbutton addTarget:self action:@selector(swipeLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _skipButton = skipbutton;
        [self.view addSubview:skipbutton];
        

    }
    if (_saveButton == nil) {
        UIButton *savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        savebutton.frame = CGRectMake(self.view.bounds.size.width - buttonwidth - positionX, self.view.bounds.size.height -positionY, buttonwidth, buttonwidth);
        [savebutton setBackgroundImage:[UIImage imageNamed:@"btn_save_normal@3x"] forState:UIControlStateNormal];
        [savebutton setBackgroundImage:[UIImage imageNamed:@"btn_save_pressed@3x"] forState:UIControlStateHighlighted];
        [savebutton addTarget:self action:@selector(swipeRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveButton = savebutton;
        [self.view addSubview:savebutton];

    }
    if (_centerButton == nil) {
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        centerButton.frame = CGRectMake(self.view.bounds.size.width - buttonwidth - positionX, self.view.bounds.size.height -positionY, buttonwidth, buttonwidth);
        centerButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height -130);
        [centerButton setTitle:@"跳过" forState:UIControlStateNormal];
        [centerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [centerButton setBackgroundColor:[UIColor redColor]];
        centerButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [centerButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _centerButton = centerButton;
        [self.view addSubview:centerButton];
    }
    
    if (_topLabel == nil) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, buttonwidth)];
        _topLabel = lab;
        lab.backgroundColor = [UIColor clearColor];
        [lab setTextAlignment:NSTextAlignmentCenter];
        lab.text = @"剩余0张";
        lab.font = [UIFont boldSystemFontOfSize:18.0f];
        [self.view addSubview:lab];
    }

}
- (NSString *)generaterandomWord
{
    const int N = 1;
    
    NSString *sourceString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}
- (void)viewDidLayoutSubviews {
    // Required Data Source
    //    self.swipeableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)swipeLeftButtonAction:(UIButton *)sender {
    CardView *cardview = (CardView *)[self.swipeableView topSwipeableView];
    cardview.skipImageView.hidden = NO;
    cardview.skipImageView.alpha = 1.0f;
    [self.swipeableView swipeTopViewToLeft];
    
}

- (void)swipeRightButtonAction:(UIButton *)sender {
     CardView *cardview = (CardView *)[self.swipeableView topSwipeableView];
    cardview.saveImageView.hidden = NO;
    cardview.saveImageView.alpha = 1.0f;
    [self.swipeableView swipeTopViewToRight];
}

- (void)centerButtonAction:(UIButton *)sender {
    [self dismissVC];
}

-(void)dismissVC{

//    if (_dataarray.count != 0) {
        [self requestWXSlideCoolInfoCreateWithDic:(NSMutableDictionary *)@{@"USER_ID":sns.ldap_uid,@"COLLOCATION_ID_LIST":_postarray}];
//    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//- (IBAction)reloadButtonAction:(UIButton *)sender {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:@"Load Cards"
//                                  delegate:self
//                                  cancelButtonTitle:@"Cancel"
//                                  destructiveButtonTitle:nil
//                                  otherButtonTitles:@"Programmatically", @"From Xib", nil];
//    [actionSheet showInView:self.view];
//}
//
//#pragma mark - UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet
//clickedButtonAtIndex:(NSInteger)buttonIndex {
//    self.loadCardFromXib = buttonIndex == 1;
//
//    self.dataIndex = 0;
//    [self.swipeableView discardAllSwipeableViews];
//    [self.swipeableView loadNextSwipeableViewsIfNeeded];
//}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeLeft:(UIView *)view {
    NSLog(@"did swipe left");
    
//    CardView *cardView = (CardView *)view;
//    
//        [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
//        }complete:^(SNSStaffFull *staff, BOOL success){
//            if (success)
//            {
//    
//                [self requestFavoriteDeleteWithdic:(NSMutableDictionary *)@{@"SourceIds":[NSString stringWithFormat:@"%@",cardView.collocationInfo.id],@"SOURCE_TYPE":@"2",@"UserId":sns.ldap_uid}];
//            }
//        }];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
        didSwipeRight:(UIView *)view {
    NSLog(@"did swipe right");
    CardView *cardView = (CardView *)view;
    NSLog(@"  cardView.goodObj.showImage-----%@",  cardView.collocationInfo.showImage);
    NSString *idStr = cardView.collocationInfo.id;
    [_postarray addObject:[NSNumber numberWithInt:idStr.intValue]];
//    [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
//    }complete:^(SNSStaffFull *staff, BOOL success){
//        if (success)
//        {
//            [self requestFavoriteCreateWithdic:(NSMutableDictionary *)@{@"UserId":sns.ldap_uid,@"SOURCE_ID":cardView.collocationInfo.id,@"SOURCE_TYPE":@"2",@"Create_User":staff.nick_name}];
//        }
//    }];
//    
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
    CardView *cardView = (CardView *)view;
    cardView.skipImageView.hidden = YES;
    cardView.saveImageView.hidden = YES;
    [_skipButton setBackgroundImage:[UIImage imageNamed:@"btn_skip_normal@3x"] forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"btn_save_normal@3x"] forState:UIControlStateNormal];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f",
          location.x, location.y, translation.x, translation.y);
    CardView *cardView = (CardView *)view;
    CGFloat offsetx = translation.x/30;
    NSLog(@"offsetxoffsetxoffsetx-----%f",offsetx);
   
    
    if (translation.x>0) {
        cardView.saveImageView.hidden = NO;
        cardView.saveImageView.alpha = offsetx;
        [_skipButton setBackgroundImage:[UIImage imageNamed:@"btn_skip_pressed@3x"] forState:UIControlStateNormal];
//        [_skipButton setEnabled:NO];
    }
    if (translation.x<0) {
        cardView.skipImageView.hidden = NO;
        cardView.skipImageView.alpha = -offsetx;
         [_saveButton setBackgroundImage:[UIImage imageNamed:@"btn_save_pressed@3x"] forState:UIControlStateNormal];
    }
    
    
   
    
    
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
    [_skipButton setBackgroundImage:[UIImage imageNamed:@"btn_skip_normal@3x"] forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"btn_save_normal@3x"] forState:UIControlStateNormal];
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    //
    
     _topLabel.text = [NSString stringWithFormat:@"剩余%d张",(int)_dataarray.count - (int)self.dataIndex+1];
    
    if (_dataarray.count - self.dataIndex + 1 == 0) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
        [self dismissVC];
        return nil;
    }
    if (self.dataIndex < self.dataarray.count) {
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        CollocationInfo *collocationInfo = self.dataarray[self.dataIndex];
        view.collocationInfo = collocationInfo;
        view.imageView.image = collocationInfo.showImage;
        view.imageView.frame = CGRectMake(view.imageView.frame.origin.x, view.imageView.frame.origin.y, view.imageView.frame.size.width, view.imageView.frame.size.height);
        
        self.dataIndex++;
        
        return view;
    }else{
        //滑酷滑完直接dismiss
      
        self.dataIndex++;
        
        //如果没数据则再次请求
        return nil;
        
    }
    
}




#pragma mark --随机搭配接口
-(void)requestRequestGetWxCollocationRandomFilterWithDic:(NSMutableDictionary *)dic
{
    [ApplicationDelegate.window makeToastActivity];
    
    
    [[HttpRequest shareRequst] httpRequestGetWxCollocationRandomFilterWithDic:dic success:^(id obj)
     {
       
         if ( [[obj objectForKey:@"isSuccess"] integerValue]==1)
         {
             id data = [obj objectForKey:@"results"];
             _totalStr = [obj objectForKey:@"total"];
             if ([data isKindOfClass:[NSArray class]])
             {
                 if (data != nil)
                 {
                     NSMutableArray *tmparray = [NSMutableArray new];
                     for (NSDictionary *dic  in data)
                         
                     {
                         CollocationInfo *collocationInfo =[JsonToModel objectFromDictionary:dic className:@"CollocationInfo"];
                         
                         //                     [_dataarray addObject:collocationInfo];
                         if (collocationInfo != nil)
                         {
                             if ( collocationInfo.pictureUrl != nil &&![collocationInfo.pictureUrl isEqualToString:@""]&&collocationInfo.pictureUrl != NULL)
                             {
                                 if (collocationInfo.pictureUrl.length != 0)
                                 {
                                     
                                     [tmparray addObject:collocationInfo];
                                 }
                             }
                         }
                         
                     }
                     
                     for (CollocationInfo *collocationInfo in tmparray) {
                       NSString *imageurl =   [CommMBBusiness changeStringWithurlString:collocationInfo.pictureUrl width:200 height:200];

                         UIImageFromURLTOCache([NSURL URLWithString:imageurl], imageurl, ^(UIImage *image)
                                               {
                                                   collocationInfo.showImage = image;
                                                   
                                                   [_dataarray addObject:collocationInfo];
                                                   if (_dataarray.count>=2) {
                                                        [ApplicationDelegate.window hideToastActivity];
                                                   }
                                                   
                                                   if (_dataarray.count >= tmparray.count )//_totalStr.intValue
                                                   {
                                                       self.swipeableView.dataSource = self;
                                                       [ApplicationDelegate.window hideToastActivity];
                                                   }
                                               }, ^{
                                                   
                                                   [ApplicationDelegate.window hideToastActivity];
                                                   [self.view makeToast:@"图片加载失败"];
                                                   
                                                   //2.10 add by miao
                                                   //                                               self.swipeableView.dataSource = self;
                                                   //                                               [ApplicationDelegate.window hideToastActivity];
                                               });
                         
                     }
                     
                     //              self.swipeableView.dataSource = self;
                     
                 }else{
                     NSLog(@"无数据");
                     return ;
                 }
                 
                 
                 _topLabel.text = [NSString stringWithFormat:@"剩余%d张",(int)_dataarray.count];
                 
                 if (_dataarray.count == _totalStr.intValue)
                 {
                     
                     [ApplicationDelegate.window hideToastActivity];
                 }
                 
             }
             
            
         }else{
             [ApplicationDelegate.window hideToastActivity];
             [self.view makeToast:@"返回数据错误"];
         }
         
     } fail:^(NSString *errorMsg) {
          [ApplicationDelegate.window hideToastActivity];
     }];
    

    
    
}


#pragma mark --请求喜欢接口
-(void)requestFavoriteCreateWithdic:(NSMutableDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestPostFavoriteCreateWithdic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"喜欢成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定" ,nil];
            //            [alert show];
        }
        
    } fail:^(NSString *errorMsg) {
        
    }];
    
}
#pragma mark --请求取消喜欢接口
-(void)requestFavoriteDeleteWithdic:(NSMutableDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestPostFavoriteDeleteWithDic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消喜欢成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: @"确定",nil];
            //            [alert show];
        }
    } fail:^(NSString *errorMsg) {
        
    }];
    
}
#pragma mark --请求记录滑酷信息
-(void)requestWXSlideCoolInfoCreateWithDic:(NSMutableDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestPostWXSlideCoolInfoCreateWithDic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            
        }
    } fail:^(NSString *errorMsg) {
        
    }];


}


+(void)showSwipeGoodsView:(UIViewController *)delegateVC
{

    SwipeSaveGoodsViewController *swipeSaveGoodsVC=[[SwipeSaveGoodsViewController alloc] initWithNibName:@"SwipeSaveGoodsViewController" bundle:nil];
    [delegateVC presentViewController:swipeSaveGoodsVC animated:YES completion:^{
        
    }];
    
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *swipedayStr=[defaults objectForKey:@"SwipeGoodsDay"];
    NSString *swipetimerStr = [defaults objectForKey:@"SwipeGoodsTime"];


//    YYYY-MM-dd HH:mm:ss  设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd--HH:mm:ss"];
    
    NSString *currentDate=[formatter stringFromDate:date];
    NSString *dayStr =  [currentDate substringToIndex:8];
    NSString *timerStr =[currentDate substringFromIndex:10];
   
    
    
    //如果不是同一天
    if (![dayStr isEqualToString:swipedayStr])
    {
        [[NSUserDefaults standardUserDefaults] setObject:dayStr forKey:@"SwipeGoodsDay"];
        [[NSUserDefaults standardUserDefaults] setObject:timerStr forKey:@"SwipeGoodsTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
      
      
  
    }else{
        
        //拿着当前时间做比较
        if ([self date:timerStr isBetweenDate:@"00:00:00" andDate:@"11:59:59"]) {
            
            if (![self date:swipetimerStr isBetweenDate:@"00:00:00" andDate:@"11:59:59"]) {
                [[NSUserDefaults standardUserDefaults] setObject:timerStr forKey:@"SwipeGoodsTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                SwipeSaveGoodsViewController *swipeSaveGoodsVC=[[SwipeSaveGoodsViewController alloc] initWithNibName:@"SwipeSaveGoodsViewController" bundle:nil];
                [delegateVC presentViewController:swipeSaveGoodsVC animated:YES completion:^{
                    
                }];
            }
            
        }
        
        if([self date:timerStr isBetweenDate:@"12:00:00" andDate:@"19:59:59"])
        {
            if (![self date:swipetimerStr isBetweenDate:@"12:00:00" andDate:@"19:59:59"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:timerStr forKey:@"SwipeGoodsTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                SwipeSaveGoodsViewController *swipeSaveGoodsVC=[[SwipeSaveGoodsViewController alloc] initWithNibName:@"SwipeSaveGoodsViewController" bundle:nil];
                [delegateVC presentViewController:swipeSaveGoodsVC animated:YES completion:^{
                    
                }];
            }

        }
        
        if([self date:timerStr isBetweenDate:@"20:00:00" andDate:@"24:00:00"]){
            
            if (![self date:swipetimerStr isBetweenDate:@"13:00:00" andDate:@"24:00:00"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:timerStr forKey:@"SwipeGoodsTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                SwipeSaveGoodsViewController *swipeSaveGoodsVC=[[SwipeSaveGoodsViewController alloc] initWithNibName:@"SwipeSaveGoodsViewController" bundle:nil];
                [delegateVC presentViewController:swipeSaveGoodsVC animated:YES completion:^{
                    
                }];
            }

            
        }
    
    
    }
    
    */
}

//if ( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//    //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的操作系统太旧,无法使用滑酷！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    //            [alertView show];
//    //            return;
//}else{
//}

+ (BOOL)date:(NSString*)date isBetweenDate:(NSString*)beginDate andDate:(NSString*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}
#pragma mark - ()
/*
 self.dataarray = @[
 @"Turquoise",
 @"Green Sea",
 @"Emerald",
 @"Nephritis",
 @"Peter River",
 @"Belize Hole",
 @"Amethyst",
 @"Wisteria",
 @"Wet Asphalt",
 @"Midnight Blue",
 @"Sun Flower",
 @"Orange",
 @"Carrot",
 @"Pumpkin",
 @"Alizarin",
 @"Pomegranate",
 @"Clouds",
 @"Silver",
 @"Concrete",
 @"Asbestos"
 ];
 
 
 - (UIColor *)colorForName:(NSString *)name {
 NSString *sanitizedName =
 [name stringByReplacingOccurrencesOfString:@" " withString:@""];
 NSString *selectorString =
 [NSString stringWithFormat:@"flat%@Color", sanitizedName];
 Class colorClass = [UIColor class];
 return [colorClass performSelector:NSSelectorFromString(selectorString)];
 }
 /.....
 if (self.loadCardFromXib) {
 UIView *contentView =
 [[[NSBundle mainBundle] loadNibNamed:@"CardContentView"
 owner:self
 options:nil] objectAtIndex:0];
 contentView.translatesAutoresizingMaskIntoConstraints = NO;
 [view addSubview:contentView];
 
 // This is important: https://github.com/zhxnlai/ZLSwipeableView/issues/9
 NSDictionary *metrics = @{
 @"height" : @(view.bounds.size.height),
 @"width" : @(view.bounds.size.width)
 };
 NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
 [view addConstraints:[NSLayoutConstraint
 constraintsWithVisualFormat:
 @"H:|[contentView(width)]|"
 options:0
 metrics:metrics
 views:views]];
 [view addConstraints:[NSLayoutConstraint
 constraintsWithVisualFormat:
 @"V:|[contentView(height)]|"
 options:0
 metrics:metrics
 views:views]];
 } else {
 //            UITextView *textView =
 //                [[UITextView alloc] initWithFrame:view.bounds];
 //            textView.text = @"sadsdasdasdasdsad";
 //            textView.backgroundColor = [UIColor clearColor];
 //            textView.font = [UIFont systemFontOfSize:24];
 //            [view addSubview:textView];
 }
 ****/


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
