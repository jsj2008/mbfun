//
//  NewAddressViewController.m
//  Wefafa
//
//  Created by fafatime on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "NewAddressViewController.h"
#import "NavigationTitleView.h"
#import "Toast.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"
#import "EditAddressViewController.h"
#import "AppDelegate.h"
#import "AppSetting.h"
#import "HZAreaPickerView.h"
#import "MBToastHud.h"
#import "HttpRequest.h"
#import "KVNProgress.h"
#define SaveString  @"完成"
#define ModifyString @"修改"
@interface NewAddressViewController ()<UITextViewDelegate,HZAreaPickerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL _keyboardIsVisible;    //keyboard 是否显示 默认NO
    NSArray *_arratTextView;
    NSArray * sections;
    NSString *showSelectImg;
    int SCROLLHEIGHT;
    
    HZAreaPickerView *pickerView;
    
    HZLocation *currentLocate;
    UIPickerView *countryPickerView;
    UIView *toolView;
    NSMutableArray *countriesArray;
    NSInteger selectRowTag;
    NSArray *streetArray;//街道数组
    BOOL isStreet;
    BOOL isModify;
    NSArray *newTableViewSection;
    
    
    
}
@property (weak, nonatomic) IBOutlet UIImageView *clickImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSString *tagString;
@property(nonatomic,strong)  UITableViewCell *CLICKCELL;
@property (nonatomic, weak) NavigationTitleView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)deleteButtonAction:(UIButton *)sender;
- (IBAction)defaultButtonAction:(UIButton *)sender;
- (IBAction)backHome:(id)sender;
- (IBAction)rightSave:(id)sender;
@property(nonatomic,strong)UIButton *rightButton;
@end

@implementation NewAddressViewController
@synthesize showDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)addkeyboardNotification{
    SCROLLHEIGHT=self.listTableView.frame.size.height;
}
- (void)keyboardWillShow:(NSNotification *)note {
    [self removePickerView];
    NSDictionary *userInfo = [note userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    [UIView animateWithDuration:0.3 animations:^{
        self.listTableView.frame = CGRectMake(self.listTableView.frame.origin.x,self. listTableView.frame.origin.y,self.listTableView.frame.size.width, SCROLLHEIGHT - keyboardRect.size.height-10);
    }];
    _keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    [UIView animateWithDuration:0.3 animations:^{
        self.listTableView.frame = CGRectMake(self.listTableView.frame.origin.x,self. listTableView.frame.origin.y,self.listTableView.frame.size.width, SCROLLHEIGHT );
    }];
    _keyboardIsVisible = NO;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [Toast makeToastActivity];

    [self addkeyboardNotification];

    
    [self setupNavbar];

    countriesArray = [[NSMutableArray alloc] init];
    streetArray = [[NSArray alloc]init];
    isStreet = NO;
    _titleArray = @[
                  @"请输入收货人姓名",
                  @"请输入收货人手机号码",
                  @"请选择国家",
                  @"请选择收货地区",
                  @"请输入详细地址",
                  @"请输入邮编"];
    
    _rightButton = _rightBtn;
    
    [_deleteButton setFrame:CGRectMake((UI_SCREEN_WIDTH/2-_deleteButton.frame.size.width)/2, _deleteButton.frame.origin.y, _deleteButton.frame.size.width, _deleteButton.frame.size.height)];
    
    [_defaultButton setFrame:CGRectMake(UI_SCREEN_WIDTH/2+_deleteButton.frame.origin.x, _defaultButton.frame.origin.y, _defaultButton.frame.size.width, _defaultButton.frame.size.height)];

    [self.view setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    
    [_bottomView setFrame:CGRectMake(0, UI_SCREEN_HEIGHT-50, UI_SCREEN_WIDTH, 50)];
    
    [_listTableView setFrame:CGRectMake(_listTableView.frame.origin.x, _listTableView.frame.origin.y, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
   
    _listTableView.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];

    sections = @[_nameCell,_mobileCell,_newcountryCell,_myCountryCell,_myDetailCell,_youbianCell];//_detailStreetCell,
   
    
    _arratTextView = @[ [_nameCell viewWithTag:122], [_mobileCell viewWithTag:122],[_newcountryCell viewWithTag:122], [_myCountryCell viewWithTag:122], [_myDetailCell viewWithTag:122], [_youbianCell viewWithTag:122]];
    //[_detailStreetCell viewWithTag:122],
    UIView *defaultBottom=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    [defaultBottom setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(17, 0, UI_SCREEN_WIDTH, 44)];
    showLabel.text=@"当前地址已是默认地址";
    showLabel.font=[UIFont systemFontOfSize:14.0f];
    showLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
    showLabel.textAlignment=NSTextAlignmentLeft;
    showLabel.backgroundColor=[UIColor clearColor];
    [defaultBottom addSubview:showLabel];
    if (self.row<0)
    {
        if (_defaultAddrID.length>0)
            _swcDefault.on=NO;
        else
            _swcDefault.on=YES;
    }
    else
    {
        if ([[self.showDic allKeys]containsObject:@"ISDEFAULT"]) {
            _swcDefault.on=[[Utils getSNSString:[self.showDic objectForKey:@"ISDEFAULT"]] isEqualToString:@"1"];
        }
        else if([[self.showDic allKeys] containsObject:@"is_default"])
        {
            _swcDefault.on=[[Utils getSNSString:[self.showDic objectForKey:@"is_default"]] isEqualToString:@"1"];
        }
        else
        {
           _swcDefault.on=[[Utils getSNSString:[self.showDic objectForKey:@"isdefault"]] isEqualToString:@"1"];
        }
    }
    self.defaultButton.selected = _swcDefault.on;
    _clickImageView.highlighted =_swcDefault.on;
    if (_swcDefault.on) {
        _listTableView.tableFooterView = defaultBottom;
        newTableViewSection=@[sections];
    }
    else
    {
        NSArray *defaultA=@[_chooseCell];
        newTableViewSection=@[sections,defaultA];
        _listTableView.tableFooterView = [[UIView alloc]init];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStreet:) name:@"changeStreet" object:nil];
    
    [self initSubViews];
//    [self changeArea];

}

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    UIView *tempView;
//    CGRect navRect = self.navigationController.navigationBar.frame;

    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[left1] ;
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
      self.navigationItem.rightBarButtonItems = @[right];
    
    NSString *titleStr =nil;
    
    //国家选择
//   [self requestCountryData];
    
    if (self.row<0)
    {
        titleStr=@"添加收货地址";
//        _deleteButton.hidden = YES;
//        _defaultButton.center = CGPointMake( self.view.center.x, _defaultButton.center.y);
     
    }
    else
    {
        titleStr=@"修改收货地址";
    }
    
//    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, navRect.size.height)];
    self.title=titleStr;
    isModify = YES;
}
- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)initSubViews{
    self.defaultButton.layer.cornerRadius = 3.0;
    self.deleteButton.layer.cornerRadius = 3.0;
    self.defaultButton.layer.masksToBounds = YES;
    self.deleteButton.layer.masksToBounds = YES;
    [self createCountryPickerView];
    
}
-(void)changeStreet:(NSNotification *)sender
{
    NSDictionary *dic = [sender userInfo];
    streetArray = dic[@"streetList"];
    
}
-(void)requestCountryData
{
    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    NSMutableArray *requestList = [NSMutableArray new];
    
    //获取国家
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"RegionFilter" param:@{@"userId":sns.ldap_uid,@"Parent_ID":@"-1"} responseList:requestList responseMsg:returnMessage])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Toast hideToastActivity];
                if ([requestList count]==0)
                {
                }
                else
                {
                    [countriesArray addObjectsFromArray:requestList];
                    [countryPickerView reloadAllComponents];
                }
            });
        }
    });
}
-(void)createCountryPickerView
{
    toolView=[[UIView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-162-39-39, UI_SCREEN_WIDTH, 39)];
    toolView.hidden=YES;
    
//    [toolView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0  blue:246.0/255.0 alpha:1]];
    [toolView setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    
    [self.view addSubview:toolView];
    UIButton *doneBar =[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBar setFrame:CGRectMake(UI_SCREEN_WIDTH-50-17, 0, 50, 39)];
    [doneBar setTitle:@"确定" forState:UIControlStateNormal];
    [doneBar setTitleColor:[Utils HexColor:0x3b3b3b Alpha:1] forState:UIControlStateNormal];
//    [doneBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    doneBar.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [doneBar addTarget:self
                action:@selector(doneBtn)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cacleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cacleBtn setFrame:CGRectMake(17, 0, 50, 39)];
    [cacleBtn setTitleColor:[Utils HexColor:0x999999 Alpha:1] forState:UIControlStateNormal];
    [cacleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cacleBtn addTarget:self
                 action:@selector(cacleBtn)
       forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:doneBar];
    [toolView addSubview:cacleBtn];
    countryPickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-162-39, UI_SCREEN_WIDTH, 162+49+39)];
    countryPickerView.hidden=YES;
    [countryPickerView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1]];
    [countryPickerView setBackgroundColor:[UIColor whiteColor]];
    countryPickerView.dataSource = self;
    countryPickerView.delegate = self;
    countryPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:countryPickerView];
    
}
-(void)doneBtn
{
    countryPickerView.hidden=YES;
    toolView.hidden=YES;
    NSString *strValueChange=nil;

    if (isStreet)
    {
        if ([streetArray count]==0||!([streetArray count]>selectRowTag)) {
            return;
        }
//        strValueChange =[NSString stringWithFormat:@"%@",streetArray[selectRowTag][@"name"]];
         strValueChange =[NSString stringWithFormat:@"%@",streetArray[selectRowTag][@"NAME"]];
    }
    else
    {
        if ([countriesArray count]==0||!([countriesArray count]>selectRowTag)) {
            return;
        }
//        strValueChange =[NSString stringWithFormat:@"%@",countriesArray[selectRowTag][@"name"]];
        strValueChange =[NSString stringWithFormat:@"%@",countriesArray[selectRowTag][@"name"]];
    }
    [self userInfoValueChanged:strValueChange];
    [self performSelector:@selector(removePickerView) withObject:nil afterDelay:0.2];
}
-(void)cacleBtn
{
    countryPickerView.hidden=YES;
    
    toolView.hidden=YES;
}

