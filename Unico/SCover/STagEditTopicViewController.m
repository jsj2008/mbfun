//
//  STagEditTopicViewController.m
//  Wefafa
//
//  Created by chencheng on 15/8/12.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "STagEditTopicViewController.h"

#import "SUtilityTool.h"

#import "SDataCache.h"

@interface STagEditTopicViewController ()
{
    UILabel *_titleLabel;
    
    int _page;
    int _numberOfPage;
    
    NSArray *_topicButtonArray;
    
    NSArray *_topicArray;
    
    UIButton *_updateTopicButton;
}
@end

@implementation STagEditTopicViewController


- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _page = 0;
        _numberOfPage = 7;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    NSMutableArray *topicButtonArray = [[NSMutableArray alloc] init];
    
    
    NSArray *colorArray = [NSArray arrayWithObjects:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:64.0/255.0 alpha:1.0],
                           [UIColor colorWithRed:255.0/255.0 green:137.0/255.0 blue:80.0/255.0 alpha:1.0],
                           [UIColor colorWithRed:180.0/255.0 green:114.0/255.0 blue:82.0/255.0 alpha:1.0],
                           [UIColor colorWithRed:244.0/255.0 green:202.0/255.0 blue:206.0/255.0 alpha:1.0],
                           [UIColor colorWithRed:145.0/255.0 green:218.0/255.0 blue:227.0/255.0 alpha:1.0],
                           [UIColor colorWithRed:86.0/255.0 green:213.0/255.0 blue:248.0/255.0 alpha:1.0],
                           [UIColor colorWithRed:183.0/255.0 green:227.0/255.0 blue:129.0/255.0 alpha:1.0], nil];
    
    for (int i=0; i<_numberOfPage; i++)
    {
        UIButton *topicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [topicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if (UI_SCREEN_WIDTH == 320)
        {
            topicButton.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        else
        {
            topicButton.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        
        topicButton.layer.cornerRadius = 20;
        topicButton.tag = i;
        [topicButtonArray addObject:topicButton];
        topicButton.hidden = YES;
        
        [topicButton addTarget:self action:@selector(topicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i < [colorArray count])
        {
            [topicButton setBackgroundColor:colorArray[i]];
        }
        else
        {
            [topicButton setBackgroundColor:colorArray[0]];
        }
        
        [self.view addSubview:topicButton];
    }
    
    _topicButtonArray = [topicButtonArray copy];
    
    _updateTopicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _updateTopicButton.frame = CGRectMake(0, 0, 200, 40);
    _updateTopicButton.center = CGPointMake(UI_SCREEN_WIDTH/2.0, UI_SCREEN_HEIGHT - 40);
    [_updateTopicButton setTitle:@"换一批看看" forState:UIControlStateNormal];
    [_updateTopicButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _updateTopicButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _updateTopicButton.layer.borderWidth = 1;
    if (UI_SCREEN_WIDTH == 320)
    {
        _updateTopicButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    else
    {
        _updateTopicButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    _updateTopicButton.layer.cornerRadius = 20;
    [_updateTopicButton addTarget:self action:@selector(updateTopicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_updateTopicButton];

    [self getTagEditTopicList];
}

/**
 *   构建导航栏
 */
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
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    _titleLabel.font = FONT_SIZE(18);
    _titleLabel.textColor = COLOR_WHITE;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"话题";
    
    self.navigationItem.titleView = _titleLabel;
}

- (void)updateView
{
    for (int i=0; i<[_topicArray count] && i<[_topicButtonArray count]; i++)
    {
        NSDictionary *topicDictionary = [_topicArray objectAtIndex:i];
        
        if (![topicDictionary isKindOfClass:[NSDictionary class]])
        {
            [MWKProgressIndicator showErrorMessage:@"服务器数据异常"];
            continue;
        }
        
        if (![topicDictionary[@"name"] isKindOfClass:[NSString class]])
        {
            [MWKProgressIndicator showErrorMessage:@"服务器数据异常"];
            continue;
        }
        
        NSString *topicName = [NSString stringWithFormat:@"#%@#", topicDictionary[@"name"]];
        
        UIButton *topicButton = [_topicButtonArray objectAtIndex:i];
        [topicButton setTitle:topicName forState:UIControlStateNormal];
        
        CGSize topicNameSize = [topicName sizeWithAttributes:@{NSFontAttributeName : topicButton.titleLabel.font}];
        
        if (i == 1 || i == 3)
        {
            if (topicNameSize.width > UI_SCREEN_WIDTH *2.0/3.0)
            {
                topicNameSize.width = UI_SCREEN_WIDTH *2.0/3.0;
            }
        }
        else if (i == 2 || i == 4)
        {
            UIButton *pretopicButton = [_topicButtonArray objectAtIndex:i-1];
            
            if (topicNameSize.width + pretopicButton.frame.size.width >  UI_SCREEN_WIDTH - 80)
            {
                topicNameSize.width = UI_SCREEN_WIDTH - 80 - pretopicButton.frame.size.width;
            }
        }
        else
        {
            if (topicNameSize.width > UI_SCREEN_WIDTH - 40)
            {
                topicNameSize.width = UI_SCREEN_WIDTH - 40;
            }
        }
        
        topicButton.frame = CGRectMake(0, 0, topicNameSize.width+40, 40);
        topicButton.hidden = YES;
    }
    
    float centerY = UI_SCREEN_HEIGHT/4.0;
    float originX = 0;
    
    for (int i=0; i<[_topicArray count] && i<[_topicButtonArray count]; i++)
    {
        UIButton *topicButton = [_topicButtonArray objectAtIndex:i];
        if (i == 0)
        {
            topicButton.center = CGPointMake(UI_SCREEN_WIDTH/2.0, centerY);
            
            centerY += topicButton.height + 10;
        }
        else if (i == 1)
        {
            if (i+1 < [_topicButtonArray count])
            {
                float nextButttonWidth = ((UIButton *)_topicButtonArray[i+1]).width;
                
                originX = (UI_SCREEN_WIDTH - topicButton.width - nextButttonWidth)/2.0;
                
                topicButton.center = CGPointMake(originX + topicButton.width/2.0 - 10, centerY);
            }
        }
        else if (i == 2)
        {
            float preButttonWidth = ((UIButton *)_topicButtonArray[i-1]).width;
            
            originX = (UI_SCREEN_WIDTH - topicButton.width - preButttonWidth)/2.0;
            
            topicButton.center = CGPointMake(UI_SCREEN_WIDTH-originX - topicButton.width/2.0 + 10, centerY);
            
            centerY += topicButton.height + 10;
        }
        else if (i == 3)
        {
            if (i+1 < [_topicButtonArray count])
            {
                float nextButttonWidth = ((UIButton *)_topicButtonArray[i+1]).width;
                
                originX = (UI_SCREEN_WIDTH - topicButton.width - nextButttonWidth)/2.0;
                
                topicButton.center = CGPointMake(originX + topicButton.width/2.0 - 10, centerY);
            }
        }
        else if (i == 4)
        {
            float preButttonWidth = ((UIButton *)_topicButtonArray[i-1]).width;
            
            originX = (UI_SCREEN_WIDTH - topicButton.width - preButttonWidth)/2.0;
            
            topicButton.center = CGPointMake(UI_SCREEN_WIDTH-originX - topicButton.width/2.0 + 10, centerY);
            
            centerY += topicButton.height + 10;
        }
        else if (i == 5)
        {
            topicButton.center = CGPointMake(UI_SCREEN_WIDTH/2.0, centerY);
            
            centerY += topicButton.height + 10;
        }
        else if (i == 6)
        {
            topicButton.center = CGPointMake(UI_SCREEN_WIDTH/2.0, centerY);
            
            centerY += topicButton.height + 10;
        }
        topicButton.hidden = NO;
    }

    
    
    for (int i=0; i<[_topicArray count] && i<[_topicButtonArray count]; i++)
    {
        UIButton *topicButton = [_topicButtonArray objectAtIndex:i];
        
        [UIView transitionWithView:topicButton duration:0.25 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (void)backButtonClick:(id)sender
{
    [self popAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

- (void)updateTopicButtonClick:(id)sender
{
    _page++;
    
    [self getTagEditTopicList];
}

- (void)topicButtonClick:(id)sender
{
    UIButton *topicButton = (UIButton *)sender;
    
    if (topicButton.tag >=0 && topicButton.tag < [_topicArray count])
    {
        NSDictionary *topicDictionary = _topicArray[topicButton.tag];
        
        if (self.completeFunc != nil)
        {
            self.completeFunc(topicDictionary[@"id"], topicDictionary[@"name"], @"");
        }
    }
}


#pragma mark - 获取网络数据的接口

/**
 *
 */
- (void) getTagEditTopicList
{
    _updateTopicButton.userInteractionEnabled = NO;
    
    [[SDataCache sharedInstance] getTagEditTopicListWithPage:_page numberOfPage:_numberOfPage complete:^(id object) {
        
        NSLog(@"getTagEditTopicListWithPage object = %@", object);
        
        _topicArray = object;
        
        [self updateView];
        
        _updateTopicButton.userInteractionEnabled = YES;
        
    } failure:^(NSError *error) {
        
        _updateTopicButton.userInteractionEnabled = YES;
        
        //错误信息提示
        [MWKProgressIndicator showErrorMessage:error.domain];
    }];
    
}

















@end
