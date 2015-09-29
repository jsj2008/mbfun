//
//  GoodsInvoiceViewController.m
//  Wefafa
//
//  Created by Miaoz on 14/12/12.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "GoodsInvoiceViewController.h"
#import "GoodsInvoiceTableViewCell.h"
#import "Globle.h"
#import "NavigationTitleView.h"
@interface GoodsInvoiceViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong, nonatomic)  UITableView *tableView;

@property(strong,nonatomic)GoodsInvoiceTableViewCell *goodsInvoiceCell;
@property (strong, nonatomic)UIView *viewHead;
@property(nonatomic,strong)NSMutableArray *dataarray;
@property(nonatomic,strong)NSMutableArray *selectedArr;//二级列表是否展开状态
@end

@implementation GoodsInvoiceViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)goodsInvoiceVCSourceVoBlock:(GoodsInvoiceVCSourceVoBlock) block{
    _myblock = block;
    
}
-(void)setSelectStr:(NSString *)selectStr{
    _selectStr = selectStr;
   

}
- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 10;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[left1] ;
    
//    UIBarButtonItem *right2 =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_share"] style:UIBarButtonItemStylePlain target:self action:@selector(onShare:)];
//    
    UIBarButtonItem *right2 =  [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(btnOkClick:)];
    
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,right2];
    self.title=@"选择发票";
    
}
- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_selectedArr == nil) {
        _selectedArr = [NSMutableArray new];
    }
    
    if (_dataarray == nil) {
        _dataarray = [NSMutableArray new];
    }
    
    _viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    [self.view addSubview:_viewHead];
    
    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view.btnOk setTintColor:[UIColor redColor]];
    view.btnOk.frame = CGRectMake( view.btnOk.frame.origin.x , view.btnOk.frame.origin.y+3.5, view.btnOk.frame.size.width, view.btnOk.frame.size.height);
    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:@selector(btnOkClick:) selectorMenu:nil];
    view.lbTitle.text=@"发票";
//    [self.viewHead addSubview:view];
    [self setupNavbar];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _viewHead.frame.size.height, UI_SCREEN_WIDTH,UI_SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    //tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorColor = [UIColor clearColor];
    
    _tableView.dataSource = self; //在self中响应UITableViewDataSource协议相关的接口
    
    _tableView.delegate = self;//在self中响应UITableViewDelegate协议相关的接口
    _tableView.backgroundColor=[UIColor colorWithHexString:@"#f2f2f2"];
    
    [self.view addSubview:_tableView];
    
    //注册
    [self.tableView  registerClass:[GoodsInvoiceTableViewCell class] forCellReuseIdentifier:@"GoodsInvoiceTableViewCell"];
    
    if (_selectStr != nil) {
        //         NSArray *titleArray = @[@"不开发票",@"个人发票",@"公司发票"];
        if ([_selectStr isEqualToString:@"不开发票"]) {
            [_selectedArr addObject:@"0"];
        }else if([_selectStr isEqualToString:@"个人发票"]){
            [_selectedArr addObject:@"1"];
        }else {//if([_selectStr isEqualToString:@"公司发票"])
            [_selectedArr addObject:@"2"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark----tableViewDelegate
//返回几个表头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//每一个表头下返回几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    //
    if (section  == 2) {
        if ([_selectedArr containsObject:string]) {
            UIImageView *imageV = (UIImageView *)[_tableView viewWithTag:20000+section];
            imageV.image = [UIImage imageNamed:@"btn_pull-diwn_pressed"];
            
            return 1;
            
            
        }
    }else{
        
        return 0;
        
    }
    
    return 0;
}

//设置表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
        return 43+15;
    return 43;
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

//设置view，将替代titleForHeaderInSection方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = @[@"不开发票",@"个人发票",@"公司发票"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 43)];
    view.backgroundColor=[UIColor whiteColor];
    //    view.backgroundColor = [UIColor colorWithHexString:@"#65cbcb"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5,UI_SCREEN_WIDTH-20, 30)];
    titleLabel.text = titleArray[section];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:titleLabel];
    
    UIImageView *leftimageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 22, 22)];
    leftimageView.tag = 10000+section;
    
    //    //判断是不是选中状态
    NSString *leftstring = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectedArr containsObject:leftstring]) {// btu_checkebox_yellow@2x.png
        leftimageView.image = [UIImage imageNamed:@"Unico/present_uncheck"];//Unico/unico_seleted_btn
    }
    else
    {// btu_checkebox@2x.png
        leftimageView.image = [UIImage imageNamed:@"Unico/uncheck_zero"];//Unico/uncheck_zero
    }
    [view addSubview:leftimageView];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 15-16, 15, 16, 14)];
    imageView.tag = 20000+section;
    
    //判断是不是选中状态
    if (section<2)
        imageView.image = nil;
    else
    {
        NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
        
        if ([_selectedArr containsObject:string]) {
            imageView.image = [UIImage imageNamed:@"icon_arrowup"];
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"icon_arrowdown"];
        }
        [view addSubview:imageView];
    }
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 42);
    button.tag = 100+section;
    [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    int line_x=15;
    NSString *leftstring2 = [NSString stringWithFormat:@"%ld",(long)section];
    if (section==2)
    {
        if ([_selectedArr containsObject:leftstring2]) {
            line_x=45;
        }
        else
        {
            line_x=0;
        }
    }

    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(line_x, 42, UI_SCREEN_WIDTH, 0.5)];
    lineImage.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    //    lineImage.image = [UIImage imageNamed:@"line.png"];
    [view addSubview:lineImage];
    
    if (section==0)
    {
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5)];
        lineImage.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        //    lineImage.image = [UIImage imageNamed:@"line.png"];
        [view addSubview:lineImage];

        UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 43+15)];
        CGRect rect=view.frame;
        view.frame=CGRectOffset(rect, 0, 15);
        [viewBg addSubview:view];
        viewBg.backgroundColor=[UIColor clearColor];
        return viewBg;
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GoodsInvoiceTableViewCell" owner:nil options:nil];
    GoodsInvoiceTableViewCell *cell = [nib objectAtIndex:0];
    cell.placeHolderTextView.delegate = self;
    
    switch (indexPath.section) {
        case 0:
            cell.placeHolderTextView.placeholder = @"无需输入";
            cell.placeHolderTextView.userInteractionEnabled = NO;
            break;
        case 1:
            cell.placeHolderTextView.placeholder = @"在此输入个人名称";
            break;
        case 2:

            if (![_selectStr isEqualToString:@"不开发票"]&&![_selectStr isEqualToString:@"个人发票"]) {
                cell.placeHolderTextView.text = _selectStr;
            }else{
                cell.placeHolderTextView.placeholder = @"在此输入公司名称";
            }
          
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doButton:(UIButton *)sender
{
    
    NSString *string = [NSString stringWithFormat:@"%ld",sender.tag-100];
    
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([_selectedArr containsObject:string])
    {
        [_selectedArr removeObject:string];
    }
    else
    {
        if (_selectedArr.count>0) {
            [_selectedArr removeAllObjects];
        }
        
        [_selectedArr addObject:string];
    }
    
    [_tableView reloadData];
    
    _goodsInvoiceCell = (GoodsInvoiceTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag-100]];
    
    
}


