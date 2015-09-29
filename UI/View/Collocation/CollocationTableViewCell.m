 //
//  CollocationTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
//废弃  以前的搭配首页
#import "CollocationTableViewCell.h"
#import "AppSetting.h"
#import "WeFaFaGet.h"
#import "Utils.h"
#import "CommMBBusiness.h"
#import "ImageHeadListView.h"
#import "SQLiteOper.h"

////////////////////////////
#import "RootViewController.h"
#import "AppDelegate.h"
#import "MBShoppingGuideInterface.h"

#define RIGHT_MARGIN 13

@implementation CollocationTableViewCell
@synthesize collocationLikeArray;

- (void)awakeFromNib
{
    self.contentView.backgroundColor=COLLOCATION_TABLE_BG;
    requestLock = [[NSLock alloc]init];
    
    _lbCollocationName.textColor=[Utils HexColor:0xffffff Alpha:1.0];
    _lbDesigner.textColor=[Utils HexColor:0xf36b55 Alpha:1.0];
    _lbTime.textColor=[Utils HexColor:0xafaca5 Alpha:1.0];
    _imgBottomLine.backgroundColor=COLLOCATION_TABLE_LINE;
//    [Utils imageViewDrawLine:_imgBottomLine fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(320, 0) lineWidth:1.0 lineColor:COLLOCATION_TABLE_LINE];
//    _viewBottom.backgroundColor=self.contentView.backgroundColor;
//    _viewAttenListBackground.backgroundColor=[Utils HexColor:0xf2f0f1 Alpha:1.0];
    _viewTop.backgroundColor=[Utils HexColor:0x000000 Alpha:0.7];//[Utils HexColor:0xf7f7f7 Alpha:1.0];
    
    _headImageView.layer.masksToBounds=YES;
    _headImageView.layer.cornerRadius =_headImageView.frame.size.width/2;
//    _headImageView.layer.borderColor = (COLLOCATION_TABLE_LINE).CGColor;
//    _headImageView.layer.borderWidth =1.0;
    
    _headImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onShowMyHomepage:)];
    [_headImageView addGestureRecognizer:tap];

    _imageColl.contentMode = UIViewContentModeScaleAspectFit;
    _imageColl.backgroundColor=self.contentView.backgroundColor;
    
    [_btnLevel setBackgroundColor:[Utils HexColor:0xf98a3e Alpha:1.0]];
    _btnLevel.layer.masksToBounds=YES;
    _btnLevel.layer.cornerRadius =_btnLevel.frame.size.width/2;
    _btnLevel.titleLabel.font = [UIFont systemFontOfSize:8];
    _btnLevel.titleLabel.textAlignment = NSTextAlignmentCenter;
    //偏移
    _btnLevel.titleEdgeInsets = UIEdgeInsetsMake(0,2, 0, 0);

    if (imageHeadScrollView==nil)
    {
        imageHeadScrollView=[[ImageHeadListView alloc] initWithFrame:CGRectMake(4,8, SCREEN_WIDTH-8,24) listCount:7];
        [imageHeadScrollView.onDidSelectedCell addListener:[CommonEventListener listenerWithTarget:self withSEL:@selector(ImageHeadCollectionView_cellDidSelected:eventData:)]];
        [_viewAttenListBackground addSubview:imageHeadScrollView];
//        imageHeadScrollView.backgroundColor=_viewAttenListBackground.backgroundColor;
        imageHeadScrollView.headerBorderColor=COLLOCATION_TABLE_LINE;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notif_refreshCollocationCellLikeHead:) name:@"notif_refreshCollocationCellLikeHead" object:nil];
    }
    
    
    //Chengyb，暂时隐藏喜欢头像
//    _viewBottom.backgroundColor = _viewAttenListBackground.backgroundColor;
    CGRect r=_viewBottom.frame;
    _viewBottom.frame=CGRectMake(r.origin.x,r.origin.y,r.size.width,29);
    r=_viewAttenListBackground.frame;
    _viewAttenListBackground.frame=CGRectMake(_viewBottom.frame.origin.x,_viewBottom.frame.size.height-1,r.size.width,1);
    imageHeadScrollView.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notif_refreshCollocationCellLikeHead" object:nil];
//}

