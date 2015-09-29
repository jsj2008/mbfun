//
//  MyStoreCell.h
//  Wefafa
//
//  Created by su on 15/1/26.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"
#import "UIUrlImageView.h"
#import "CommMBBusiness.h"
#import "AppSetting.h"

#define kMyStoreCollocationNotifyKey @"kMyStoreCollocationNotifyKey"

@interface MyStoreCell : UITableViewCell

- (void)updateCellWithLeftInfo:(CollocationDetail *)leftDict rightInfo:(CollocationDetail *)rigthDict;
@end
