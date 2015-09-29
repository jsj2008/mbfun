//
//  ImcomeDetailsViewController.m
//  Designer
//
//  Created by Charles on 15/1/19.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "IncomeDetailsViewController.h"

@interface IncomeDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UITextField *dateTxtFld1;
@property (weak, nonatomic) IBOutlet UITextField *dateTxtFld2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell1;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell2;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell3;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell4;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell5;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell6;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell7;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell8;

@end

@implementation IncomeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的收益";
    self.dateTxtFld1.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"day"]];
    self.dateTxtFld2.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"day"]];
    self.dateTxtFld1.rightViewMode = UITextFieldViewModeAlways;
    self.dateTxtFld2.rightViewMode = UITextFieldViewModeAlways;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            return indexPath.section?_cell5:_cell1;
        }
            break;
        case 1:
        {
            return indexPath.section?_cell6:_cell2;
        }
            break;
        case 2:
        {
            return indexPath.section?_cell7:_cell3;
        }
            break;
        case 3:
        {
            return indexPath.section?_cell8:_cell4;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            return _cell1.bounds.size.height;
        }
            break;
        case 1:
        {
            return _cell2.bounds.size.height;
        }
            break;
        case 2:
        {
            return _cell3.bounds.size.height;
        }
            break;
        case 3:
        {
            return _cell4.bounds.size.height;
        }
            break;
        default:
            return 0.;
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
