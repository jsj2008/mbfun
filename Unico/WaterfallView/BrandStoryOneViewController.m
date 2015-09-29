//
//  BrandStoryOneViewController.m
//  Wefafa
//
//  Created by 凯 张 on 15/5/22.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "BrandStoryOneViewController.h"
#import "SUtilityTool.h"
#import "LNGood.h"
#import "SDataCache.h"
#import "HttpRequest.h"
#import "MBProgressHUD.h"
#import "Toast.h"
#import "ShareRelated.h"

@interface BrandStoryOneViewController()
{
    UIButton *collocationBtn;
    UILabel *collocationLabel;
    
    UIButton *itemBtn;
    UILabel *itemLabel;
    UIImageView *p_select_y;
    BOOL isGetGoodList;
    NSMutableArray *productArray;
    NSMutableArray *collocationArray;
    UIImageView *sharetTitleImgView;
}
@end

@implementation BrandStoryOneViewController
@synthesize brandId;

#define  TAG_DP   100
#define  TAG_ITEM 101
- (void)viewDidLoad {
    [super viewDidLoad];
    //显示navigator
    [self setupNavbar];
    sharetTitleImgView= [[UIImageView alloc]init];
    
//    [self.collectionView setOrigin:CGPointMake(0, self.navigationController.navigationBar.height+20)];
    self.collectionView.backgroundColor = COLOR_WHITE;
    isGetGoodList = NO;
}

- (void)setupNavbar{
    [super setupNavbar];
}

-(void)getData{
    if (!self.brandId || self.brandId <= 0) {
        self.brandId = @"";
    }
    self.goodsList =nil;
    [self getBrandDetails];
    [self getCollocationListForBrand:NO];
    //[self getCollocationList:NO];
    
}
//-(void) getCollocationList:(BOOL) isScrollUpdate{
//    [[SDataCache sharedInstance] getCollocationList:0 complete:^(NSArray *data, NSError *error) {
//        if (data) {
//            //转换成LNGood的数据模型
//            if (!self.goodsList) {
//                self.goodsList = [NSMutableArray arrayWithCapacity:data.count];
//            }
//            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                LNGood *goods = [LNGood goodWithDict:obj];
//                [self.goodsList addObject:goods];
//            }];
//            if (isScrollUpdate) {
//                [self.collectionView reloadData];
//            }else{
//                [self dealCollocationData];
//            }
//        }
//    }];
//}
//-(void)dealCollocationData{
//    if (!self.listDict ||  !self.goodsList || self.goodsList.count <= 0) {
//        return;
//    }else{
//        [self layoutUI];
//    }
//}

- (NSInteger)calcPageIndexWithNum:(NSInteger)num
{
    NSInteger page = num / 20;
    if (page % 20 > 0 || page == 0) {
        page ++;
    }
    return page;
}

//请求单品
- (void)requestProductIsPull:(BOOL)isPull
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:1] forKey:@"pageIndex"];
    NSInteger pageIndex = [self calcPageIndexWithNum:productArray.count];
    [dict setObject:[NSNumber numberWithInteger:pageIndex] forKey:@"pageSize"];
    [dict setObject:[NSString stringWithFormat:@"%@",self.brandId] forKey:@"BrandId"];
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [HttpRequest productPostRequestPath:nil methodName:@"ProductClsCommonSearchFilter"params:@{@"pageIndex": @1, @"pageSize" : @20} success:^(NSDictionary *dict) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (isPull) {
            [productArray removeAllObjects];
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [Toast makeToast:@"获取失败!"];
    }];
}

-(void)getBrandDetails{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [SDATACACHE_INSTANCE getBrandDetails:self.brandId complete:^(NSArray *data, NSError *error) {
        self.listDict = (NSMutableDictionary*)data;
        [sharetTitleImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.listDict[@"pic_img"]]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        
        [self dealBrandDetailsData];
        
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [Toast makeToast:@"获取失败!"];
        }
    }];
}
-(void)dealBrandDetailsData{
    if (self.listDict) {
        [self layoutUI];
    }
    [self getCollocationListForBrand:YES];
}
-(void)getCollocationListForBrand:(BOOL)isScrollUpdate{
    __weak typeof(self) weakSelf = self;
    [SDATACACHE_INSTANCE getCollocationListForBrand:self.brandId page:0 complete:^(NSArray *data) {
       // self.collocationAry = (NSArray*)data;
        //转换成LNGood的数据模型
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (!collocationArray) {
            collocationArray = [NSMutableArray arrayWithCapacity:0];
        }
        if (isScrollUpdate) {
            [collocationArray removeAllObjects];
        }
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LNGood *goods = [LNGood goodWithDict:obj];
            [collocationArray addObject:goods];
        }];
        [weakSelf updateCollectionViewWithArray:collocationArray];
    }];
}

