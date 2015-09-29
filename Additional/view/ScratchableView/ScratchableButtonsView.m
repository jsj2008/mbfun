//
//  ScratchableButtonsView.m
//  QCIconprocess
//
//  Created by Miaoz on 15/1/19.
//  Copyright (c) 2015年 Scasy. All rights reserved.
//

#import "ScratchableButtonsView.h"
#import "Globle.h"
#import "ColorMapping.h"
#import "FontInfo.h"

#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]

#define MENU_ITEM_HEIGHT        44
#define FONT_SIZE               15
#define CELL_IDENTIGIER         @"MenuPopoverCell"
#define MENU_TABLE_VIEW_FRAME   CGRectMake(0, 0, frame.size.width, frame.size.height)
#define SEPERATOR_LINE_RECT     CGRectMake(10, MENU_ITEM_HEIGHT - 1, self.frame.size.width - 20, 1)
#define MENU_POINTER_RECT       CGRectMake(frame.origin.x, frame.origin.y, 23, 11)

#define CONTAINER_BG_COLOR      RGBA(0, 0, 0, 0.1f)

#define ZERO                    0.0f
#define ONE                     1.0f
#define ANIMATION_DURATION      0.5f

#define MENU_POINTER_TAG        1011
#define MENU_TABLE_VIEW_TAG     1012

#define LANDSCAPE_WIDTH_PADDING 50




/*
 1.adjust....方法去掉第2个参数----add:(BOOL)add （不能增加全局变量或者成员变量）
 2.在表情最后面增加一个“+”按钮，添加按钮在尾部添加一个表情（表情图片随机）
 */

#define kImgWH 50
#define kImgW 50
#define kInitCount 13

@interface ScratchableButtonsView ()<UIScrollViewDelegate>

@property(nonatomic,retain) UIButton *containerButton;

- (void)hide;

@end
@implementation ScratchableButtonsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        // Adding Container Button which will take care of hiding menu when user taps outside of menu area
        self.containerButton = [[UIButton alloc] init];
        [self.containerButton setBackgroundColor:CONTAINER_BG_COLOR];
        [self.containerButton addTarget:self action:@selector(dismissScratchPopover) forControlEvents:UIControlEventTouchUpInside];
        [self.containerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        // Adding Menu Options Pointer
        /*
         UIImageView *menuPointerView = [[UIImageView alloc] initWithFrame:MENU_POINTER_RECT];
         menuPointerView.image = [UIImage imageNamed:@"options_pointer"];
         menuPointerView.tag = MENU_POINTER_TAG;
         [self.containerButton addSubview:menuPointerView];
         */
        // Adding menu Items table
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 11, frame.size.width, frame.size.height)];
        _scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        scrollView.backgroundColor = [UIColor colorWithHexString:@"#353535"];
        scrollView.tag = MENU_TABLE_VIEW_TAG;
        
//        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Menu_PopOver_BG"]];
//        bgView.frame = scrollView.frame;
//        [scrollView addSubview:bgView];
        
        [self addSubview:scrollView];
        
        [self.containerButton addSubview:self];
        
    }
    return self;
}


