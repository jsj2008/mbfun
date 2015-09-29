//
//  CommentInputView.m
//  Wefafa
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CommentInputView.h"
#import "Utils.h"
#import "Toast.h"
static const int SEND_BUTTON_WIDTH=60;
static const int Margin=8;

@implementation CommentInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)innerInit
{
//    self.backgroundColor=TITLE_BG;//[Utils HexColor:0xd0d0d0 Alpha:1.0];
    
    if (_btnSend==nil)
    {
        _btnSend=[UIButton buttonWithType:UIButtonTypeCustom];//Margin
        _btnSend.frame=CGRectMake(SCREEN_WIDTH-SEND_BUTTON_WIDTH-Margin-2,Margin-5, SEND_BUTTON_WIDTH+5, self.frame.size.height-2*3);//2*Margin
        _btnSend.backgroundColor=[Utils HexColor:0x000000 Alpha:1.0];
        _btnSend.titleLabel.font=[UIFont systemFontOfSize:16];
        _btnSend.layer.cornerRadius =3;
        _btnSend.layer.shadowRadius=1.0;
        
        [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        [_btnSend addTarget:self action:@selector(btnSendClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnSend];
        
        _txtField=[[UITextField alloc] initWithFrame:CGRectMake(Margin,Margin-2,SCREEN_WIDTH-_btnSend.frame.size.width-3*Margin, _btnSend.frame.size.height-5)];
        _txtField.placeholder=@"请输入内容";
        _txtField.font=[UIFont systemFontOfSize:12];
        _txtField.borderStyle = UITextBorderStyleRoundedRect;
        _txtField.backgroundColor=[UIColor whiteColor];
        _txtField.returnKeyType=UIReturnKeySend;
        _txtField.layer.cornerRadius=3;
        _txtField.delegate=self;
        _txtField.layer.shadowRadius=2.0;
        
        [self addSubview:_txtField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self btnSendClick:nil];
    return YES;
}

-(void)btnSendClick:(id)sender
{
    if (self.onSendButtonClick!=nil)
    {
        if (_txtField.text==nil||[Utils isEmptyOrNull:_txtField.text])
        {
            [Toast makeToast:@"评论内容不能为空" duration:0.1 position:@"center"];
        }
        else
        {
            [self.onSendButtonClick fire:self eventData:_txtField.text];
        }
    }
}

@end
