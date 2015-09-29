//
//  MyStoreViewController.m
//  Wefafa
//
//  Created by su on 15/1/26.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MyStoreViewController.h"
#import "MBShoppingGuideInterface.h"
#import "MyStoreCell.h"
#import "NavigationTitleView.h"
#import "WeFaFaGet.h"
#import "Toast.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "ASIHTTPRequest.h"
#import "Utils.h"
#import "UIImageView+AFNetworking.h"

@interface MyStoreViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    UITableView *_storeTable;
    NSMutableArray *dataArray;
    StoreModel *storeInfo;
    UIUrlImageView *_bgImage;
    UILabel *_acountLabel;
    
    NSInteger currentPage;
    NSInteger pageSize;
    NSInteger totalCount;
    
    UIView *photoView;
    
    UIView *attentionView;
    NavigationTitleView *naviView;
}

@end

@implementation MyStoreViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    naviView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [naviView createTitleView:CGRectMake(0, 0, 320, 44) delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    if (!self.naviTitle) {
        self.naviTitle = @"我的店铺";
    } else {
        if ([self.naviTitle length] <= 0) {
            self.naviTitle = @"他的店铺";
        }
    }
    naviView.lbTitle.text=self.naviTitle;
    [self.view addSubview:naviView];
    
    currentPage = 1;
    pageSize = 10;
    
    if (!self.userId) {
        self.userId = sns.ldap_uid;
    }
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
    __weak MyStoreViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf networkRequestIsPull:NO];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf requestBasicStoreInfo];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickCollocationView:) name:kMyStoreCollocationNotifyKey object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_storeTable) {
        CGFloat tableHeight = 44;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            tableHeight = 64;
        }
        _storeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, tableHeight, self.view.frame.size.width, self.view.frame.size.height - tableHeight) style:UITableViewStylePlain];
        [_storeTable setDataSource:self];
        [_storeTable setDelegate:self];
        [_storeTable setShowsVerticalScrollIndicator:NO];
        [_storeTable setBackgroundColor:[UIColor whiteColor]];
        [_storeTable setSeparatorColor:[UIColor clearColor]];
        [_storeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_storeTable];
        
        [self addFooter];
        [self addHeader];
    }
}

- (void)addHeader
{
    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    currentPage = 1;
    [_storeTable addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf networkRequestIsPull:YES];
            [weakSelf requestBasicStoreInfo];
        });
    }];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [_storeTable addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        
        if ([weakSelf isNoMoreData]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateViewWithRequestSuccess:YES message:@"没有更多信息"];
            });
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakSelf networkRequestIsPull:NO];
            });
        }
    }];
}

- (BOOL)isNoMoreData
{
    if (totalCount == 0) {
        return NO;
    }
    if (totalCount > dataArray.count) {
        return NO;
    }
    return YES;
}

- (void)showRequestToast
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
}

- (void)updateViewWithRequestSuccess:(BOOL)isSuccess message:(NSString *)message
{
    if (isSuccess) {
        [_storeTable reloadData];
    }
    [_storeTable footerEndRefreshing];
    [_storeTable headerEndRefreshing];
    [Toast hideToastActivity];
    if (!message || [message isEqual:[NSNull null]] || [message isEqualToString:@""]) {
        return;
    }
    [Toast makeToast:message];
    
}

- (void)didClickCollocationView:(NSNotification *)notify
{

}

- (UIView *)tableHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 166)];
    _bgImage = [[UIUrlImageView alloc] initWithFrame:header.bounds];
//    _bgImage.contentMode = UIViewContentModeScaleAspectFill;
//    _bgImage.layer.masksToBounds = YES;
    [header addSubview:_bgImage];
    [header setClipsToBounds:YES];
    
    if ([sns.ldap_uid length]>0 && [sns.ldap_uid isEqualToString:self.userId]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeStoreBg)];
        [header addGestureRecognizer:tap];
    }
    
    UIView *assetView = [[UIView alloc] initWithFrame:CGRectMake(88, 86, 144, 80)];
    [assetView setBackgroundColor:[UIColor redColor]];
    [header addSubview:assetView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 100, 20)];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:@"店铺资产（元）"];
    [assetView addSubview:label];
    
    _acountLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 35, 136, 36)];
    [_acountLabel setFont:[UIFont systemFontOfSize:30]];
    [_acountLabel setAdjustsFontSizeToFitWidth:YES];
    [_acountLabel setTextColor:[UIColor whiteColor]];
    [_acountLabel setTextAlignment:NSTextAlignmentLeft];
    [assetView addSubview:_acountLabel];
    
    return header;
}

