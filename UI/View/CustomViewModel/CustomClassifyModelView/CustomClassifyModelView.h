//
//  CustomClassifyModelView.h
//  WeFFDemo
//
//  Created by fafatime on 14-4-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomClassifyModelView : UIView<UIScrollViewDelegate>
{
    NSDictionary *dictionary;
    UIScrollView *secondView;
    NSString *detailstrname;
    
}

- (id)initWithFrame:(CGRect)frame withDictionary:(NSDictionary *)transdic withName:(NSString *)nameStr;

@end
