//
//  SSearchViewController.h
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSearchViewController : SBaseViewController

@property (nonatomic, assign) BOOL isSetSearchText;
@property (nonatomic, strong) NSString *searchText;
- (void)jumpAction;
@end
