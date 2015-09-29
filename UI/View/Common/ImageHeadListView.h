//
//  ImageHeadListView.h
//  Wefafa
//
//  Created by mac on 14-9-17.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PSTCollectionView.h"
#import "ImageGridCell.h"
#import "CollectionBaseView.h"
#import "CommonEventHandler.h"

@interface ImageHeadListView : CollectionBaseView
{
}

@property (nonatomic,retain) UIColor *headerBorderColor;
@property (nonatomic) BOOL likeChecked; //设置后需要重新刷新界面
@property (nonatomic,retain) CommonEventHandler *imageHeadDrawEvent;

- (id)initWithFrame:(CGRect)frame listCount:(int)listCount;

@end
