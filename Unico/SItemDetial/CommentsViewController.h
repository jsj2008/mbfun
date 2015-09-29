//
//  CommentsViewController.h
//  Wefafa
//
//  Created by unico_0 on 5/30/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : SBaseViewController

@property (nonatomic, copy) NSString *collocationID;
@property (nonatomic, strong) NSMutableString *commentDetailCount;
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, assign) CGFloat commentTotalScore;

@property (weak, nonatomic) IBOutlet UIView *topCommentView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@end