-(void)downloadImage:(UIUrlImageView* )imageView url:(NSString *)url
{
    if (imageView==nil) return;
    NSString *defaultImg=@"home_cell_default@2x.png";
    if (!url || [url isEqual:[NSNull null]]) {
        [imageView setImage:[UIImage imageNamed:defaultImg]];
    }else {
         NSString *urlValue = [Utils convertImageUrl:url WithFixedWidth:self.view.frame.size.width * 2 height:600];
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlValue]];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            [imageView setImageAFWithURLRequest:request placeholderImage:[UIImage imageNamed:defaultImg] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                if (image) {
                    [weakSelf performSelectorOnMainThread:@selector(resizeImageWithImage:) withObject:image waitUntilDone:NO];
//                    [weakSelf resizeImageWithImage:image inImageView:nil];
                }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
        });
        
        
//        [imageView downloadImageUrl:[CommMBBusiness changeStringWithurlString:url size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
//    }
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *urlValue = [Utils convertImageUrl:url WithFixedWidth:self.view.frame.size.width * 2 height:166 * 2];
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlValue]];
//        NSData *imgData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (imgData) {
//                UIImage *image = [UIImage imageWithData:imgData];
//                [self resizeImageWithImage:image inImageView:_bgImage];
//            }
//            
//        });
//    });
    }
    
}

- (void)resizeImageWithImage:(UIImage *)image
{
    [self resizeImageWithImage:image inImageView:nil];
}

- (void)resizeImageWithImage:(UIImage *)image inImageView:(UIImageView *)imgView
{
    if (!imgView) {
        imgView = _bgImage;
    }
    if (!image) {
        image = [UIImage imageNamed:@"home_cell_default@2x.png"];
    }else{
        CGRect frame = imgView.frame;
        CGFloat scaleValue = 1.0;
        if (image.size.width > frame.size.width) {
            scaleValue = frame.size.width / image.size.width;
        }
        frame.size.height = image.size.height * scaleValue;
        imgView.frame = frame;
    }
    [imgView setImage:image];
}

-(void)backHome:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//da36fd98-10fa-4cc3-8455-7a2e6263d6b2

- (void)updateTable
{
    [_storeTable reloadData];
}

- (void)requestBasicStoreInfo
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableString *message = [[NSMutableString alloc] init];
    BOOL request = [[MBShoppingGuideInterface create] requestGetUrlName:@"StoreBasicFilter" param:(NSMutableDictionary *)@{@"UserId":self.userId} responseAll:responseDict responseMsg:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request) {
            NSDictionary *basicInfo = [[responseDict objectForKey:@"results"] lastObject];
            storeInfo = [[StoreModel alloc] initWithInfo:basicInfo];
            if ([storeInfo.storeAccout integerValue] > 0) {
                [weakSelf uploadTableViewIsTableView:NO];
            } else {
                attentionView = [[UIView alloc] initWithFrame:CGRectMake(0, naviView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - naviView.frame.size.height)];
                [attentionView setBackgroundColor:[UIColor whiteColor]];
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 47)/2, 170, 47, 50)];
                [imgView setImage:[UIImage imageNamed:@"btn-store@2x.png"]];
                [attentionView addSubview:imgView];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 20)];
                [label setBackgroundColor:[UIColor whiteColor]];
                [label setTextColor:[UIColor lightGrayColor]];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setText:@"暂无内容!"];
                [label setFont:[UIFont systemFontOfSize:14.0]];
                [attentionView addSubview:label];
                [self.view addSubview:attentionView];
            }
        }else{
            [_storeTable setTableHeaderView:nil];
        }
    });
}

