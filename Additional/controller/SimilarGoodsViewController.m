//
//  SimilarGoodsViewController.m
//  Wefafa
//
//  Created by Miaoz on 14/12/17.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//废弃 不用 
#define kNavHeight 0
#define kDeviceWidth self.view.bounds.size.width
#define kDeviceHeight self.view.bounds.size.height
#define kTabBarHeight 60

#import "SimilarGoodsViewController.h"
#import "GoodsCollectionCell.h"
#import "Globle.h"
#import "DetailMapping.h"


@interface SimilarGoodsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GoodsCollectionCellDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataarray;
@property(nonatomic,strong)UILabel *centerLable;
@property(nonatomic,strong)NSString *productId;
@end

@implementation SimilarGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor clearColor];
    if (_dataarray == nil) {
        _dataarray = [NSMutableArray new];
    }
    [self creatCenterLable];
    [self initCollectionView];
    [self requestRequestGetProductClsFilterWithDicWithdic:(NSMutableDictionary *)@{@"id":[NSNumber numberWithInt:_productId.intValue]}];
    //     [self addFooter];
    
}
-(void)setDatasource:(id)datasource{
    _datasource = datasource;
    
    if ([_datasource isKindOfClass:[GoodObj class]]) {
        GoodObj *goodobj = (GoodObj *)_datasource;
        _productId = goodobj.clsInfo.id;
    }else if([_datasource isKindOfClass:[DetailMapping class]]){
        DetailMapping *detailMapping = (DetailMapping *)_datasource;
        _productId = detailMapping.productClsId;
    }
    
}
#pragma mark --没有获得数据时提示
-(void)creatCenterLable{
    if (_centerLable == nil) {
        UILabel *lab;
        lab = [UILabel new];
        lab.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        CGFloat centerY = self.view.bounds.size.height - 100;
        lab.center = CGPointMake(self.view.bounds.size.width/2, centerY/2);
        //        lab.center = self.view.center;
        lab.text = @"没有商品";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont boldSystemFontOfSize:30.0f];
        _centerLable = lab;
        lab.hidden = YES;
        [self.view addSubview:lab];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化是这样初始化的。
-(void) initCollectionView{
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(107, 107);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavHeight, kDeviceWidth+1, kDeviceHeight-60) collectionViewLayout:flowLayout];
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.tag = 111;
        //注册
        [self.collectionView registerClass:[GoodsCollectionCell class] forCellWithReuseIdentifier:@"GoodsCollectionCell"];
        
        //设置代理
        
        self.collectionView.delegate = self;
        
        self.collectionView.dataSource = self;
        
        [self.view addSubview:self.collectionView];
        
        
    }
}

#pragma mark ---搜索关键字商品接口
#pragma mark --商品搜索接口
-(void)requestRequestGetProductClsFilterWithDicWithdic:(NSMutableDictionary *)dic
{
    [[HttpRequest shareRequst] httpRequestGetProductClsFilterWithDic:dic success:^(id obj) {
        // 商品颜色款
        id data = [obj objectForKey:@"results"];
        if ([data isKindOfClass:[NSArray class]])
        {
            if (data != nil)
            {
                
                for (NSDictionary *dic in data)
                {
                    
                    //商品基本信息
                    NSDictionary *clsInfodic = [dic objectForKey:@"clsInfo"];
                    ClsInfo *clsinfo =[JsonToModel objectFromDictionary:clsInfodic className:@"ClsInfo"];
                    
                    //获得所有商品颜色
                    NSMutableArray *parsercolorArray = [NSMutableArray new];
                    NSArray * colorarray = [dic objectForKey:@"colorList"];
                    if (colorarray != nil)
                    {
                        for (NSDictionary *colorDic in colorarray)
                        {
                            ProductColorMapping *productColorMapping = [JsonToModel objectFromDictionary:colorDic className:@"ProductColorMapping"];
                            [parsercolorArray addObject:productColorMapping];
                        }
                    }
                    
                    
                    //商品图片url
                    NSArray * clsPicUrlarray = [dic objectForKey:@"clsPicUrl"];
                    for (NSDictionary *clspicDic in clsPicUrlarray)
                    {
                        GoodObj *goodobj = [GoodObj new];
                        
                        
                        goodobj.clsInfo = clsinfo;
                        //1.6 add by miao
                        //判断是否是商品标示 1代表商品 2是素材////判断是否是商品标示 1代表商品 goodobj.sourceType = [NSString stringWithFormat:@"1"];
                        goodobj.sourceType = [NSString stringWithFormat:@"%@",goodobj.clsInfo.proD_FLAG];
                        
                        ClsPicUrl *clsPicurl = [JsonToModel objectFromDictionary:clspicDic className:@"ClsPicUrl"];
                        NSLog(@"clsPicurl.srC_TYPE -------%@",clsPicurl.srC_TYPE );
                        if ([clsPicurl.srC_TYPE isEqualToString:@"ProdColor"]&& clsPicurl.isMainImage.intValue == 0)
                        {
                            goodobj.clsPicUrl = clsPicurl;
                            for (ProductColorMapping *productColorMapping in parsercolorArray)
                            {
                                if (clsPicurl.srC_ID.intValue == productColorMapping.id.intValue)
                                {
                                    goodobj.productColorMapping = productColorMapping;
                                }
                            }
                            [_dataarray addObject:goodobj];
                        }
                        
                        
                    }
                    
                }
                
            }
            if (_dataarray.count == 0)
            {
                _centerLable.hidden = NO;
            }else
            {
                _centerLable.hidden = YES;
                
                //                self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#acacac"];
                
            }
            [self.collectionView reloadData];
            
        }
        
        
    } fail:^(NSString *errorMsg) {
        
    }];
    
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
// {
// return CGSizeMake(106, 106);
// }
//
// //定义每个UICollectionView 的 margin
// -(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
// {
// return UIEdgeInsetsMake(0,0,0, 0);
// }
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return -0.6;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataarray == nil || _dataarray.count == 0) {
        return 0;
    }
    return _dataarray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCollectionCell *cell =(GoodsCollectionCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.likeButton.hidden = YES;
    
    if (_dataarray == nil || _dataarray.count == 0) {
        return nil;
    }
    
    if (indexPath.section == 0) {
        cell.topLineImageView.hidden = YES;
    }
    
    GoodObj *goodobj = _dataarray[indexPath.row];
    // Configure the cell
    cell.goodObj = goodobj;
    
    if (goodobj.clsPicUrl.filE_PATH == nil || goodobj.clsPicUrl.filE_PATH == NULL) {
        cell.imageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        
    }else {
        
        NSString *imageurl =  [self changeStringWithurlString:goodobj.clsPicUrl.filE_PATH];
        //缓存图片
        UIImageFromURLTOCache([NSURL URLWithString:imageurl], imageurl, ^(UIImage *image) {
            cell.imageView.image = image;
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }, ^{
            cell.imageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        });
        
    }
    
    return cell;
}

