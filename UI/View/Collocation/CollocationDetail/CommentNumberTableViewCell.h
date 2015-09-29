//
//  CommentNumberTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-11-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "UrlImageTableViewCell.h"
#import "WeFaFaGet.h"
#import "CommonEventHandler.h"

@interface CommentNumberTableViewCell : UrlImageTableViewCell
{
    UIImageView *imageSeparator;
    UIImageView *imageComment;
    UIButton *btnMoreComment;
    NSString *collocationID;
    UIControl *currentEditControl;
//    NSString *_data;                      //不知道这个字段是用来干什么的？
    NSDictionary *_data;
}

@property (strong, nonatomic) UILabel *lbCommentNum;
@property (strong, nonatomic) UILabel *lbStyle;

@property (strong, nonatomic) CommonEventHandler *onShowCommentList;
+(int)getCellHeight:(id)data1;

@end
