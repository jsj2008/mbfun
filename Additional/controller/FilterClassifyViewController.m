//
//  FilterClassifyViewController.m
//  newdesigner
//
//  Created by Miaoz on 14/10/23.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "FilterClassifyViewController.h"
#import "ClassifyTableCell.h"
#import "Globle.h"
#import "GoodCategoryObj.h"
@interface FilterClassifyViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataarray;
@property(nonatomic,strong)NSMutableArray *selectedArr;//二级列表是否展开状态

@end

@implementation FilterClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    if (_selectedArr == nil) {
        _selectedArr = [NSMutableArray new];
    }

    if (_dataarray == nil) {
        _dataarray = [NSMutableArray new];
    }

    //注册
    [self.tableView  registerClass:[ClassifyTableCell class] forCellReuseIdentifier:@"ClassifyTableCell"];

}
-(void)classifyVCBlockWithGoodCategoryObj:(ClassifyVCBlock) block{
    _myblock = block;

}

- (IBAction)leftBarButtonItemClickevent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setMainGoodCategoryObj:(GoodCategoryObj *)mainGoodCategoryObj{
    _mainGoodCategoryObj = mainGoodCategoryObj;
    
    if (_mainGoodCategoryObj == nil) {
        return;
    }
    [self requestCategotyWithParentId:_mainGoodCategoryObj.id];
}



#pragma mark-商品类别请求
-(void)requestCategotyWithParentId:(NSString *)parentid
{
    [[HttpRequest shareRequst] httpRequestGetProductCategoryFilterWithDic:(NSMutableDictionary *)@{@"ParentId":parentid} success:^(id obj) {
        
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1) {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]]) {
                //遍历数组解析
                
                for (NSDictionary *dic in data) {
                    GoodCategoryObj *categoryObj;
                    categoryObj=[JsonToModel objectFromDictionary:dic className:@"GoodCategoryObj"];
                    [_dataarray addObject:categoryObj];
                }
            }
            [self.tableView reloadData];
        }
        
        
        
    } ail:^(NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
    }];
    
}
-(void)dealloc{
    
    NSLog(@"FilterClassifyViewController---dealloc");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark----tableViewDelegate
//返回几个表头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每一个表头下返回几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%d",section];
    
    if ([_selectedArr containsObject:string]) {
        return 0;
      
    }else{
    
        UIImageView *imageV = (UIImageView *)[_tableView viewWithTag:20000+section];
        imageV.image = [UIImage imageNamed:@"btn_pull-diwn_pressed"];
        
        
        return _dataarray.count;
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
    view.backgroundColor = [UIColor colorWithHexString:@"#65cbcb"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, tableView.frame.size.width-20, 30)];
    titleLabel.text = _mainGoodCategoryObj.name;
    [view addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    imageView.tag = 20000+section;
    
    //判断是不是选中状态
    NSString *string = [NSString stringWithFormat:@"%d",section];
    
    if ([_selectedArr containsObject:string]) {
        imageView.image = [UIImage imageNamed:@"btn_down_normal@3x"];//btn_pull-down_normal@3x
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"btn_down_pressed@3x"];//btn_pull-down_pressed@3x
    }
    [view addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 320, 40);
    button.tag = 100+section;
    [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 0.5)];
    lineImage.backgroundColor = [UIColor grayColor];
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
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ClassifyTableCell" owner:nil options:nil];
    ClassifyTableCell *cell = [nib objectAtIndex:0];
    GoodCategoryObj *secondCategoryObj = _dataarray[indexPath.row];
    cell.classifyLab.text = secondCategoryObj.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
     GoodCategoryObj *secondCategoryObj = _dataarray[indexPath.row];

    if (_myblock) {
                _myblock(secondCategoryObj);
            }
   
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doButton:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%d",sender.tag-100];
    
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([_selectedArr containsObject:string])
    {
        [_selectedArr removeObject:string];
    }
    else
    {
        [_selectedArr addObject:string];
    }
    
   
    [_tableView reloadData];
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
