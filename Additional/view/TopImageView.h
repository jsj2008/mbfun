//
//  TopImageView.h
//  newdesigner
//
//  Created by Miaoz on 14-9-24.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TopImageViewBlock)();

@interface TopImageView : UIImageView

@property(nonatomic,strong)TopImageViewBlock block;

-(void)tapclickEventBlock:(TopImageViewBlock)topBlock;
@end
