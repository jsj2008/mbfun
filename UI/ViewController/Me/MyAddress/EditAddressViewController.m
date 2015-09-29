//
//  EditAddressViewController.m
//  Wefafa
//
//  Created by fafatime on 14-9-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

// 废弃 不用 以前的请求国家省市区
#import "EditAddressViewController.h"
#import "NavigationTitleView.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
@interface EditAddressViewController ()
{
    NSMutableArray * requestList;
}
@end

@implementation EditAddressViewController
@synthesize nameStr;
@synthesize countryStr;
@synthesize cityStr;
@synthesize provinceStr;
@synthesize detailStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
//    UIView *tempView;
//    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    //    negativeSpacer.width = 0;
    //    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ion_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    self.title=nameStr;
    
//    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, navRect.size.height)];
//    
//    
//    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 200, navRect.size.height)];
//    [tempBtn setTitle:nameStr forState:UIControlStateNormal];
//    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
//    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    tempBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//    
//    [tempView addSubview:tempBtn];
//    
//    self.navigationItem.titleView = tempView;
    
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.current=-1;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
//    view.lbTitle.text=@"编辑地址";
    view.lbTitle.text = nameStr;
//    [self.headView addSubview:view];
    [self setupNavbar];
    
    [_editTableView setFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, _editTableView.frame.size.height)];
    [_detailCityTableView setFrame:CGRectMake(UI_SCREEN_WIDTH, 64, UI_SCREEN_WIDTH, _detailCityTableView.frame.size.height)];
    [_lastCityTableView setFrame:CGRectMake(UI_SCREEN_WIDTH*2, 64, UI_SCREEN_WIDTH, _lastCityTableView.frame.size.height)];
    
    _editTextField.delegate=self;
    _editTextField.text=self.detailStr;
    _editTextField.keyboardType = self.keyboardType;
    
    _detailCityTableView.hidden=YES;
    if ([self.nameStr isEqualToString:@"请输入收货人所在地"])
    {
        _editTableView.hidden=NO;
        _editTextField.hidden=YES;
        _doneBtn.hidden=YES;
        
        _editTableView.delegate=self;
        _editTableView.dataSource=self;
        _detailCityTableView.delegate=self;
        _detailCityTableView.dataSource=self;
        _lastCityTableView.delegate=self;
        _lastCityTableView.dataSource=self;
        
        NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
        requestList=[[NSMutableArray alloc]init];
        NSMutableString *returnMessage=[[NSMutableString alloc]init];
       NSString * MBShoppingGuideServerOther = @"RegionFilter";
        [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            if ([SHOPPING_GUIDE_ITF requestGetUrlName:MBShoppingGuideServerOther param:@{@"userId":userId,@"REGION_LEVEL":@2} responseList:requestList responseMsg:returnMessage])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Toast hideToastActivity];
                    if ([requestList count]==0)
                    {
                        
                    }
                    else
                    {
                        [_editTableView reloadData];
                        
                    }
                });

            }
            else
            {
                [Toast hideToastActivity];
                [Toast makeToast:@"加载失败" duration:2 position:@"center"];
                
            }

        });

    }
    else
    {
        _editTableView.hidden=YES;
        _editTextField.hidden=NO;
        _doneBtn.hidden=NO;
        
        _editTextField.placeholder = self.nameStr;
        [_editTextField becomeFirstResponder];
    }
    
    _editTableView.tableFooterView=[UIView new];
    _detailCityTableView.tableFooterView=[UIView new];
    _lastCityTableView.tableFooterView=[UIView new];

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
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((1[0-9]))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];

}

-(BOOL)validatePostcode:(NSString*)postcode
{
    NSString *phoneRegex = @"^[1-9]\\d{5}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    NSLog(@" phoneTest---%lu" ,(unsigned long)phoneRegex.length);
    
    if (phoneRegex.length>12)
    {
        return NO;
        
    }
    else
    {
         return [phoneTest evaluateWithObject:postcode];
    }

}


