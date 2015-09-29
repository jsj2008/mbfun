//
//  PersonalInformationContentListTableView.m
//  Designer
//
//  Created by Jiang on 1/15/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "PersonalInformationContentListTableView.h"
#import "PersonalInformationContentListTableViewCell.h"

@interface PersonalInformationContentListTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

static NSString *cellIdentifier = @"personalInformationContentListTableViewCellIdentifier";
@implementation PersonalInformationContentListTableView

- (void)awakeFromNib{
    self.dataSource = self;
    self.delegate = self;
    [self setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self registerNib:[UINib nibWithNibName:@"PersonalInformationContentListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalInformationContentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

@end
