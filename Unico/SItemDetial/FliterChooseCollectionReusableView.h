//
//  FliterChooseCollectionReusableView.h
//  Wefafa
//
//  Created by Funwear on 15/9/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FliterChooseCollectionReusableView : UICollectionReusableView
@property (nonatomic, copy) NSString *titleName;//选择名称
@property (nonatomic, copy) NSString *contentText;//选择内容

@property (weak, nonatomic) IBOutlet UILabel *showNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIImageView *borderImage;
@property (weak, nonatomic) IBOutlet UIButton *determineButton;

@end
