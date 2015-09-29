//
//  EditAddressVController.m
//  BanggoPhone
//
//  Created by Samuel on 14-7-13.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "EditAddressVController.h"
#import "Animations.h"

#import "AddressPicker.h"

static NSString *REUSE_ID_Cell = @"EditViewCell";

@interface EditAddressVController ()
{
    NSMutableArray *Provinces;
    NSMutableArray *Citys;
    NSMutableArray *Districts;
    
    int pickerControl;
    
    NSMutableArray *tableViewArray;
    
    UILabel *pickerViewLabel;
    AddressPicker *addressPicker;
}


@end

@implementation EditAddressVController

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
    self.title=@"编辑地址";
    self.tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initDatas];
    [self.setDefaultAddress setBackgroundColor:[UIColor clearColor]];
    [self.delectAddress setBackgroundColor:[UIColor clearColor]];
    
}
- (void)initDatas
{
    if (IOS7)
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    //展开pickerView
    pickerViewLabel = [[UILabel alloc]init];
    pickerViewLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    pickerViewLabel.textColor = [UIColor lightGrayColor];
    [self SetLeftButton:nil Image:nil];
    //右上角完成保存按钮
        UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 29)];
        saveButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveButton.titleLabel.font= [UIFont fontWithName:@"Arial" size:14.0];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
        self.navigationItem.rightBarButtonItem=saveItem;
    [saveButton addTarget:self action:@selector(saveAvtion:) forControlEvents:0];
    /*****************************判断调用页面到入口*****************************/
    if (self.isAddControl == YES)//添加新地址
    {
        self.title = @"输入新的收货地址";
    }
    /*****************************判断调用页面到入口*****************************/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangAddressCodes:)name:@"ChangAddressCodes"object:nil];
    pickerControl = 0;
    [self getAddressPickerZoneID:nil andTag:@"Provinces"];