- (void)networkRequestIsPull:(BOOL)isPull
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableString *message = [[NSMutableString alloc] init];

    if (!dataArray) {
        dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (isPull) {
        currentPage = 1;
        [dataArray removeAllObjects];
        [weakSelf performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:NO];
    }
     BOOL request = [[MBShoppingGuideInterface create] requestGetUrlName:@"WxCollocationBasicInfoFilter" param:(NSMutableDictionary *)@{@"UserIds":self.userId,@"commonStatus":@"Myself",@"pageIndex":[NSNumber numberWithInt:(int)currentPage],@"pageSize":[NSNumber numberWithInt:(int)pageSize]} responseAll:responseDict responseMsg:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request) {
            NSArray *collocationArr = [responseDict objectForKey:@"results"];
            if (collocationArr.count > 0) {
                currentPage += 1;
            }
            for(NSDictionary *dict in collocationArr){
                if (dict) {
                    CollocationDetail *aInfo = [[CollocationDetail alloc] initWithInfo:dict];
                    [dataArray addObject:aInfo];
                }
            }
            [self updateViewWithRequestSuccess:YES message:nil];
        }else{
            [self updateViewWithRequestSuccess:NO message:nil];
        }
    });
    
    
    
//    __weak MyStoreViewController *weakSelf = self;
//    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] initWithCapacity:0];
//    NSMutableString *message = [[NSMutableString alloc] init];
//    
//    if (!dataArray) {
//        dataArray = [[NSMutableArray alloc] initWithCapacity:0];
//    }
//    if (isPull) {
//        currentPage = 1;
//        [dataArray removeAllObjects];
//        [weakSelf performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:NO];
//    }
//
//    BOOL request = [[MBShoppingGuideInterface create] requestGetUrlName:@"StorePersonalInfoFilter" param:(NSMutableDictionary *)@{@"UserId":self.userId,@"pageIndex":[NSNumber numberWithInt:currentPage],@"pageSize":[NSNumber numberWithInt:pageSize]} responseAll:responseDict responseMsg:message];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (request) {
//            if ([responseDict objectForKey:@"results"]) {
//                totalCount = [[responseDict objectForKey:@"total"] integerValue];
//                NSArray *array = [responseDict objectForKey:@"results"];
//                for (int i = 0; i < array.count; i ++) {
//                    NSDictionary *dict = [array objectAtIndex:i];
//                    NSDictionary *basicInfo = [dict objectForKey:@"storeBasicInfo"];
//                    if (basicInfo) {
//                        storeInfo = [[StoreModel alloc] initWithInfo:basicInfo];
//                        if (storeInfo) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [weakSelf uploadTableViewIsTableView:NO];
//                            });
//                            
//                        } else {
//                            [_storeTable setTableHeaderView:nil];
//                        }
//                        NSArray *collocationArr = [dict objectForKey:@"collocationList"];
//                        if (collocationArr.count > 0) {
//                            currentPage += 1;
//                        }
//                        for(NSDictionary *dict in collocationArr){
//                            if (dict) {
//                                CollocationDetail *aInfo = [[CollocationDetail alloc] initWithInfo:dict];
//                                [dataArray addObject:aInfo];
//                            }
//                        }
//                    }
//                }
//                [self updateViewWithRequestSuccess:YES message:nil];
//                
//            }
//        }else {
//            [self updateViewWithRequestSuccess:NO message:@"获取失败"];
//        }
//    });
    
}

- (void)uploadTableViewIsTableView:(BOOL)isTable
{
    if (isTable) {
        [_storeTable reloadData];
    } else {
        if (attentionView) {
            [attentionView removeFromSuperview];
            attentionView = nil;
        }
        [_storeTable setTableHeaderView:[self tableHeaderView]];
        if ([self.naviTitle isEqualToString:@"他的店铺"] && [storeInfo.storeName length] > 0) {
            naviView.lbTitle.text = [NSString stringWithFormat:@"%@的店铺",storeInfo.storeName];
        }
        [_acountLabel setText:[NSString stringWithFormat:@"¥ %@",storeInfo.storeAccout]];
        [self downloadImage:_bgImage url:storeInfo.backGround];
        
    }
}

