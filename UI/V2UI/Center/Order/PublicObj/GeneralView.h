//
//  GeneralView.h
//  BanggoPhone
//
//  Created by Juvid on 14-8-1.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MBTextField : UITextField
-(void)setLeftViewImg:(NSString *)imgName;
@end
@interface BaseButton: UIButton

@end

@interface OrangeButton : BaseButton

@end

@interface BlackButtton: BaseButton

@end


@interface BalckLable : UILabel

@end

@interface GrayLable : UILabel

@end


@interface BorderButton : UIButton

@property (nonatomic, strong) UILabel *labNum;

-(void)setLabTitle:(NSString *)nums;
@end

@interface BorderLineButton : UIButton

@property (nonatomic, strong) UILabel *labNum;
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UIImageView *rightLineImgView;


-(void)setLabTitle:(NSString *)nums;

@end




@interface NumButton : UIButton{
    UILabel *labNum;
}
-(void)setLabTitle:(NSString *)nums;
@end

@interface CircleImg : UIImageView

@end
@interface EnableButton : OrangeButton
-(void)SetUnSelectBg;
-(void)setSelectBg;
@end

@interface BlackEnableButton : BlackButtton
-(void)SetUnSelectBg;
-(void)setSelectBg;
@end


@interface MBMyStoreButton : UIButton// 数字下面 文字上面
{
    UILabel *labNum;
    UILabel *labText;
    
}
-(void) setlabTitle:(NSString *)nums;
-(void) setTextTitle:(NSString *)text;

@end