-(NSString *)getProvinceCityCountyAddressString
{

    NSString *str_addrdetail=[NSString stringWithFormat:@"%@ %@ %@",[Utils getSNSString:[self.showDic objectForKey:@"province"]],[Utils getSNSString:[self.showDic objectForKey:@"city"]],[Utils getSNSString:[self.showDic objectForKey:@"county"]]];
    return str_addrdetail;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
//        NSString *str=[self.showDic objectForKey:@"address"];
//       CGSize size = [str boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size;
//        return size.height+45;
        return 44;

    }else if (indexPath.row == 3){
//        NSString *str= [self getProvinceCityCountyAddressString];
//         CGSize size = [str boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size;
//        return size.height/2+45;
        return 44;
    }
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [newTableViewSection count];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newTableViewSection[section] count];
//    return [sections count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cellX = [sections objectAtIndex:[indexPath row]];
     UITableViewCell *cellX = [newTableViewSection[indexPath.section] objectAtIndex:[indexPath row]];
    NSString *AIdentifier =  [cellX reuseIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        cell = cellX;
    }
    cell.layer.masksToBounds = YES;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIKeyboardType keyboardType=UIKeyboardTypeDefault;
    
    UITextView *telLabel = (UITextView*)[cell.contentView viewWithTag:122];
    telLabel.delegate = self;
    telLabel.userInteractionEnabled = NO;

    if (!isModify) {

        telLabel.userInteractionEnabled = NO;
    }else{
        
        if (indexPath.row != 3&&indexPath.row!=2) {//&&indexPath.row!=4
            telLabel.userInteractionEnabled = YES;
           
        }
    }
    switch (indexPath.row)
    {
        case 0:{ //收货人
            keyboardType = UIKeyboardTypeDefault;
//            if ([[self.showDic allKeys]containsObject:@"NAME"]&&[[self.showDic allKeys] containsObject:@"ISDEFAULT"])
//            {
//                if ([[Utils getSNSString:[self.showDic objectForKey:@"NAME"]] isEqualToString:@""]) {
//                    
//                }else{
//                    
//                    telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"NAME"]]];
//                }
//            }
//            else
//            {
                if ([[Utils getSNSString:[self.showDic objectForKey:@"name"]] isEqualToString:@""]) {
                    NSString *nameStr =[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"NAME"]]];
                    if ([Utils getSNSString:nameStr].length!=0) {
                        telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"NAME"]]];
                    }
                }else{
                    
                    telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"name"]]];
                }
