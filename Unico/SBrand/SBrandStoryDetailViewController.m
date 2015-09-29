//
//  SBrandStoryDetailViewController.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/28.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBrandStoryDetailViewController.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "Toast.h"
#import "SBrandStoryDetailModel.h"

@interface SBrandStoryDetailViewController () <UIScrollViewDelegate>
{
    UITextView *detailStoryTextView;
    UIImageView *brandImgView;
    
    UIScrollView *_contentScroll;
}
@end

@implementation SBrandStoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    
    [self setupNavbar];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initView];
//    [self requestData];
}
-(void)requestData
{

    NSDictionary *data = @{
                           @"m": @"",
                           @"a": @""
                           };
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        
        if ([object[@"status"] intValue] != 1) {
            [Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
            return ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];

}
-(void)initView
{
    _contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationController.navigationBar.bottom)];
    [_contentScroll setBackgroundColor:COLOR_C4];
    _contentScroll.delegate = self;
    [self.view addSubview:_contentScroll];
    //头部brand icon
//    brandImgView=[[UIImageView alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH-50)/2, 64+10, 50, 50)];
    brandImgView=[[UIImageView alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH-100) / 2, 28, 100, 100)];
    [brandImgView setImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    brandImgView.layer.cornerRadius=brandImgView.frame.size.width/2;
    brandImgView.layer.masksToBounds=YES;
    [brandImgView setBackgroundColor:[UIColor whiteColor]];
    NSString * urlString =[_headerModel.logo_img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [brandImgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    
//    [self.view addSubview:brandImgView];
    [_contentScroll addSubview:brandImgView];
    //下部内容
//    detailStoryTextView=[[UITextView alloc]initWithFrame:CGRectMake(5, brandImgView.frame.origin.y+brandImgView.frame.size.height, UI_SCREEN_WIDTH-10, UI_SCREEN_HEIGHT-(brandImgView.frame.origin.y+brandImgView.frame.size.height))];
    detailStoryTextView=[[UITextView alloc]initWithFrame:CGRectMake(15, brandImgView.frame.origin.y+brandImgView.frame.size.height + 30, UI_SCREEN_WIDTH-30, UI_SCREEN_HEIGHT-(brandImgView.frame.origin.y+brandImgView.frame.size.height))];
    [detailStoryTextView setBackgroundColor:[UIColor clearColor]];
    detailStoryTextView.editable = NO;
    detailStoryTextView.text=[NSString stringWithFormat:@"%@",_headerModel.story];
    detailStoryTextView.userInteractionEnabled=NO;
    detailStoryTextView.textColor=[Utils HexColor:0x666666 Alpha:1];
    [detailStoryTextView sizeToFit];
//    [self.view addSubview:detailStoryTextView];
    [_contentScroll addSubview:detailStoryTextView];
    [_contentScroll setContentSize:CGSizeMake(UI_SCREEN_WIDTH, detailStoryTextView.bottom)];
}

- (void)setupNavbar {
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backHome:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"品牌故事";
}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height < UI_SCREEN_HEIGHT) {
        scrollView.alwaysBounceVertical = NO;
    }else {
        scrollView.alwaysBounceVertical = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
