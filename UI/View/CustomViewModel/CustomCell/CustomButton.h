//
//  CustomButton.h
//  Wefafa
//
//  Created by fafatime on 14-5-20.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"
@interface CustomButton : UIButton
{
    UIUrlImageView *itemImageV;
    UILabel *nameLabel;
    UIUrlImageView *selectImageView;
}

@property (nonatomic,retain)UIUrlImageView *itemImageV;
@property (nonatomic,retain)UILabel *nameLabel;
@property (nonatomic,retain)UIUrlImageView *selectImageView;
@property (nonatomic,retain)UIUrlImageView *clickImgView;


//@property (nonatomic,retain)UIView *actionView;
- (id)initWithFrame:(CGRect)frame withLineUp:(BOOL)Up;


@end
