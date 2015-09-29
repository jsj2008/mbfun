//
//  GoodsDetailVC.m
//  Wefafa
//
//  Created by Miaoz on 15/3/26.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//
// 废弃不用  解锁商品
#import "GoodsDetailVC.h"
#import "Globle.h"
#import "GoodObj.h"
#import "TemplateCollocationMatchVC.h"
@interface GoodsDetailVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *brandLab;
@property (weak, nonatomic) IBOutlet UIView *bootomView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UILabel *likeLab;

@end

@implementation GoodsDetailVC

-(void)setGoodObj:(GoodObj *)goodObj{
    _goodObj = goodObj;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _goodObj.clsInfo.name;
     [self SetLeftButton:nil Image:@"ion_back"];
//    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _addButton.layer.masksToBounds = YES;
    _addButton.layer.cornerRadius = 3.0f;
    [self requestGetJugeFavoriteFilterWithDic:@{@"UserId":sns.ldap_uid, @"SOURCE_ID":_goodObj.clsInfo.id, @"SOURCE_TYPE":@"1"}];
    NSMutableArray *list = [NSMutableArray new];
    NSMutableString *msg;
    
    if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"CommonCountTotalFilter" param:@{@"sourcE_IDS":_goodObj.clsInfo.id,@"sourcE_TYPE":@"1"} responseList:list responseMsg:msg]) {
        _likeLab.text = [NSString stringWithFormat:@"%@",list[0][@"favoritCount"]];
    }
    
    [_heartButton addTarget:self action:@selector(heartClickevent:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)requestGetJugeFavoriteFilterWithDic:(NSDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestGetJugeFavoriteFilterWithDic:(NSMutableDictionary *)dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1 )
        {
            NSString *total =[obj objectForKey:@"total"];
            if (total.intValue>0) {
                if (_goodObj != nil) {
                    [self getdataSourceWithjuge:YES];
                }
            }else{
                if (_goodObj != nil) {
                    [self getdataSourceWithjuge:NO];
                }
            }
            
        }
       
    } fail:^(NSString *errorMsg) {
        
    }];
}

-(void)getdataSourceWithjuge:(BOOL)islike{

    NSString *imageurl = [CommMBBusiness changeStringWithurlString:_goodObj.clsPicUrl.filE_PATH width:200 height:200];
    //缓存图片
    UIImageFromURLTOCache([NSURL URLWithString:imageurl], imageurl, ^(UIImage *image) {
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
        _imageView.image = image;
    
    }, ^{
         _imageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    });

        _priceLab.text = [NSString stringWithFormat:@"￥%@",_goodObj.clsInfo.sale_price];

    if (_goodObj.clsInfo.brand.length != 0) {
        _brandLab.text = [NSString stringWithFormat:@"%@",_goodObj.clsInfo.brand];
    }
    
    if (islike) {
        [_heartButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    }else{
    [_heartButton setImage:[UIImage imageNamed:@"heart-narmal"] forState:UIControlStateNormal];
    }
   
}

-(void)heartClickevent:(UIButton *)sender{
    if ([sender.currentImage isEqual:[UIImage imageNamed:@"heart"]]) {
        
      
                [self requestFavoriteDeleteWithdic:(NSMutableDictionary *)@{
                                                                            @"userId":sns.ldap_uid,
                                                                            @"sourceIdS":_goodObj.clsInfo.id,
                                                                            @"SOURCE_TYPE":@"1",
                                                                           
                                                                            }];
      
        //删除like
       
    }else{
        
        [CommMBBusiness getStaffInfoByStaffID:[AppSetting getFafaJid] staffType:STAFF_TYPE_OPENID defaultProcess:^{
        }complete:^(SNSStaffFull *staff, BOOL success){
            if (success)
            {
                [self requestFavoriteCreateWithdic:(NSMutableDictionary *)@{
                                                                            @"SOURCE_ID":_goodObj.clsInfo.id,
                                                                            @"userId":sns.ldap_uid,
                                                                            @"SOURCE_TYPE":@"1",
                                                                            @"CREATE_USER":staff.nick_name
                                                                            }];

                
            }}];
        
       
    
    }


}
#pragma 请求喜欢接口
-(void)requestFavoriteCreateWithdic:(NSMutableDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestPostFavoriteCreateWithdic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
             [_heartButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
            NSMutableArray *list = [NSMutableArray new];
            NSMutableString *msg;
            
            if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"CommonCountTotalFilter" param:@{@"sourcE_IDS":_goodObj.clsInfo.id,@"sourcE_TYPE":@"1"} responseList:list responseMsg:msg]) {
                _likeLab.text = [NSString stringWithFormat:@"%@",list[0][@"favoritCount"]];
            }
        }
        
    } fail:^(NSString *errorMsg) {
        
    }];
    
}
#pragma 请求取消喜欢接口
-(void)requestFavoriteDeleteWithdic:(NSMutableDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestPostFavoriteDeleteWithDic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
              [_heartButton setImage:[UIImage imageNamed:@"heart-narmal"] forState:UIControlStateNormal];
            NSMutableArray *list = [NSMutableArray new];
            NSMutableString *msg;
            
            if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"CommonCountTotalFilter" param:@{@"sourcE_IDS":_goodObj.clsInfo.id,@"sourcE_TYPE":@"1"} responseList:list responseMsg:msg]) {
                _likeLab.text = [NSString stringWithFormat:@"%@",list[0][@"favoritCount"]];
            }
        }
    } fail:^(NSString *errorMsg) {
        
    }];
    
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

- (IBAction)addDataSourceClick:(id)sender {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
    
         if ([vc isKindOfClass:[TemplateCollocationMatchVC class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_ADDCHOOSEGOODS object:nil userInfo:@{@"GoodObj":_goodObj}];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
   
}
@end
