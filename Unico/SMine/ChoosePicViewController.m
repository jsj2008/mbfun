//
//  ChoosePicViewController.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/27.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ChoosePicViewController.h"
#import "MNWheelView.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "Toast.h"

@interface ChoosePicViewController ()
{
    NSArray *picArray;
    int  chooseIndex;
    NSMutableArray *picMutableArray;
    UIImage *chooseImg;
}
@end

@implementation ChoosePicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[Utils HexColor:0X666666 Alpha:1]];
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setFrame:CGRectMake(10, UI_SCREEN_HEIGHT-30-44, UI_SCREEN_WIDTH-20, 44)];
    sureBtn.titleLabel.font=FONT_t1;
    [sureBtn setTitleColor:[Utils HexColor:0xffffff Alpha:1] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius=3.0f;
    sureBtn.layer.masksToBounds=YES;
    [sureBtn setBackgroundColor:[UIColor blackColor]];
    [sureBtn setTitle:@"确定选择" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(addPic:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureBtn];
    picMutableArray = [[NSMutableArray alloc]init];
    
    chooseImg=[[UIImage alloc]init];
    [self setupNavbar];
    [self requestData];
    
}
-(void)requestData
{
    //a=getSysUserBackImg&m=User
    NSDictionary *data = @{
                           @"m": @"User",
                           @"a": @"getSysUserBackImg"
                           };
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        
        if ([object[@"status"] intValue] != 1) {
            [Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
            return ;
        }
        picArray = [NSArray arrayWithArray:object[@"data"]];
        if ([picArray count]==0) {
            return;
        }
        [self initPic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}
-(void)initPic
{
    MNWheelView *view=[[MNWheelView alloc]initWithFrame:CGRectMake(0, 64+50, self.view.frame.size.width, UI_SCREEN_HEIGHT-64-50-165)];
    view.backgroundColor=[UIColor clearColor];
    for (int a=0;a<[picArray count]; a++) {
        
        [picMutableArray addObject:picArray[a][@"img"]];
        
    }
    chooseIndex = (int)[picMutableArray count]/2;
    view.images = [NSArray arrayWithArray:picMutableArray];

    view.click=^(int i ,UIImage *image)
    {
//        NSString *picUrl=picMutableArray[i-1];
        chooseIndex = i -1;
        chooseImg =image;
    };
    [self.view addSubview:view];
}
-(void)addPic:(id)sender
{
    NSString *picUrl=picMutableArray[chooseIndex];
    
    UIImageView *chooseImgS=[[UIImageView alloc]init];
    [chooseImgS sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_BIGLOADING]];
    chooseImg = chooseImgS.image;
    _clickPic(picUrl,chooseImg);
    [self backHome:nil];
    

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
    self.title=@"默认图";
}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
