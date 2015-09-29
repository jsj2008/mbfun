//
//  SProductSelectedModuleView.h
//  Wefafa
//
//  Created by unico_0 on 7/21/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SProductSelectedModuleViewDelegate <NSObject>

- (void)productSelectedIndex:(int)index;

@end

@interface SProductSelectedModuleView : UIView

@property (nonatomic, assign) id<SProductSelectedModuleViewDelegate> delegate;
@property (nonatomic, assign) int selectedIndex;
//@property (nonatomic, assign) int commentCount;
@property (nonatomic, assign) int similarityProductCount;
@property (nonatomic, assign) int collocationProductCount;
@end
