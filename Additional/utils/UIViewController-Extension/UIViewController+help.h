//
//  UIViewController+help.h
//  Qilian
//
//  Created by Miaozlc on 13-12-11.
//  Copyright (c) 2013年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MapKit/MapKit.h>

@interface UIViewController (help)
void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) );
void UIImageFromURLTOCache( NSURL * URL , NSString *cachekey,void (^imageBlock)(UIImage * image), void (^errorBlock)(void) );

+(void)setSubViewExternNone:(UIViewController *)viewController;
-(void)setNavbarchangeBgdAndTitlecolor;
-(UIButton *)setNavRightBarbtnWithimage:(NSString *)imageStr;
-(UIButton *)setNavLeftBarbtnWithimage:(NSString *)imageStr;
-(UIButton *)setNavLeftBarbtnWithimage:(NSString *)imageStr withRect:(CGRect )rect;
-(UIButton *)setNavRightBarbtnWithString:(NSString *)righttitleStr;

-(void)changeSearchBar:(UISearchBar *)_searchBar;
-(void)changeViewlayer:(CALayer *)layer;

//排除一个文件备份
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
#pragma mark -直接画成image图片
-(UIImage *)imageDrawGroupimageWithimageArray:(NSArray *)imgArray;
//截屏
-(UIImage *)screenShot;
@end
