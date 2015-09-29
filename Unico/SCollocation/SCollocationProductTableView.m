//
//  SCollocationProductTableView.m
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationProductTableView.h"
#import "SCollocationShowBuyNowView.h"
#import "SCollocationDetailModel.h"
#import "LNGood.h"
#import "SCollocationProductCell.h"
#import "SUtilityTool.h"
#import "SProductDetailViewController.h"
#import "MBGoodsDetailsModel.h"

@interface SCollocationProductTableView () <UITableViewDataSource, UITableViewDelegate> 

@end

static NSString *cellIdentifier = @"SCollocationProductCellIdentifier";
@implementation SCollocationProductTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    [self registerNib:[UINib nibWithNibName:@"SCollocationProductCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.delegate = self;
    self.dataSource = self;
    self.separatorInset = UIEdgeInsetsMake(0, 75, 0, 0);
    
    self.tableHeaderView = [self createHeaderView];
    self.tableFooterView = [[SCollocationShowBuyNowView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 90)];
    self.scrollEnabled = NO;
}

- (UIView *)createHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 40)];
    label.text = @"搭配详情";
    label.textColor = COLOR_C2;
    label.font = FONT_t5;
    [view addSubview:label];
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = COLOR_C7.CGColor;
    layer.zPosition = 5;
    layer.frame = CGRectMake(75, 39.5, UI_SCREEN_WIDTH - 75, 0.5);
    [view.layer addSublayer:layer];
    return view;
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    if([self.tableFooterView respondsToSelector:@selector(setContentModel:)]){
        [self.tableFooterView setValue:contentModel forKey:@"contentModel"];
    }
    self.contentArray = contentModel.productArray;
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    if([self.tableFooterView respondsToSelector:@selector(setTarget:)]){
        [self.tableFooterView setValue:target forKey:@"target"];
    }
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    CGRect frame = self.frame;
    if (contentArray.count > 0) {
        frame.size.height = 124 + contentArray.count * 60;
        [self reloadData];
    }else{
        frame.size.height = 0;
    }
    self.frame = frame;
}

#pragma mark delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCollocationProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentModel = _contentArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBGoodsDetailsModel *model = _contentArray[indexPath.row];
    SProductDetailViewController *controller = [[SProductDetailViewController alloc]init];
    controller.productID = [NSString stringWithFormat:@"%@",model.clsInfo.code];
    [_target.navigationController pushViewController:controller animated:YES];
}

@end
