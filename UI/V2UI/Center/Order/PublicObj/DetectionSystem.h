//
//  DetectionSystemVersion.h
//  models
//
//  Created by juvid on 13-9-23.
//  Copyright (c) 2013年 minfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetectionSystem : NSObject
+(BOOL)SystemVersion;
+(UIAlertView *)ShowAlert:(NSString *)title Message:(NSString *)message;
+(UIAlertView *)ShowDoubleAlert:(NSString *)title Message:(NSString *)message;

+(CGFloat)WidthString:(NSString *)string Width:(float)width Font:(int)font;
+(UIActionSheet *)PayForView:(UIView *)view;
// 手机号
+(BOOL)isMobileCheck:(NSString *)str;
+(BOOL)isEmpty:(NSString *)str;
//遍历UITableViewCell
+ (NSIndexPath *)SubView:(UIView *)subview TableView:(UITableView *)tableView;

+(int)CellRight;

@end
