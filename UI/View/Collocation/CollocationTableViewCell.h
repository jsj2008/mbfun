//
//  CollocationTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"
#import "ImageHeadListView.h"

@interface CollocationTableViewCell : UITableViewCell
{
    NSCondition *download_lock;
    ImageHeadListView *imageHeadScrollView;
    NSString *designerLoginAccount;
    int likeNum;
    int ReadNum;
    int commentNum;
    NSLock *requestLock;
}
@property (strong, nonatomic) IBOutlet UIUrlImageView *imageColl;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *lbDesigner;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) IBOutlet UIView *viewTop;
@property (strong, nonatomic) IBOutlet UILabel *lbCollocationName;
@property (strong, nonatomic) IBOutlet UIImageView *imgBottomLine;
@property (strong, nonatomic) IBOutlet UILabel *lbLikeNum;
@property (strong, nonatomic) IBOutlet UILabel *lbCommentNum;
@property (strong, nonatomic) IBOutlet UILabel *lbReadNum;
@property (strong, nonatomic) IBOutlet UIView *viewAttenListBackground;
@property (strong, nonatomic) IBOutlet UILabel *lbTime;
@property (strong, nonatomic) IBOutlet UIButton *btnLevel;
@property (strong, nonatomic) NSMutableArray *collocationLikeArray;


//approved = 1;
//"creatE_DATE" = "/Date(1407303823707-0000)/";
//"creatE_USER" = 1;
//description = "\U6d4b\U8bd5\U6570\U636e20140806014343";
//designerId = 1;
//id = 52;
//"lasT_MODIFIED_DATE" = "/Date(1407303823707-0000)/";
//"lasT_MODIFIED_USER" = 1;
//name = "\U590f\U5b63\U5927\U653e\U9001";
//pictureServerId = "//192.169.12.12/d$";
//pictureUrl = "sohu.com";
//status = 1;
//subjectKeyWord = 212;
//thrumbnailUrl = "sh.com";
@property (strong, nonatomic) NSDictionary *data;

-(void)setLikeHead:(NSString *)source_id;
@end
