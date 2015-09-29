//
//  SMineTableViewCell.h
//  Wefafa
//
//  Created by wave on 15/5/22.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//  

#import <UIKit/UIKit.h>
@class MBOtherUserInfoModel, SMineTableViewCell;

typedef enum : NSUInteger {
    cellAttention = 0,
    cellFans
} CellType;

typedef NS_OPTIONS(NSInteger, SMineTableViewCellClickType) {
    SMineTableViewCellDiscardConcerning,    //取消关注
    SMineTableViewCellAddConcerning,        //添加关注
    SMineTableViewCellDiscardFans,    //取消粉丝
    SMineTableViewCellAddFans,        //添加粉丝
};

@protocol SMineTableViewCellDelegate <NSObject>

@optional
- (void)SMineTableViewCell:(SMineTableViewCell*)cell didclickedWithDic:(NSDictionary*)contenDic method:(SMineTableViewCellClickType)clicktype;
- (void)mineTableViewCell:(UITableViewCell*)cell attentionButtonAction:(UIButton*)sender;
- (void)mineTableConetntModel:(MBOtherUserInfoModel*)model attentionButtonAction:(UIButton*)sender;

@end

@interface SMineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *AccessoryBtn;
@property (strong,nonatomic) UIImageView *vipImgView;

@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;


@property (nonatomic, assign) id<SMineTableViewCellDelegate> delegate;
/**
 *  cell类型 require
 */
@property (nonatomic, assign) CellType celltype;
/**
 *  cell数据 optional
 */
@property (nonatomic, strong) NSDictionary *contentDic;
@property (nonatomic, strong) MBOtherUserInfoModel *contentModel;

- (IBAction)accessoryBtnClicked:(id)sender;

@property (nonatomic ,strong, setter=setdic:) NSDictionary *dic;
@end
