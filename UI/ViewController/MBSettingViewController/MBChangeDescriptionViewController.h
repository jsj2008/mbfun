//
//  MBChangeDescriptionViewController.h
//  Wefafa
//
//  Created by fafatime on 15-2-7.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPUserSqliteStorageObject;

@interface MBChangeDescriptionViewController : SBaseViewController/*UIViewController*/<UITextViewDelegate>
{
     XMPPUserSqliteStorageObject *myUser;
}
@property (assign, nonatomic) id preViewController;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITextView *editTextView;

@end
