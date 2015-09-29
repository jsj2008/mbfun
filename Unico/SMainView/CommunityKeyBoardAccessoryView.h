//
//  CommunityKeyBoardAccessoryView.h
//  Wefafa
//  快速评论键盘
//  Created by wave on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMDataModel;
typedef void (^sendCommentBlock)(SMDataModel*model);

@interface CommunityKeyBoardAccessoryView : UIView
@property (nonatomic, strong) UITextField *textView;
@property (nonatomic, strong) UIWindow *modelView;

@property (nonatomic, strong) sendCommentBlock block;

@property (nonatomic, strong) SMDataModel *model; //对象model
//@property (nonatomic, strong) NSIndexPath *indexPath;   //对象cell indexPath
+ (CommunityKeyBoardAccessoryView*)instance;
@end