-(NSString *)changeStringWithurlString:(NSString *)imageurl{
    NSMutableString *mainurlString;
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:imageurl];
    NSRange range = [String1 rangeOfString:@"--"];
    
    int location = (int)range.location;
    int leight = (int)range.length;
    
    if (leight == 2) {////有--400x400
        mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
        [mainurlString appendString:[NSString stringWithFormat:@".png"]];
        
        
    }else{//没有--400x400 //有后缀.png
        NSRange range = [String1 rangeOfString:@".png"];
        
        int leight = (int)range.length;
        if (leight == 4){//有后缀.png
            
            mainurlString = [[NSMutableString alloc] initWithString:String1];
            
        }else{//没有后缀png
            
            //后缀jpg
            NSRange range2 = [String1 rangeOfString:@".jpg"];
            int location2 = (int)range2.location;
            int leight2 = (int)range2.length;
            if (leight2 == 4){//有后缀.jpg
                
                mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location2]];
                [mainurlString appendString:[NSString stringWithFormat:@".jpg"]];
            }else{//没有后缀
                
                mainurlString = [[NSMutableString alloc] initWithString:String1];
                [mainurlString appendString:[NSString stringWithFormat:@".png"]];
                
            }
            
            
        }
        
    }
    
    [mainurlString insertString:[NSString stringWithFormat:@"--%dx%d",(int)200,(int)200] atIndex:mainurlString.length -4];
    NSLog(@"mainurlString--------%@",mainurlString);
    return mainurlString;
}


#pragma mark <UICollectionViewDelegate>



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodObj *goodobj = _dataarray[indexPath.row];
    //12.12 add by miao
    if (goodobj.clsPicUrl.filE_PATH == nil || goodobj.clsPicUrl.filE_PATH == NULL) {
        
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_ADDCHOOSEGOODS object:nil userInfo:@{@"GoodObj":goodobj}];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- GoodsCollectionCellDelegate
-(void)callBackGoodsCollectionCellWithjudgeType:(id)sender withGoodobj:(id)senderobj{
    
    NSString *judgetype = [NSString stringWithFormat:@"%@",sender];
    GoodObj *goodobj = (GoodObj *)senderobj;
    if (judgetype.intValue == 1) {//喜欢@"9999" @"ios-miao"
        //add by miao 11.14
        //      SNSStaffFull *userinfo =  [[Globle shareInstance] getUserInfo];
        //add by miao 11.26
        [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
        }complete:^(SNSStaffFull *staff, BOOL success){
            if (success)
            {
                [self requestFavoriteCreateWithdic:(NSMutableDictionary *)@{@"UserId":sns.ldap_uid,@"SOURCE_ID":goodobj.clsInfo.id,@"SOURCE_TYPE":@"1",@"Create_User":staff.nick_name}];
            }
        }];
        
        
    }else{//取消喜欢
        
        [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
        }complete:^(SNSStaffFull *staff, BOOL success){
            if (success)
            {
                
                [self requestFavoriteDeleteWithdic:(NSMutableDictionary *)@{@"SourceIds":[NSString stringWithFormat:@"%@",goodobj.clsInfo.id],@"SOURCE_TYPE":@"1",@"UserId":sns.ldap_uid}];
            }
        }];
        
    }
    
}

#pragma 请求喜欢接口
-(void)requestFavoriteCreateWithdic:(NSMutableDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestPostFavoriteCreateWithdic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"喜欢成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定" ,nil];
            [alert show];
        }
        
    } fail:^(NSString *errorMsg) {
        
    }];
    
}
#pragma 请求取消喜欢接口
-(void)requestFavoriteDeleteWithdic:(NSMutableDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestPostFavoriteDeleteWithDic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消喜欢成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: @"确定",nil];
            [alert show];
        }
    } fail:^(NSString *errorMsg) {
        
    }];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)leftBarButtonItemClickevent:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
