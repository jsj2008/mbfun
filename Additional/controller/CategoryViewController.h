//
//  CategoryTableViewController.h
//  newdesigner
//
//  Created by Miaoz on 14-9-26.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CategoryVCMaterialBlock) (id sender);

@interface CategoryViewController : UIViewController
@property(nonatomic,copy)CategoryVCMaterialBlock myblock;
@property(nonatomic,strong)NSString *replaceStr;

-(void)categoryVCMaterialBlockWithMaterialMapping:(CategoryVCMaterialBlock) block;


- (IBAction)leftBarButtonItemClickevent:(id)sender;
- (IBAction)rightBarButtonItemClickevent:(id)sender;

-(void)recordClickSelectShearWithclickint:(int) clickint;

@end
