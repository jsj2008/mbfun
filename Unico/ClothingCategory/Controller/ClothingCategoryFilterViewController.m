//
//  ClothingCategoryFilterViewController.m
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ClothingCategoryFilterViewController.h"
#import "ClothingCategoryFilterViewModel.h"
#import "SCheckBox.h"
#import "UIImageView+WebCache.h"

#import "SUtilityTool.h"

@interface ClothingCategoryFilterViewController ()
{
    UIScrollView  *_scrollView;
    ClothingCategoryFilterViewModel *_filterModel;
}

@end

@implementation ClothingCategoryFilterViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64 - 64)];
    _scrollView.alwaysBounceVertical = YES;
    
    [self.view addSubview:_scrollView];
    
    float k = UI_SCREEN_WIDTH/750.0;

    
    float leftEdge = 15 * k;// 左边边距
    float rightEdge = leftEdge;// 右边边距
    
    
    //完成按钮
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(leftEdge, UI_SCREEN_HEIGHT - 64, UI_SCREEN_WIDTH-leftEdge-rightEdge, 40)];
    [doneButton setBackgroundColor:[UIColor colorWithRed:59.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1.0]];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    doneButton.layer.cornerRadius = 4;
    doneButton.layer.masksToBounds = YES;
    [self.view addSubview:doneButton];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self getData];
    });
}

- (void)setupNavbar
{
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,backButtonItem] ;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = FONT_SIZE(18);
    titleLabel.textColor = COLOR_WHITE;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 其他UI接口

- (void)updateUI
{
    for (UIView *subview in [_scrollView subviews])
    {
        [subview removeFromSuperview];
    }
    
    float k = UI_SCREEN_WIDTH/750.0;
    
    float horizontalSpacing = 20 * k;//水平间距
    float verticalSpacing = 10 * k;//垂直间距
    
    float leftEdge = 30 * k;// 左边边距
    float rightEdge = leftEdge;// 右边边距
    
    float offsetX = leftEdge; //起始X
    float offsetY = 10;////起始Y
    
    //_filterModel.filterGroups总共的筛选组
    for (int i=0; i<[_filterModel.filterGroups count]; i++)
    {
        FilterGroup *filterGroup = [_filterModel.filterGroups objectAtIndex:i];
        
        //分组名称
        UILabel *groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftEdge, offsetY, UI_SCREEN_WIDTH-leftEdge-rightEdge, 40)];
        groupNameLabel.text = filterGroup.groupName;
        groupNameLabel.textAlignment = NSTextAlignmentLeft;
        groupNameLabel.textColor = [UIColor blackColor];
        groupNameLabel.font = [UIFont systemFontOfSize:16];
        [_scrollView addSubview:groupNameLabel];
        
        offsetY += groupNameLabel.frame.size.height + verticalSpacing;
        
        
        if (filterGroup.titles != nil)//文本类型的checkBox
        {
            float checkBoxMiniWidth = (UI_SCREEN_WIDTH-leftEdge - rightEdge - horizontalSpacing*2)/3.0;
            float checkBoxMaxWidth = UI_SCREEN_WIDTH-leftEdge - rightEdge;
            float checkBoxHeight = 30;
            
            for (int j=0; j<[filterGroup.titles count]; j++)
            {
                SCheckBox *checkBox = [[SCheckBox alloc] init];
                checkBox.titleLabel.text = [filterGroup.titles objectAtIndex:j];
                
                CGSize checkBoxSize = [checkBox.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : checkBox.titleLabel.font}];
                
                if (checkBoxSize.width < checkBoxMiniWidth)
                {
                    checkBoxSize.width = checkBoxMiniWidth;
                }
                
                if (checkBoxSize.width > checkBoxMaxWidth)
                {
                    checkBoxSize.width = checkBoxMaxWidth;
                }
                
                if (((offsetX+checkBoxSize.width)-(UI_SCREEN_WIDTH-leftEdge)) < 0.01) //追加到同一行 浮点数本来有误差、不要用严格等于进行比较
                {
                    checkBox.frame = CGRectMake(offsetX, offsetY, checkBoxSize.width, checkBoxHeight);
                    offsetX += checkBoxSize.width + horizontalSpacing;
                }
                else//换下一行
                {
                    offsetX = leftEdge;
                    offsetY = offsetY + checkBoxHeight + verticalSpacing;
                    
                    checkBox.frame = CGRectMake(offsetX, offsetY, checkBoxSize.width, checkBoxHeight);
                    offsetX += checkBoxSize.width + horizontalSpacing;
                }
                
                [_scrollView addSubview:checkBox];
            }
            offsetY = offsetY + checkBoxHeight + verticalSpacing + verticalSpacing;
            
            //每组结束时加一条横线 最后一组不用加
            if (i != [_filterModel.filterGroups count] - 1)
            {
                offsetX = 0;
                offsetY = offsetY + verticalSpacing;
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, UI_SCREEN_WIDTH, 1)];
                lineView.backgroundColor = [UIColor grayColor];
                [_scrollView addSubview:lineView];
            }
            
            offsetX = leftEdge;//下一组时X还原
            offsetY = offsetY + verticalSpacing;//下一组时Y更新
        }
        else if (filterGroup.imageURLs != nil)//图片类型的checkBox
        {
            float checkBoxWidth = (UI_SCREEN_WIDTH - leftEdge - rightEdge -  horizontalSpacing * 3)/4.0;
            float checkBoxHeight = checkBoxWidth;
            
            for (int j=0; j<[filterGroup.imageURLs count]; j++)
            {
                SCheckBox *checkBox = [[SCheckBox alloc] init];
                checkBox.imageView.image = [UIImage imageNamed:[filterGroup.imageURLs objectAtIndex:j]];
                //[checkBox.imageView setImageWithURL:[NSURL URLWithString:[filterGroup.imageURLs objectAtIndex:j]]];
                
                int row = j / 4;
                int column = j % 4;
                
                checkBox.frame = CGRectMake(leftEdge + column * (checkBoxWidth + horizontalSpacing), offsetY + row * (checkBoxHeight + verticalSpacing), checkBoxWidth, checkBoxHeight);
                
                [_scrollView addSubview:checkBox];
            }
            
            offsetY = offsetY + ([filterGroup.imageURLs count] / 4) * (checkBoxHeight + verticalSpacing);
            
            //每组结束时加一条横线 最后一组不用加
            if (i != [_filterModel.filterGroups count] - 1)
            {
                offsetX = 0;
                offsetY = offsetY + verticalSpacing;
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, UI_SCREEN_WIDTH, 1)];
                lineView.backgroundColor = [UIColor grayColor];
                [_scrollView addSubview:lineView];
            }
            
            offsetX = leftEdge; //下一组时X还原
            offsetY = offsetY + verticalSpacing;//下一组时Y更新
        }
    }
    
    
    CGSize contentSize;
    if (offsetY < _scrollView.bounds.size.height)
    {
        contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height);
    }
    else
    {
        contentSize = CGSizeMake(_scrollView.bounds.size.width, offsetY);
    }
    
    _scrollView.contentSize = contentSize;
}

