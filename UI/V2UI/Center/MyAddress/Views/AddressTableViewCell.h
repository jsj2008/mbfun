//
//  AddressTableViewCell.h
//  BanggoPhone
//
//  Created by issuser on 14-6-24.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressViewController.h"
@interface AddressTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *names;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *address;

- (IBAction)changes:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changesImag;

@property (strong ,nonatomic)AddressViewController *addressObject;

@property (strong,nonatomic)NSIndexPath *indexPath;
@end
