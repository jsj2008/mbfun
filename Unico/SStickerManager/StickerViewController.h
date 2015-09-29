//
//  ViewController.h
//  StickerManager
//
//  Created by Ryan on 15/4/16.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StickerSelectedFunc)(NSString* data);
typedef void(^StickerCanelFunc)();

@interface StickerViewController : UIViewController

@property (nonatomic) UIColor* imageColor;
@property (nonatomic) NSArray *list;
@property (nonatomic) CGRect cellFrame;
@property (nonatomic,strong) StickerSelectedFunc selectFunc;
@property (nonatomic,strong) StickerCanelFunc cancelFunc;

@end
