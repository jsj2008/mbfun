//
//  ChangePersonalInformationTableViewCell.h
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChangePersonalInformationModel;

@interface ChangePersonalInformationTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, copy) void(^operation)();

@property (nonatomic, strong) ChangePersonalInformationModel *model;

@end