- (void)updateCollectionViewWithArray:(NSArray *)array
{
    self.goodsList = [NSMutableArray arrayWithArray:array];
    [self.collectionView reloadData];
}

-(void)setHeadTitle{
    NSInteger offset = self.view.frame.size.height -100;
    //置顶
    UIImageView *tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"to_top"]];
    tempView.frame = CGRectMake(self.view.frame.size.width - 194/2, offset, 60/2, 60/2);
    [self.view addSubview:tempView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toTopClick:)];
    [tempView setUserInteractionEnabled:YES];
    [tempView addGestureRecognizer:recognizer];
    
    offset += 30;
    offset += 10;
    //创作
    UIImage *image = [UIImage imageNamed:@"icon_create"];
    [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 10) resizingMode:UIImageResizingModeStretch];
    tempView = [[UIImageView alloc]initWithImage:image];
    [tempView setSize:CGSizeMake(0, 70/2)];
    NSString *tempStr = self.listDict[@"english_name"];
    NSString *tempStr2 = @"晒我的";
    tempStr = [tempStr2 stringByAppendingString:tempStr];
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:nil color:nil rect:CGRectMake(30, 0, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [tempLabel setOrigin:CGPointMake(tempLabel.frame.origin.x + 5, tempView.height/2-tempLabel.height/2)];
    [tempView setSize:CGSizeMake(30+tempLabel.width+20/2, tempView.height)];
    [tempView setOrigin:CGPointMake(UI_SCREEN_WIDTH - tempView.width, offset)];

    [tempView addSubview:tempLabel];
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toCreateTopic:)];
    [tempView setUserInteractionEnabled:YES];
    [tempView addGestureRecognizer:recognizer];
    [self.view addSubview:tempView];
    
    //顶端背景
    UIImageView *topBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_bg"]];
    topBgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 128/2);
    [topBgView setUserInteractionEnabled:YES];
    
    //添加返回
//    tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_back"]];
//    tempView.frame = CGRectMake(0, 20, 88/2, 88/2);
//    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBack:)];
//    [tempView setUserInteractionEnabled:YES];
//    [tempView addGestureRecognizer:recognizer];
//    [topBgView addSubview:tempView];
    
    
    
    //分享
    tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/icon_navigation_share"]];
    tempView.frame = CGRectMake(self.view.frame.size.width-44,20,  88/2, 88/2);
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickShare:)];
    [tempView setUserInteractionEnabled:YES];
    [tempView addGestureRecognizer:recognizer];
    [topBgView addSubview:tempView];
    [self.view addSubview:topBgView];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_transparentblack.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)clickBack:(id)selector{
    NSLog(@"返回");
    //[self.navigationController popViewControllerAnimated:YES];
    [self popAnimated:YES];
}

-(void)toCreateTopic:(id)selector{
    NSLog(@"创建");
    [[SUtilityTool shared] showCamera:self.listDict[@"english_name"]];
}

