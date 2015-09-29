//
//  AddRessTableCell.h
//  Wefafa
//
//  Created by fafatime on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEventHandler.h"

@interface AddRessTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UIButton *btnDefaultAddr;

@property (assign, nonatomic) int row;
@property (strong, nonatomic) CommonEventHandler *btnModifyClickEvent;
- (IBAction)btnModifyClicked:(id)sender;

@end
