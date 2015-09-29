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
//#import "CommonEventHandler.h"

@interface EAImageListGridData : NSObject
@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *code;
@property (nonatomic,assign) BOOL checked;

@end


@interface EAImageListView : CollectionBaseView
{
    NSInteger _selectIndex;
}

@property (nonatomic,assign) float imageBorderWidth;
@property (nonatomic,assign) float imageSelectedBorderWidth;
@property (nonatomic,assign) float cornerRadius;
//@property (nonatomic,retain) CommonEventHandler *imageHeadDrawEvent;
@property (nonatomic,retain) UIColor *imageSelectedBorderColor;
@property (nonatomic,retain) UIColor *imageBorderColor;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) CGSize imageSize;
@property (nonatomic,assign) CGSize imageSelectedSize;
@property (nonatomic,assign) NSInteger margin;

- (id)initWithFrame:(CGRect)frame listCount:(NSInteger)listCount;
-(NSInteger)getViewWidth;
-(NSInteger)getCellWidth:(NSInteger)index;

@end
