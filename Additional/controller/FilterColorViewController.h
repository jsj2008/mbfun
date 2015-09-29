//
//  FilterColorViewController.h
//  newdesigner
//
//  Created by Miaoz on 14/10/22.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ColorVCBlock) (id sender);

@interface FilterColorViewController : UIViewController
@property(nonatomic,copy)ColorVCBlock myblock;

-(void)colorVCBlockWithColorMapping:(ColorVCBlock) block;
- (IBAction)leftBarButtonItemClickevent:(id)sender;
@end
