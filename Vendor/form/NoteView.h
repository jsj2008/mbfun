//
//  NoteView.h
//  Wefafa
//
//  Created by daniel on 14-3-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface NoteView : UITextView<UIScrollViewDelegate>
{
    UILabel *_placeholder;
    BOOL _isShowPlaceholder;
}

@property (strong, nonatomic) UILabel *placeholder;

-(void)setShowPlaceholder:(BOOL)isShow;

@end
