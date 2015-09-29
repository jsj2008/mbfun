//
//  FilterBrandViewController.m
//  newdesigner
//
//  Created by Miaoz on 14/10/22.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "FilterBrandViewController.h"
#import "BrandTableCell.h"
#import "Globle.h"
#import "BrandMapping.h"
//废弃 不用 
@interface FilterBrandViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataarray;

@end

@implementation FilterBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        _dataarray = [NSMutableArray new];
 
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#e2e2e2"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //注册
    [self.tableView  registerClass:[BrandTableCell class] forCellReuseIdentifier:@"crandTableCell"];
    
       [self requestBrandFilter];
}

-(void)brandVCBlockWithBrandMapping:(BrandVCBlock) block{

    _myblock = block;
}

- (IBAction)leftBarButtonItemClickevent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestBrandFilter{
    [[HttpRequest shareRequst] httpRequestGetBrandFilterWithdic:nil success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dic in data)
                {
                    BrandMapping*brandMapping;
                    brandMapping=[JsonToModel objectFromDictionary:dic className:@"BrandMapping"];
                    [_dataarray addObject:brandMapping];
                }
                [self.tableView reloadData];
            }
        }
    } ail:^(NSString *errorMsg) {
        
    }];

}

-(void)dealloc{
    
    NSLog(@"FilterBrandViewController---dealloc");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//每个section显示的标题
/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 
 GoodPrimaryCategoryObj * Primaryobj = _dataarray[section];
 return Primaryobj.name;
 }
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
 // Return the number of sections.
 return _dataarray.count;
 }
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    // Return the number of rows in the section.
    return _dataarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"BrandTableCell" owner:nil options:nil];
    BrandTableCell *cell = [nib objectAtIndex:0];
   
    BrandMapping *brandMapping = _dataarray[indexPath.row];
   
    cell.brandMapping = brandMapping;
    
        NSString *brandid = [_dataDic objectForKey:@"BrandId"];
    if (brandid != nil) {
        if (brandMapping.id.intValue == brandid.intValue) {
            cell.checkImageView.hidden = NO;
        }
    }
    
    
    // Configure the cell...
  
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     BrandMapping *brandMapping = _dataarray[indexPath.row];
    if (_myblock) {
        _myblock(brandMapping);
    }
//    BrandTableCell *brandCell = (BrandTableCell *)[tableView cellForRowAtIndexPath:indexPath];
//    brandCell.checkImageView.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
