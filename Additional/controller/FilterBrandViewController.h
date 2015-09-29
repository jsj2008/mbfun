//
//  FilterBrandViewController.h
//  newdesigner
//
//  Created by Miaoz on 14/10/22.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandMapping.h"
typedef void (^BrandVCBlock) (id sender);

@interface FilterBrandViewController : UIViewController
@property(nonatomic,copy)BrandVCBlock myblock;
@property(nonatomic,strong)NSMutableDictionary *dataDic;

-(void)brandVCBlockWithBrandMapping:(BrandVCBlock) block;
- (IBAction)leftBarButtonItemClickevent:(id)sender;
@end
