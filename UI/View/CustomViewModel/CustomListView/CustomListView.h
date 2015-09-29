//
//  CustomListView.h
//  Wefafa
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomGridListView.h"
#import "CustomNormalListView.h"

typedef enum
{
    CUSTOM_LISTVIEW_STYLE_NORMAL,
    CUSTOM_LISTVIEW_STYLE_GRID3,
    CUSTOM_LISTVIEW_STYLE_GRID4
}CUSTOM_LISTVIEW_STYLE;



@protocol CustomListViewDelegate <NSObject>

//-(NSString *)listView:(id)sender cellImageNameForIndex:(int)gridCellIndex;
//-(NSString *)listView:(id)sender cellTitleForIndex:(int)gridCellIndex;

@optional

-(id)createCell:(id)listview forIndex:(int)index;

#pragma grid
-(void)gridView:(id)sender gridDataForIndex:(int)gridIndex;
-(void)gridView:(id)sender clickedCell:(id)cell forIndex:(int)gridIndex;

#pragma list
-(id)listView:(id)sender dataArray:(id)dataarr;
-(void)listView:(id)sender cell:(id)cell cellForRowAtIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)listView:(id)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)listView:(id)sender clickedCell:(id)cell indexPath:(NSIndexPath *)indexPath;

@end



//
@interface CustomListView : UIView<CustomGridListViewDelegate,CustomNormalListViewDelegate>
{
    CUSTOM_LISTVIEW_STYLE _style;
    CustomGridListView *customGridView;//scrollview、tableview
    CustomNormalListView *normalListView;
    int _columnNuber;
    NSMutableArray *_dataArray;
}

@property (nonatomic,assign) id<CustomListViewDelegate> listViewDelegate;
@property (nonatomic,retain) NSDictionary *dataMapDictionary;

//点击响应页面数据字典
@property (nonatomic,retain) NSDictionary *clickActionDictionary;

- (id)initWithFrame:(CGRect)frame style:(CUSTOM_LISTVIEW_STYLE)style;

-(void)setDataArray:(NSMutableArray *)dataarr;
-(NSMutableArray *)dataArray;


@end
