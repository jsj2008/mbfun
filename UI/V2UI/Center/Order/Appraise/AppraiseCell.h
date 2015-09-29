//
//  AppraiseCell.h
//  BanggoPhone
//
//  Created by Juvid on 14-7-14.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppraiseCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgGoods;
@property (weak, nonatomic) IBOutlet UILabel *labName;
//@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UITextField *txtAppraise;

@end
