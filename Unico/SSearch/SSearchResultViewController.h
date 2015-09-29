//
//  SSearchResultViewController.h
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSearchResultViewController : SBaseViewController
@property (nonatomic, strong) SDataTagSelectFunc completeFunc;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSString *searchText;

@property (nonatomic, strong) NSMutableDictionary *searchSaveDictionary;

@end
