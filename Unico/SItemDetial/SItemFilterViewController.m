//
//  SItemFilterViewController.m
//  Wefafa
//
//  Created by unico on 15/5/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SItemFilterViewController.h"
#import "SItemFilterCell.h"
#import "SUtilityTool.h"
#import "HttpRequest.h"
#import "FilterPirceRangeModel.h"
#import "FilterBrandCategoryModel.h"
#import "FilterColorCategoryModel.h"

@interface SItemFilterViewController ()
{
    //滚动时加载
    BOOL scrollLoading;
}

@property (nonatomic, strong) NSArray *pirceRangeModelArray;
@property (nonatomic, strong) NSArray *colorModelArray;
@property (nonatomic, strong) NSArray *brandModelArray;

@end

@implementation SItemFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // TODO: 判断登陆状态，如果没有登录，显示登录界面。
    //测试
    self.list = @[@"1",@"2",@"3",@"4"];
    UIButton *tempBtn = [SUTILITY_TOOL_INSTANCE createTitleButtonAction:@"完成" bgColor:UIColorFromRGB(0xfedc32) fontColor:nil fontStyle:FONT_SIZE(15) rect:CGRectMake(UI_SCREEN_WIDTH/2-160/2/2, UI_SCREEN_HEIGHT-70/2-40/2, 160/2, 70/2) target:self action:@selector(onFinish:)];
    [self.view addSubview:tempBtn];
    [self requestData];
    
}

- (void)requestData{
    [self requestPirceRange];
    [self requestColorCategory];
    [self requestBrandCategory];
}

- (void)requestPirceRange{
    __unsafe_unretained typeof(self) p = self;
    
    [HttpRequest productPostRequestPath:@"Product" methodName:@"BasePriceFilter" params:nil success:^(NSDictionary *dict) {
        p.pirceRangeModelArray = [FilterPirceRangeModel modelArrayForDataArray:dict[@"results"]];
    } failed:^(NSError *error) {
        NSLog(@"价格区间请求错误");
    }];
    return;
    
//    [HttpRequest productGetRequestPath:nil methodName:@"BasePriceFilter" params:nil success:^(NSDictionary *dict) {
//        p.pirceRangeModelArray = [FilterPirceRangeModel modelArrayForDataArray:dict[@"results"]];
//    } failed:^(NSError *error) {
//        NSLog(@"价格区间请求错误");
//    }];
}

- (void)requestColorCategory{
    __unsafe_unretained typeof(self) p = self;
    

    [HttpRequest productPostRequestPath:@"Product" methodName:@"BaseColorFilter" params:nil success:^(NSDictionary *dict) {
      
        p.colorModelArray = [FilterColorCategoryModel modelArrayForDataArray:dict[@"results"]];
        
    } failed:^(NSError *error) {
        
    }];
    return;
    
    
//    [HttpRequest productGetRequestPath:nil methodName:@"BaseColorFilter" params:nil success:^(NSDictionary *dict) {
//        p.colorModelArray = [FilterColorCategoryModel modelArrayForDataArray:dict[@"results"]];
//    } failed:^(NSError *error) {
//        
//    }];
}

- (void)requestBrandCategory{
    __unsafe_unretained typeof(self) p = self;
    [HttpRequest productPostRequestPath:@"Product" methodName:@"BrandFilter" params:@{@"pageIndex": @1, @"pageSize": @20} success:^(NSDictionary *dict) {
        p.brandModelArray = [FilterBrandCategoryModel modelArrayForDataArray:dict[@"results"]];
    } failed:^(NSError *error) {
        
    }];
//    [HttpRequest productGetRequestPath:nil methodName:@"BrandFilter" params:@{@"pageIndex": @1, @"pageSize": @20} success:^(NSDictionary *dict) {
//        p.brandModelArray = [FilterBrandCategoryModel modelArrayForDataArray:dict[@"results"]];
//    } failed:^(NSError *error) {
//        
//    }];
}


- (void)setPirceRangeModelArray:(NSArray *)pirceRangeModelArray{
    _pirceRangeModelArray = pirceRangeModelArray;
    [self.tableView reloadData];
}

- (void)setBrandModelArray:(NSArray *)brandModelArray{
    _brandModelArray = brandModelArray;
    [self.tableView reloadData];
}

- (void)setColorModelArray:(NSArray *)colorModelArray{
    _colorModelArray = colorModelArray;
    [self.tableView reloadData];
}

-(void)onFinish:(id)selector{
    NSLog(@"finish");
}

- (void)setupNavbar {
    [super setupNavbar];
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    
    // 这里可以试试 UIBarButtonItem的customView来处理2个btn
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10;// TODO 负数无效这里
    UIBarButtonItem *right1 =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_filter"] style:UIBarButtonItemStylePlain target:self action:@selector(onFilter:)];
    
    self.navigationItem.rightBarButtonItems = @[right1] ;
    //tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    
    //白底
    tempView = [SUTILITY_TOOL_INSTANCE createUIViewByHeightAndWidth:navRect.size.height - 22/2  width:UI_SCREEN_WIDTH-110 coordY:0];
    tempView.backgroundColor = COLOR_WHITE;
    
    UILabel *tempLable = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"黑色" fontStyle:FONT_SIZE(18) color:[UIColor whiteColor] rect:CGRectMake(10/2, 0, 0, 48/2) isFitWidth:YES isAlignLeft:YES];
    UIView *tempView2 = [SUTILITY_TOOL_INSTANCE createUIViewByHeightAndWidth:tempLable.height width:tempLable.width+30 coordY:tempView.height/2 -tempLable.height/2];
    [tempView2 setOrigin:CGPointMake(10/2, tempView2.frame.origin.y)];
    tempView2.backgroundColor = UIColorFromRGB(0xc4c4c4);
    [tempView2 addSubview:tempLable];
    [tempView addSubview:tempView2];
    
    self.navigationItem.titleView = tempView;
    
}

-(void)onBack:(id)sender{
    NSLog(@"返回");
    [self popAnimated:YES];
}

-(void)onTitleTap:(id)sender{
    
}

-(void)onFilter:(id)sender{
    NSLog(@"过滤");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasourceDelegate

#pragma mark - UITableViewDatasourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.pirceRangeModelArray.count;
            break;
        case 1:
            return self.colorModelArray.count;
            break;
        case 2:
            return self.brandModelArray.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SItemFilterCell";
    SItemFilterCell *cell = (SItemFilterCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SItemFilterCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    self.cellNowHeight = cell.cellHeight;
    return cell;
}


@end