//            }

            
            
        }
            break;
        case 1://手机号码
        {
             keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            if ([[Utils getSNSString:[self.showDic objectForKey:@"mobileno"]] isEqualToString:@""]) {
                NSString *nameStr =[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"MOBILENO"]]];
                if ([Utils getSNSString:nameStr].length!=0) {
                    telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"MOBILENO"]]];
                }
            }else{
                NSString *mobilS=[NSString stringWithFormat:@"%@",[self.showDic objectForKey:@"mobileno"]];
                telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:mobilS]];
            }
            //            telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"address"]]];
            //            if ([telLabel.text length]>14)
            //            {
            //                telLabel.lineBreakMode = NSLineBreakByCharWrapping;
            //                telLabel.numberOfLines = 0;
            //                [telLabel sizeToFit];
            //            }
            //            else
            //            {
            //                telLabel.numberOfLines = 1;
            //            }
        }break;
        case 2://国籍
        {
//            if ([[Utils getSNSString:[self.showDic objectForKey:@"country"]] isEqualToString:@""]) {
                telLabel.text=@"中国";
                
//                NSString *nameStr =[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"COUNTRY"]]];
//                if ([Utils getSNSString:nameStr].length!=0) {
//                    telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"COUNTRY"]]];
//                }
//                
//            }else{
//                NSString *country=[NSString stringWithFormat:@"%@",[self.showDic objectForKey:@"country"]];
//                telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:country]];
//            }
        }
            break;
        case 3://省市区
        {
            if ([[Utils getSNSString:[self.showDic objectForKey:@"county"]] isEqualToString:@""]) {
                NSString *nameStr =[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"COUNTY"]]];
                if ([Utils getSNSString:nameStr].length!=0) {
                    telLabel.text=[NSString stringWithFormat:@"%@ %@ %@",[Utils getSNSString:[self.showDic objectForKey:@"PROVINCE"]],[Utils getSNSString:[self.showDic objectForKey:@"CITY"]],[Utils getSNSString:[self.showDic objectForKey:@"COUNTY"]]];
                    CGSize size=[telLabel.text sizeWithFont:telLabel.font constrainedToSize:CGSizeMake(telLabel.frame.size.width, MAXFLOAT)];
                    telLabel.frame=CGRectMake(telLabel.frame.origin.x,telLabel.frame.origin.y,telLabel.frame.size.width,size.height+20);
                }
                
            }else{
                telLabel.text=[NSString stringWithFormat:@"%@ %@ %@",[Utils getSNSString:[self.showDic objectForKey:@"province"]],[Utils getSNSString:[self.showDic objectForKey:@"city"]],[Utils getSNSString:[self.showDic objectForKey:@"county"]]];
                CGSize size=[telLabel.text sizeWithFont:telLabel.font constrainedToSize:CGSizeMake(telLabel.frame.size.width, MAXFLOAT)];
                telLabel.frame=CGRectMake(telLabel.frame.origin.x,telLabel.frame.origin.y,telLabel.frame.size.width,size.height+20);
            }
        }break;
        case 41 ://街道
        {
//            if ([[Utils getSNSString:[self.showDic objectForKey:@"street"]] isEqualToString:@""]) {
//                if (![self.titleLabel.text isEqualToString:@"新建收货地址"]) {
//                        telLabel.text=@"";
//                }
//            }else{
//                telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"street"]]];
//                CGSize size=[telLabel.text sizeWithFont:telLabel.font constrainedToSize:CGSizeMake(telLabel.frame.size.width, MAXFLOAT)];
//                telLabel.frame=CGRectMake(telLabel.frame.origin.x,telLabel.frame.origin.y,telLabel.frame.size.width,size.height+20);
//            }
        }   break;
        case 4://详细地址
        {
            //            NSString *phoneS=[NSString stringWithFormat:@"%@",[self.showDic objectForKey:@"phoneno"]];
            //
            //            telLabel.text=[Utils getSNSString:phoneS];
            
             keyboardType = UIKeyboardTypeDefault;
            if ([[Utils getSNSString:[self.showDic objectForKey:@"address"]] isEqualToString:@""]) {
                if (![self.titleLabel.text isEqualToString:@"新建收货地址"]) {
                    telLabel.text=@"";
                }
                NSString *nameStr =[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"ADDRESS"]]];
                if ([Utils getSNSString:nameStr].length!=0) {
                    telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"ADDRESS"]]];
                    CGSize size = [telLabel.text boundingRectWithSize:CGSizeMake(telLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObject:telLabel.font forKey:NSFontAttributeName] context:nil].size;
                    telLabel.frame=CGRectMake(telLabel.frame.origin.x,telLabel.frame.origin.y,telLabel.frame.size.width,size.height+20);
                }
                
         
                
                
            }else{
                telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"address"]]];
//                CGSize size=[telLabel.text sizeWithFont:telLabel.font constrainedToSize:CGSizeMake(telLabel.frame.size.width, MAXFLOAT)];
                 CGSize size = [telLabel.text boundingRectWithSize:CGSizeMake(telLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObject:telLabel.font forKey:NSFontAttributeName] context:nil].size;
                telLabel.frame=CGRectMake(telLabel.frame.origin.x,telLabel.frame.origin.y,telLabel.frame.size.width,size.height+20);
            }
            
            
        }break;
        case 5://邮政编码
        {
              keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            if ([[Utils getSNSString:[self.showDic objectForKey:@"posT_CODE"]] isEqualToString:@""]) {
                if (![self.titleLabel.text isEqualToString:@"新建收货地址"]) {
                    telLabel.text=@"";
                }
                NSString *nameStr =[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"POST_CODE"]]];
                if ([Utils getSNSString:nameStr].length!=0) {
                    telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"POST_CODE"]]];
                }
                NSString *nameStrs =[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"post_code"]]];
                if ([Utils getSNSString:nameStrs].length!=0) {
                    telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"post_code"]]];
                }

                
            }else{
                NSString *postcode =[NSString stringWithFormat:@"%@",[self.showDic objectForKey:@"posT_CODE"]];
                telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:postcode]];

            }
            //             telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"name"]]];
        }
            break;

        case 7:
        {
            
            //            NSString *defaultss =[NSString stringWithFormat:@"%@",[self.showDic objectForKey:@"isdefault"]];
            //            telLabel.text=@"是否为默认";
            //
            //             UIImageView *showImg = (UIImageView*)[cell.contentView viewWithTag:101];
            //            if ([defaultss isEqualToString:@"0"])
            //            {
            //                [showImg setImage:[UIImage imageNamed:@"register_checkbox_unselected.png"]];
            //
            //            }else
            //            {
            //                [showImg setImage:[UIImage imageNamed:@"register_checkbox_selected.png"]];
            //
            //            }
            
        }break;
        case 8:
        {
            //            NSString *postcode =[NSString stringWithFormat:@"%@",[self.showDic objectForKey:@"posT_CODE"]];
            //            telLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:postcode]];
        }break;
            
        default:
            break;
    }
    
    
    
    if (telLabel.text.length==0||[telLabel.text isEqualToString:@"(null)"])
    {
        telLabel.text=@"";//@"未填写";
//        telLabel.textColor=[Utils HexColor:0x919191 Alpha:1.0];
        
    }
    else
    {
//        telLabel.textColor =[Utils HexColor:0x333333 Alpha:1.0];
    }
    
    telLabel.keyboardType =keyboardType;
    return cell;
    
    
}

