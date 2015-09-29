//
//  NibLoad.h
//  YunHK
//
//  Created by Juvid on 14/12/30.
//  Copyright (c) 2014年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NibLoad : NSObject
+(UIView*)loadNib:(NSString *)nibName;
@property (strong, nonatomic) IBOutlet UIView *views;
@property (strong ,nonatomic) UIView *otherView;
@end
