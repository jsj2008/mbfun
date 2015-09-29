//
//  ChangePersonalInformationTableView.m
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ChangePersonalInformationTableView.h"
#import "ChangePersonalInformationTableViewCell.h"
#import "ChangePersonalInformationModel.h"

@interface ChangePersonalInformationTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

static NSString *cellIdentifier = @"ChangePersonalInformationTableViewCellIdentifier";
@implementation ChangePersonalInformationTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.dataSource = self;
    self.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.modelArray[section];
    return array.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangePersonalInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ChangePersonalInformationTableViewCell alloc]init];
    }
    ChangePersonalInformationModel *model = self.modelArray[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}


@end
