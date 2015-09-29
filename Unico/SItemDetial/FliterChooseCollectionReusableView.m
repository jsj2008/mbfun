//
//  FliterChooseCollectionReusableView.m
//  Wefafa
//
//  Created by Funwear on 15/9/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "FliterChooseCollectionReusableView.h"
#import "SUtilityTool.h"
@interface FliterChooseCollectionReusableView (){
    UIImageView *imageView;
}
@end

@implementation FliterChooseCollectionReusableView

- (void)awakeFromNib {
    [self.showNameLabel setFont:FONT_t4];
    [self.showNameLabel setTextColor:COLOR_C2];
    [self.chooseButton  setTitle:@"请选择" forState:UIControlStateNormal];
    [self.chooseButton.titleLabel setFont:FONT_t5];
    [self.chooseButton setTitleColor:COLOR_C6 forState:UIControlStateNormal];
    
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/arrow_address"]];
    [self.chooseButton addSubview:imageView];
    imageView.frame =CGRectMake(self.chooseButton.frame.size.width-17-7,(self.chooseButton.frame.size.height-14)/2, 7, 14);
    
    
    
    [self.borderImage setBackgroundColor:COLOR_C9];
    [self.borderImage setFrame:CGRectMake(17, 0, UI_SCREEN_WIDTH-17, 0.7)];
    
    float sizeK=UI_SCREEN_WIDTH/750.0;
    
    self.determineButton.titleLabel.font = FONT_T3;
    [self.determineButton setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    [self.determineButton setTitle:@"确定" forState:UIControlStateNormal];
    
//    [_okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.determineButton setBackgroundColor:COLOR_C2];
//    self.determineButton.userInteractionEnabled = NO;
    
    self.determineButton.layer.cornerRadius = 6 * sizeK;
    self.determineButton.layer.masksToBounds = YES;
    
    float okButtonWidth = 710 * sizeK;
    self.determineButton.frame = CGRectMake((UI_SCREEN_WIDTH - okButtonWidth)/2.0, 30, okButtonWidth, 88 * sizeK);
}

- (void)setTitleName:(NSString *)titleName{
    _titleName = [titleName copy];
    self.showNameLabel.text = _titleName;
    if([_titleName isEqualToString:@""]){
        [self.determineButton setHidden:NO];
        [self.chooseButton setHidden:YES];
        [self.borderImage setHidden:YES];
    }else{
        [self.determineButton setHidden:YES];
        [self.chooseButton setHidden:NO];
        [self.borderImage setHidden:NO];
    }
}
-(void)setContentText:(NSString *)contentText{
    _contentText=[contentText copy];

    if(!_contentText||[_contentText isEqualToString:@"(null) (null)"]){
        [self.chooseButton setTitleColor:COLOR_C6 forState:UIControlStateNormal];
        _contentText=@"请选择";
    }else{
        [self.chooseButton setTitleColor:COLOR_C2 forState:UIControlStateNormal];
    }
    [self.chooseButton setTitle:_contentText forState:UIControlStateNormal];
}
@end
