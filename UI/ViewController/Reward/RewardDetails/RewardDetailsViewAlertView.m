//
//  BGAlertView.m
//  Designer
//
//  Created by Jiang on 1/16/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "RewardDetailsViewAlertView.h"

@interface RewardDetailsViewAlertView ()

- (IBAction)cancelButton:(UIButton*)sender;
- (IBAction)acceptButton:(UIButton*)sender;

@end

@implementation RewardDetailsViewAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BGAlertView" owner:nil options:nil];
        self = [array firstObject];
        CGRect rect = CGRectMake(0, 0, 240, 130);
        self.frame = rect;
    }
    return self;
}

- (IBAction)cancelButton:(UIButton*)sender{
    [self.delegate alertViewCancelAction];
}
- (IBAction)acceptButton:(UIButton*)sender{
    [self.delegate alertViewAcceptAction];
}

@end
