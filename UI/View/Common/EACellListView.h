//
//  EACellListView
//  iShangEManager
//
//  Created by mac on 13-7-10.
//  Copyright (c) 2013年 FafaTimes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EACellListView;

//@protocol EACellListViewDataSource<NSObject>
//- (NSMutableArray *)dataArray:(EACellListView *)cellview;
//@end;
typedef enum
{
    EALIST_VERTICAL_ALIGNMENT_TOP,
    EALIST_VERTICAL_ALIGNMENT_CENTER
}EALIST_VERTICAL_ALIGNMENT_TYPE;

typedef enum
{
    EALIST_STYLE_BUTTON_PLAIN,
    EALIST_STYLE_BUTTON_RADIOBUTTON,//不可以取消
    EALIST_STYLE_BUTTON_CHECKBUTTON,//可以取消
}EALIST_STYLE;

typedef enum
{
    EALIST_CELL_TYPE_TEXT,
    EALIST_CELL_TYPE_IMAGE
}EALIST_CELL_TYPE;

@interface EACellListView : UIView
{
    NSMutableArray *dataArray;
//    id<EACellListViewDataSource> datasource;
    id delegate;
    SEL selectorAddItemClick;
    UIColor *_buttonBorderColor;
    UIColor *_buttonTextColor;
    UIColor *_buttonActiveBorderColor;
    UIColor *_buttonActiveTextColor;
    int _activeIndex;//选中按钮
    int _realViewHeight;
}
//@property (nonatomic, assign) id<EACellListViewDataSource> datasource;
@property (nonatomic, assign) EALIST_CELL_TYPE cellType;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *keyArray;
@property (nonatomic, retain) NSMutableArray *enableArray;
@property (assign, nonatomic) EALIST_VERTICAL_ALIGNMENT_TYPE contentVerticalAlignment;
@property (assign, nonatomic) id de1;
@property (assign, nonatomic) EALIST_STYLE listStyle;
@property (assign, nonatomic) CGSize cellSize;
@property (strong, nonatomic) UIFont *textFont;
@property (strong, nonatomic) UIImageView *imageSelectedFlag;

@property (assign, nonatomic) int activeIndex;
@property (strong, nonatomic, readonly) UIColor *buttonBorderColor;
@property (strong, nonatomic, readonly) UIColor *buttonTextColor;
@property (strong, nonatomic, readonly) UIColor *buttonActiveBorderColor;//选中按钮颜色
@property (strong, nonatomic, readonly) UIColor *buttonActiveTextColor;//选中按钮颜色
@property (assign, nonatomic) int margin;//间隔距离

-(void)setButtonBorderColor:(UIColor *)bordercolor textColor:(UIColor *)textcolor;
-(void)setButtonActiveBorderColor:(UIColor *)bordercolor activeTextColor:(UIColor *)textcolor;

-(void)reloadData;
-(void)setDelegate:(id)del selector:(SEL)sel;
-(void)setActiveIndex:(int)activeIndex1;
-(int)getListViewHeight;
-(int)getCellIndex:(NSString*)text;

@end