//- (void)notif_refreshCollocationCellLikeHead:(NSNotification*) notification
//{
//    NSLog(@"——————data----%@",_data);
//    NSDictionary *operator = [notification object];//获取到传递的对象
//    NSDictionary *dict=[notification userInfo];
//    if([[dict allKeys] containsObject:@"collocationInfo"]){
//        if ([dict[@"collocationInfo"][@"id"] intValue]==[_data[@"collocationInfo"][@"id"] intValue])
//        {
//            [self loadCollocationLikeList];
//            [imageHeadScrollView reloadData];
//        }
//    }
//    else if ([[dict allKeys] containsObject:@"detailInfo"]){
//        if ([dict[@"detailInfo"][@"id"] intValue]==[_data[@"detailInfo"][@"id"] intValue])
//        {
//            [self loadCollocationLikeList];
//            [imageHeadScrollView reloadData];
//        }
//    }
//
//}

- (void)onShowMyHomepage:(id)sender
{
   
    [CommMBBusiness getStaffInfoByStaffID:_data[@"collocationInfo"][@"userId"] staffType:STAFF_TYPE_OPENID defaultProcess:^{
    }complete:^(SNSStaffFull *staff, BOOL success){
        [requestLock lock];
        if (success)
        {

            
        }
        else
        {

        }
        [requestLock unlock];
    }];
}

