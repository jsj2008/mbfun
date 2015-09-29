//
//  SActivityListTableViewCell.h
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SActivityListModel;
@class SMBNewActivityListModel;

@interface SActivityListTableViewCell : UITableViewCell

@property (nonatomic, strong) SMBNewActivityListModel *contentModel;

@end
