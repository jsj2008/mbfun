//
//  MyOrderVC.h
//  Designer
//
//  Created by Juvid on 15/1/15.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "BasicTableVC.h"

@interface MyOrderVC : BasicTableVC
@property (weak, nonatomic) IBOutlet UIView *vieHead;
- (IBAction)PressStatus:(UIButton *)sender;

//选中订单状态
@property NSInteger orderStatus;
@end