- (void)resignAllViewFirstResponder
{
    NSArray *array = [self.listTableView visibleCells];
    for(UITableViewCell *cell in array){
        UITextView *telLabel = (UITextView*)[cell.contentView viewWithTag:122];
        [telLabel resignFirstResponder];
    }
     [_listTableView setContentOffset:CGPointMake(0,0) animated:YES];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:NO];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *clickStr;
    UIKeyboardType keyboardType=UIKeyboardTypeDefault;

    UITableViewCell *cell = newTableViewSection[indexPath.section][indexPath.row];
    UITextView *telLabel = (UITextView*)[cell.contentView viewWithTag:122];

    if (indexPath.section==1) {
        
        [_clickImageView setHighlighted:!_clickImageView.highlighted];
        return;
    }
    
    if(indexPath.row==2)
    {
        
//        isStreet = NO;
//        currentEditControl=(UIControl *)telLabel;
//
//        [self resignAllViewFirstResponder];
//        [self removePickerView];
//        [countryPickerView reloadAllComponents];
//        countryPickerView.hidden=NO;
//        toolView.hidden=NO;
        
        
    }
   else if (indexPath.row == 3) {
       
//       [self resignAllViewFirstResponder];
//       [self removePickerView];
//       EditAddressViewController *edit = [[EditAddressViewController alloc]initWithNibName:@"EditAddressViewController" bundle:nil];
//       edit.nameStr = @"请输入收货人所在地";
//       edit.keyboardType = keyboardType;
//       edit.cityStr=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"city"]]];
//       edit.countryStr=[NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"county"]]];
//       edit.provinceStr = [NSString stringWithFormat:@"%@",[Utils getSNSString:[self.showDic objectForKey:@"province"]]];
//       edit.delegate=self;
//       edit.detailStr = [NSString stringWithFormat:@"%@",telLabel.text];
//
//       [self.navigationController pushViewController:edit animated:YES];
//       return;
       currentEditControl=(UIControl *)telLabel;

        [self resignAllViewFirstResponder];
       [self removePickerView];
        if (!pickerView) {
            pickerView = [[HZAreaPickerView alloc] initWithStyle:self];
            [pickerView showInView:self.view];
            
            if (!currentLocate) {
                HZLocation *locate = [[HZLocation alloc] init];
                
                NSString *state = [Utils getSNSString:[self.showDic objectForKey:@"province"]];
                if ([state length] == 2) {
                    state = [state stringByAppendingString:@"市"];
                }
                locate.city = [Utils getSNSString:[self.showDic objectForKey:@"city"]];
                locate.state = state;
                locate.district = [Utils getSNSString:[self.showDic objectForKey:@"county"]];
                
                //        locate.state = @"吉林省";
                //        locate.city = @"四平市";
                //        locate.district = @"铁东县";
                [pickerView updatePickerWithAddress:locate];
            } else {
                [pickerView updatePickerWithAddress:currentLocate];
            }
            
        }
   }
//   } else if(indexPath.row==4){
//       isStreet = YES;
//       
//
//
//       [self resignAllViewFirstResponder];
//       [self removePickerView];
//       [countryPickerView reloadAllComponents];
//       countryPickerView.hidden=NO;
//       toolView.hidden=NO;
//   }
   else {
        [self removePickerView];
        switch (indexPath.row)
        {
            case 0:{
                clickStr = @"请输入收货人姓名";
                keyboardType = UIKeyboardTypeDefault;
            }
                break;
            case 1:
            {
                clickStr =@"请输入收货人手机号码";
                keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }break;
            case 2:
            {
                clickStr =@"请选择国家";

            }break;
            case 3:
            {
                clickStr =@"请选择收货地区";
 

            }break;
            case 41:
            {
                clickStr =@"请输入街道";
                keyboardType = UIKeyboardTypeDefault;

            }break;
            case 4:
            {
                clickStr =@"请输入详细地址";
                keyboardType = UIKeyboardTypeDefault;

            }   break;
            case 5:
            {
                clickStr =@"请输入邮编";
                keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                //         clickStr =@"是否默认";
            }break;
            case 7:
            {

            }break;
                
            default:
                break;
        }
        
        telLabel.keyboardType =keyboardType;
       
    }
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    [self shouldMoveframe:YES WithRect:rect];
}