-(void)clickShare:(id)selector{
    NSLog(@"分享");
    
    //分享的参数有问题
    ShareData *shareData = [[ShareData alloc]init];
    
    NSString *shareUrl=[NSString stringWithFormat:@"%@",U_SHARE_BRAND_URL];
    NSString *detailUrlStr= [NSString stringWithFormat:@"%@",shareUrl];
    NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
    NSString *noLastUrlStr=detailUrlStr;
    
    if ([lastStr isEqualToString:@"?"]) {
        
        noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
        
    }
    
    shareUrl=[NSString stringWithFormat:@"%@",noLastUrlStr];
    
    NSString *jsonWeb =[NSString stringWithFormat:@"&f_code=brand_detail&brandCode=%@",self.brandId];
    
    NSString * web_urlStr = [shareUrl stringByAppendingFormat:@"%@",jsonWeb];
    
    shareData.shareUrl = [NSString stringWithFormat:@"%@",web_urlStr];
    NSString *titleStrs=[NSString stringWithFormat:@"%@",self.listDict[@"english_name"]];
    shareData.title =titleStrs;
    shareData.descriptionStr = @"";
    
//    shareData.shareUrl = [NSString stringWithFormat:@"%@",U_SHARE_BRAND_URL];
//    
   shareData.image = [Utils reSizeImage:sharetTitleImgView.image toSize:CGSizeMake(57,57)];
    ShareRelated *share = [ShareRelated sharedShareRelated];
    [share showInTarget:self withData:shareData];
}
-(void)onLike:(id)selector{
    NSLog(@"喜欢");
}
//设置上部分内容
-(void) updateHeaderView:(UICollectionReusableView*) headerView{
    float offset = 0;
    UILabel *temp;
    UIImageView *imageView;
    UIView *tempUI;
    int tempInt;
    NSString *tempStr = self.listDict[@"pic_img"];
    UIImageView *brandBg = [UIImageView new];
    brandBg.contentMode = UIViewContentModeScaleAspectFill;
    [brandBg sd_setImageWithURL:[NSURL URLWithString:tempStr]];
    brandBg.frame = CGRectMake(0, 0, self.view.frame.size.width, 999/2);
    [headerView addSubview:brandBg];
    
    offset = 782/2;
    CGSize labelSize;
    tempStr = self.listDict[@"english_name"];
    labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempStr fontStyle:FONT_t2];
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0,offset, UI_SCREEN_WIDTH, labelSize.height)];
    textView.backgroundColor = [UIColor clearColor];
    //品牌
    temp = [SUTILITY_TOOL_INSTANCE  createUILabelByStyle:tempStr fontStyle:FONT_t2 color:COLOR_C2 rect:CGRectMake(20/2, 0, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [textView addSubview:temp];
    
    tempInt = [self.listDict[@"look_num"]intValue];
    tempStr = OTHER_TO_STRING(@"%d", tempInt);
    NSString *tempStr2 = @"浏览";
    tempStr = [tempStr2 stringByAppendingString:tempStr];
    //浏览次数
    temp = [SUTILITY_TOOL_INSTANCE  createUILabelByStyle: tempStr fontStyle:FONT_t7 color:COLOR_C2 rect:CGRectMake(UI_SCREEN_WIDTH - 20/2, 10/2 , 0, 0) isFitWidth:YES isAlignLeft:NO];
    [textView addSubview:temp];
    [brandBg addSubview:textView];
    offset += textView.height;
    offset += 46/2;
    //品牌故事
    tempStr = self.listDict[@"story"];
    tempStr2 = @"　　";
    tempStr  = [tempStr2 stringByAppendingString:tempStr];
    temp = [SUTILITY_TOOL_INSTANCE createUILabelByStyleFitHeight:tempStr fontStyle:FONT_t3 color:COLOR_C5 width:UI_SCREEN_WIDTH - 20 point:CGPointMake(20/2, offset)];
    temp.backgroundColor = [UIColor whiteColor];
    [brandBg addSubview:temp];
    temp.backgroundColor = [UIColor clearColor];
    offset += temp.height;
//    imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/arrow_bottom" rect:CGRectMake(UI_SCREEN_WIDTH/2-28/2/2, offset + 18/2, 28/2, 14/2)];
//    [headerView addSubview:imageView];
    offset += 20;
//TODO:点赞的人的信息还没有做
    UIView *tempView = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:(34 + 34 + 60)/2 coordY:offset];
    [headerView addSubview:tempView];
    
    imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/smile_big_y" rect:CGRectMake(20/2, tempView.height/2-80/2/2, 80/2, 80/2)];
    [tempView addSubview:imageView];
    
//    for (int i = 0; i<6; i++) {
//        imageView = [SUTILITY_TOOL_INSTANCE createRoundUIImageView:@"Unico/designer1" rect:CGRectMake(20/2+80/2+10/2 +i*(60/2 + 10/2), tempView.height/2-60/2/2, 60/2, 60/2) cornerRadius:60/2/2];
//        [tempView addSubview:imageView];
//    }
    NSInteger likeNum = [self.listDict[@"like_count"] integerValue];
    imageView = [SUTILITY_TOOL_INSTANCE createImageViewByLike:likeNum];
    [imageView setOrigin:CGPointMake(UI_SCREEN_WIDTH - 44/2 - imageView.width, tempView.height/2 - imageView.height/2)];
    [tempView addSubview:imageView];
    offset += tempView.height;
    
     tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:COLOR_C8];
    [tempUI setOrigin:CGPointMake(0, offset)];
    [headerView addSubview:tempUI];
    offset += 1;
    float tempFloat = UI_SCREEN_WIDTH/2;
    UIButton *tempBtn = [SUTILITY_TOOL_INSTANCE createTitleButtonAction:@"搭配" bgColor:COLOR_WHITE fontColor:COLOR_C2 fontStyle:FONT_t2 rect:CGRectMake(0, offset,tempFloat , 110/2) target:self action:@selector(onSelectType:)];
    [tempBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, tempBtn.height/2-28/2, 0)];
    long collocationNum = self.goodsList.count;
    tempStr = OTHER_TO_STRING(@"%ld", collocationNum);
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:FONT_t7 color:COLOR_C2 rect:CGRectMake(0, 0, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [tempLabel setOrigin:CGPointMake(tempBtn.width/2-tempLabel.width/2, tempBtn.height-20/2-tempLabel.height)];
    [tempBtn addSubview:tempLabel];
    collocationBtn = tempBtn;
    collocationLabel = tempLabel;
    [tempBtn setTitleColor:COLOR_C2 forState:UIControlStateNormal];
    tempBtn.tag = BASE_BTN_TAG + TAG_DP;
    [headerView addSubview:tempBtn];
   
    tempBtn = [SUTILITY_TOOL_INSTANCE createTitleButtonAction:@"单品" bgColor:COLOR_WHITE fontColor:COLOR_C6 fontStyle:FONT_t2 rect:CGRectMake(UI_SCREEN_WIDTH/2, offset,tempFloat , 110/2) target:self action:@selector(onSelectType:)];
    [tempBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, tempBtn.height/2-28/2, 0)];
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:FONT_t7 color:COLOR_C6 rect:CGRectMake(0, 0, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [tempLabel setOrigin:CGPointMake(tempBtn.width/2-tempLabel.width/2, tempBtn.height-20/2-tempLabel.height)];
    [tempBtn addSubview:tempLabel];
    tempBtn.tag = BASE_BTN_TAG + TAG_ITEM;
    itemBtn = tempBtn;
    itemLabel = tempLabel;
    [tempBtn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
    [headerView addSubview:tempBtn];
    
    p_select_y = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/line_y_150" rect:CGRectMake(tempFloat/2-150/2/2, tempBtn.frame.origin.y+tempBtn.height - 6/2, 150/2, 6/2)];
    [headerView addSubview:p_select_y];
    
    tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:COLOR_C8];
    [tempUI setOrigin:CGPointMake(0, tempBtn.frame.origin.y + tempBtn.height)];
    [headerView addSubview:tempUI];
    
    tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:1 height:tempBtn.height color:COLOR_C8];
    [tempUI setOrigin:CGPointMake(UI_SCREEN_WIDTH/2, offset)];
    [headerView addSubview:tempUI];
    offset += tempBtn.height;
    self.headerViewHeight = offset;
}

-(void)toTopClick:(UITapGestureRecognizer*)recognizer{
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)onSelectType:(id)selector{
    UIButton *tempBtn = (UIButton*)selector;
    long tag = tempBtn.tag - BASE_BTN_TAG;
    if (tag < 0) {
        return;
    }
    [tempBtn setTitleColor:COLOR_C2 forState:UIControlStateNormal];
    
    switch (tag) {
        case TAG_DP:
            NSLog(@"搭配");
            [itemBtn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
            [p_select_y setOrigin:CGPointMake(tempBtn.width/2-p_select_y.width/2, p_select_y.frame.origin.y)];
            itemLabel.textColor = COLOR_C6;
            if (collocationArray.count == 0) {
                [self getCollocationListForBrand:YES];
            }
            break;
        case TAG_ITEM:
            NSLog(@"单品");
            [collocationBtn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
            [p_select_y setOrigin:CGPointMake(UI_SCREEN_WIDTH/2+tempBtn.width/2-p_select_y.width/2, p_select_y.frame.origin.y)];
            collocationLabel.textColor = COLOR_C6;
            if (productArray.count == 0) {
//                [self requestProductIsPull:YES];
            }
            break;
        default:
            break;
    }
    
}

@end