#pragma mark - 控件事件接口

-(void)backButtonClick:(id)sender
{
    [self popAnimated:YES];
}

#pragma mark - 获取网络数据接口

- (void)getData
{
    //sleep(1);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_filterModel == nil)
        {
            _filterModel = [[ClothingCategoryFilterViewModel alloc] init];
        }
        
        _filterModel.filterGroups = nil;
        
        FilterGroup *clothingCategoryFilterGroup = [[FilterGroup alloc] init];
        clothingCategoryFilterGroup.groupName = @"品类";
        clothingCategoryFilterGroup.titles = @[@"男装", @"女装", @"童装"];
        
        
        FilterGroup *priceFilterGroup = [[FilterGroup alloc] init];
        priceFilterGroup.groupName = @"价格";
        priceFilterGroup.titles = @[@"≤￥100", @"￥100≤300", @"￥301≤500", @"￥501≤1000", @"￥1000≤"];
        
        
        FilterGroup *colorFilterGroup = [[FilterGroup alloc] init];
        colorFilterGroup.groupName = @"颜色";
        colorFilterGroup.titles = @[@"红色", @"黄色", @"蓝色", @"橙色", @"黄色", @"米色", @"浅灰色", @"浅灰色", @"紫色"];
        
        
        FilterGroup *brandFilterGroup = [[FilterGroup alloc] init];
        brandFilterGroup.groupName = @"品牌";
        brandFilterGroup.imageURLs = @[@"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5", @"Unico/brand_5"];
        
        
        _filterModel.filterGroups = @[clothingCategoryFilterGroup, priceFilterGroup, colorFilterGroup, brandFilterGroup];
        
        [self updateUI];
    });
}

@end
