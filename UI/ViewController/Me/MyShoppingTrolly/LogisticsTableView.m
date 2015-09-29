//
//  LogisticsTableView.m
//  Wefafa
//
//  Created by wave on 15/5/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "LogisticsTableView.h"
#import "LogisticsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommMBBusiness.h"
#import "OrderViewTableViewCell.h"
#import "SUtilityTool.h"

static NSString *cellID;
static NSString *cellID2;
@interface BrandHeadView : UIView
- (instancetype)initWithFrame:(CGRect)frame BrandName:(NSString*)name num:(NSString*)num logo:(NSString*)logo;
@end

@implementation BrandHeadView //height 65
- (instancetype)initWithFrame:(CGRect)frame BrandName:(NSString*)name num:(NSString*)num logo:(NSString*)logo {
    if (self == [super init]) {
      
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(17, 15, 40, 40)];
//        [imgView setImageWithURL:[NSURL URLWithString:[self str:logo]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        [imgView setImage:[UIImage imageNamed:logo]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
        NSArray *arraytext = @[[self str:name], [NSString stringWithFormat:@"运单编号:%@", [self str:num]]];
        for (int i = 0; i < 2; i++) {//imgView.right + 10
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, i * 30, 200, 30)];
            label.text = [self str:arraytext[i]];
            label.backgroundColor=[UIColor clearColor];
            label.font = FONT_t4;
            [self addSubview:label];
        }
        UIView *footBtnView=[[UIView alloc]initWithFrame:CGRectMake(0, 60, UI_SCREEN_WIDTH, 50)];
        [footBtnView setBackgroundColor:[UIColor whiteColor]];
        UILabel *titLabel=[[UILabel alloc]initWithFrame:CGRectMake(17, 0, UI_SCREEN_WIDTH-17, 50)];
        [titLabel setText:@"物流跟踪"];
        [titLabel setBackgroundColor:[UIColor clearColor]];
        [titLabel setFont:FONT_t4];
        [footBtnView addSubview:titLabel];
        [self addSubview:footBtnView];
    }
    return self;
}
- (NSString*)str:(NSString*)str {
    if (str.length != 0 && [str isKindOfClass:[NSString class]] && ![str isEqual:[NSNull null]]) {
        return str;
    }
    return @"";
}
@end

@interface LogisticsTableView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, setter=setContentDic:) NSDictionary *contentDic;
@end

@implementation LogisticsTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withDic:(NSDictionary *)dic {
    if (self == [super initWithFrame:frame style:style]) {
        self.contentDic = dic;
        self.delegate = self;
        self.dataSource = self;
        self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, .01f)];
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, .01f)];
    }
    return self;
}

- (void)setContentDic:(NSDictionary*)dic {
    if (_contentDic != dic) {
        _contentDic = [dic copy];
    }
    [self reloadData];
}

#pragma mark -
#pragma mark - UITableViewDataSoure, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (![[self.contentDic allKeys] containsObject:@"invoiceProdInfoList"]) {
            return 0;
        }
        return [self.contentDic[@"invoiceProdInfoList"] count];
//     return [self.contentDic[@"invoiceInfo"] count];
//        return 1;
    }
    
    return [self.contentDic[@"operationInfoList"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        cellID2 = [NSString stringWithFormat:@"%d", (int)indexPath.section];
        OrderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (cell == nil) {
            cell=[[OrderViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *array = [self.contentDic objectForKey:@"invoiceProdInfoList"];
        [cell updateCellContentWithDict:[array objectAtIndex:indexPath.row]];
//        [cell updateCellContentWithDict:self.contentDic[@"invoiceInfo"]];
        return cell;
    }else{
        cellID = [NSString stringWithFormat:@"%d", (int)indexPath.section];
        LogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LogisticsTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.stateName.text = [[self.contentDic[@"operationInfoList"] objectAtIndex:indexPath.row] objectForKey:@"context"];
        NSString *timeDate = [[self.contentDic[@"operationInfoList"] objectAtIndex:indexPath.row] objectForKey:@"time"];
//        cell.timeLabel.text=[CommMBBusiness getdate:timeDate];
        cell.timeLabel.text=[Utils getSNSString:timeDate];
        cell.topImgView.hidden=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        NSArray *array = [self.contentDic objectForKey:@"invoiceProdInfoList"];
        NSArray *array1 = [self.contentDic objectForKey:@"operationInfoList"];
        if (array.count == 0 && array1.count == 0) {
//            return nil;
        }

        NSString *name = [self.contentDic[@"invoiceInfo"] objectForKey:@"express_name"];
        NSString *num = [self.contentDic[@"invoiceInfo"] objectForKey:@"express_listno"];
//        NSString *logo = [self.contentDic[@"invoiceInfo"] objectForKey:@""];
        NSString *logo = @"Unico/logisticslog";
        
        BrandHeadView *headView = [[BrandHeadView alloc] initWithFrame:CGRectMake(0, 0, self.width, 110) BrandName:name num:num logo:logo];
        return headView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1)
        return 64;
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00000000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        __weak LogisticsTableView *weakself = self;
        self.clickCellBlock = ^{//回调产品详情
            weakself.contentDic[@"invoiceInfo"];
        };
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
