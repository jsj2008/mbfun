//
//  ShareTopView.m
//  Wefafa
//
//  Created by Miaoz on 14/12/1.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "ShareTopView.h"
#import "ShareCellView.h"
#import "Globle.h"
#define fixedWidth 30
@implementation ShareTopView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        //        self.opaque = YES;
        
        // 单击的 Recognizer
        self.backgroundColor = [UIColor whiteColor];
        [self createImageView];
        
}
    return self;
}

-(void)createImageView{
    UIImageView *imageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 45, 45)];
    imageVIew.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
//    imageVIew.backgroundColor = [UIColor yellowColor];
    _mainShowImage = imageVIew;
    [self addSubview:imageVIew];
    
    UILabel *wordLab = [[UILabel alloc] initWithFrame:CGRectMake(imageVIew.frame.size.width+20, 30, 60, 20)];
    wordLab.text = @"上传成功！";
    wordLab.font = [UIFont boldSystemFontOfSize:11.0f];
    [self addSubview:wordLab];
//    [self createLineView];
    [self createClickButton];
    [self createRemoveButton];
//    [self createSelectButton];
}
-(void)createRemoveButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.frame.size.width - 20, 5, 15, 15);
    button.imageEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, 0);
    button.imageView.frame = CGRectMake(0, 0, 10, 10);
//    button.backgroundColor = [UIColor redColor];
//    [button setBackgroundImage:[UIImage imageNamed:@"btn_delete_normal@3x.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"形状-4-拷贝"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removeShareTopView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];



}
-(void)createLineView{
    UIImageView *imageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(100, fixedWidth-10, 0.5, 100+40)];
    imageVIew.backgroundColor  = [UIColor grayColor];
    [self addSubview:imageVIew];
}
-(void)createClickButton{
    UIView *view=nil;
    view=[self createShareCellView:@"微信" imageName:@"btn_wechat_normal@2x.png" imageNameClicked:@"btn_wechat_pressed@3x.png" clickAction:@selector(btnWeiXinClicked:) index:0];
    [self addSubview:view];
    
    view=[self createShareCellView:@"朋友圈" imageName:@"btn_friend_normal@2x.png" imageNameClicked:@"btn_friend_pressed@3x.png" clickAction:@selector(btnCircleClicked:) index:1];
    [self addSubview:view];
    
    view=[self createShareCellView:@"微博" imageName:@"btn_weibo_normal@2x.png" imageNameClicked:@"btn_weibo_pressed@3x.png" clickAction:@selector(btnSinaClicked:) index:2];
    [self addSubview:view];
    
    view=[self createShareCellView:@"QQ" imageName:@"btn_QQ_normal@2x.png" imageNameClicked:@"btn_QQ_pressed@3x.png" clickAction:@selector(btnQQclicked:) index:3];
    [self addSubview:view];
    
    
//    view=[self createShareCellView:@"造型师好友" imageName:@"btn_share.png" imageNameClicked:@"btn_share.png" clickAction:@selector(btnTxlClicked:) index:4];
//    
    
//     view=[self createShareCellView:@"造型师朋友圈" imageName:@"btn_share.png" imageNameClicked:@"btn_share.png" clickAction:@selector(btnFriendslicked:) index:5];
    [self addSubview:view];
    
   
    [self addSubview:view];
}

