//
//  MyAttentionOrFansCell.h
//  Wefafa
//
//  Created by fafatime on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSDataClass.h"
#import "UIUrlImageView.h"

typedef enum : NSUInteger {
    cellAttention = 0,
    cellFans
} CellType;

@interface MyAttentionOrFansCell : UITableViewCell<UIAlertViewDelegate>
{
    NSCondition *download_lock;

}

@property (weak, nonatomic) IBOutlet UIUrlImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *collocationFansLb;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *showAttenImg;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UIButton *attenShowBtn;

- (IBAction)attentionBtnClick:(id)sender;

//@property (assign, nonatomic) BOOL hasAtten;
@property (strong, nonatomic) SNSMicroAccount *ma;

@property (nonatomic,retain)SNSStaff *snsStaff;

@property (weak, nonatomic) IBOutlet UIImageView *showLineImgView;
@property (nonatomic,retain) NSDictionary *attendDic;
@property (nonatomic, assign) CellType cellType;

@end
