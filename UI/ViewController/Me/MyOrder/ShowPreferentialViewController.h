//
//  ShowPreferentialViewController.h
//  Wefafa
//
//  Created by fafatime on 15-3-2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPreferentialViewController :SBaseViewController /*UIViewController*/<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *showDetailTV;
@property (retain,nonatomic) NSArray *detailPreferentArray;
@end