-(void)setData:(NSDictionary *)data1
{
    _data=data1;
    if (_data==nil||[[_data allKeys] count]==0){
        
    }
    else{
        NSString *username=nil;
        if (_data[@"userPublicEntity"]!=nil)
        {
            if (_data[@"userPublicEntity"][@"nickName"]!=nil&&[_data[@"userPublicEntity"][@"nickName"] length]>0)
            {
                username=_data[@"userPublicEntity"][@"nickName"];
            }
            else if (_data[@"userPublicEntity"][@"userName"]!=nil)
            {
                username=_data[@"userPublicEntity"][@"userName"];
            }
        }
        if (username.length==0)
            username=[Utils getSNSString:_data[@"collocationInfo"][@"creatE_USER"]];

        if ([[_data allKeys]containsObject:@"collocationInfo"])
        {
            _lbCollocationName.text=_data[@"collocationInfo"][@"name"];
            
            _lbDesigner.text=username;
            
            _lbReadNum.text=[[NSString alloc] initWithFormat:@"%d人浏览",0];
            _lbCommentNum.text=[[NSString alloc] initWithFormat:@"%d人评论",0];
            _lbLikeNum.text=[[NSString alloc] initWithFormat:@"%d人喜欢",0];
            likeNum=0;
            
            NSString *interval=[MBShoppingGuideInterface getJsonDateInterval:_data[@"collocationInfo"][@"creatE_DATE"]];
            NSDate *date=[Utils getDateTimeInterval_MS:interval];
            _lbTime.text=[Utils FormatDateTime:date FormatType:FORMAT_DATE_TYPE_DURATION_ALL];
            if (_data[@"collocationInfo"]!=nil && _data[@"collocationInfo"][@"sharedCount"]!=nil)
            {
                _lbReadNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:_data[@"collocationInfo"][@"sharedCount"]]];
                _lbCommentNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:_data[@"collocationInfo"][@"commentCount"]]];
                _lbLikeNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:_data[@"collocationInfo"][@"favoriteCount"]]];
                likeNum=[[Utils getSNSInteger:_data[@"collocationInfo"][@"favoritCount"]] intValue];
            }
            else if (_data[@"statisticsFilterList"]!=nil&& ((NSArray *)_data[@"statisticsFilterList"]).count>0)
            {
                _lbReadNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:_data[@"statisticsFilterList"][0][@"sharedCount"]]];
                _lbCommentNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:_data[@"statisticsFilterList"][0][@"commentCount"]]];
                _lbLikeNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:_data[@"statisticsFilterList"][0][@"favoritCount"]]];
                likeNum=[[Utils getSNSInteger:_data[@"statisticsFilterList"][0][@"favoritCount"]] intValue];
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableDictionary *rstdict=[[NSMutableDictionary alloc] initWithCapacity:10];
                    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
                    BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"WxCollocationStatisticsFilter" param:@{@"sourceId":_data[@"collocationInfo"][@"id"]} responseAll:rstdict responseMsg:msg];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success)
                        {
                            _lbReadNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:rstdict[@"statisticsInfo"][@"sharedCount"]]];
                            _lbCommentNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:rstdict[@"statisticsInfo"][@"commentCount"]]];
                            _lbLikeNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:rstdict[@"statisticsInfo"][@"favoritCount"]]];
                            likeNum=[[Utils getSNSInteger:rstdict[@"statisticsInfo"][@"favoritCount"]] intValue];
                        }
                    });
                });
            }
            
            NSString *imgurl=[Utils getSNSString:_data[@"collocationInfo"][@"pictureUrl"]];
            
            NSString *defaultImg=DEFAULT_LOADING_BIGLOADING;
            [_imageColl downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgurl size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
            
            [CommMBBusiness getStaffInfoByStaffID:_data[@"collocationInfo"][@"userId"] staffType:STAFF_TYPE_OPENID defaultProcess:^{
                [self setImageLevelFrame];
                _headImageView.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
            }complete:^(SNSStaffFull *staff, BOOL success){
                if (success)
                {
                    [self loadUserInfo:staff];
                }
            }];
            
        }
        else
        {
            if (_data[@"nickName"]!=nil)
            {
                _lbCollocationName.text=_data[@"nickName"];
                _lbDesigner.text=_data[@"nickName"];
            }
            else if (_data[@"userName"]!=nil)
            {
                _lbCollocationName.text=_data[@"userName"];
                _lbDesigner.text=_data[@"userName"];
            }
            _lbReadNum.text=[[NSString alloc] initWithFormat:@"%d人浏览",0];
            _lbCommentNum.text=[[NSString alloc] initWithFormat:@"%d人评论",0];
            _lbLikeNum.text=[[NSString alloc] initWithFormat:@"%d人喜欢",0];
            likeNum=0;
            
            NSString *interval=[MBShoppingGuideInterface getJsonDateInterval:_data[@"collocationInfo"][@"creatE_DATE"]];//_data[@"concernTime"]];
            NSDate *date=[Utils getDateTimeInterval_MS:interval];
            _lbTime.text=[Utils FormatDateTime:date FormatType:FORMAT_DATE_TYPE_DURATION_ALL];
            if (_data[@"statisticsFilterList"]!=nil&& ((NSArray *)_data[@"statisticsFilterList"]).count>0)
            {
                _lbReadNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:_data[@"statisticsFilterList"][0][@"sharedCount"]]];
                _lbCommentNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:_data[@"statisticsFilterList"][0][@"commentCount"]]];
                _lbLikeNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:_data[@"statisticsFilterList"][0][@"favoritCount"]]];
                likeNum=[[Utils getSNSInteger:_data[@"statisticsFilterList"][0][@"favoritCount"]] intValue];
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableDictionary *rstdict=[[NSMutableDictionary alloc] initWithCapacity:10];
                    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
                    BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"WxCollocationStatisticsFilter" param:@{@"sourceId":_data[@"id"]} responseAll:rstdict responseMsg:msg];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success)
                        {
                            _lbReadNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:rstdict[@"statisticsInfo"][@"sharedCount"]]];
                            _lbCommentNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:rstdict[@"statisticsInfo"][@"commentCount"]]];
                            _lbLikeNum.text=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:rstdict[@"statisticsInfo"][@"favoritCount"]]];
                            likeNum=[[Utils getSNSInteger:rstdict[@"statisticsInfo"][@"favoritCount"]] intValue];
                        }
                    });
                });
            }
            
            NSString *imgurl=[Utils getSNSString:_data[@"headPortrait"]];
            
            NSString *defaultImg=DEFAULT_LOADING_BIGLOADING;
            
            [_imageColl downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgurl size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
            
            [CommMBBusiness getStaffInfoByStaffID:_data[@"userId"] staffType:STAFF_TYPE_OPENID defaultProcess:^{
                [self setImageLevelFrame];
                _headImageView.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
            }complete:^(SNSStaffFull *staff, BOOL success){
                if (success)
                {
                    [self loadUserInfo:staff];
                }
            }];
            
        }
        [self setImageLevelFrame];
        
//        [self loadCollocationLikeList];
    }
}