-(IBAction)doneBtn:(id)sender
{
    if([_editTextField.text isEqualToString:@"<null>"]||_editTextField.text==nil||[[_editTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""]||[_editTextField.text isEqualToString:@"(null)"]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"输入信息不能包含空格字符"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }

    BOOL isMatch;
    NSString *showMessage;
    BOOL isJudgement;
    
    if ([_editTextField.placeholder isEqualToString:@"请输入收货人手机号码"])
    {
        isJudgement = YES;
        isMatch = [self validateMobile:_editTextField.text];
        showMessage = [NSString stringWithFormat:@"请输入正确的手机号码"];
    }
    
    if ([_editTextField.placeholder isEqualToString:@"请输入收货人邮箱地址"])
    {
        isJudgement = YES;
        isMatch = [self validateEmail:_editTextField.text];
        showMessage = [NSString stringWithFormat:@"请输入正确的电子邮箱"];
    }
    
    if ([_editTextField.placeholder isEqualToString:@"请输入邮编"]) {
        
        isJudgement = YES;
        isMatch = [self validatePostcode:_editTextField.text];
        showMessage = [NSString stringWithFormat:@"请输入正确的六位邮编地址"];
    }
    

    if (showMessage) {
        if (!isMatch) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:showMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        else
        {
            if (_delegate!=nil && [_delegate respondsToSelector:@selector(userInfoValueChanged:)])
            {
                [_delegate userInfoValueChanged:[NSString stringWithFormat:@"%@",_editTextField.text]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
    
    else
    {
        if (_delegate!=nil && [_delegate respondsToSelector:@selector(userInfoValueChanged:)])
        {
            [_delegate userInfoValueChanged:[NSString stringWithFormat:@"%@",_editTextField.text]];
        }
        [self.navigationController popViewControllerAnimated:YES];

    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [requestList count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString *st = [NSString stringWithFormat:@"%@",[[requestList objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.textLabel.text=st ;

    if ([tableView isEqual:_editTableView])
    {
        if ([self.provinceStr isEqualToString:st])
        {
           cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    else if ([tableView isEqual:_detailCityTableView])
    {
        if ([self.cityStr isEqualToString:st])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        if ([self.countryStr isEqualToString:st])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
//    {
//        if (_current==indexPath.row)
//        {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else
//        {
//            if (k==0)//首次进来的时候显示
//            {
//                if ([self.cityStr isEqualToString:[[requestList objectAtIndex:indexPath.row] objectForKey:@"name"]])
//                {
//                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                    k=1;
//                    _current = indexPath.row;
//                }
//            }
//            else
//            {
//                
//                cell.accessoryType = UITableViewCellAccessoryNone;
//            }
//        }
//
//    }
//    else if ([tableView isEqual:_lastCityTableView])
//    {
//        if (_current==indexPath.row)
//        {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else
//        {
//            if (k==0)//首次进来的时候显示
//            {
//                if ([self.countryStr isEqualToString:[[requestList objectAtIndex:indexPath.row] objectForKey:@"name"]])
//                {
//                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                    k=1;
//                    _current = indexPath.row;
//                }
//            }
//            else
//            {
//                
//                cell.accessoryType = UITableViewCellAccessoryNone;
//            }
//        }
// 
//    }

 
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Toast hideToastActivity];
       NSMutableString *returnMessage=[[NSMutableString alloc]init];
    if ([tableView  isEqual:_lastCityTableView])
    {
        NSString *MBShoppingGuideServerOther =@"RegionFilter";
        NSString *parentid;
        
//        [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
        if ([requestList count]==0) {
//            [Toast hideToastActivity];
            return;
        }
       
        self.countryStr =[NSString stringWithFormat:@"%@",[[requestList objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        parentid=[[requestList objectAtIndex:indexPath.row] objectForKey:@"id"];
        [requestList removeAllObjects];
   
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
  
            if ([SHOPPING_GUIDE_ITF requestGetUrlName:MBShoppingGuideServerOther param:@{@"userId":sns.ldap_uid,@"Parent_ID":parentid,@"regioN_LEVEL":@5} responseList:requestList responseMsg:returnMessage])
            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [Toast hideToastActivity];
//                    if ([requestList count]==0)
//                    {
//                        
//                    }
//                    else
//                    {
//                        
//                    }
//                });
                   dispatch_async(dispatch_get_main_queue(), ^{
                       NSDictionary *dic = @{@"streetList":requestList};
                       [[NSNotificationCenter  defaultCenter] postNotificationName:@"changeStreet" object:nil userInfo:dic];
                       
                       if (_delegate!=nil && [_delegate respondsToSelector:@selector(userInfoValueChanged:)])
                       {
                           [_delegate userInfoValueChanged:[NSString stringWithFormat:@"%@ %@ %@",self.provinceStr,self.cityStr,self.countryStr]];
                       }
                       [self.navigationController popViewControllerAnimated:YES];
                     });
            }
            else
            {
//                [Toast hideToastActivity];
//                [Toast makeToast:@"加载失败" duration:2 position:@"center"];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (_delegate!=nil && [_delegate respondsToSelector:@selector(userInfoValueChanged:)])
                      {
                          [_delegate userInfoValueChanged:[NSString stringWithFormat:@"%@ %@ %@",self.provinceStr,self.cityStr,self.countryStr]];
                      }
                      [self.navigationController popViewControllerAnimated:YES];
                  });
            }
            
            
        });


  
        
    }
    else
    {
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3];
    
        if ([tableView isEqual:_editTableView])
        {
            self.provinceStr = [NSString stringWithFormat:@"%@",[[requestList objectAtIndex:indexPath.row] objectForKey:@"name"]];
            
            _detailCityTableView.hidden=NO;
            _editTableView.hidden=YES;
            [_detailCityTableView setFrame:_editTableView.frame];
            [_editTableView setFrame:CGRectMake(-_editTableView.frame.size.width, _editTableView.frame.origin.y, _editTableView.frame.size.width, _editTableView.frame.size.height)];
        }
        else if([tableView isEqual:_detailCityTableView])
        {
            self.cityStr = [NSString stringWithFormat:@"%@",[[requestList objectAtIndex:indexPath.row] objectForKey:@"name"]];
            _detailCityTableView.hidden=YES;
            _editTableView.hidden=YES;
            _lastCityTableView.hidden=NO;
            
            [_lastCityTableView setFrame:_detailCityTableView.frame];
            [_detailCityTableView setFrame:_editTableView.frame];
        }

        [UIView commitAnimations];
    
        NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
     
     
        NSString *MBShoppingGuideServerOther=[NSString stringWithFormat:@"http://10.100.20.180:8018/RegionFilter?format=json&Parent_ID=%@",[[requestList objectAtIndex:indexPath.row] objectForKey:@"id"]];
        MBShoppingGuideServerOther =@"RegionFilter";
        [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
        NSString *parentid=[[requestList objectAtIndex:indexPath.row] objectForKey:@"id"];
        [requestList removeAllObjects];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            if ([SHOPPING_GUIDE_ITF requestGetUrlName:MBShoppingGuideServerOther param:@{@"userId":userId,@"Parent_ID":parentid} responseList:requestList responseMsg:returnMessage])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Toast hideToastActivity];
                    if ([requestList count]==0)
                    {
                        //加载请求失败 要清除以前掉 city country
                        self.cityStr=@"";
                        self.countryStr=@"";
                        
                        if (_delegate!=nil && [_delegate respondsToSelector:@selector(userInfoValueChanged:)])
                        {
                            [_delegate userInfoValueChanged:[NSString stringWithFormat:@"%@ %@ %@",self.provinceStr,self.cityStr,self.countryStr]];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        if ([tableView isEqual:_editTableView])
                        {
                             [_detailCityTableView reloadData];
                        }
                        else if([tableView isEqual:_detailCityTableView])
                        {
                            [_lastCityTableView reloadData];
                        }
                        
                    }
                });
                
            }
            else
            {
                [Toast hideToastActivity];
                [Toast makeToast:@"加载失败" duration:2 position:@"center"];
                
            }
            
        });
    }
}
#pragma mark text delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField==self.txtFieldGroupName && range.location>20) {
//        return NO;
//    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location>500) {
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
//    if (textView==self.txtViewGroupDesc) {
//        [self.txtViewGroupDesc.placeholder setHidden:![@"" isEqualToString:textView.text]];
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


-(void)backHome:(UIButton*)sender
{
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
