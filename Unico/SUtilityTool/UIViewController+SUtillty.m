//
//  UIViewController+SUtillty.m
//  Wefafa
//
//  Created by unico_0 on 7/12/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "UIViewController+SUtillty.h"
#import "Toast.h"

@implementation UIViewController (SUtillty)

- (void)viewWillDisappear:(BOOL)animated{
    [Toast hideToastActivity];
}

@end
