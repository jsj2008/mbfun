//
//  AddressTableView.h
//  BanggoPhone
//
//  Created by issuser on 14-6-24.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableView : UITableView

@property(nonatomic,retain)NSArray *dataAry;

@property(nonatomic,assign)IBOutlet id<UITableViewDelegate> mDelegate;

@end
