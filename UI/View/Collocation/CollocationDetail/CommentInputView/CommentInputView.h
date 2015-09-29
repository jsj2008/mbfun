//
//  CommentInputView.h
//  Wefafa
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEventHandler.h"

@interface CommentInputView : UIView<UITextFieldDelegate>

@property (retain, nonatomic) UITextField *txtField;
@property (retain, nonatomic) UIButton *btnSend;

@property(nonatomic,retain) CommonEventHandler *onSendButtonClick;

@end