- (void)shouldMoveframe:(BOOL)animate WithRect:(CGRect)rect {
//    CGFloat offsetHeight = [UIScreen mainScreen].bounds.size.height == 480 ? 100 : 120;
//    if ( !(_keyboardIsVisible && animate) ) {
//        [UIView animateWithDuration:.3 delay:0 options:0 animations:^{
//            CGFloat offset = rect.origin.y - offsetHeight;
//            CGPoint point = CGPointZero;
//            point.y = offset >= 0 ? offset : 0;
//            [_listTableView setContentOffset:point];
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
    return;
    
    BOOL shouldSetoffset = ([UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(rect) - 216 - 64 - 44) < 0 ? YES : NO;
    
    if ( !(_keyboardIsVisible && animate) && shouldSetoffset ) {
        [UIView animateWithDuration:.3 delay:0 options:0 animations:^{
//            CGFloat zidane = CGRectGetMaxY(rect);
            CGFloat offset = [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(rect) - 216 - 64 - 44;
            CGPoint point = CGPointZero;
            point.y = -offset;
            [_listTableView setContentOffset:point];
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGRect rect = _listTableView.frame;
//    rect.origin.y = _headerView.frame.origin.y + _headerView.frame.size.height;
//    _listTableView.frame = rect;
}

#pragma mark userInfoValueChanged delegate
-(void)userInfoValueChanged:(NSString *)sender
{
    UILabel *label=(UILabel *)currentEditControl;

    label.text = [NSString stringWithFormat:@"%@",sender];
    
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObject:label.font forKey:NSFontAttributeName] context:nil].size;
    label.frame=CGRectMake(label.frame.origin.x,label.frame.origin.y,label.frame.size.width,size.height+25);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)validateUserName:(NSString *)userName
{
    //只含有汉字、数字、字母
    //    NSString *phoneRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";//^[a-zA-Z0-9_\u4e00-\u9fa5]+$ 可加下划线位置不限
    //    1-18位 不能全部为数字 不能全部为字母 必须包含字母和数字
    //    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSString *regex =   @"^[A-Za-z\u4e00-\u9fa5]+$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phoneTest evaluateWithObject:userName];
}
-(void)save:(UIButton *)sender
{
    [self.view endEditing:YES];
//    if ([_titleLabel.text isEqualToString:@"新建收货地址"]) {
//        
//    }
//    else
//    {
//          _bottomView.hidden=!_bottomView.hidden;
//    }

    
//    if ([sender.titleLabel.text  isEqualToString:ModifyString]) {
//        [sender setTitle:SaveString forState:UIControlStateNormal];
//        isModify= YES;
//        [self.listTableView reloadData];
//        [self requestCountryData];
//
//        
//    }else
//    {
//        isModify=NO;
//        if ([_titleLabel.text isEqualToString:@"新建收货地址"]) {
//            isModify=YES;
//        }
//        NSMutableDictionary *saveDic=[[NSMutableDictionary alloc]initWithDictionary:self.showDic];
     NSMutableDictionary *saveDic=[[NSMutableDictionary alloc]init];
    NSLog(@".SELF.SHOW.....%@",self.showDic);
    
        [saveDic setObject:sns.ldap_uid forKey:@"UserId"];

        if (self.row>=0)
        {
//            [saveDic setObject:sns.myStaffCard.nick_name forKey:@"lasT_MODIFIED_USER"];
              [saveDic setObject:sns.myStaffCard.nick_name forKey:@"CREATE_USER"];
            if ([[self.showDic allKeys]containsObject:@"id"]) {
                  [saveDic setObject:self.showDic[@"id"] forKey:@"ID"];
            }
            else
            {
                [saveDic setObject:self.showDic[@"ID"] forKey:@"ID"];
            }
         
            [saveDic setObject:@"" forKey:@"ACCOUNT_ORIGINAL_CODE"];
        }
        else
        {
            [saveDic setObject:sns.myStaffCard.nick_name forKey:@"CREATE_USER"];
        }
    
        for (int k=0; k<[sections count]; k++)
        {
            UITableViewCell *cell = [sections objectAtIndex:k];
            //        UILabel *telLabel = (UILabel*)[cell.contentView viewWithTag:100];
            UITextView *telLabel = (UITextView*)[cell.contentView viewWithTag:122];
            
            NSString *changeStr=[NSString stringWithFormat:@"%@",telLabel.text];
            //判断空格
            NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimedString = [changeStr stringByTrimmingCharactersInSet:set];
            trimedString = [Utils getSNSString:trimedString];
            
            switch (k)
            {
                case 0:{
                    if ([changeStr isEqualToString:@"请输入收货人姓名"])
                    {
                        changeStr=@"";
                        trimedString=@"";
//                        [Utils alertMessage:@"请输入收货人姓名"];
                        [MBToastHud show:@"请输入收货人姓名" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                        return;
                    }
                    if (trimedString.length==0)
                    {
                        [MBToastHud show:@"请输入收货人姓名" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
//                        [Utils alertMessage:@"请输入联系人姓名！"];Unico/warning
    
                        return;
                    }
                    NSInteger msgLength = [self unicodeLengthOfString:changeStr];
                    if (msgLength>6) {
                       //请输入2-12个字符的姓名
                        [MBToastHud show:@"请输入6个汉字或10个英文以内的姓名" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                        
                        return;
                    }
                    else if(msgLength<2)
                    {//请输入2-12个字符的姓名
                        [MBToastHud show:@"请输入正确的姓名" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                        return;
                    }
//                    if (changeStr.length>20) {
//                    
//                        [MBToastHud show:@"请输入2-20个字符的姓名" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
//                        
//                        return;
//                    }
//                    else if(changeStr.length<2)
//                    {
//                        [MBToastHud show:@"请输入2-20个字符的姓名" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
//                        return;
//                    }
                     if( ![self validateUserName:changeStr] )
                      {
                          [MBToastHud show:@"请输入中英文的姓名" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                          return;
                      }
                    
                    [saveDic setObject:changeStr forKey:@"NAME"];
                    /*
                     NSArray *array=[changeStr componentsSeparatedByString:@" "];
                     NSString *provinceS=[NSString stringWithFormat:@"%@",[array firstObject]];
                     NSString *city =[NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
                     NSString *county = [NSString stringWithFormat:@"%@",[array objectAtIndex:2]];
                     if (provinceS.length==0||city.length==0||county.length==0)
                     {
                     [Utils alertMessage:@"请输入联系人所在地区！"];
                     return;
                     }
                     [saveDic setObject:provinceS forKey:@"province"];
                     [saveDic setObject:city forKey:@"city"];
                     [saveDic setObject:county forKey:@"county"];
                     */
                }
                    break;
                case 1:
                {
                    if (trimedString.length==0)
                    {
                         [MBToastHud show:@"请输入联系人手机号" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
//                        [Utils alertMessage:@"请输入联系人手机号！"];
                        return;
                    }
                    [saveDic setObject:changeStr forKey:@"MOBILENO"];
            
                    
                    if ([self detectiontextViewWithString:changeStr withIndexRow:k] == NO) {
                        return;
                    }
                    
                }break;
                case 2:
                {
                    if ([changeStr isEqualToString:@"请选择国家"])
                    {
                        changeStr=@"";
                        
//                        [Utils alertMessage:@"请选择国家！"];
                         [MBToastHud show:@"请选择国家" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                        return;
                    }
                    
                    if (trimedString.length==0)
                    {
//                        [Utils alertMessage:@"请选择联系人国家！"];
                          [MBToastHud show:@"请选择联系人国家" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                        return;
                    }
                         [saveDic setObject:changeStr forKey:@"COUNTRY"];
                }
                    break;
                case 3:
                {
                    if ([changeStr isEqualToString:@"具体城市"]) {
                        
                        [MBToastHud show:@"请输入联系人所在地区" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
//                        [Utils alertMessage:@"请输入联系人所在地区!"];
                        return;
                    }
                    NSArray *array=[changeStr componentsSeparatedByString:@" "];
                    NSString *provinceS=@"";
                    NSString *city=@"";
                    NSString *county=@"";
                    
                    if ([array count]>1) {
                        
                        provinceS=[NSString stringWithFormat:@"%@",[array firstObject]];
                        city =[NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
                        county = [NSString stringWithFormat:@"%@",[array objectAtIndex:2]];
                    }
                    provinceS = [Utils getSNSString:provinceS];
                    city= [Utils getSNSString:city];
                    county =[Utils getSNSString:county];
                    if (provinceS.length==0||city.length==0||county.length==0)
                    {
                        [MBToastHud show:@"请输入联系人所在地区" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                        return;
                    }
                    [saveDic setObject:provinceS forKey:@"PROVINCE"];
                    [saveDic setObject:city forKey:@"CITY"];
                    [saveDic setObject:county forKey:@"COUNTY"];
                    
                }
                    break;
                    case 41:
                {
                    
                    if ([changeStr isEqualToString:@"请选择街道"])
                    {
                       changeStr =@"";
                    }
                    if (trimedString.length==0)//||changeStr.length==0
                    {
//                        [Utils alertMessage:@"请选择街道"];
                    }
                     [saveDic setObject:changeStr forKey:@"street"];
                }
                    break;
                    
                case 4:
                {
//                    NSInteger msgLength = [self unicodeLengthOfString:changeStr];
                    
                    if ([changeStr isEqualToString:@"请输入详细地址"])
                    {
                        changeStr =@"";
//                        [Utils alertMessage:@"请输入详细地址"];
                        [MBToastHud show:@"请输入详细地址" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                        return;
                    }
              
                    if (trimedString.length==0)
                    {
//                        [Utils alertMessage:@"请输入联系人地址！"];
                        [MBToastHud show:@"请输入联系人详细地址" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                        return;
                    }
                    if (changeStr.length>60) {
                        
                        [MBToastHud show:@"请输入5-60个字符的详细地址" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                        
                        return;
                    }
                    else if(changeStr.length<5)
                    {
                        [MBToastHud show:@"请输入5-60个字符的详细地址" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
                        return;
                    }
                    [saveDic setObject:changeStr forKey:@"ADDRESS"];
//                    [saveDic setObject:sns.myStaffCard.nick_name forKey:@"address"];
                    
                    
                    
                    //                [saveDic setObject:changeStr forKey:@"phoneno"];
                }
                    break;
                case 5:
                {
                    //                    if (trimedString.length==0)
                    //                    {
                    //                        [Utils alertMessage:@"请输入联系地址邮编！"];
                    //                        return;
                    //                    }
                    //邮编不为必须输入字段   2015-3-24 lvxuejun
                    if ([changeStr isEqualToString:@"请输入邮编"])
                    {
                        changeStr =@"";
                    }
                    if(trimedString.length>0 && ![trimedString isEqualToString:@"请输入邮编"])
                    {
                        [saveDic setObject:changeStr forKey:@"POST_CODE"];
                    }
                    
                    if ([self detectiontextViewWithString:changeStr withIndexRow:k] == NO) {
                        return;
                    }
                    
                    /*
                     if (changeStr.length==0)
                     {
                     [Utils alertMessage:@"请输入联系人姓名！"];
                     return;
                     }
                     [saveDic setObject:changeStr forKey:@"name"];
                     */
                }
                    break;
                case 7:
                {
                    //                [saveDic setObject:changeStr forKey:@"email"];
                    //                [saveDic setObject:@"0" forKey:@"isdefault"];
                }   break;
                case 8:
                {
//                    [saveDic setObject:@"0" forKey:@"isdefault"];
                }
                    break;
                case 9:
                {
//                    [saveDic setObject:changeStr forKey:@"posT_CODE"];
                }break;
                    
                default:
                    break;
            }
        }

        if (saveDic[@"PHONENO"]==nil){
            if ([[saveDic allKeys]containsObject:@"MOBILENO"]) {
                [saveDic setObject:saveDic[@"MOBILENO"] forKey:@"PHONENO"];
            }
        }
        
        NSString *MBShoppingGuideServerOther;
        NSMutableString *returnMessage=[[NSMutableString alloc]init];
        if (self.row<0)
        {
            MBShoppingGuideServerOther=@"ReceiverCreate";
            //        if (_existDefaultAddr)
            //            [saveDic setObject:@"0" forKey:@"isdefault"];
            //        else
            //            [saveDic setObject:@"1" forKey:@"isdefault"];
        }
        else
        {
            MBShoppingGuideServerOther=@"ReceiverUpdate";
        }
        //    [saveDic setObject:_swcDefault.on?@"1":@"0" forKey:@"isdefault"];
//        NSString *defaultString = [NSString stringWithFormat:@"%d", [self.defaultButton isSelected]];
    NSString *defaultString = [NSString stringWithFormat:@"%d", [_clickImageView isHighlighted]];
    _swcDefault.on=_clickImageView.highlighted;
    
        [saveDic setObject:defaultString forKey:@"ISDEFAULT"];
        [Toast makeToastActivity:@"正在提交..." hasMusk:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           __block BOOL cancelOldDefault=NO;
            NSLog(@"--------%d",_swcDefault.on);
            
            if (_defaultAddrID.length>0&&_swcDefault.on)
            {

                
                   cancelOldDefault=YES;
                
            }
            
            
            [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:MBShoppingGuideServerOther params:saveDic success:^(NSDictionary *dict) {

                if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
                {
                
                    [Toast hideToastActivity];
                    if (cancelOldDefault)
                        [_mainview setDefaultAddress:_defaultAddrID isDefault:NO];
                    [_mainview NewAddressViewController_onRefreshRow:self eventData:saveDic];
                    NSString *message=nil;
                    if (self.row<0)
                    {
                        //                        [Toast makeToast:@"添加成功！"];//returnMessage
                        message=@"添加地址成功";
                        //                        [MBToastHud show:@"添加地址成功" image:[UIImage imageNamed:@"Unico/success"] spin:NO hide:YES Interaction:NO];
                    }
                    else
                    {
                        //                        [Toast makeToast:@"修改成功！"];//returnMessage
                        message=@"修改地址成功";
                        
                    }
                    [MBToastHud show:message image:[UIImage imageNamed:@"Unico/success"] spin:NO hide:YES Interaction:NO];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [Toast hideToastActivity];
                    NSString *message=nil;
                    if(self.row<0)
                    {
                        message=@"添加地址失败";
                    }
                    else
                    {
                        message=@"修改地址失败";
                    }
                    [MBToastHud show:message image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
                }
                
            } failed:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    NSString *message=nil;
                    if(self.row<0)
                    {
                        message=@"添加地址失败";
                    }
                    else
                    {
                        message=@"修改地址失败";
                    }
                    [MBToastHud show:message image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
                });
                
            }];

        });
//    }
}


- (IBAction)rightSave:(id)sender {
//    [_listTableView reloadData];
    [self.view endEditing:YES];
    [self save:sender];
    
}

- (IBAction)swcDefaultValueChanged:(id)sender {
    //isSetDefault=_swcDefault.on;
    UITableViewCell *cell = [sections objectAtIndex:5];
    UIImageView *showImg = (UIImageView*)[cell.contentView viewWithTag:101];
    
    if (_swcDefault.on)
    {
        showSelectImg=@"1";
        
        [showImg setImage:[UIImage imageNamed:@"register_checkbox_selected.png.png"]];
    }else
    {
        [showImg setImage:[UIImage imageNamed:@"register_checkbox_unselected.png"]];
        showSelectImg=@"0";
    }
    
    
}

#pragma mark -- textViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//     int tap=0;
//    for (UITextView *tv in _arratTextView) {
//        if (textView == tv) {
//            UIView *superview = textView.superview.superview;
//            NSIndexPath *indexPath = [_listTableView indexPathForCell:(UITableViewCell *)superview];
//            NSLog(@"indexPath ---- %@",indexPath);
//            if (indexPath) {
////                tap = indexPath.row;
////                [self tableView:_listTableView didSelectRowAtIndexPath:indexPath];
//            }
//        }
//    }

    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSString *allString = @"具体城市,请选择国家,请输入国家,请选择收货地区,请选择街道,请输入详细地址,请输入收货人姓名,请输入收货人手机号码,请输入收货人联系电话,请输入收货人邮箱地址,请输入邮编";
    NSRange range = [allString rangeOfString:textView.text];//判断字符串是否包含

    if (range.length >0)//包含
    {
         textView.text = @"";
    }
    int tap=0;
    UITableViewCell *tableViewCell;
    if (SYSTEM_VERSION_GREATER_THAN(@"8")) {
        tableViewCell = (UITableViewCell *)[textView superview].superview;
    }else {
        
        tableViewCell = (UITableViewCell *)[textView superview].superview.superview;
        
    }
//    UITableViewCell *tableViewCell=(UITableViewCell *)textView.superview.superview.superview;
    
    NSIndexPath *indexPath = [_listTableView indexPathForCell:tableViewCell];
    tap = (int)indexPath.row;
    [self removePickerView];
    
    if (UI_SCREEN_HEIGHT<500)
    {
        [_listTableView setContentOffset:CGPointMake(0,50*((tap-3)>0?4:0)) animated:YES];
    }
    else
    {
        [_listTableView setContentOffset:CGPointMake(0,50*((tap-4)>0?3:0)) animated:YES];
    }
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
   
    UITableViewCell *CLICKCELL;
    NSIndexPath *indexpath;
    if (SYSTEM_VERSION_GREATER_THAN(@"8")) {
         CLICKCELL = (UITableViewCell *)[textView superview].superview;
    }else {
    
        CLICKCELL = (UITableViewCell *)[textView superview].superview.superview;
    
    }

    if ([CLICKCELL isKindOfClass:[UITableViewCell class]]) {
       indexpath = [_listTableView indexPathForCell:CLICKCELL];
    }
    
    if (textView.text.length == 0) {
        textView.text = _titleArray[indexpath.row];

    }
    
    if (indexpath.row == 3) {
        NSMutableDictionary *tmpdic = [NSMutableDictionary dictionaryWithDictionary:self.showDic];
        [tmpdic setObject:textView.text forKey:@"address"];
   

    }
//        [_listTableView reloadData];
      [_listTableView setContentOffset:CGPointMake(0,0) animated:YES];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
  
    //判断输入内容是否为表情图标   2015-3-26 lvxuejun
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        [self.view endEditing:NO];
        [textView canResignFirstResponder];
        [textView resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    NSString *detailStr = [NSString stringWithFormat:@"%@%@",textView.text,text];
    if(detailStr.length!=0)
    {
        UITableViewCell *CLICKCELL;
        NSIndexPath *indexpath;
        if (SYSTEM_VERSION_GREATER_THAN(@"8")) {
            CLICKCELL = (UITableViewCell *)[textView superview].superview;
        }else {
            
            CLICKCELL = (UITableViewCell *)[textView superview].superview.superview;
            
        }
        
        if ([CLICKCELL isKindOfClass:[UITableViewCell class]]) {
            indexpath = [_listTableView indexPathForCell:CLICKCELL];
        }
        switch (indexpath.row) {
            case 0://名字
            {
                [self.showDic setValue:detailStr forKey:@"name"];
                
            }
                break;
            case 1:
            {
            
                [self.showDic setValue:detailStr forKey:@"mobileno"];
            }
                break;
            case 2:
            {
                  [self.showDic setValue:detailStr forKey:@"country"];
            }
                break;
            case 3:
            {
                
            }
                break;
            case 4:
            {
               [self.showDic setValue:detailStr forKey:@"address"];
            }
                break;
            case 5:
            {
//                [self.showDic setValue:detailStr forKey:@"address"];
                    [self.showDic setValue:detailStr forKey:@"posT_CODE"];
            }
                break;
            case 6:
            {
//                    [self.showDic setValue:detailStr forKey:@"posT_CODE"];
            }
                break;
                
            default:
                break;
        }
 
    }
       return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
}

-(BOOL)detectiontextViewWithString:(NSString *)getString withIndexRow:(int)selectrow{
    
    //邮编不为必须输入字段   2015-3-24 lvxuejun
    //||[[getString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""]
    if([getString isEqualToString:@"<null>"]||getString==nil||[getString isEqualToString:@"(null)"]){
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"输入信息不能包含空格字符"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        
//        [alert show];
          [MBToastHud show:@"请输入正确信息" image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
        return NO;
    }
    
    BOOL isMatch;
    NSString *showMessage;
    BOOL isJudgement;
    
    if (selectrow == 1)
    {
        isJudgement = YES;
        isMatch = [self validateMobile:getString];
        showMessage = [NSString stringWithFormat:@"请输入正确的手机号码"];
    }
    
    //if ([_editTextField.placeholder isEqualToString:@"请输入收货人邮箱地址"])
    //{
    //    isJudgement = YES;
    //    isMatch = [self validateEmail:getString];
    //    showMessage = [NSString stringWithFormat:@"请输入正确的电子邮箱"];
    //}
    
    if (selectrow == 5) {
        //邮编不为必须输入字段   2015-3-24 lvxuejun
        if(getString.length>0 && ![getString isEqualToString:@"请输入邮编"])
        {
            isJudgement = YES;
            isMatch = [self validatePostcode:getString];
            showMessage = [NSString stringWithFormat:@"请输入正确的六位邮编地址"];
        }
        else
        {
            isMatch = YES;
        }
    }
    
    
    if (showMessage) {
        if (!isMatch) {
            
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:showMessage
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            
//            [alert show];
       [MBToastHud show:showMessage image:[UIImage imageNamed:@"Unico/warning"] spin:NO hide:YES Interaction:NO];
           
        }
        
    }
    
     return isMatch;
}
//邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码验证
- (BOOL)validateMobile:(NSString *)mobile
{
    //    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    return [phoneTest evaluateWithObject:mobile];
    
    NSString *phoneRegex = @"^((1[0-9]))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
    
}

-(BOOL)validatePostcode:(NSString*)postcode
{
//    NSString *phoneRegex = @"^[0-9]\\d{6}$";
    NSString *phoneRegex =@"^\\d{6}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    if (phoneRegex.length>12)
    {
        return NO;
        
    }
    else
    {
        return [phoneTest evaluateWithObject:postcode];
    }
    
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


- (void)removePickerView
{
    if (pickerView) {
        [pickerView removeFromSuperview];
        pickerView = nil;
    }
    countryPickerView.hidden=YES;
    toolView.hidden=YES;
}

- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    currentLocate = picker.locate;
    NSString *state = picker.locate.state;
//    state = [state stringByReplacingOccurrencesOfString:@"市" withString:@""];
    [self userInfoValueChanged:[NSString stringWithFormat:@"%@ %@ %@",state,picker.locate.city,picker.locate.district]];
    [self performSelector:@selector(removePickerView) withObject:nil afterDelay:0.2];
}

- (void)pickerToolBarCancel:(HZAreaPickerView *)picker
{
    [self removePickerView];
}
- (IBAction)deleteButtonAction:(UIButton *)sender {
    [Toast makeToastActivity:@"正在删除..." hasMusk:NO];
    
    NSString *idst = [NSString stringWithFormat:@"%@",[showDic objectForKey:@"id"]];
    [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"ReceiverDelete" params:@{@"ID":idst} success:^(NSDictionary *dict) {
        [Toast hideToastActivity];

        if ([dict[@"isSuccess"] integerValue] ==1) {
            if (_delegate && [_delegate respondsToSelector:@selector(callBackNewAddressViewControllerDelegateWithDeleteAddressByrow:)]) {
                [_delegate callBackNewAddressViewControllerDelegateWithDeleteAddressByrow:_row];
            }
            [self.navigationController popViewControllerAnimated:YES];
            [Toast makeToastSuccess:@"已删除"];
        }
        else
        {
            [Toast hideToastActivity];
            [Toast makeToast:@"删除失败"];
        }
        
    } failed:^(NSError *error) {
        
        [Toast hideToastActivity];
        [Toast makeToast:@"删除失败"];
        
    }];
}


//以下3个方法实现PickerView的数据初始化
//确定picker的轮子个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (isStreet)
    {
        return [streetArray count];
    }
    return [countriesArray count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    
    CGFloat componentWidth = UI_SCREEN_WIDTH; // 第一个组键的宽度
    
    return componentWidth;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel*myViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, UI_SCREEN_WIDTH, 30)] ;

    myViewLabel.textAlignment = NSTextAlignmentCenter;
    myViewLabel.text= countriesArray[row][@"name"];
//    myViewLabel.text=countriesArray[row][@"NAME"];
    if (isStreet)
    {
        myViewLabel.text= streetArray[row][@"name"];
    }
  
    myViewLabel.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
    
    myViewLabel.backgroundColor = [UIColor clearColor];
    myViewLabel.textColor=[UIColor blackColor];
    
    return myViewLabel;
    
}
//确定每个轮子的每一项显示什么内容
//#pragma mark 实现协议UIPickerViewDelegate方法
//-(NSString *)pickerView:(UIPickerView *)pickerView
//            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    return  countriesArray[row];
//}
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectRowTag = row;

}

- (IBAction)defaultButtonAction:(UIButton *)sender {
    self.defaultButton.selected = ![self.defaultButton isSelected];
    _swcDefault.on = self.defaultButton.selected;
    [self.headerView.btnOk setTitle:SaveString forState:UIControlStateNormal];
}

- (IBAction)backHome:(id)sender;
{
 [self.navigationController popViewControllerAnimated:YES];
}
-(void)changeArea
{
    return;
    
    [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"RegionFilter" params:@{@"type":@"2"} success:^(NSDictionary *dict) {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
        NSMutableDictionary *areaDic = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath]mutableCopy];
        NSString *isSuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
        NSMutableArray *requestList=[[NSMutableArray alloc]init];
        NSMutableArray *oneArray=[[NSMutableArray alloc]init];//省
        NSMutableArray *twoArray = [[NSMutableArray alloc]init];//市
        NSMutableArray *threearray = [[NSMutableArray alloc]init];//区
        
        NSMutableDictionary *quDic=[[NSMutableDictionary alloc]init];
        NSMutableDictionary *shengDic = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *waiDic = [[NSMutableDictionary alloc]init];//最外面一层
     
        if ([isSuccess isEqualToString:@"1"]) {
            requestList = [NSMutableArray arrayWithArray:dict[@"results"]];
            //        id  统一加1了
            //省
            for ( int k=0; k<[requestList count]; k++) {
                NSString *parenT_ID=[NSString stringWithFormat:@"%@",requestList[k][@"regioN_LEVEL"]];
                if([parenT_ID isEqualToString:@"2"])
                {
                    [oneArray addObject:requestList[k]];
                }
            }
            //市
            for ( int k =0; k<[requestList count]; k++) {
                NSString *parenT_ID=[NSString stringWithFormat:@"%@",requestList[k][@"regioN_LEVEL"]];
                if([parenT_ID isEqualToString:@"3"])
                {
                    [twoArray addObject:requestList[k]];
                }
            }
            //区
            for ( int k =0; k<[requestList count]; k++) {
                NSString *regioN_LEVEL=[NSString stringWithFormat:@"%@",requestList[k][@"regioN_LEVEL"]];
                if([regioN_LEVEL isEqualToString:@"4"])
                {
                    [threearray addObject:requestList[k]];
                }
            }
            //分别取出省市区  然欧  区根市相匹配
            /*
             "七台河市" =     (
             "新兴区",
             "桃山区",
             "茄子河区",
             "其它区县",
             "勃利县"
             );
             "万宁市" =     (
             "万宁市"
             );
             "三亚市" =     (
             "三亚市",
             "吉阳区",
             "崖州区",
             "天涯区",
             "海棠区"
             );
             
             */
            for(int k=0;k<[twoArray count];k++)
            {
                NSString *shiID=[NSString stringWithFormat:@"%@",twoArray[k][@"id"]];
                NSMutableArray *quArray=[[NSMutableArray alloc]init];
                
                for (int m=0; m<[threearray count];m++) {
                    
                    NSString *quID=[NSString stringWithFormat:@"%@",threearray[m][@"parenT_ID"]];
                    if ([shiID isEqualToString:quID]) {
                        [quArray addObject:threearray[m][@"name"]];
                    }
                }
                [quDic setObject:quArray forKey:[NSString stringWithFormat:@"%@",twoArray[k][@"name"]]];
            }
            //            NSLog(@"QUDIC--区根县匹配-%@",quDic);
            /*
             "云南省" =     {
             0 = "昆明市";
             1 = "曲靖市";
             10 = "保山市";
             11 = "德宏傣族景颇族自治州";
             12 = "丽江市";
             13 = "怒江傈僳族自治州";
             14 = "迪庆藏族自治州";
             15 = "临沧市";
             16 = "其它地区";
             17 = "蒙自市";
             2 = "玉溪市";
             3 = "昭通市";
             4 = "楚雄彝族自治州";
             5 = "红河哈尼族彝族自治州";
             6 = "文山壮族苗族自治州";
             7 = "普洱市";
             8 = "西双版纳傣族自治州";
             9 = "大理白族自治州";
             };
             "北京" =     {
             0 = "北京市";
             };
             "宁夏回族自治区" =     {
             0 = "银川市";
             1 = "石嘴山市";
             2 = "中卫市";
             3 = "吴忠市";
             4 = "固原市";
             5 = "其它地区";
             };
             
             */
            for(int k=0;k<[oneArray count];k++)
            {
                NSString *shiID=[NSString stringWithFormat:@"%@",oneArray[k][@"id"]];
                NSMutableArray *quArray=[[NSMutableArray alloc]init];
                
                for (int m=0; m<[twoArray count];m++) {
                    
                    NSString *quID=[NSString stringWithFormat:@"%@",twoArray[m][@"parenT_ID"]];
                    if ([shiID isEqualToString:quID]) {
                        [quArray addObject:twoArray[m][@"name"]];
                    }
                }
                
                
                NSMutableDictionary *keyDic=[[NSMutableDictionary alloc]init];
                
                for ( int j=0; j<[quArray count]; j++) {
                    
                    NSString *key = [NSString stringWithFormat:@"%d",j];
                    NSString *keyName=[NSString stringWithFormat:@"%@",quArray[j]];// 市的名字
                    NSArray *jutishiArray =quDic[keyName];
                    NSDictionary * kDic = @{keyName:jutishiArray};
                    [keyDic setObject:kDic forKey:key];
                }
                
                [shengDic setObject:keyDic forKey:[NSString stringWithFormat:@"%@",oneArray[k][@"name"]]];
                
                //            NSLog(@" -省根市匹配-%@",quArray);
                
            }
            //            NSLog(@"QUDIC--省根市匹配-%@",shengDic);
            
            /*
             ...waitDic...{
             0 = "北京";
             1 = "天津";
             10 = "浙江省";
             11 = "安徽省";
             12 = "福建省";
             13 = "江西省";
             14 = "山东省";
             */
            for (int j=0;j<[oneArray count];j++)
            {
                NSString *shiID=[NSString stringWithFormat:@"%@",oneArray[j][@"id"]];
                int showID=[shiID intValue]-2;
                [waiDic setObject:oneArray[j][@"name"] forKey:[NSString stringWithFormat:@"%d",showID]];
            }
            for (int k=0; k<[[waiDic allKeys] count]; k++) {
                NSString *key = [NSString stringWithFormat:@"%d",k];
                NSString *keyName=[NSString stringWithFormat:@"%@",waiDic[key]];//最外一层的value
                NSDictionary *jutishiDic = shengDic[keyName];
                NSDictionary * kDic = @{keyName:jutishiDic};
                
                [waiDic setObject:kDic forKey:key];
                
            }
            ///****************
            /* waiDic
             10 =     {
             "浙江省" =         {
             0 = "杭州市";
             1 = "宁波市";
             10 = "丽水市";
             11 = "其它地区";
             2 = "温州市";
             3 = "嘉兴市";
             4 = "湖州市";
             5 = "绍兴市";
             6 = "金华市";
             7 = "衢州市";
             8 = "舟山市";
             9 = "台州市";
             };
             };*/
            //            NSLog(@"wai整理后的 －－－－－%@－－-----",waiDic);
            areaDic = [waiDic copy];
            [areaDic writeToFile:plistPath atomically:YES];
            
            [self performSelector:@selector(hiddenToast) withObject:nil afterDelay:2.0];
            
        }
        
        
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
        
    }];
}
-(void)hiddenToast
{
     [Toast hideToastActivity];
}
@end
