//
//  QuestFeedBackViewController.h
//  Wefafa
//
//  Created by fafatime on 15-1-27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestFeedBackViewController :SBaseViewController /*UIViewController*/
@property (nonatomic,retain) IBOutlet UIView *headView;
@property (weak, nonatomic)  IBOutlet UITextView *writeTextView;
@property (nonatomic,retain) IBOutlet UILabel *placeHoderLabel;
@property (nonatomic,retain) NSString *setBalenceId;
@property (nonatomic,retain) NSString *seller_id;
@end
