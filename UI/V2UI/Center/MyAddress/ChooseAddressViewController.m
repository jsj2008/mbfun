//
//  ChooseAddressViewController.m
//  Designer
//
//  Created by Samuel on 1/19/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ChooseAddressViewController.h"
#import "Animations.h"
#import "AddressViewController.h"
#import "AddressTableViewCell.h"
static NSString *REUSE_ID_Cell = @"AddressTableViewCell";
@interface ChooseAddressViewController (){
    NSMutableArray *listArray ;
    NSIndexPath *pickIndex;
    NSIndexPath *startIndex;
    
    UIView *shadowView;
    
}
@end
@implementation ChooseAddressViewController


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
    }
    else if (buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)getRequestDataStart:(int)start andEnd:(int)end
{
    [self ShowHideHUD:@"正在加载数据..."];
    //test
    //    if (listArray.count==0||listArray == nil) {
    //        shadowView = [[UIView alloc]initWithFrame:self.view.bounds];
    //        [shadowView setBackgroundColor:[UIColor whiteColor]];
    //        UIButton *buttons = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [buttons setFrame:CGRectMake(100, 200, 200, 100)];
    //        [buttons setBackgroundColor:[UIColor orangeColor]];
    //        [buttons addTarget:self action:@selector(creatNewAddress:) forControlEvents:0];
    //        [shadowView addSubview:buttons];
    //        [self.view addSubview:shadowView];
    //        [Animations fadeOut:shadowView andAnimationDuration:0 andWait:NO];
    //        [Animations fadeIn:shadowView andAnimationDuration:.3 andWait:YES];
    //    }
    for (int i=0; i<10; i++) {
        [listArray addObject:@""];
    }
    [self.tableViews reloadData];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"配送地址";
    listArray = [[NSMutableArray alloc]init];
    pickIndex = [NSIndexPath indexPathForRow:9898 inSection:9898];
    self.tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getEditAddress:)name:@"EditButtonAction"object:nil];
    [self SetLeftButton:nil Image:nil];

    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 29)];
    saveButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font= [UIFont fontWithName:@"Arial" size:14.0];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem=saveItem;
    [saveButton addTarget:self action:@selector(changeAdd:) forControlEvents:0];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self getRequestDataStart:1 andEnd:20];
}
static CGFloat _s_unHeight = RAND_MAX;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_s_unHeight == RAND_MAX)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:REUSE_ID_Cell owner:nil options:nil];
        UITableViewCell *cell = [nib lastObject];
        _s_unHeight = [cell bounds].size.height;
    }
    return _s_unHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"AddressTableViewCell"];
    UINib *nib = [UINib nibWithNibName:@"AddressTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.indexPath = indexPath;
    [cell.changesImag setHidden:YES];
    UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(0, 79, 320, .5)];
    [lines setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:lines];
    //test
    cell.names.text = @"names";
    cell.names.font = [UIFont fontWithName:@"Arial-Bold" size:13.0];
    cell.phoneNumber.text = @"13822288888";
    cell.phoneNumber.font = [UIFont fontWithName:@"Arial-Bold" size:13.0];
    cell.tag = indexPath.row + 54647;
    BOOL orS = YES;//is default address
    NSString *testAddress = @"中国上海浦东新区康桥东路700号";
    NSString *getAddString = [testAddress stringByReplacingOccurrencesOfString:@"中国" withString:@""];
    if (orS)
    {
        UILabel *defaultsStr = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, cell.address.frame.size.height)];
        NSString *defaultStr = [NSString stringWithFormat:@"[默认] %@ %@",getAddString,testAddress];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:defaultStr];
        NSRange range=[defaultStr rangeOfString:@"[默认]"];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
        cell.address.attributedText=string;
        [cell.address addSubview:defaultsStr];
        cell.address.font = [UIFont fontWithName:@"Arial" size:12.0];
        pickIndex = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        //先是默认地址的选择
        [cell.changesImag setBackgroundImage:[UIImage imageNamed:@"icon_profile_checkmark"] forState:0];
        cell.changesImag.userInteractionEnabled = NO;
        [cell.changesImag setHidden:NO];
        return cell;
    }
    cell.address.text = [NSString stringWithFormat:@"%@ %@",getAddString,testAddress];
    cell.address.font = [UIFont fontWithName:@"Arial" size:12.0];
    if (indexPath.row == 0)
    {
        startIndex = indexPath;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)getEditAddress:(id)gets
{
    [self getRequestDataStart:1 andEnd:10];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)chooseAddress:(NSIndexPath*)indexPath
{
    if (indexPath.row == pickIndex.row){
        //        用于显示的对象传入
        //        editAddressVController.toShowData = ???
    }
    
}
- (void)changeAdd:(id)sender
{
    AddressViewController *views = [[AddressViewController alloc]init];
    [self.navigationController pushViewController:views animated:YES];
}

@end
