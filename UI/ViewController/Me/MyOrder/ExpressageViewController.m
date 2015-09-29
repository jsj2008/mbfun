//
//  ExpressageViewController.m
//  Wefafa
//
//  Created by fafatime on 14-12-12.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "ExpressageViewController.h"
#import "Utils.h"
#import "NavigationTitleView.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
#import "OrderOtherTableViewCell.h"
#import "MBShoppingGuideInterface.h"
#import "SQLiteOper.h"
#import "OrderModel.h"
#import "SUtilityTool.h"
#import "HttpRequest.h"

@interface ExpressageViewController ()
{
    NSArray *sectionArray;
    NSArray *remarkArray;
    NSMutableArray *expressArray;
    UIPickerView *pickerView;
    UIView*toolView;
    NSIndexPath *indexPathTwo;
    int chooseRow;
    NSString *transCompany;
    NSString *numCode;
    NSString *fee;
    NSString *description;
    NSString *companyCode;
    
    
}
@end

@implementation ExpressageViewController
@synthesize goodsDic;
@synthesize returnDataDic;
@synthesize isReturn;
@synthesize goodsDicOrderModel;

//@synthesize returnID;
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
    
    CGRect headrect=CGRectMake(0,0,_headView.frame.size.width,_headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"退货信息";
//    [_headView addSubview:view];
    expressArray=[NSMutableArray new];
    NSMutableString *returnMsg=nil;
    self.view.backgroundColor=TABLEVIEW_BACKGROUND_COLOR;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    [self setupNavbar];
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50)];
    footView.backgroundColor=[Utils HexColor:0xf2f2f2 Alpha:1];
    UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 50)];
    showLabel.backgroundColor=[UIColor clearColor];
    showLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
    showLabel.text=@"客服电话: 400-821-9988 \n提示:请将发货清单放入包裹中一并退回!";
    showLabel.font=[UIFont systemFontOfSize:11.0f];
    showLabel.font=FONT_t6;
    showLabel.textAlignment=NSTextAlignmentCenter;
    showLabel.numberOfLines=2;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:showLabel.text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    
//    [paragraphStyle setLineSpacing:2];//调整行间距
//    
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [showLabel.text length])];
//    showLabel.attributedText = attributedString;
//  
//    showLabel.textAlignment=NSTextAlignmentCenter;
//    [showLabel sizeToFit];

    [footView addSubview:showLabel];
    
    _listTableView.tableFooterView=footView;
    UITapGestureRecognizer *tapS=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editShow)];
    _listTableView.userInteractionEnabled=YES;
    [_listTableView addGestureRecognizer:tapS];
    
    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(10, UI_SCREEN_HEIGHT-60, UI_SCREEN_WIDTH-20, 40)];
    [doneBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    doneBtn.layer.masksToBounds=YES;
    doneBtn.layer.cornerRadius=3;
    doneBtn.titleLabel.font=FONT_t1;
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(submitApplication) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.backgroundColor=[UIColor blackColor];
    [self.view addSubview:doneBtn];
    sectionArray = @[@"快递公司",@"快递单号",@"快递费用",@"快递说明"];
    remarkArray=@[@" ",@" ",@" ",@"可不填"];
       [self createTransPicker];
    [Toast makeToastActivity:@"正在加载,请稍后..." hasMusk:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"ExpressFilter" param:nil responseList:expressArray responseMsg:returnMsg]){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Toast hideToastActivity];
                [pickerView reloadAllComponents];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Toast hideToastActivity];
            });
        }

    });

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
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
   self.title=@"退货信息";
    

}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)createTransPicker
{
   toolView=[[UIView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-162-45, UI_SCREEN_WIDTH, 45)];
    toolView.hidden=YES;
    
    [toolView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1]];
    [self.view addSubview:toolView];
    UIButton *doneBar =[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBar setFrame:CGRectMake(toolView.frame.size.width-80, 0, 80, 44)];
    [doneBar setTitle:@"确定" forState:UIControlStateNormal];
    [doneBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBar addTarget:self
                action:@selector(doneBtn)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cacleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cacleBtn setFrame:CGRectMake(0, 0, 50, 44)];
    [cacleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cacleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cacleBtn addTarget:self
                 action:@selector(cacleBtn)
       forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:doneBar];
    [toolView addSubview:cacleBtn];
    UIImageView *lineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, toolView.frame.size.width, 1)];
    lineImgView.backgroundColor= TABLEVIEW_BACKGROUND_COLOR;
    [toolView addSubview:lineImgView];
    
    pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-162, UI_SCREEN_WIDTH, 162)];
    pickerView.hidden=YES;
    [pickerView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1]];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:pickerView];
    
}

