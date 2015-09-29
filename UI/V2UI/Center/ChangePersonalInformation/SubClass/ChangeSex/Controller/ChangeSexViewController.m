//
//  ChangeSexViewController.m
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ChangeSexViewController.h"
#import "ChangeSexTableViewCell.h"

@interface ChangeSexViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@end

static NSString *cellIdentifier = @"ChangeSexTableViewCellIdentifier";
@implementation ChangeSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"性别"];
    [self SetLeftButton:nil Image:@"u145"];
    self.contentTableView.dataSource = self;
    self.contentTableView.delegate = self;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self isSexWoman] inSection:0];
    [self.contentTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangeSexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ChangeSexTableViewCell alloc]init];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"  男";
    }else{
        cell.textLabel.text = @"  女";
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

@end
