//
//  MyAddressFooterView.h
//  Wefafa
//
//  Created by Miaoz on 15/6/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyAddressFooterViewDefaultSelected)(id sender,UIButton *button,NSIndexPath *indexpath);
typedef void (^MyAddressFooterViewEditSelected)(id sender,UIButton *button,NSIndexPath *indexpath);
typedef void (^MyAddressFooterViewDeleteSelected)(id sender,UIButton *button,NSIndexPath *indexpath);

@interface MyAddressFooterView : UIView
@property (nonatomic, copy) MyAddressFooterViewDefaultSelected didDefaultSelectedEnter;
@property (nonatomic, copy) MyAddressFooterViewEditSelected didEditSelectedEnter;
@property (nonatomic, copy) MyAddressFooterViewDeleteSelected didDeleteSelectedEnter;
@property (nonatomic,strong) NSDictionary *dataDic;//
@property(nonatomic,strong)NSIndexPath *indexPath;
- (id)initWithFrame:(CGRect)frame;
@end
