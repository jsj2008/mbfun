//
//  FilterClassifyViewController.h
//  newdesigner
//
//  Created by Miaoz on 14/10/23.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodCategoryObj;

typedef void (^ClassifyVCBlock) (id sender);

@interface FilterClassifyViewController : UIViewController
@property(nonatomic,strong)GoodCategoryObj *mainGoodCategoryObj;//最上级分类
@property(nonatomic,copy)ClassifyVCBlock myblock;

-(void)classifyVCBlockWithGoodCategoryObj:(ClassifyVCBlock) block;
- (IBAction)leftBarButtonItemClickevent:(id)sender;

@end
