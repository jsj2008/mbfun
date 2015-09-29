//
//  SGlobal.m
//  Story
//
//  Created by Ryan on 15/4/26.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "SGlobal.h"

@implementation SGlobal
__strong static SGlobal *instance = nil;

+(id)shared{
    if (!instance) {
        instance = [SGlobal new];
        [instance initApp];
    }
    return instance;
}

-(void)initApp{
//    [self loadFonts];
    // 目前无效
//    [self loadGlobalDefaultFont];
    
}

// 需要有字体，才能够显示模板
- (void)loadFonts{
    NSArray* name = @[
                      @"fzfys.ttf",
                      @"fzjh.otf",
                      @"fzlthjw.ttf",
                      @"fzltxh.ttf",
                      @"fzqkbys.ttf",
                      @"fzygytk.ttf",
                      @"fzzdh.ttf",
                      @"txjzh.ttf",
                      @"xdhbbdz.ttf"
                      ];
    for (int i = 0; i < [name count]; i++) {
        NSString* fontFileName = [name objectAtIndex:i];
        NSURL* myFontURL = [[NSBundle mainBundle] URLForResource:fontFileName withExtension:@""];
        [UIFont registerFontFromURL:myFontURL];
    }
    
    
}

// 全局的字体。 无效目前
- (void)loadGlobalDefaultFont{
    // Set font and textColor to nil just before setting attributed string.
    NSString* fontFileName = @"fzltxh.ttf";
    NSURL* myFontURL = [[NSBundle mainBundle] URLForResource:fontFileName withExtension:@""];
    NSArray* fontPostScriptNames = [UIFont registerFontFromURL:myFontURL];
    NSString* fontName = [fontPostScriptNames objectAtIndex:0];
    
    UIFont *appFont = [UIFont fontWithName:fontName size:17.0];
    [[UILabel appearance] setFont:appFont];
}

#pragma mark - 视图切换常用效果
- (UIImage*)snapshot:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    // 下面那个会让view交互丢失。
    //    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 根据UI Image裁剪，不能简单的判断不透明，因为装饰物可能超出区域。
    return image;
}

// 这里处理一些常用切换效果。还没有完成
-(void)animatePushVC:(UIViewController*)oldVC newVC:(UIViewController*)newVC type:(STransitionType)type complete:(SVoidFunc)complete{
//    UIImage *snap = [self snapshot:oldVC.view];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:snap];
//    [newView addSubview:imgView];
//    
//    CGRect frame1 = vc.view.frame;
//    CGRect frame0 = frame1;
//    frame0.origin.x = -frame0.size.width;
//    vc.view.frame = frame0;
//    
//    CGRect frameOut = frame1;
//    frameOut.origin.x = frame1.size.width;
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        vc.view.frame = frame1;
//        imgView.frame = frameOut;
//    } completion:^(BOOL finished) {
//        [imgView removeFromSuperview];
//    }];
}


-(void)calculateCommentNum:(NSInteger)topicId addNum:(NSInteger)num{
    if (SGLOBAL_DATA_INSTANCE.specialLastIndex <=0) {
        return;
    }
    for (NSInteger i = 0; i<[SGLOBAL_DATA_INSTANCE.specialArray count]; i++) {
        if([[[SGLOBAL_DATA_INSTANCE.specialArray objectAtIndex:i] objectForKey:@"id" ] intValue] == topicId ){
            NSInteger currentNum = [[[SGLOBAL_DATA_INSTANCE.specialArray objectAtIndex:i] objectForKey:@"comment_num" ] intValue];
            currentNum += num;
            [[SGLOBAL_DATA_INSTANCE.specialArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%ld",currentNum] forKey:@"comment_num"];
            break;
        }
    }
}
-(void)calculateLikeNum:(NSInteger)topicId addNum:(NSInteger)num{
    if (SGLOBAL_DATA_INSTANCE.specialLastIndex <=0) {
        return;
    }
    for (NSInteger i = 0; i<[SGLOBAL_DATA_INSTANCE.specialArray count]; i++) {
        if([[[SGLOBAL_DATA_INSTANCE.specialArray objectAtIndex:i] objectForKey:@"id" ] intValue] == topicId ){
            NSInteger currentNum = [[[SGLOBAL_DATA_INSTANCE.specialArray objectAtIndex:i] objectForKey:@"like_num" ] intValue];
            currentNum += num;
            [[SGLOBAL_DATA_INSTANCE.specialArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%ld",currentNum] forKey:@"like_num"];
            break;
        }
    }
}
@end
