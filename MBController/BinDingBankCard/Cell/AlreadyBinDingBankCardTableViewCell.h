//
//  AlreadyBinDingBankCardTableViewCell.h
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyBankCardModel;

@protocol AlreadyBinDingBankCardTableViewCellDelegate <NSObject>

- (void)alreadyDeleteCellWithMode:(MyBankCardModel*)model;
- (void)alreadySettingDefalutCell:(MyBankCardModel*)model;
- (void)alreadyStartDrag;
- (void)alreadyEndDrag;

@end

static NSString *cellIdentifie = @"AlreadyBinDingBankCardTableViewCellIdentifie";
@interface AlreadyBinDingBankCardTableViewCell : UITableViewCell

@property (nonatomic, assign) id<AlreadyBinDingBankCardTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardImgView;

@property (nonatomic, strong) MyBankCardModel *myBankCardModel;

- (void)showBankImageOpen;

@end
