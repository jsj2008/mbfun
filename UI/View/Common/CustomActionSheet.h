//
//  CustomActionSheet.h
//  Wefafa
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEventHandler.h"

@protocol doneSelect <NSObject>

-(void)done;

@end

@interface CustomActionSheet : UIView
{
    UIToolbar* toolBar;
}
//-(id)initWithView:(UIView *)view viewHeight:(float)height;
-(id)initWithTitle:(NSString *)title viewHeight:(int)viewHeight;
-(void)dismissWithClickedButtonIndex:(int)index animated:(BOOL)animated;
-(void)showInView:(UIView *)view;

@property (nonatomic,strong) UIView *view;
@property(nonatomic,retain) UIButton* btnCancel;
@property(nonatomic,assign) int viewHeight;

@end



@interface CustomActionSheetOld : UIActionSheet
{
}
@property(nonatomic,retain) UIView* view;
@property(nonatomic,retain) UIButton* btnCancel;
@property(nonatomic,assign) int viewHeight;
@property(nonatomic,retain) CommonEventHandler *loadActionViewEvent;

-(id)initWithTitle:(NSString *)title viewHeight:(int)viewHeight;

@end