//    if ([self.getAddressListlist.province isEqualToString:@""]||self.getAddressListlist.province == nil)
//    {
//        self.getAddressListlist.province = @"2";
//    }
//    if ([self.getAddressListlist.city isEqualToString:@""]||self.getAddressListlist.city == nil)
//    {
//        self.getAddressListlist.city = @"36";
//    }
//    [self getAddressPickerZoneID:self.getAddressListlist.province andTag:@"Citys"];
//    [self getAddressPickerZoneID:self.getAddressListlist.city andTag:@"Districts"];
//    if (self.getAddressListlist == nil)
//    {
//        self.getAddressListlist = [[MGetAddressListlist alloc]init];
//    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditCell"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *pName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 91, 44)];
        pName.font = [UIFont fontWithName:@"Arial" size:12.0];
        pName.textColor = [UIColor lightGrayColor];
        
        UITextField *pData = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 300, 43)];
        pData.returnKeyType = UIReturnKeyDone;
        pData.font = [UIFont fontWithName:@"Arial" size:12.0];
        pData.textColor = [UIColor lightGrayColor];
        pData.delegate = self;
        pData.tag = 554784+indexPath.row;
        
        pData.leftView = pName;
        pData.leftViewMode = UITextFieldViewModeAlways;
        pData.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(0, 43, 320, .5)];
        [lines setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:lines];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        switch (indexPath.row)
        {
            case 0:
            {
                pName.text = @"收货人";
                [pName setFrame:CGRectMake(10, pName.frame.origin.y, pName.frame.size.width, pName.frame.size.height)];
                [cell.contentView addSubview:pData];
                if (self.isAddControl == YES)return cell;
                else
                {
                    //用于填写数据
                }
                
                break;
            }
            case 1:
            {
                pName.text = @"手机号码";
                [cell.contentView addSubview:pData];
                pData.keyboardType = UIKeyboardTypeNumberPad;
                if (self.isAddControl == YES )return cell;
                else
                {
                    //用于填写数据
                }
                
                break;
            }
            case 2:
            {
                [pickerViewLabel setFrame:CGRectMake(pData.frame.origin.x+91, pData.frame.origin.y, pData.frame.size.width-91, pData.frame.size.height)];
                [cell.contentView addSubview:pickerViewLabel];
                
                UILabel *pNamex = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 91, 44)];
                pNamex.font = [UIFont fontWithName:@"Arial" size:12.0];
                pNamex.textColor = [UIColor lightGrayColor];
                pNamex.text = @"省、市、区";
                [cell.contentView addSubview:pNamex];
                if (self.isAddControl == YES)return cell;
                else
                {
                    //用于填写数据
                }
                
                break;
            }
            case 3:
            {
                pName.text = @"详细地址";
                [cell.contentView addSubview:pData];
                if (self.isAddControl == YES)return cell;
                else
                {
                    //用于填写数据
                }
                
                
                break;
            }
            case 4:
            {
                pName.text = @"邮政编码";
                [cell.contentView addSubview:pData];
                pData.keyboardType = UIKeyboardTypeNumberPad;
                if (self.isAddControl == YES)return cell;
                else
                {
                    //用于填写数据
                }
                
                break;
            }
            default:
                break;
        }
        
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        [self addressToPicker];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.view.frame.size.height <=480 && textField.tag == 554788)
    {
        [Animations moveUp:self.tableViews andAnimationDuration:0.2 andWait:NO andLength:150];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.view.frame.size.height <=480 && textField.tag == 554788)
    {
        [Animations moveDown:self.tableViews andAnimationDuration:0.2 andWait:NO andLength:150];
    }
    //存储填写数据
    long countes = textField.tag - 554784;
    switch (countes)
    {
        case 0:
//            self.getAddressListlist.consignee = textField.text;
            break;
        case 1:
//            self.getAddressListlist.mobile = textField.text;
            break;
        case 3:
//            self.getAddressListlist.address = textField.text;
            break;
        case 4:
//            self.getAddressListlist.zipcode = textField.text;
            break;
        default:
            break;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = nil;
    if (range.length == 0) {
        str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        
    }else if (range.length == 1){
        str = [textField.text substringToIndex:[textField.text length] - 1];
    }
    
    //存储填写数据
    long countes = textField.tag - 554784;
    switch (countes)
    {
        case 0:
//            self.getAddressListlist.consignee = str;
            break;
        case 1:
//            self.getAddressListlist.mobile = str;
            break;
        case 3:
//            self.getAddressListlist.address = str;
            break;
        case 4:
//            self.getAddressListlist.zipcode = str;
            break;
        default:
            break;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)getAddressPickerZoneID:(NSString*)zoneId andTag:(NSString*)tag
{
//    [BGSever getZoneListWithZoneID:zoneId
//                           success:^(id result)
//    {
//        MGetZoneList *getZoneList = result;
//        if ([tag isEqualToString:@"Provinces"])
//        {
//            Provinces = [[NSMutableArray alloc]initWithArray:getZoneList.list];
//        }
//        else if ([tag isEqualToString:@"Citys"])
//        {
//            Citys = [[NSMutableArray alloc]initWithArray:getZoneList.list];
//        }
//        else if([tag isEqualToString:@"Districts"])
//        {
//            Districts = [[NSMutableArray alloc]initWithArray:getZoneList.list];
//        }
//        pickerControl ++;
//    } failure:^(NSError *error)
//    {
//        
//    }];

}
- (void)ChangAddressCodes:(NSNotification*)objects
{
    NSMutableDictionary *getObj = objects.object;
    NSMutableArray *addressCodeArray = [getObj objectForKey:@"getAllData"];
    Citys = [getObj objectForKey:@"citylist"];
    Districts = [getObj objectForKey:@"districtslist"];
//    MGetZoneListlist *statex = [addressCodeArray objectAt:0];
//    MGetZoneListlist *cityx = [addressCodeArray objectAt:1];
//    MGetZoneListlist *areax = [addressCodeArray objectAt:2];
//    self.getAddressListlist.province = statex.regionId;
//    self.getAddressListlist.city = cityx.regionId;
//    self.getAddressListlist.district = areax.regionId;
//    pickerViewLabel.text = [NSString stringWithFormat:@"%@%@%@",statex.regionName,cityx.regionName,areax.regionName];
//    pickerViewBtn.titleLabel.textColor = kUIColorFromRGB(0x221e21);
}


-(void)RightReturn:(UIButton *)sender{
    [self.view endEditing:NO];

    [self upDataForDefaultAddress:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)canalSelfView
{
    if (self.isAddControl)
    {
        if (self.parentViewController.childViewControllers.count>1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if (self.presentingViewController)
            {
                [self dismissViewControllerAnimated:YES completion:^{
//                    [self.getCart clickBuyButton:nil];
                }];
            }
        }
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)addressToPicker
{
    [self.view endEditing:YES];
    
    int loadProvinceCount = 0;
    int loadCityCount = 0;
    int loadDistrictCount = 0;

    for (int i = 0 ; i < [Provinces count]; i ++)
    {
//        MGetZoneListlist *listlists = [Provinces objectAt:i];
//        if ([listlists.regionId isEqualToString:self.getAddressListlist.province])
//        {
//            loadProvinceCount = i;
//        }
    }
    for (int i = 0 ; i < [Citys count]; i ++)
    {
//        MGetZoneListlist *listlists = [Citys objectAt:i];
//        if ([listlists.regionId isEqualToString:self.getAddressListlist.city])
//        {
//            loadCityCount = i;
//        }
    }
    for (int i = 0 ; i < [Districts count]; i ++)
    {
//        MGetZoneListlist *listlists = [Districts objectAt:i];
//        if ([listlists.regionId isEqualToString:self.getAddressListlist.district])
//        {
//            loadDistrictCount = i;
//        }
    }
    if (addressPicker!=nil) {
        addressPicker=nil;
    }
    addressPicker = [[AddressPicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    addressPicker.provinces = Provinces;
    addressPicker.citys = Citys;
    addressPicker.districts = Districts;
    [self.view addSubview:addressPicker];
//    [Animations moveDown:addressPicker andAnimationDuration:0 andWait:NO andLength:addressPicker.pickerViews.frame.size.height];
    
    [addressPicker.pickerViews reloadComponent:0];
    [addressPicker.pickerViews reloadComponent:1];
    [addressPicker.pickerViews reloadComponent:2];

    [addressPicker.pickerViews selectRow:loadProvinceCount inComponent:0 animated:YES];
    [addressPicker.pickerViews selectRow:loadCityCount inComponent:1 animated:YES];
    [addressPicker.pickerViews selectRow:loadDistrictCount inComponent:2 animated:YES];
    [Animations moveUp:addressPicker andAnimationDuration:.3 andWait:NO andLength:568];
    [addressPicker.pickerViews selectRow:0 inComponent:2 animated:YES];
}
- (void)deleTapAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确定删除收货地址，此操作不可逆。"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确定"
                                  otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self ShowHUD:@""];
//        [BGSever delAddressWithAddressID:self.getAddressListlist.addressId
//                                 success:^(id result)
//         {
//             [self HideHUD];
////             [self canalSelfView];
//             [self.navigationController popViewControllerAnimated:YES];
//         } failure:^(NSError *error) {
//             ;
//         }];

    }
    
}
- (IBAction)setDefautAddress:(id)sender
{
    
}
- (void)upDataForDefaultAddress:(BOOL)isDefaults
{
    [self ShowHUD:@"加载中..."];
//    [BGSever updateAddressWithAddressId:self.getAddressListlist.addressId
//                            withAddress:self.getAddressListlist.address
//                         withProvinceId:self.getAddressListlist.province
//                             withCityId:self.getAddressListlist.city
//                         withDistrictId:self.getAddressListlist.district
//                          withCountryId:[NSString stringWithFormat:@"1"]
//                          withConsignee:self.getAddressListlist.consignee
//                          withIsdefault:Isdefaults
//                             withMobile:self.getAddressListlist.mobile
//                                withTel:nil
//                            withZipCode:self.getAddressListlist.zipcode
//                                success:^(id result)
//     {
//         
//         [self HideHUD];
//         NSDictionary *dic = (NSDictionary *)result;
//         if ([dic[@"rsc"] integerValue] == 1001)
//         {
//             [self canalSelfView];
//         }
//         else
//         {
//             [self showInfo:dic[@"msg"] autoHidden:YES];
//         }
//     } failure:^(NSError *error) {
//         ;
//     }];
}
- (IBAction)setDefaultAddress:(id)sender {
}

- (IBAction)delectAddress:(id)sender {
}
- (void)saveAvtion:(id)sender
{
    
}
@end