-(UIView*)createShareCellView:(NSString *)name imageName:(NSString *)imageName imageNameClicked:(NSString *)imageNameClicked clickAction:(SEL)clickAction index:(int)index
{

//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50*index, 0, 50, 50)];
//    UIImageView
    ShareCellView *view=[[[NSBundle mainBundle] loadNibNamed:@"ShareCellView" owner:self options:nil] objectAtIndex:0];
    view.backgroundColor = [UIColor clearColor];
//    view.backgroundColor = [UIColor redColor];
    //    [view.btnItem setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //    [view.btnItem setImage:[UIImage imageNamed:imageNameClicked] forState:UIControlStateHighlighted];
    view.btnItem.tag = 70+index;
    view.imageView.image=[UIImage imageNamed:imageName];
  
    [view.btnItem addTarget:self action:clickAction forControlEvents:UIControlEventTouchUpInside];
    view.lbName.textColor=[Utils HexColor:0x6b6b6b Alpha:1.0];
    view.lbName.text=[[NSString alloc] initWithFormat:@"%@",name ];
    view.lbName.font = [UIFont systemFontOfSize:10.0f];
    view.frame=CGRectMake(125+index*45, 15, 45, 45);
    view.btnItem.frame = CGRectMake(0, 0, 45, 45);
    view.imageView.frame  = CGRectMake(5, 0,  30, 30);
    view.lbName.frame  = CGRectMake(3, view.imageView.frame.size.height,  35, 15);
//    view.imageView.layer.masksToBounds=YES;
//    view.imageView.layer.cornerRadius=view.imageView.frame.size.width/2;
    //    view.frame=CGRectMake(101+index%3*view.frame.size.width/1.5,(index/3)*view.frame.size.height/1.2+fixedWidth, 50, 50);
    
    return view;
}

-(void)btnWeiXinClicked :(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackShareTopViewWithShareButton:)]) {
        [_delegate callBackShareTopViewWithShareButton:sender];
    }
}
-(void)btnCircleClicked :(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackShareTopViewWithShareButton:)]) {
        [_delegate callBackShareTopViewWithShareButton:sender];
    }
}
-(void)btnSinaClicked :(UIButton *)sender{
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackShareTopViewWithShareButton:)]) {
        [_delegate callBackShareTopViewWithShareButton:sender];
    }
}
-(void)btnQQclicked :(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackShareTopViewWithShareButton:)]) {
        [_delegate callBackShareTopViewWithShareButton:sender];
    }
}

- (void)btnFriendslicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(callBackShareTopViewWithShareButton:)]) {
        [_delegate callBackShareTopViewWithShareButton:sender];
    }
}

-(void)btnTxlClicked :(UIButton *)sender{
//    CustomActionSheet *actionview=(CustomActionSheet*)[[[((UIButton*)sender) superview] superview] superview];
//    [actionview dismissWithClickedButtonIndex:0 animated:YES];
  
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackShareTopViewWithShareButton:)]) {
        [_delegate callBackShareTopViewWithShareButton:sender];
    }
}

-(void)createSelectButton{
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn .frame = CGRectMake(10, 112.5+65, 15, 15);
//    selectBtn.backgroundColor = [UIColor getColor:@"#039a86"];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"形状-5@2x"] forState:UIControlStateNormal];
    _selectButton = selectBtn;
    [selectBtn addTarget:self action:@selector(selectButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分享成功后，-将能得到搭配大师的指导意见哦！@2x"]];
    imageview.frame = CGRectMake(30, 115+65, imageview.image.size.width/2, imageview.image.size.height/2);
    [self addSubview:imageview];

}

-(void)selectButtonCLick:(UIButton *)sender{
    if ([sender.backgroundColor isEqual:[UIColor colorWithHexString:@"#039a86"]]) {
         [sender setBackgroundImage:[UIImage imageNamed:@"形状-5@2x"] forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor clearColor];
    }else{
        sender.backgroundColor = [UIColor colorWithHexString:@"#039a86"];
    [sender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }

}

-(void)removeShareTopView:(id)sender{
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(self.frame.origin.x, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 
 //宣告一个UITouch的指标来存放事件触发时所撷取到的状态
 //    UITouch *touch = [[event allTouches] anyObject];
 //    [_pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake([touch locationInView:touch.view].x, [touch locationInView:touch.view].y)]];
 CGPoint point;
 point = [[touches anyObject] locationInView:self];
 
 
 }
*/

@end
