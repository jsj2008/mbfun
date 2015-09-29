//
//  VerticalAlignTextView.h
//  StoryCam
//
//  Created by Ryan on 15/4/2.
//  Copyright (c) 2015年 Unico. All rights reserved.

//  竖对齐的一个TextView
//

#import <UIKit/UIKit.h>
typedef enum VerticalAlignment {
    VerticalAlignmentTop = 0,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom
} VerticalAlignment;
@interface VerticalAlignTextView : UITextView
@property (nonatomic) VerticalAlignment verticalAlignment;
@end