# pragma mark-UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    
}


//这个函数的最后一个参数text代表你每次输入的的那个字，所以：
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        [self.view endEditing:NO];
        [textView canResignFirstResponder];
        [textView resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)btnBackClick:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)btnOkClick:(id)sedner{
    
    NSString *sectionStr = [_selectedArr firstObject];
    
    switch (sectionStr.intValue) {
        case 0:
            _myblock(@"不开发票");
            break;
        case 1:
            _myblock(@"个人发票");
            break;
        case 2:
        {
            NSLog(@"%@--%@-----------%@",_goodsInvoiceCell.placeHolderTextView,_goodsInvoiceCell.placeHolderTextView.text,_selectStr);
            [self.view endEditing:NO];
            if (_goodsInvoiceCell == nil) {
                if ([_selectedArr containsObject:@"2"]) {
                    _goodsInvoiceCell = (GoodsInvoiceTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                }
            }
            
            NSString *cellHoldText =  [ _goodsInvoiceCell.placeHolderTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
            NSRange range1 = [_goodsInvoiceCell.placeHolderTextView.text rangeOfString:@" "];
            int leight1 = (int)range1.length;

            NSRange range2 = [_goodsInvoiceCell.placeHolderTextView.text rangeOfString:@""];
            int leight2 = (int)range2.length;
            
            NSRange range3 = [_goodsInvoiceCell.placeHolderTextView.text rangeOfString:@"\n"];
            int leight3 = (int)range3.length;
            
            
            
            
            if (leight2 > 0 || _goodsInvoiceCell.placeHolderTextView.text == nil || [_goodsInvoiceCell.placeHolderTextView.text isEqualToString:@""]||_goodsInvoiceCell.placeHolderTextView== nil) {
                [Toast makeToast:@"亲,选择公司发票，请填写公司名称"];
                return;
                
                if (_selectStr != nil) {
                     _myblock(_selectStr);
                     [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
               
            }
            
            
            
//            NSInteger textlength=[self unicodeLengthOfString:_goodsInvoiceCell.placeHolderTextView.text];

//            NSInteger textlength=[self unicodeLengthOfString:cellHoldText];
            
//            NSLog(@"textlength－－－%ld",(long)textlength);
            NSInteger textA=[self getToInt:_goodsInvoiceCell.placeHolderTextView.text];
     
            
            if (textA>40) {
                 [Toast makeToast:@"亲,公司名称最长为20个汉字或40个英文"];
                return;
            }
           
            //11.9 add by miao
            if (leight1>0 ) {
                
                [Toast makeToast:@"亲,公司发票不能输入空格"];
                return;
            }
            if (leight3>0) {
                
                [Toast makeToast:@"亲,公司发票不能输入换行符"];
                return;
            }
            BOOL isSpec=[self isIncludeSpecialCharact:_goodsInvoiceCell.placeHolderTextView.text];
            if(isSpec)
            {
                 [Toast makeToast:@"亲,公司发票不能输入特殊字符"];
            }
//            NSString *regex = @"^[\u4E00-\u9FA5]*$";
//            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//            if(![pred evaluateWithObject:_goodsInvoiceCell.placeHolderTextView.text])
//            {
//                [Toast makeToast:@"亲,只能输入中文"];
//                return;
//            }
            

            _myblock(_goodsInvoiceCell.placeHolderTextView.text);
        }
            break;
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
//字符长度
-(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}
- (NSUInteger)getToInt:(NSString*)strtemp

{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}
-(BOOL)isIncludeSpecialCharact: (NSString *)str {
    
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }    
    
    return YES;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