-(void)setImageLevelFrame
{
    CGSize size=[_lbDesigner.text sizeWithFont:_lbDesigner.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    _btnLevel.frame=CGRectMake(size.width>0?_lbDesigner.frame.origin.x+size.width+3:_lbDesigner.frame.origin.x, _btnLevel.frame.origin.y, _btnLevel.frame.size.width, _btnLevel.frame.size.height);
}

//-(void)setImageLikeFrame
//{
//    CGSize size=[_lbAttenNum.text sizeWithFont:_lbAttenNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
//    _imageLike.frame=CGRectMake(SCREEN_WIDTH-RIGHT_MARGIN-size.width-3-_imageLike.frame.size.width, _imageLike.frame.origin.y, _imageLike.frame.size.width, _imageLike.frame.size.height);
//}

-(void)loadUserInfo:(SNSStaffFull *)staff_full
{
    if (download_lock==nil)
        download_lock=[[NSCondition alloc] init];
    
    designerLoginAccount=[[NSString alloc] initWithFormat:@"%@",staff_full.login_account];
    [self setImageLevelFrame];

  _headImageView.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
    
    UIImage *img1= [Utils getImageAsyn:staff_full.photo_path path:[AppSetting getSNSHeadImgFilePath] downloadLock:download_lock ImageCallback:^(UIImage * image,NSObject *recv_img_id){
        NSString *r_id=(NSString *)recv_img_id;
        if ([r_id isEqualToString:[Utils fileNameHash:staff_full.photo_path]])
        {
//            _headImageView.contentMode=UIViewContentModeScaleAspectFit;
            _headImageView.image=image;
        }
    } ErrorCallback:^{
    }];
//    UIImage *img1=[Utils getSnsImageAsyn:staff_full.photo_path downloadLock:download_lock ImageCallback:^(UIImage *img, NSObject *recv_img_id)
//                   {
//                       NSString *r_id=(NSString *)recv_img_id;
//                       if ([r_id isEqualToString:staff_full.photo_path])
//                       {
//                           _headImageView.contentMode=UIViewContentModeScaleAspectFit;
//                           _headImageView.image=img;
//                       }
//                   } ErrorCallback:^{}];
    if (img1!=nil) _headImageView.image=img1;
    
}

-(void)loadCollocationLikeList
{
    NSMutableArray *likelist=[[NSMutableArray alloc] initWithCapacity:10];
    
    NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:10];
    NSMutableString *msg=[[NSMutableString alloc] initWithCapacity:20];
    imageHeadScrollView.dataArray=likelist;
    collocationLikeArray=[[NSMutableArray alloc] initWithCapacity:10];
    
    //Chengyb，暂时隐藏喜欢头像
//    [imageHeadScrollView reloadData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sourceid=@"";
        if ([[_data allKeys] containsObject:@"collocationList"] && ((NSArray*)_data[@"collocationList"]).count>0)
        {
            sourceid=[Utils getSNSInteger:_data[@"collocationList"][0][@"collocationInfo"][@"id"]];
        }
        else if ([[_data allKeys]containsObject:@"collocationInfo"])
        {
            sourceid=[Utils getSNSInteger:_data[@"collocationInfo"][@"id"]];
        }
        else
        {
            sourceid = [Utils getSNSInteger:_data[@"id"]];
        }
        // [UIImage imageNamed:@"register_checkbox_selected"]
        if (_data==nil)
        {
            sourceid = @"1";
        }
        if (sourceid.length>0)
        {
            BOOL rst=[SHOPPING_GUIDE_ITF requestGetUrlName:@"FavoriteFilter" param:@{@"SOURCE_ID":sourceid, @"SOURCE_TYPE":@"2"} responseList:list responseMsg:msg];
            if (rst)
            {
                [collocationLikeArray addObjectsFromArray:list];
                
                for (int i=0;i<list.count;i++)
                {
                    SNSStaffFull *staff=[[SNSStaffFull alloc] init];
                    if ([sqlite getStaffFullByLdapUID:list[i][@"userId"] stafffull:staff]==YES)
                    {
                        [likelist addObject:staff];
                    }
                    else
                    {
                        NSString *rst=[sns getStaffCard:list[i][@"userId"] StaffCard:&staff];
                        if ([rst isEqualToString:SNS_RETURN_SUCCESS])
                        {
                            staff.ldap_uid=[[NSString alloc] initWithFormat:@"%@",list[i][@"userId"]];
                            [sqlite insertStaff:staff];
                        }
                        [likelist addObject:staff];
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imageHeadScrollView.dataArray=[[NSMutableArray alloc] initWithArray:likelist];
                imageHeadScrollView.likeChecked=([self myLikeIndex:imageHeadScrollView.dataArray]>=0)?YES:NO;
                
                //Chengyb，暂时隐藏喜欢头像
                //            [imageHeadScrollView reloadData];
                
            });
        }
    });
}

