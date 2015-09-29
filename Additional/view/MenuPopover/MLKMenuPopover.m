//
//  MLKMenuPopover.m
//  MLKMenuPopover
//
//  Created by NagaMalleswar on 20/11/14.
//  Copyright (c) 2014 NagaMalleswar. All rights reserved.
//

#import "MLKMenuPopover.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+extend.h"
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]

#define MENU_ITEM_HEIGHT        44
#define FONT_SIZE               14
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

@interface MLKMenuPopover ()

@property(nonatomic,retain) NSArray *menuItems;
@property(nonatomic,retain) UIButton *containerButton;
@property(nonatomic,strong) NSMutableArray *imageArray;
- (void)hide;
- (void)addSeparatorImageToCell:(UITableViewCell *)cell;

@end

@implementation MLKMenuPopover

@synthesize menuPopoverDelegate;
@synthesize menuItems;
@synthesize containerButton;

- (id)initWithFrame:(CGRect)frame menuItems:(NSArray *)aMenuItems imageArray:(NSMutableArray *)aimageArray
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.menuItems = aMenuItems;
        self.imageArray = aimageArray;
        // Adding Container Button which will take care of hiding menu when user taps outside of menu area
        self.containerButton = [[UIButton alloc] init];
        [self.containerButton setBackgroundColor:CONTAINER_BG_COLOR];
        [self.containerButton addTarget:self action:@selector(dismissMenuPopover) forControlEvents:UIControlEventTouchUpInside];
        [self.containerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        // Adding Menu Options Pointer
        /*
        UIImageView *menuPointerView = [[UIImageView alloc] initWithFrame:MENU_POINTER_RECT];
        menuPointerView.image = [UIImage imageNamed:@"options_pointer"];
        menuPointerView.tag = MENU_POINTER_TAG;
        [self.containerButton addSubview:menuPointerView];
        */
        // Adding menu Items table
        UITableView *menuItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 11, frame.size.width, frame.size.height)];
        
        menuItemsTableView.dataSource = self;
        menuItemsTableView.delegate = self;
        menuItemsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        menuItemsTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        menuItemsTableView.separatorColor = [UIColor colorWithHexString:@"#e2e2e2"];
        menuItemsTableView.scrollEnabled = NO;
        menuItemsTableView.backgroundColor = [UIColor clearColor];
        menuItemsTableView.tag = MENU_TABLE_VIEW_TAG;
        
        self.backgroundColor = [UIColor clearColor];
//        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Menu_PopOver_BG"]];
//        menuItemsTableView.backgroundView = bgView;
//        
        [self addSubview:menuItemsTableView];
        
        [self.containerButton addSubview:self];
    }
    
    return self;
}

#pragma mark -
#pragma mark UITableViewDatasource
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    
//    return 12;
//
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 12)];
//    view
//    
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.menuItems.count-1) {
        return MENU_ITEM_HEIGHT + 12;
    }
    return MENU_ITEM_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = CELL_IDENTIGIER;
    UIImageView *showImageView;
    UILabel *showLab;
//    UIImageView 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        showImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-25-100)/2, 10, 25, 25)];
        showImageView.tag = 666;
        [cell.contentView addSubview:showImageView];
        
        showLab = [[UILabel alloc] initWithFrame:CGRectMake(showImageView.frame.size.width+showImageView.frame.origin.x+20, 10, 100, 25)];
        showLab.tag = 777;
        [cell.contentView addSubview:showLab];
    }
    
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    if( [tableView numberOfRowsInSection:indexPath.section] > ONE && !(indexPath.row == numberOfRows - 1) )
    {
//        [self addSeparatorImageToCell:cell];
    }
    
    if (self.imageArray != nil && self.imageArray.count != 0) {
         showImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    }else{
        showImageView.hidden = YES;
        showLab.center = CGPointMake(cell.center.x, cell.center.y);
        showLab.textAlignment = NSTextAlignmentCenter;
    
    }
    showImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    showLab.text = [self.menuItems objectAtIndex:indexPath.row];
    if ([_delectStr isEqualToString:showLab.text]) {
        showLab.textColor = [UIColor redColor];
    }
//    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    if (indexPath.row == self.menuItems.count-1) {
        cell.backgroundColor = [UIColor clearColor];
        showLab.textColor = [UIColor colorWithHexString:@"#919191"];
        showLab.frame = CGRectMake(showLab.frame.origin.x, showLab.frame.origin.y+12, showLab.frame.size.width, showLab.frame.size.height);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 12, UI_SCREEN_WIDTH, cell.frame.size.height)];//cell.frame.size.width
        view.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:view];
        [cell.contentView bringSubviewToFront:showLab];
        
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hide];
    [self.menuPopoverDelegate menuPopover:self didSelectMenuItemAtIndex:indexPath.row];
}

#pragma mark -
#pragma mark Actions

- (void)dismissMenuPopover
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
#pragma mark Separator Methods

- (void)addSeparatorImageToCell:(UITableViewCell *)cell
{
    UIImageView *separatorImageView = [[UIImageView alloc] initWithFrame:SEPERATOR_LINE_RECT];
    [separatorImageView setImage:[UIImage imageNamed:@"DefaultLine"]];
    separatorImageView.opaque = YES;
    [cell.contentView addSubview:separatorImageView];
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

@end
