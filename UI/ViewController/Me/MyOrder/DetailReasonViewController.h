//
//  DetailReasonViewController.h
//  Wefafa
//
//  Created by fafatime on 15-1-4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailReasonViewController : SBaseViewController/*UIViewController*/
{
    
}
@property (weak,nonatomic)IBOutlet UIView *headView;
@property (weak,nonatomic)IBOutlet UITableView *listTableView;

@property (retain,nonatomic) NSString *type;

@end
