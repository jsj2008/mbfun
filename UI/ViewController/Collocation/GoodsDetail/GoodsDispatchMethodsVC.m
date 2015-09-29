//
//  GoodsDispatchMethodsVC.m
//  Wefafa
//
//  Created by Miaoz on 15/2/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "GoodsDispatchMethodsVC.h"
#import "Globle.h"
#import "NavigationTitleView.h"
#import "GoodsDispatchMethodCell.h"
@interface GoodsDispatchMethodsVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)  UITableView *tableView;

@property (strong, nonatomic)UIView *viewHead;
@property(nonatomic,strong)NSArray *disptchDatearray;
@property(nonatomic,strong)NSMutableArray *selectedArr;//二级列表是否展开状态
@end

@implementation GoodsDispatchMethodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  =  [UIColor whiteColor];
    if (_selectedArr == nil) {
        _selectedArr = [NSMutableArray new];
    }
    
    _disptchDatearray = @[@"工作日,双休日均可送货",
                   @"只有工作日送货",
                   @"只有双休日送货"];
    _viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 64)];
//    [self.view addSubview:_viewHead];
    
    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view.btnOk setTintColor:[UIColor redColor]];
    
    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:@selector(btnOkClick:) selectorMenu:nil];
    view.lbTitle.text=@"配送方式";
//    [self.viewHead addSubview:view];
    [self setupNavbar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _viewHead.frame.size.height, UI_SCREEN_WIDTH, 43*6) style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.separatorColor = [UIColor colorWithHexString:@"#e2e2e2"];
    //tableView.backgroundColor = [UIColor clearColor];
    
//    _tableView.separatorColor = [UIColor clearColor];
    
    _tableView.dataSource = self; //在self中响应UITableViewDataSource协议相关的接口
    
    _tableView.delegate = self;//在self中响应UITableViewDelegate协议相关的接口
//    _tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:_tableView];
    


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
    self.title=@"配送方式";
    
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
#pragma mark----tableViewDelegate
//返回几个表头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//每一个表头下返回几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}

//设置表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
    NSArray *titleArray = @[@"选择送货方式",@"选择送货时间"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 42)];
    view.backgroundColor=[UIColor whiteColor];
    //    view.backgroundColor = [UIColor colorWithHexString:@"#65cbcb"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, UI_SCREEN_WIDTH-20, 30)];
    titleLabel.text = titleArray[section];
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [view addSubview:titleLabel];
    
   
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-0.5, UI_SCREEN_WIDTH, 0.5)];
    lineImage.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    //    lineImage.image = [UIImage imageNamed:@"line.png"];
    [view addSubview:lineImage];

    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GoodsDispatchMethodCell" owner:nil options:nil];
    GoodsDispatchMethodCell *cell = [nib objectAtIndex:0];
    
    if (indexPath.section == 0) {
        cell.leftLab.text = @"快递运输";// icon_create_check@2x
        cell.rightImagView.image = [UIImage imageNamed:@"Unico/present_uncheck"];// Unico/unico_seleted_btn
    }else{// Unico/uncheck_zero
        
         cell.leftLab.text = _disptchDatearray[indexPath.row];
        
        if ([_selectStr isEqualToString:@"0"]&&indexPath.row==0) {
       
            cell.rightImagView.image = [UIImage imageNamed:@"Unico/present_uncheck"];//present_uncheck
        }
        
        if ([_selectStr isEqualToString:@"1"]&&indexPath.row==1) {
          
            cell.rightImagView.image = [UIImage imageNamed:@"Unico/present_uncheck"];
        }

        
        if ([_selectStr isEqualToString:@"2"]&&indexPath.row==2) {
          
            cell.rightImagView.image = [UIImage imageNamed:@"Unico/present_uncheck"];
        }
    }
    
    
   
    
    return cell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.section == 1) {
        if (_myblock) {
            _myblock([NSString stringWithFormat:@"%ld",(long)indexPath.row]);
        }
         [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

-(void)goodsDispatchMethodsVCSourceVoBlock:(GoodsDispatchMethodsVCSourceVoBlock) block{

    _myblock = block;
}

-(void)btnBackClick:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