#pragma mark uitableview datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = dataArray.count / 2;
    num = (dataArray.count % 2 ==0) ? num : num +1;
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *storeCell = @"storeCell";
    MyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCell];
    if (cell == nil) {
        cell = [[MyStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
   NSInteger index =  indexPath.row * 2;
    if ((index + 1) == dataArray.count) {
        [cell updateCellWithLeftInfo:[dataArray objectAtIndex:index] rightInfo:nil];
    }else{
        if (dataArray.count >= indexPath.row * 2) {
           [cell updateCellWithLeftInfo:[dataArray objectAtIndex:index] rightInfo:[dataArray objectAtIndex:index + 1]];
        }
    }
    
    return cell;
}

- (void)changeStoreBg
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:
                   @"相机",@"从相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [actionSheet showInView:[AppDelegate shareAppdelegate].window];
    return;
    if (photoView)
    {
        [self dismissPhotoViewUseAnimation:NO];
        return;
    }
    
    photoView = [[UIView alloc] initWithFrame:self.view.bounds];
    [photoView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelOpen)];
    [photoView addGestureRecognizer:tap];
    [self.view addSubview:photoView];
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 140)];
    
    [aView setBackgroundColor:[UIColor whiteColor]];
    [photoView addSubview:aView];
    
    [self configBtn:10 title:@"相册" selector:@selector(openPhoto) inView:aView];
    [self configBtn:50 title:@"相机" selector:@selector(openCamera) inView:aView];
    [self configBtn:90 title:@"取消" selector:@selector(cancelOpen) inView:aView];
    
    [UIView animateWithDuration:0.5 animations:^{
        [aView setFrame:CGRectMake(0, self.view.frame.size.height - 140, self.view.frame.size.width, 140)];
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self openCamera];
    }else if (buttonIndex == 1){
        [self openPhoto];
    }
}


- (void)configBtn:(CGFloat)yPoint title:(NSString *)title selector:(SEL)selector inView:(UIView *)view
{
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setFrame:CGRectMake((self.view.frame.size.width - 200)/2, yPoint, 200, 30)];
    [imageBtn setBackgroundColor:[UIColor whiteColor]];
    [imageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imageBtn.layer setCornerRadius:4.0];
    [imageBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [imageBtn.layer setBorderWidth:1.0];
    [imageBtn setTitle:title forState:UIControlStateNormal];
    [imageBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:imageBtn];
}

- (void)dismissPhotoViewUseAnimation:(BOOL)isAnimation
{
    if (!isAnimation) {
        [photoView removeFromSuperview];
        photoView = nil;
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        if (photoView) {
            [photoView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
        }
        
    } completion:^(BOOL finished) {
        [photoView removeFromSuperview];
        photoView = nil;
    }];
    
}

- (void)cancelOpen
{
    [self dismissPhotoViewUseAnimation:YES];
}


- (void)openPhoto
{
    [self dismissPhotoViewUseAnimation:NO];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持相册功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self imagePickWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持照相功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self imagePickWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)imagePickWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if (image) {
        [self resizeImageWithImage:image inImageView:_bgImage];
    }
    
    
    __weak MyStoreViewController *weakSelf = self;
     [Toast makeToastActivity:@"正在上传图片" hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf uploadBackGroundImage:image];
    });

    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)uploadBackGroundImage:(UIImage *)image
{
    [self dismissPhotoViewUseAnimation:NO];
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableString *message = [[NSMutableString alloc] init];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *imgStr =[ASIHTTPRequest base64forData:imageData];
    
    BOOL request = [[MBShoppingGuideInterface create] requestPostUrlName:@"StoreSetBackGround" param:
                    (NSMutableDictionary *)@{@"UserId":sns.ldap_uid,@"PictureType":@"png",@"backGroundData":imgStr} responseAll:responseDict responseMsg:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = @"";
        if (request) {
            message = @"更新成功";
        }else {
            message = @"更新失败";
        }
        [Toast hideToastActivity];
        [Toast makeToast:message];
    });
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissPhotoViewUseAnimation:NO];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
