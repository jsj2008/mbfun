//
//  GeneralVCCell.h
//  Designer
//
//  Created by Juvid on 15/1/15.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralVCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labLeft;
@property (weak, nonatomic) IBOutlet UILabel *labRight;

-(void)OrderStatus:(NSInteger)orderStatus;//订单列表调用

-(void)SetLeftTitle:(NSInteger)orderStatus;//订单详情
@end
