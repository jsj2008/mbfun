//
//  AddressTableView.m
//  BanggoPhone
//
//  Created by issuser on 14-6-24.
//  Copyright (c) 2014年 BG. All rights reserved.
//  未做下拉刷新

#import "AddressTableView.h"
#import "AddressTableViewCell.h"
//#import "BGSever+Address.h"

//#import "MGetAddressList.h"
//#import "MGetAddressListlist.h"

@interface AddressTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listArray ;
}

@end

@implementation AddressTableView

static NSString *REUSE_ID_Cell = @"AddressTableViewCell";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.delegate = self;
    self.dataSource = self;
    
    
}

-(void)awakeFromNib
{
    [self registNib];
}

-(void)registNib
{
    UINib *CellNib = [UINib nibWithNibName:REUSE_ID_Cell bundle:nil];
    [self registerNib:CellNib forCellReuseIdentifier:REUSE_ID_Cell];
}

static CGFloat _s_unHeight = RAND_MAX;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_s_unHeight == RAND_MAX)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:REUSE_ID_Cell owner:nil options:nil];
        UITableViewCell *cell = [nib lastObject];
        _s_unHeight = [cell bounds].size.height;
    }
    return _s_unHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_Cell];
    if (!cell)
    {
        cell = [[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSE_ID_Cell];
    }
//    MGetAddressListlist *addressDetail = [listArray objectAtIndex:indexPath.row];
//    cell.names.text = addressDetail.consignee;
//    cell.phoneNumber.text = addressDetail.mobile;
//    cell.address.text = [NSString stringWithFormat:@"%@ %@",addressDetail.addString,addressDetail.address];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mDelegate&&[_mDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [_mDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


@end
