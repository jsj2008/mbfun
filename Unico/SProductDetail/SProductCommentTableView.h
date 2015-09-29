//
//  SProductCommentTableView.h
//  Wefafa
//
//  Created by Jiang on 8/4/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SProductDetailModel;

@interface SProductCommentTableView : UITableView

@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) NSArray *contentModelArray;
@property (nonatomic, strong) SProductDetailModel *contentModel;

@end
