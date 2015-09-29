//
//  ExtractApplicationViewController.m
//  Wefafa
//
//  Created by fafatime on 14-8-22.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
//废弃 不用 以前的 体现申请

#import "ExtractApplicationViewController.h"
#import "Utils.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
#import "NSDateAdditions.h"
#import "NavigationTitleView.h"
@interface ExtractApplicationViewController ()

{
    UIView*toolView;
    UIPickerView*pickerView;
    NSArray *pickData;
    NSMutableArray *myCardArray;//持卡人姓名
    NSMutableArray *cardList;//银行卡
    int selectInt;
}
@end

@implementation ExtractApplicationViewController
@synthesize transDic;
@synthesize cardDicArray;
@synthesize canUpMoney;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_headView setBackgroundColor:TITLE_BG];
    [_doneBtn setBackgroundColor:[UIColor colorWithRed:72/255.0 green:187/255.0 blue:11/255.0 alpha:1]];
    _showView.userInteractionEnabled=YES;
    _upLabel.text=self.canUpMoney;
    
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"提现申请";
    [self.headView addSubview:view];

    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchUpShowView)];
    [_showView addGestureRecognizer:tap];
    _moneyTextField.delegate=self;
    _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    UITapGestureRecognizer *tapSc=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchUpSc)];
    [_backScrollView addGestureRecognizer:tapSc];
    pickData = [[NSArray alloc]initWithArray:self.cardDicArray];

    myCardArray=[[NSMutableArray alloc]init];
    NSString *mysellerId=[NSString stringWithFormat:@"%@",[[self.transDic objectForKey:@"responseMsg"]objectForKey:@"sellerId"]];
    mysellerId =@"320";//默认 需改
    cardList=[[NSMutableArray alloc]init];
    
    for (int k=0; k<[pickData count]; k++)
    {
        NSDictionary *wsCardInfo=[[pickData objectAtIndex:k] objectForKey:@"wsCardInfo"];
        NSDictionary *bankListDic = [[pickData objectAtIndex:k] objectForKey:@"bankList"];
        NSString *wsInfoSt=[NSString stringWithFormat:@"%@",[wsCardInfo objectForKey:@"accounT_ID"]];
        if ([mysellerId isEqualToString:wsInfoSt])
        {
            [myCardArray addObject:wsCardInfo];
            [cardList addObject:bankListDic];
        }
    }
    if ([myCardArray count]!=0)
    {
        _bankLabel.text=[[cardList objectAtIndex:0] objectForKey:@"carD_NAME"];
        NSString *carno=[NSString stringWithFormat:@"%@",[[myCardArray objectAtIndex:0] objectForKey:@"carD_NO"]];
        int k=0;
        k = (int)[carno length]-4;
      
        NSString *carnoLast = [NSString stringWithFormat:@"%@",[carno substringFromIndex:k]];
        _cardLabel.text=[NSString stringWithFormat:@"%@",carnoLast];
        _cardNameLabel.text=[NSString stringWithFormat:@"%@",[[myCardArray objectAtIndex:0] objectForKey:@"carD_NAME"]];
    }
    [self initPackView];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_backScrollView setFrame:CGRectMake(_backScrollView.frame.origin.x,40, _backScrollView.frame.size.width, _backScrollView.frame.size.height)];
}
-(void)touchUpShowView
{
    [_backScrollView setFrame:CGRectMake(_backScrollView.frame.origin.x,40,  _backScrollView.frame.size.width, _backScrollView.frame.size.height)];
    toolView.hidden=NO;
    pickerView.hidden=NO;
    [_moneyTextField resignFirstResponder];
}
-(void)touchUpSc
{
    [_backScrollView setFrame:CGRectMake(_backScrollView.frame.origin.x,64,  _backScrollView.frame.size.width, _backScrollView.frame.size.height)];
    [_moneyTextField resignFirstResponder];
    toolView.hidden=YES;
    pickerView.hidden=YES;
    
}
-(IBAction)doneBtnClick:(id)sender
{
    [_backScrollView setFrame:CGRectMake(_backScrollView.frame.origin.x,64,  _backScrollView.frame.size.width, _backScrollView.frame.size.height)];
    [_moneyTextField resignFirstResponder];
    
    NSString *st = @"WxSellerCashAppCreate";
    
    int input;
    input = [_moneyTextField.text intValue];
    if (input>[self.canUpMoney intValue])
    {
        [Utils alertMessage:@"输入的金额要小于等于可提现金额"];
    }
    else
    {
        [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   
            NSDictionary *paramdic=@{@"SUPER_SELLER_ID":[[self.transDic objectForKey:@"responseMsg"]objectForKey:@"sellerId"],
                                     @"SELLER_BANK_ID":[[myCardArray objectAtIndex:selectInt] objectForKey:@"bank"],
                                     @"AMOUNT":_moneyTextField.text,
                                     };
    
            NSMutableDictionary *requestDic=[[NSMutableDictionary alloc]init];
            NSMutableString *returnMsg=[[NSMutableString alloc]init];
            
           
            BOOL success = [SHOPPING_GUIDE_ITF  requestGetUrlName:st param:paramdic responseAll:requestDic responseMsg:returnMsg];
//        NSDictionary *requestDic =[[NSDictionary alloc]initWithDictionary:[SHOPPING_GUIDE_ITF ASIPostJSonRequest:st PostParamDic:paramdic]];
        NSLog(@"requestDic---提现--%@",requestDic);
//        NSString *flagStr=[NSString stringWithFormat:@"%@",[requestDic objectForKey:@"isSuccess"]];
//            NSString *message =[NSString stringWithFormat:@"%@",[requestDic objectForKey:@"message"]];
        //银行
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Toast hideToastActivity];
            if (success)
            {
               [Utils alertMessage:returnMsg];
            }
            else
            {

            }
            
        });
        });
    }
}
-(void)initPackView
{
    toolView=[[UIView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-162-44, UI_SCREEN_WIDTH, 44)];
    toolView.hidden=YES;
    [toolView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1]];
    [self.view addSubview:toolView];
    
    UIButton *doneBar =[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBar setFrame:CGRectMake(toolView.frame.size.width-80, 0, 80, 44)];
    [doneBar setTitle:@"确定" forState:UIControlStateNormal];
    [doneBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBar addTarget:self
                action:@selector(doneBtn:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cacleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cacleBtn setFrame:CGRectMake(0, 0, 50, 44)];
    [cacleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cacleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cacleBtn addTarget:self
                 action:@selector(cacleBtn:)
       forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:doneBar];
    [toolView addSubview:cacleBtn];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,UI_SCREEN_HEIGHT-162,UI_SCREEN_WIDTH, 162)];
    pickerView.hidden=YES;
    //    指定Delegate
    pickerView.delegate=self;
    pickerView.dataSource=self;
    [pickerView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1]];
    //    显示选中框
    pickerView.showsSelectionIndicator=YES;
    [self.view addSubview:pickerView];
}
#pragma mark -
#pragma mark Picker Date Source Methods

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [cardList count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    return 30.0;
    
}
#pragma toolBar PickDateView
-(void)doneBtn:(UIButton *)sender
{
    
    [_backScrollView setFrame:CGRectMake(_backScrollView.frame.origin.x,64,  _backScrollView.frame.size.width, _backScrollView.frame.size.height)];
    pickerView.hidden=YES;
    toolView.hidden=YES;
}
-(void)cacleBtn:(UIButton *)sender
{
    
    [_backScrollView setFrame:CGRectMake(_backScrollView.frame.origin.x,64,  _backScrollView.frame.size.width, _backScrollView.frame.size.height)];
    pickerView.hidden=YES;
    toolView.hidden=YES;
}
#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *carno=[NSString stringWithFormat:@"%@",[[myCardArray objectAtIndex:row] objectForKey:@"carD_NO"]];
    int k=0;
    k = (int)[carno length]-4;
    NSString *carnoLast = [NSString stringWithFormat:@"%@",[carno substringFromIndex:k]];
    _cardNameLabel.text=[NSString stringWithFormat:@"%@",[[myCardArray objectAtIndex:row] objectForKey:@"carD_NAME"]];
    _cardLabel.text=[NSString stringWithFormat:@"%@",carnoLast];
    
    return [[cardList objectAtIndex:row] objectForKey:@"carD_NAME"];
}
-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    selectInt = (int)row;
    NSString *carno=[NSString stringWithFormat:@"%@",[[myCardArray objectAtIndex:row] objectForKey:@"carD_NO"]];
    int k=0;
    k = (int)[carno length]-4;
    NSString *carnoLast = [NSString stringWithFormat:@"%@",[carno substringFromIndex:k]];
    _cardLabel.text=[NSString stringWithFormat:@"%@",carnoLast];
    _cardNameLabel.text=[NSString stringWithFormat:@"%@",[[myCardArray objectAtIndex:row] objectForKey:@"carD_NAME"]];
}
-(void)backHome:(UIButton *)sender
{
      [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
