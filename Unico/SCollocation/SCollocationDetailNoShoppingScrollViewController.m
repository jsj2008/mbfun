//
//  SCollocationDetailNoShoppingScrollViewController.m
//  Wefafa
//
//  Created by chencheng on 15/7/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SCollocationDetailNoShoppingScrollViewController.h"

@interface SCollocationDetailNoShoppingScrollViewController ()<UIScrollViewDelegate>

@end

@implementation SCollocationDetailNoShoppingScrollViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)loadView
{
    [super loadView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    
    
    _scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [self.view addSubview:_scrollView];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    //_scrollView.delegate = self;
    
    //NSLog(@"self.collocationIdArray.count = %d", self.collocationIdArray.count);
    
    if (self.collocationIdArray.count > 0)
    {
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.collocationIdArray.count, [UIScreen mainScreen].bounds.size.height);
    }
    else
    {
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    
    if (self.currentcollocationIdIndex >=0 && self.currentcollocationIdIndex < self.collocationIdArray.count)
    {
        _scrollView.contentOffset = CGPointMake(self.currentcollocationIdIndex * _scrollView.bounds.size.width, 0);
        
        _detailNoShoppingViewController2 = [[SCollocationDetailNoneShopController alloc] init];
        _detailNoShoppingViewController2.collocationId =  [self.collocationIdArray objectAtIndex:self.currentcollocationIdIndex];
        
        [_scrollView addSubview:_detailNoShoppingViewController2.view];
        

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            _detailNoShoppingViewController2.view.frame = CGRectMake(_scrollView.contentOffset.x, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        });
        
        
        
        
        _detailNoShoppingViewController2.view.layer.borderColor = [UIColor greenColor].CGColor;
        _detailNoShoppingViewController2.view.layer.borderWidth = 3;
        
      /*  if (self.currentcollocationIdIndex - 1 > 0)
        {
            _detailNoShoppingViewController1 = [[SCollocationDetailNoneShopController alloc] init];
            _detailNoShoppingViewController1.collocationId =  [[self.collocationIdArray objectAtIndex:self.currentcollocationIdIndex-1] intValue];
            [_scrollView addSubview:_detailNoShoppingViewController1.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _detailNoShoppingViewController1.view.frame = CGRectMake(_scrollView.contentOffset.x - _scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
            });
            
            _detailNoShoppingViewController1.view.layer.borderColor = [UIColor redColor].CGColor;
            _detailNoShoppingViewController1.view.layer.borderWidth = 3;
        }
        
        if (self.currentcollocationIdIndex + 1 < self.collocationIdArray.count)
        {
            _detailNoShoppingViewController3 = [[SCollocationDetailNoneShopController alloc] init];
            _detailNoShoppingViewController3.collocationId =  [[self.collocationIdArray objectAtIndex:self.currentcollocationIdIndex+1] intValue];
            [_scrollView addSubview:_detailNoShoppingViewController3.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _detailNoShoppingViewController3.view.frame = CGRectMake(_scrollView.contentOffset.x + _scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
            });
            
            _detailNoShoppingViewController3.view.layer.borderColor = [UIColor blueColor].CGColor;
            _detailNoShoppingViewController3.view.layer.borderWidth = 3;
        }*/
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