- (void)submitApplication
{
    if (transCompany.length==0||transCompany==nil) {
        [Toast makeToast:@"请选择快递公司" duration:1.0 position:@"center"];
        return;
    }else if (numCode.length==0||numCode==nil){
        [Toast makeToast:@"请填写快递单号" duration:1.0 position:@"center"];
        return;
    }else if (fee.length==0||fee==nil){
        [Toast makeToast:@"请填写快递费用" duration:1.0 position:@"center"];
        return;
    }
    [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
//    SNSStaffFull *staff=[[SNSStaffFull alloc] init];
//    [sqlite getStaffFullByLdapUID:sns.ldap_uid stafffull:staff];
    NSMutableDictionary *responseAllDic=[NSMutableDictionary new];
    NSMutableString *returnMsg=nil;
//    NSString *nick_name=[NSString stringWithFormat:@"%@",staff.nick_name];
    NSString *desStr=[NSString stringWithFormat:@"%@",description];
    NSDate *date = [NSDate date];
    NSString *dateStr= [NSString stringWithFormat:@"%@",date];
    NSString *reapP_id;
    if ([[self.returnDataDic allKeys]containsObject:@"orderReturnInfo"])
    {
        reapP_id=[NSString stringWithFormat:@"%@",self.returnDataDic[@"orderReturnInfo"][@"id"]];
    }
    else
    {
        if(isReturn)
        {
            reapP_id=[NSString stringWithFormat:@"%@",self.goodsDic[@"detailInfo"][@"reapP_ID"]];
        }
        else
        {
            reapP_id = [NSString stringWithFormat:@"%@",self.goodsDicOrderModel.detailInfo.reapP_ID];// [@"detailInfo"][@"reapP_ID"]
        }
    }
    NSDictionary *paramDic=@{@"EXPRESS_NO":numCode,@"RETURN_ID":reapP_id,@"EXPRESS_ID":companyCode,@"expressname":transCompany,@"Fee":fee,@"return_desc":desStr,@"userid":sns.ldap_uid,@"return_time":dateStr};
    
    [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"ReturnRetailCreate" params:paramDic success:^(NSDictionary *dict) {
        if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Toast hideToastActivity];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"requestData" object:nil];
                NSDictionary *postDic=@{@"tag":@[@"0",@"3",@"4"]};
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeData" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenbtn" object:nil];
                
                
                [self backHome:nil];
            });

        }
    } failed:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Toast hideToastActivity];
            NSString *message=[NSString stringWithFormat:@"%@",[Utils getSNSString:[NSString stringWithFormat:@"%@",error]]];
            
            if(message.length==0)
            {
                if (returnMsg.length==0)
                {
                    [Utils alertMessage:@"提交失败"];
                }
                else
                {
                    [Utils alertMessage:returnMsg];
                }
            }
            else
            {
                [Utils alertMessage:message];
            }
            
        });

        
    }];

    /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([SHOPPING_GUIDE_ITF requestPostUrlName:@"ReturnRetailCreate" param:paramDic responseAll:responseAllDic responseMsg:returnMsg])
            {
                if ([[responseAllDic allKeys]containsObject:@"isSuccess"]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Toast hideToastActivity];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"requestData" object:nil];
                         NSDictionary *postDic=@{@"tag":@[@"0",@"3",@"4"]};
     
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeData" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenbtn" object:nil];
                        
                        
                        [self backHome:nil];
                    });
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Toast hideToastActivity];
                    NSString *message=[NSString stringWithFormat:@"%@",[Utils getSNSString:responseAllDic[@"message"]]];
                    
                    if(message.length==0)
                    {
                        if (returnMsg.length==0)
                        {
                            [Utils alertMessage:@"提交失败"];
                        }
                        else
                        {
                            [Utils alertMessage:returnMsg];
                        }
                    }
                    else
                    {
                        [Utils alertMessage:message];
                    }

                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
            });
        });
    */
}
- (void)editShow
{
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.view endEditing:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section>2) {
        return 120;
    }else{
        
        return 50;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [sectionArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 35)];
    sectionHeadView.backgroundColor=TABLEVIEW_BACKGROUND_COLOR;
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 35)];
    nameLabel.textColor=[UIColor blackColor];
    nameLabel.text=[NSString stringWithFormat:@"%@",[sectionArray objectAtIndex:section]];
    nameLabel.font=[UIFont systemFontOfSize:13.0f];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    nameLabel.font=FONT_t5;
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [sectionHeadView addSubview:nameLabel];
    CGSize max=CGSizeMake(300, nameLabel.frame.size.height);
    CGSize textSize=[nameLabel.text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:max lineBreakMode:NSLineBreakByCharWrapping];
    nameLabel.frame = CGRectMake(15, 0, textSize.width, nameLabel.frame.size.height);
    if (section>2){
    }
    else{
        UILabel *starLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.size.width+nameLabel.frame.origin.x+1, 10, 10, 10)];
        starLabel.text=@"*";
        starLabel.backgroundColor=[UIColor clearColor];
        starLabel.textAlignment=NSTextAlignmentLeft;
        starLabel.textColor=[Utils HexColor:0xfd5b5e Alpha:1];
        starLabel.font=FONT_t5;
        [sectionHeadView addSubview:starLabel];
    }
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+10, 0, 100,nameLabel.frame.size.height)];
    moreLabel.text=[NSString stringWithFormat:@"%@",remarkArray[section]];
    moreLabel.font=[UIFont systemFontOfSize:11.0f];
    moreLabel.font=FONT_t7;
    moreLabel.textColor= [Utils HexColor:0X999999 Alpha:1];
    moreLabel.backgroundColor=[UIColor clearColor];
    [sectionHeadView addSubview:moreLabel];
    
    return sectionHeadView;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    OrderOtherTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderOtherTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.writeTextView.textColor=[Utils HexColor:0X999999 Alpha:1];
    cell.writeTextView.font=FONT_t6;
    if (indexPath.section==0) {
        indexPathTwo = indexPath;
        cell.writeTextView.hidden=YES;
        cell.showTapLabel.hidden=NO;
        cell.showTapLabel.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapShow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTrans)];
        [cell.showTapLabel addGestureRecognizer:tapShow];
        
    }
    else{
        UITextView *cellTextView=cell.writeTextView;
        cellTextView.tag=indexPath.section;
        cellTextView.delegate=self;
    }

    return cell ;
}
-(void)textViewDidChange:(UITextView *)textView
{
    pickerView.hidden=YES;
    toolView.hidden=YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    UITextView *textV=textView;
    switch (textV.tag) {
        case 0:
        {
        }
            break;
        case 1:
        {
            numCode=[NSString stringWithFormat:@"%@",textV.text];
        }
            break;
        case 2:
        {
            fee=[NSString stringWithFormat:@"%@",textV.text];
        }
            break;
        case 3:
        {
            description=[NSString stringWithFormat:@"%@",textV.text];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)chooseTrans
{
    [self.view endEditing:YES];
    pickerView.hidden=NO;
    toolView.hidden=NO;
}
-(void)doneBtn
{
    pickerView.hidden=YES;
    toolView.hidden=YES;
    OrderOtherTableViewCell*cell=(OrderOtherTableViewCell *)[_listTableView cellForRowAtIndexPath:indexPathTwo];
    cell.showTapLabel.text =expressArray[chooseRow][@"name"];
    transCompany = [NSString stringWithFormat:@"%@",expressArray[chooseRow][@"name"]];
    companyCode =[NSString stringWithFormat:@"%@",expressArray[chooseRow][@"id"]];
}
-(void)cacleBtn
{
    pickerView.hidden=YES;
    toolView.hidden=YES;
}
#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;     //这个picker里的组键数
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [expressArray count];
}
#pragma mark -
#pragma mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, UI_SCREEN_WIDTH, 30)] ;
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
    myView.text=[NSString stringWithFormat:@"%@",expressArray[row][@"name"]];
    myView.backgroundColor = [UIColor clearColor];
    myView.textColor=[UIColor blackColor];
    return myView;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = UI_SCREEN_WIDTH; // 第一个组键的宽度
    return componentWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    OrderOtherTableViewCell*cell=(OrderOtherTableViewCell *)[_listTableView cellForRowAtIndexPath:indexPathTwo];
    cell.showTapLabel.text =expressArray[row][@"name"];
    chooseRow = (int)row;
    transCompany = [NSString stringWithFormat:@"%@",expressArray[chooseRow][@"name"]];
    companyCode =[NSString stringWithFormat:@"%@",expressArray[chooseRow][@"id"]];
}

- (void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
