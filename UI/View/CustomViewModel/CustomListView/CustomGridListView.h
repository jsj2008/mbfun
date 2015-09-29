//
//  CustomGridListView.h
//  Wefafa
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomGridCell.h"

////////////////////////////////////////////////////////////
@protocol CustomGridListViewDelegate <NSObject>

#pragma datasource

-(void)gridView:(id)sender gridDataForIndex:(int)gridIndex;
-(int)gridNumber:(id)sender;

@optional
-(void)gridView:(id)sender clickedItemIndex:(int)itemIndex;
-(id)createGridCell:(id)sender;

@end


@interface CustomGridListView : UIView<CustomGridDelegate>
{
    int _columnNuber;
    NSString *_defaultImageName;
    UIScrollView *backScrollView;
}

@property (nonatomic,assign) id<CustomGridListViewDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *gridViewArray;

- (id)initWithFrame:(CGRect)frame column:(int)column;
- (id)initWithFrame:(CGRect)frame column:(int)column defaultImageName:(NSString *)defaultImageName;
-(int)getGridListViewHeight;
-(id)createDefaultGrid:(int)index;
-(void)setDefaultGrid:(CustomGridCell *)grid imageName:(NSString *)imageName title:(NSString *)title;
-(void)reloadData;

@end
