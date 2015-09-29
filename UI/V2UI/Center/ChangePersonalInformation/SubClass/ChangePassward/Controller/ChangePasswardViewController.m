//
//  ChangePasswardViewController.m
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ChangePasswardViewController.h"
#import "ChangePasswardTableViewCell.h"

@interface ChangePasswardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@end

static NSString *cellIdentifier = @"ChangePasswardTableViewCellIdentifier";
@implementation ChangePasswardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"修改登陆密码"];
    [self setLeftButton:@"取消" target:self selector:@selector(navigationItemLeftItemAction:)];
    [self setRightButton:@"完成" target:self selector:@selector(navigationItemRightItemAction:)];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"ChangePasswardTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangePasswardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ChangePasswardTableViewCell alloc]init];
    }
    if (indexPath.row == 0) {
        cell.passwardTitleLabel.text = @"密码";
        cell.passwardField.placeholder = @"请输入密码";
    }else if(indexPath.row == 1){
        cell.passwardTitleLabel.text = @"确认密码";
        cell.passwardField.placeholder = @"请再次输入密码";
    }
    return cell;
}

- (void)navigationItemLeftItemAction:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)navigationItemRightItemAction:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
