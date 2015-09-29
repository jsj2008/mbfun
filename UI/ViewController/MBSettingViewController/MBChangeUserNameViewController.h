//
//  MBChangeUserNameViewController.h
//  Wefafa
//
//  Created by fafatime on 14-11-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPUserSqliteStorageObject;
@interface MBChangeUserNameViewController : SBaseViewController//UIViewController
{
    NSArray *sections; //title, cells, title, cells,...
    XMPPUserSqliteStorageObject *myUser;

}
@property (weak, nonatomic) id preViewController;

@property (weak, nonatomic) IBOutlet UIView *viewHead;
@property (nonatomic,strong) NSString *currentName;

@end