#pragma mark 调整图片的位置
//横向图片展示
-(void)addbuttonsWithdataarray:(NSMutableArray *)dataarray buttonoffsetY:(CGFloat)offsety width:(CGFloat)width height:(CGFloat)height isimage:(BOOL)isimage{



    for (int i = 0; i < dataarray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 700+i;

        if (isimage == YES) {
            FontInfo *fontInfo = (FontInfo *)dataarray[i];
            [btn setBackgroundImage:fontInfo.showImage
                           forState:UIControlStateNormal];

        }else{
            ColorMapping *colorMapping = dataarray[i];
            NSLog(@"colorMapping.coloR_VALUE%@%d",colorMapping.coloR_VALUE,colorMapping.coloR_VALUE.length);
//            NSString *colorStr ;
//            if (colorMapping.coloR_VALUE.length<7) {
//                colorStr = [NSString stringWithFormat:@"#%@",colorMapping.coloR_VALUE];
//            }else{
//                colorStr = colorMapping.coloR_VALUE;
//            }
            
            [btn setBackgroundColor:[UIColor colorWithHexString:colorMapping.coloR_VALUE]];
        }
       
        btn.frame = CGRectMake(5+ (width +10)*i, offsety, width, height);
      
        [btn addTarget:self action:@selector(buttonClick:)
      forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake(5+ (width +10)*dataarray.count, self.bounds.size.height);
}

-(void)buttonClick:(UIButton *)sender{
    

        if (_delegate && [_delegate respondsToSelector:@selector(scratchablePopover:didSelectMenuItemAtIndex:)]) {
            [_delegate scratchablePopover:self  didSelectMenuItemAtIndex:sender.tag - 700];
        }
        
      

    
    
}
//宫格排序
- (void)adjustImagePosWithColumns:(int)columns dataarray:(NSMutableArray *)array add:(BOOL)add
{
    if (array.count == 0|| array == nil) {
        return;
    }
    // 1.定义列数、间距
    // 每行3列
    //#warning 不一样
    //    int columns = 3;
    // 每个表情之间的间距 = (控制器view的宽度 - 列数 * 表情的宽度) / (列数 + 1)
    CGFloat margin = (self.frame.size.width - columns * kImgWH) / (columns + 1);
    
    // 2.定义第一个表情的位置
    // 第一个表情的Y值
    CGFloat oneY = 10;
    // 第一个表情的x值
    CGFloat oneX = margin;
    
    // 3.创建所有的表情array.count
    for (int i = 0; i<array.count; i++) {
        // i这个位置对应的列数
        int col = i % columns;
        // i这个位置对应的行数
        int row = i / columns;
        
        // 列数（col）决定了x
        CGFloat x = oneX + col * (kImgWH + margin);
        // 行数（row）决定了y
        CGFloat y = oneY + row * (kImgWH/2 + margin);
        
        //#warning 不一样
        if (add) { // 添加新的imageView
            FontInfo *fontInfo = (FontInfo *)array[i];
            UIImage *image = fontInfo.showImage;
            [self addImg:image tag:i x:x y:y];
        } else { // 取出旧的imageview 设置x、y
            // 取出i + 1位置对应的imageView，设置x、y值
            // + 1是为了跳过最前面的UISegmentControl 和 UILable
            UIView *child = self.subviews[i + 3];
            // 取出frame
            CGRect tempF = child.frame;
            // 修改x、y
            tempF.origin = CGPointMake(x, y);
            // 重新赋值
            child.frame = tempF;
        }
    }
}



#pragma mark 添加表情 icon:表情图片名
- (void)addImg:(UIImage *)icon tag:(int)tag x:(CGFloat)x y:(CGFloat)y
{
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, kImgWH, kImgWH/2);
    [button setBackgroundImage:icon forState:UIControlStateNormal];

    [button setBackgroundColor:[UIColor yellowColor]];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:button];
    
    
}



#pragma mark Actions

- (void)dismissScratchPopover
{
    [self hide];
}

- (void)showInView:(UIView *)view
{
    self.containerButton.alpha = ZERO;
    self.containerButton.frame = view.bounds;
    [view addSubview:self.containerButton];
    
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.containerButton.alpha = ONE;
                     }
                     completion:^(BOOL finished) {}];
}

- (void)hide
{
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.containerButton.alpha = ZERO;
                     }
                     completion:^(BOOL finished) {
                         [self.containerButton removeFromSuperview];
                     }];
}

#pragma mark -
#pragma mark Orientation Methods

- (void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL landscape = (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
    UIImageView *menuPointerView = (UIImageView *)[self.containerButton viewWithTag:MENU_POINTER_TAG];
    UITableView *menuItemsTableView = (UITableView *)[self.containerButton viewWithTag:MENU_TABLE_VIEW_TAG];
    
    if( landscape )
    {
        menuPointerView.frame = CGRectMake(menuPointerView.frame.origin.x + LANDSCAPE_WIDTH_PADDING, menuPointerView.frame.origin.y, menuPointerView.frame.size.width, menuPointerView.frame.size.height);
        
        menuItemsTableView.frame = CGRectMake(menuItemsTableView.frame.origin.x + LANDSCAPE_WIDTH_PADDING, menuItemsTableView.frame.origin.y, menuItemsTableView.frame.size.width, menuItemsTableView.frame.size.height);
    }
    else
    {
        menuPointerView.frame = CGRectMake(menuPointerView.frame.origin.x - LANDSCAPE_WIDTH_PADDING, menuPointerView.frame.origin.y, menuPointerView.frame.size.width, menuPointerView.frame.size.height);
        
        menuItemsTableView.frame = CGRectMake(menuItemsTableView.frame.origin.x - LANDSCAPE_WIDTH_PADDING, menuItemsTableView.frame.origin.y, menuItemsTableView.frame.size.width, menuItemsTableView.frame.size.height);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