-(int)myLikeIndex:(NSMutableArray *)arr
{
    return -1;
}
-(void)ImageHeadCollectionView_cellDidSelected:(id)sender eventData:(NSIndexPath *)idx
{
    if (idx.row<7-1&&idx.row<imageHeadScrollView.dataArray.count)
    {
    }
    else
    {
        [self setLikeHead:nil];
    }
}

-(void)setLikeHead:(NSString *)source_id
{
    @synchronized(self)
    {
        @try {
            //set like
            imageHeadScrollView.likeChecked=!imageHeadScrollView.likeChecked;
            //新添字段增加创建人名称信息
            SNSStaffFull *mystaff=[[SNSStaffFull alloc] init];
            [sqlite getStaffFullByJid:[AppSetting getFafaJid] stafffull:mystaff];
            if (imageHeadScrollView.likeChecked)
            {
                int index=[self myLikeIndex:imageHeadScrollView.dataArray];
                if (index<0)
                {
                    SNSStaffFull *staff=[[SNSStaffFull alloc] init];
                    [sqlite getStaffFullByJid:[AppSetting getFafaJid] stafffull:staff];
                    [imageHeadScrollView.dataArray insertObject:staff atIndex:0];
                    likeNum++;
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @try
                    {
                        NSString *sourceid=_data[@"collocationInfo"][@"id"];
                        NSDictionary *param=@{
                                              @"userId":sns.ldap_uid,
                                              @"SOURCE_ID":sourceid,
                                              @"SOURCE_TYPE":@"2",
                                              @"Create_User":mystaff.nick_name
                                              };
                        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
                        [SHOPPING_GUIDE_ITF requestPostUrlName:@"FavoriteCreate" param:param responseAll:nil responseMsg:msg];
                        
                        if (collocationLikeArray.count>0)
                            [collocationLikeArray insertObject:@{@"id":sourceid,@"userId":sns.ldap_uid} atIndex:0];
                        else
                            [collocationLikeArray addObject:@{@"id":sourceid,@"userId":sns.ldap_uid}];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            @try
                            {
                                [imageHeadScrollView reloadData];
                                _lbLikeNum.text=[[NSString alloc] initWithFormat:@"%d人喜欢",likeNum];

//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"notif_setCollocationCellLikeHeadComplete" object:self userInfo:_data];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDataFavrite" object:nil userInfo:nil];
                                
                            }
                            @catch(NSException *exception)
                            {
                                NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
                            }
                        });
                    }
                    @catch(NSException *exception)
                    {
                        NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
                    }
                });
            }
            else
            {
                int likeid=0;
                for (int i=0;i<collocationLikeArray.count;i++)
                {
                    if ([collocationLikeArray[i][@"userId"] isEqualToString:sns.ldap_uid])
                    {
                        likeid=[collocationLikeArray[i][@"id"] intValue];
                        if (likeid ==[source_id intValue]) {
                          
                        }else
                        {
                            likeid=[source_id intValue];
                        }
                        [collocationLikeArray removeObjectAtIndex:i];
                        break;
                    }
                }
                int index=[self myLikeIndex:imageHeadScrollView.dataArray];
                if (index>=0)
                {
                    [imageHeadScrollView.dataArray removeObjectAtIndex:index];
                    likeNum--;
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @try
                    {
                        NSDictionary *param=@{
                                              @"sourceIdS":[NSString stringWithFormat:@"%d",likeid],
                                              @"userId":sns.ldap_uid,
                                              @"SOURCE_TYPE":@"2"
                                              };
                        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
                        
                        [SHOPPING_GUIDE_ITF requestPostUrlName:@"FavoriteDelete" param:param responseAll:nil responseMsg:msg];
                        
        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            @try
                            {
                                [imageHeadScrollView reloadData];
                                _lbLikeNum.text=[[NSString alloc] initWithFormat:@"%d人喜欢",likeNum];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"notif_setCollocationCellLikeHeadComplete" object:self userInfo:_data];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDataFavrite" object:nil userInfo:nil];
                            }
                            @catch(NSException *exception)
                            {
                                NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
                            }
                        });
                    }
                    @catch(NSException *exception)
                    {
                        NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
                    }
                });
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
        }
    }
}

@end
