//
//  CustomHeadModelView.h
//  WeFFDemo
//
//  Created by fafatime on 14-4-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHeadModelView : UIView
{
    NSDictionary *dictionary;
    int ios7height;
    NSString *backJust;
    
}
- (id)initWithFrame:(CGRect)frame WithDic:(NSDictionary *)transDic WithColor:(NSString*)colcorStr;
@end
