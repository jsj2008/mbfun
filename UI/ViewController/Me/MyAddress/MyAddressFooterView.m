//
//  MyAddressFooterView.m
//  Wefafa
//
//  Created by Miaoz on 15/6/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "MyAddressFooterView.h"
#import "UIColor+extend.h"
@interface MyAddressFooterView ()
@property(nonatomic,strong)UIButton * deleteBtn;
@property(nonatomic,strong)UIButton * editBtn;
@property(nonatomic,strong)UIButton * defaultBtn;
@end

@implementation MyAddressFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:[self creatBtns]];
    }
    return self;
}
-(UIView *)creatBtns{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOWW, 40.0f)];
    //    footer.backgroundColor = [UIColor redColor];
    
    UIButton *  deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn = deleteBtn;
    deleteBtn.frame = CGRectMake(WINDOWW - 70, 7.5, 60, 25);
    [deleteBtn setImage:[UIImage imageNamed:@"Unico/addressdelete"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [deleteBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    deleteBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    deleteBtn.backgroundColor = [UIColor clearColor];
    [deleteBtn addTarget:self action:@selector(deleteBtnClickMothel:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.layer.cornerRadius = 3.0f;
    deleteBtn.layer.masksToBounds = YES;
    
    UIButton *  editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn = editBtn;
    editBtn.frame = CGRectMake(WINDOWW -2*70, 7.5, 60, 25);
    [editBtn setImage:[UIImage imageNamed:@"Unico/addressedit"] forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [editBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    editBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    editBtn.backgroundColor = [UIColor clearColor];
    [editBtn addTarget:self action:@selector(editBtnClickMothel:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.layer.cornerRadius = 3.0f;
    editBtn.layer.masksToBounds = YES;
    
    
    UIButton *  defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _defaultBtn = defaultBtn;
    defaultBtn.frame = CGRectMake(0, 7.5, 120, 30);
    [defaultBtn setTitle:@"设为默认地址" forState:UIControlStateNormal];
   //present_uncheck
    [defaultBtn setImage:[UIImage imageNamed:@"Unico/address_zero"] forState:UIControlStateNormal];
    
    defaultBtn.imageEdgeInsets = UIEdgeInsetsMake(-6,-10, 0, 0);
    defaultBtn.titleEdgeInsets = UIEdgeInsetsMake(-6, 5,0, 0);//2 5 0 0

    defaultBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [defaultBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    defaultBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    defaultBtn.backgroundColor = [UIColor clearColor];
    [defaultBtn addTarget:self action:@selector(defaultBtnClickMothel:) forControlEvents:UIControlEventTouchUpInside];
    defaultBtn.layer.cornerRadius = 3.0f;
    defaultBtn.layer.masksToBounds = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, footer.frame.size.height-0.5, WINDOWW, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    [footer addSubview:lineView];
    [footer addSubview:deleteBtn];
    [footer addSubview:defaultBtn];
    [footer addSubview:editBtn];
    return footer;
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    if ([_dataDic[@"isdefault"] integerValue] == 1) {
        [_defaultBtn setImage:[UIImage imageNamed:@"Unico/address_select"] forState:UIControlStateNormal];
        [_defaultBtn setTitle:@"默认地址" forState:UIControlStateNormal];
         _defaultBtn.imageEdgeInsets = UIEdgeInsetsMake(-6,-35, 0, 0);
        _defaultBtn.titleEdgeInsets = UIEdgeInsetsMake(-6, -20, 0, 0);
//        _defaultBtn.titleEdgeInsets = UIEdgeInsetsMake(2, -20, 0, 0);
//                _defaultBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    }
    if ([_dataDic[@"is_default"] integerValue] == 1) {
        [_defaultBtn setImage:[UIImage imageNamed:@"Unico/address_select"] forState:UIControlStateNormal];
        [_defaultBtn setTitle:@"默认地址" forState:UIControlStateNormal];
        _defaultBtn.imageEdgeInsets = UIEdgeInsetsMake(-6,-35, 0, 0);
              _defaultBtn.titleEdgeInsets = UIEdgeInsetsMake(-6, -20, 0, 0);
//        _defaultBtn.titleEdgeInsets = UIEdgeInsetsMake(2, -20, 0, 0);
        
    }
    if ([_dataDic[@"ISDEFAULT"] integerValue] == 1) {
        [_defaultBtn setImage:[UIImage imageNamed:@"Unico/address_select"] forState:UIControlStateNormal];
        [_defaultBtn setTitle:@"默认地址" forState:UIControlStateNormal];
        _defaultBtn.imageEdgeInsets = UIEdgeInsetsMake(-6,-35, 0, 0);
              _defaultBtn.titleEdgeInsets = UIEdgeInsetsMake(-6, -20, 0, 0);
//        _defaultBtn.titleEdgeInsets = UIEdgeInsetsMake(2, -20, 0, 0);
    }
 
}
-(void)deleteBtnClickMothel:(UIButton *)sender{

    if (_didDeleteSelectedEnter) {
        _didDeleteSelectedEnter(_dataDic,sender,_indexPath);
    }
}

-(void)editBtnClickMothel:(UIButton *)sender{
    if (_didEditSelectedEnter) {
        _didEditSelectedEnter(_dataDic,sender,_indexPath);
    }

}
-(void)defaultBtnClickMothel:(UIButton *)sender{
    if (_didDefaultSelectedEnter) {
        _didDefaultSelectedEnter(_dataDic,sender,_indexPath);
    }

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */




@end
