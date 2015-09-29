//
//  PicAndTextButton.h
//  Wefafa
//
//  Created by fafatime on 14-11-30.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"
@interface PicAndTextButton : UIButton
{
    UILabel *nameLabel;
    UIUrlImageView *itemImageV;
    UIUrlImageView *selectImageView;
    
}
@property (nonatomic,retain)UIUrlImageView *itemImageV;
@property (nonatomic,retain)UILabel *nameLabel;
@property (nonatomic,retain)UIUrlImageView *selectImageView;
@end
