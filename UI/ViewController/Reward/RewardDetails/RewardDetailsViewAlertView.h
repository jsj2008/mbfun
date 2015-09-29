//
//  BGAlertView.h
//  Designer
//
//  Created by Jiang on 1/16/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RewardDetailsViewAlertViewDelegate <NSObject>

- (void)alertViewCancelAction;
- (void)alertViewAcceptAction;

@end

@interface RewardDetailsViewAlertView : UIView

@property (nonatomic, assign) id<RewardDetailsViewAlertViewDelegate> delegate;

@end
