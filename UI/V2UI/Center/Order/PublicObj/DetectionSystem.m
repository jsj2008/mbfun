//
//  DetectionSystemVersion.m
//  models
//
//  Created by juvid on 13-9-23.
//  Copyright (c) 2013年 minfo. All rights reserved.
//

#import "DetectionSystem.h"
//#import "UIColor+expanded.h"

@implementation DetectionSystem
+(BOOL)SystemVersion{

    return ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)?YES:NO;
}
+(UIAlertView *)ShowAlert:(NSString *)title Message:(NSString *)message{
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
    return alertview;
}
+(UIAlertView *)ShowDoubleAlert:(NSString *)title Message:(NSString *)message{
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertview show];
    return alertview;
}
+(CGFloat)WidthString:(NSString *)string Width:(float)width Font:(int)font{
    CGSize sizeFrame;
    if (string.length!=0) {
        sizeFrame =[string sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        //            NSLog(@"%@",arrRowHight);
    }
    return sizeFrame.width;
    
}

+(CGFloat)SizeString:(NSString *)string Width:(float)width Font:(int)font{
    CGSize sizeFrame;
    if (string.length!=0) {
        sizeFrame =[string sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        //            NSLog(@"%@",arrRowHight);
    }
    return sizeFrame.height;
    
}
// 手机号
+(BOOL)isMobileCheck:(NSString *)str{
    NSString *Regex = @"^(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}$";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:str];
}

//空字符
+(BOOL)isEmpty:(NSString *)str{
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
//遍历UITableViewCell
+ (NSIndexPath *)SubView:(UIView *)subview TableView:(UITableView *)tableView{
    while (![subview isKindOfClass:[UITableViewCell class]]) {
        subview=subview.superview;
    }
    NSIndexPath * path = [tableView indexPathForCell:(UITableViewCell *)subview];
    return path;
}
+(int)CellRight{
    if (IOS7) {
        return 0;
    }
    return 20;
}
+(UIActionSheet *)PayForView:(UIView *)view{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择付款方式"
                                  delegate:nil
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"支付宝支付", @"微信支付",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:view];
    return actionSheet;
}
@end



