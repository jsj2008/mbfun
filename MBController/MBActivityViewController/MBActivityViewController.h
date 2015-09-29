//
//  MBActivityViewController.h
//  Wefafa
//
//  Created by fafatime on 15-4-2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBMyGoodsContentCollectionView.h"
@interface MBActivityViewController : UIViewController<MBMyGoodsContentCollectionViewDelegate>
@property(nonatomic,retain)NSString *activityId;
@property(nonatomic,retain)NSString *activityName;


@end
