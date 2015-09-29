//
//  AlreadyBinDingBankCardTableView.m
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "AlreadyBinDingBankCardTableView.h"
#import "AlreadyBinDingBankCardTableViewCell.h"
#import "MyBankCardModel.h"
#import "SUtilityTool.h"

@interface AlreadyBinDingBankCardTableView ()<UITableViewDataSource, UITableViewDelegate, AlreadyBinDingBankCardTableViewCellDelegate>

@end

@implementation AlreadyBinDingBankCardTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.backgroundColor = COLOR_C4;
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"AlreadyBinDingBankCardTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifie];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
}

- (void)setMyBankCardModelArray:(NSArray *)myBankCardModelArray{
    _myBankCardModelArray = myBankCardModelArray;

    [self reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBankCardModel *model = self.myBankCardModelArray[indexPath.row];
    AlreadyBinDingBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifie forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myBankCardModel = model;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AlreadyBinDingBankCardTableViewCell *cell = (AlreadyBinDingBankCardTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell showBankImageOpen];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myBankCardModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - cellDelegate

- (void)alreadyDeleteCellWithMode:(MyBankCardModel *)model{
    [self.alreadyTableViewDelegate alreadyTableDeleteCellWithMode:model];
}

- (void)alreadySettingDefalutCell:(MyBankCardModel *)model{
    [self.alreadyTableViewDelegate alreadyTableSettingDefalutCell:model];
}

- (void)alreadyStartDrag{
    self.scrollEnabled = NO;
}
- (void)alreadyEndDrag{
    self.scrollEnabled = YES;
}

@end
