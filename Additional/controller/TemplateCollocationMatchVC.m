//
//  TemplateCollocationMatchVC.m
//  Wefafa
//
//  Created by Miaoz on 15/3/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//
#define belowwidth    60
#define buttondistanceY 7.5
#define positionHeight 80 //162+40
#import "MLKMenuPopover.h"

#import "TemplateCollocationMatchVC.h"
#import "Globle.h"
#import "GesturesImageView.h"
#import "MentallySuperView.h"
#import "TemplatePublishCollocationVC.h"
#import "MentallyMyViewController.h"
@interface TemplateCollocationMatchVC ()<MentallySuperViewDelegate,UIActionSheetDelegate,MyViewControllerDeleagte,MLKMenuPopoverDelegate>
@property(nonatomic,strong)MentallySuperView *mentallSuperView;
@property (nonatomic,strong)NSString * uniquesessionid;
@property(nonatomic,strong)NSMutableArray *mentallViewArray;
@property(nonatomic,strong)UIScrollView *bottomView;
@property(nonatomic,strong)GesturesImageView *jugeGesturesImageView;//判断需要
@property(nonatomic,strong)MLKMenuPopover *menuPopover;
@end

@implementation TemplateCollocationMatchVC
//以及界面数据传递到二级界面
-(void)setTemplateElement:(TemplateElement *)templateElement{
    _templateElement = templateElement;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (IOS7_OR_LATER) {
//        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#000000"];
//        
//    }else{
//        　self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#000000"];
//    }
  
    
    if (_mentallViewArray == nil) {
        _mentallViewArray = [NSMutableArray new];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]];
    
    [self SetLeftButton:nil Image:@"ion_back"];
    [self setRightButton:@"More" action:@selector(addRightTemplateClick:)];
    //    [self setRightButton:@"更多" action:@selector(addMoreTemplateClick:)];
 
//    [self createMentallViewsbytemplateElement:_templateElement];
    [self requestCollocationModuleEditFilterWithModuleid:_templateElement.templateInfo.id];
    [self createBottomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addChooseGoodsMethods:) name:NOTICE_ADDCHOOSEGOODS object:nil];
    
}
-(void)addRightTemplateClick:(id)sender{
    
//    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布",@"保存草稿",@"新建",@"打开" , nil];
//    actionsheet.tag = 555;
//    [actionsheet showInView:[AppDelegate shareAppdelegate].window];

    [self.menuPopover dismissMenuPopover];
    
    
    self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width, 250) menuItems:@[@"发布",@"保存草稿",@"新建",@"打开",@"取消"] imageArray:nil];
    self.menuPopover.delectStr = @"";
    self.menuPopover.menuPopoverDelegate = self;
    [self.menuPopover showInView:self.view];


}
-(void)createBottomView{
    _bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, belowwidth)];//self.frame.size.height-positionHeight
//        _bottomView.hidden = YES;
    _bottomView.userInteractionEnabled = YES;
    _bottomView.showsHorizontalScrollIndicator = YES;
    //    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#504d4d"];
    _bottomView.backgroundColor = [UIColor clearColor];
    _bottomView.contentSize = CGSizeMake(self.view.frame.size.width+60, belowwidth);
    [self.view addSubview:_bottomView];
        NSArray *array = @[@"移除",@"翻转"];
    NSArray *imgArray = @[@"icon_create_trash",@"icon_create_mirror"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3.0f;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithHexString:@"#919191"];
        btn.frame = CGRectMake(30+140*i, buttondistanceY, 120, 40);
        btn.tag = 40+i;
        [btn addTarget:self action:@selector(buttonClickevent:)
      forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
    }
    
    
    
}

-(void)buttonClickevent:(UIButton *)sender{
    
    switch (sender.tag) {
        case 40:{
            
            [UIView animateWithDuration:0.5 animations:^{
                _mentallSuperView.gesturesImageView.transform = CGAffineTransformMakeScale(0.05, 0.05);
                _mentallSuperView.gesturesImageView.isFirstClick = NO;
                
            } completion:^(BOOL finished) {
                
                [_mentallSuperView.gesturesImageView removeFromSuperview];
                [UIView animateWithDuration:0.3 animations:^{
                    _bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, belowwidth);
                } completion:^(BOOL finished) {
                    
                }];

            }];
            
            
            break;
    }
        case 41:
            [self flipimageMothel];
            break;
        default:
            break;
    }


}
#pragma mark -- 添加商品图片
-(void)addChooseGoodsMethods:(NSNotification *)notification{
    
       NSDictionary *notificationdic = notification.userInfo;
    GoodObj *goodObj = [notificationdic objectForKey:@"GoodObj"];
    //11.25 add by Miao
    CGFloat ratioNum  ;
    NSLog(@"============goodObj.clsPicUrl.width.floatValue -%f",goodObj.clsPicUrl.width.floatValue);
    if (goodObj.clsPicUrl.width.floatValue >=[Globle shareInstance].globleWidth) {
        ratioNum = [Globle shareInstance].globleWidth/(2.5*goodObj.clsPicUrl.width.floatValue);
    }else{
        
//        if (goodObj.clsPicUrl.height.floatValue >[Globle shareInstance].globleWidth) {
//            ratioNum = [Globle shareInstance].globleWidth/(2.5*goodObj.clsPicUrl.width.floatValue);
//        }else{
            ratioNum = 0.4;
//        }
        
    }
  
    for (MentallySuperView *view in _mentallViewArray) {
        if (view.layoutMapping.id.integerValue == _mentallSuperView.layoutMapping.id.integerValue) {
            
           [view addGesturesImageViewToMentallySuperView:_mentallSuperView.frame image:nil center:_mentallSuperView.center withTransformStr:nil withtGoodObj:goodObj];
        }
    }
    
   
}


-(void)flipimageMothel{
    
    NSLog(@"%@",NSStringFromCGAffineTransform( _mentallSuperView.gesturesImageView.transform));
    float a =  _mentallSuperView.gesturesImageView.transform.a;
    float b =  _mentallSuperView.gesturesImageView.transform.b;
    float c =  _mentallSuperView.gesturesImageView.transform.c;
    float d =  _mentallSuperView.gesturesImageView.transform.d;
    
    _mentallSuperView.gesturesImageView.transform = CGAffineTransformMake(-a, -b, c, d, 0, 0);
    NSLog(@"%@",NSStringFromCGAffineTransform( _mentallSuperView.gesturesImageView.transform));
    a =  _mentallSuperView.gesturesImageView.transform.a;
    b =  _mentallSuperView.gesturesImageView.transform.b;
    c =  _mentallSuperView.gesturesImageView.transform.c;
    d =  _mentallSuperView.gesturesImageView.transform.d;
    
    _mentallSuperView.gesturesImageView.transform = CGAffineTransformMake(a, -b, -c, d, 0, 0);
    
    
    if (d*a < 0.000000) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"1"}];//改变成-
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGesturesImageViewRotate" object:nil userInfo:@{@"ischange":@"0"}];//不改变
    }
    
    
    
    
    NSLog(@"%@",NSStringFromCGAffineTransform( _mentallSuperView.gesturesImageView.transform));
}

#pragma mark -- 复原模板
-(void)createMentallViewsbytemplateElement:(TemplateElement *)templateElement{

//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
//    view.backgroundColor = [UIColor redColor];
//    view.layer.masksToBounds = YES;
//    [self.view addSubview:view];
    
    for(UIView *view in self.mentallViewArray)
    {
        [view removeFromSuperview];
    }
    [self.mentallViewArray removeAllObjects];
    
    if (templateElement.layoutMappingList!= nil&& templateElement != nil) {
        for (int i = 0; i< templateElement.layoutMappingList.count; i++) {
            LayoutMapping *layoutMapping = templateElement.layoutMappingList[i];
            DetailMapping *detailMapping = templateElement.detailMappingList[i];
            MentallySuperView *mentallyView = [[MentallySuperView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            mentallyView.delegate = self;
            mentallyView.mainSuperView = self.view;
//            [mentallyView changeMentallySuperViewWithLayoutMapping:layoutMapping withDetailMapping:detailMapping withtemplateElement:templateElement];
            [mentallyView repetitionMentallyGesturesImageViewWithServicedata:layoutMapping withdetailMapping:detailMapping withCollocationInfo:nil withtemplateInfo:templateElement.templateInfo withContentInfo:layoutMapping.contentInfo];
         
            [self.view addSubview:mentallyView];
            
            [_mentallViewArray addObject:mentallyView];
        }
    }

//    GesturesImageView *gestureImgV = [[GesturesImageView alloc] initWithFrame:view.frame];
//    gestureImgV.backgroundColor = [UIColor greenColor];
//    [view addSubview:gestureImgV];


}

//搭配草稿
#pragma mark --复原搭配草稿
-(void)createMentallViewsbycollocationElement:(CollocationElement *)collocationElement{
    
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    //    view.backgroundColor = [UIColor redColor];
    //    view.layer.masksToBounds = YES;
    //    [self.view addSubview:view];
    
    for(UIView *view in self.mentallViewArray)
    {
        [view removeFromSuperview];
    }
    [self.mentallViewArray removeAllObjects];
    
    if (collocationElement.layoutMappingList!= nil&& collocationElement != nil) {
        for (int i = 0; i< collocationElement.layoutMappingList.count; i++) {
            LayoutMapping *layoutMapping = collocationElement.layoutMappingList[i];
            DetailMapping *detailMapping = collocationElement.detailMappingList[i];
            MentallySuperView *mentallyView = [[MentallySuperView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            mentallyView.delegate = self;
            mentallyView.mainSuperView = self.view;
            [mentallyView repetitionMentallyGesturesImageViewWithServicedata:layoutMapping withdetailMapping:detailMapping withCollocationInfo:collocationElement.collocationInfo withtemplateInfo:nil withContentInfo:layoutMapping.contentInfo];
            
//            [mentallyView repetitionMentallyGesturesImageViewWithServicedata:layoutMapping withdetailMapping:detailMapping withCollocationInfo:collocationElement.collocationInfo withContentInfo:layoutMapping.contentInfo];
            [self.view addSubview:mentallyView];
            
            [_mentallViewArray addObject:mentallyView];
        }
    }
    
    //    GesturesImageView *gestureImgV = [[GesturesImageView alloc] initWithFrame:view.frame];
    //    gestureImgV.backgroundColor = [UIColor greenColor];
    //    [view addSubview:gestureImgV];
    
    
}




#pragma mark -保存到草稿请求
-(void)uploaddataWithModelTemplate:(NSMutableArray *)array{
    
    if (array.count>0) {
        //11.20 add by miao
        MentallySuperView  *view = array[0];
        //在最外层添加参数maintemplateId  内部搭配布局中的TemplateId及LayoutId 不再需要
        NSString *maintemplateId;
        if (view.templateInfo.id != nil) {
            maintemplateId = view.templateInfo.id;//
        }else if(view.collocationInfo.templateId != nil)
        {
        maintemplateId = view.collocationInfo.templateId;
        
        }
        else{
            maintemplateId = @"-1";
        }
        
        
        
        NSMutableArray*detaillist =[NSMutableArray new] ;
        NSMutableArray *layoutMappingList = [NSMutableArray new];
      
        for (int i = 0; i < array.count; i++) {
            MentallySuperView *view = array[i];
           
            //模板容器层
            NSString * detailClsId;
            NSString *detailpictureurl;
            NSString *detailName;
            NSString *detailCode;
            NSString *detailPrice;
            NSString *detailColorCode;
            NSString *detailColorNam;
            NSString *detailsourceType;
            NSString *detaillayoutId = [NSString stringWithFormat:@"%d",i];
            NSString *detailindex = [NSString stringWithFormat:@"%d",(i+1)*10];
            
            //商品层
            NSString * productClsId ;
            NSString *productpictureurl;
            NSString *productLayoutpictureurl;
            NSString *productName;
            NSString *productCode;
            NSString *productPrice;
            NSString *productColorCode;
            NSString *productColorNam;
            NSString *productsourceType;
            NSString *productlayoutId = [NSString stringWithFormat:@"%d",i];
            NSString *productindex = [NSString stringWithFormat:@"%d",(i+1)*10+1];
            
            if (view.detailMapping.productPictureUrl.length == 0) {//第一次 使用模板
                if(view.detailMapping != nil){//模板的数据
                    DetailMapping *detailMapping = view.detailMapping;
                    detailClsId = detailMapping.productClsId;
                    if (detailMapping.shearPicUrl != nil && ![detailMapping.shearPicUrl isEqualToString:@""] ) {
                        detailpictureurl = detailMapping.shearPicUrl;
                    }else
                    {
                       
                        detailpictureurl = detailMapping.productPictureUrl;
                        if (detailpictureurl.length == 0) {
                            detailpictureurl = view.layoutMapping.pictureUrl;
                        }
                        
                    }
                    
                    
                    detailName = detailMapping.productName;
                    detailCode = detailMapping.productCode;
                    detailPrice = detailMapping.productPrice;
                    detailColorCode = detailMapping.colorCode;
                    detailColorNam = detailMapping.colorName;
                    if (detailMapping.sourceType == nil)
                    {
                        detailsourceType = @"1";
                    }else{
                        detailsourceType = detailMapping.sourceType;
                    }
                    
                }
             }
            else{//复原保存的搭配&草稿
                LayoutMapping *modulelayout = view.layoutMapping;
//                DetailMapping *detailMapping = view.detailMapping;
                detailClsId =  modulelayout.productClsId;
                detailpictureurl = modulelayout.pictureUrl;
                detailName = modulelayout.productName; //@"";
                detailCode = @"";
                detailPrice = @"";
                detailColorCode = @"";
                detailColorNam = @"";
                detailsourceType = @"";
            }
            
           //重新拼接bankurl
            NSRange range = [detailpictureurl rangeOfString:@"$blank_"];
            if (range.length == 7) {
                NSArray *tmparray = [detailpictureurl componentsSeparatedByString:@"$blank_"];
//                NSString * dicString = [[[tmparray objectAtIndex:1] componentsSeparatedByString:@"--"] objectAtIndex:0];
                
//                NSDictionary *oldBankdic = [NSString dictionaryWithJsonString:dicString];
                NSMutableDictionary *bankDic = [NSMutableDictionary new];
//                
                [bankDic setObject:[NSNumber numberWithInt:view.bankWidth.intValue] forKey:@"w"];
                 [bankDic setObject:[NSNumber numberWithInt:view.bankHeight.intValue] forKey:@"h"];
         
//                [bankDic setObject:[oldBankdic objectForKey:@"w"] forKey:@"w"];
//                [bankDic setObject:[oldBankdic objectForKey:@"h"] forKey:@"h"];
                [bankDic setObject:[NSNumber numberWithInt:0] forKey:@"b"];
                NSString *lastBankStr = [NSString stringWithFormat:@"$blank_%@.png",[NSString stringByJson:bankDic]];
                
                detailpictureurl = [NSString stringWithFormat:@"%@%@",[tmparray objectAtIndex:0],lastBankStr];

            }
            
           
            
            if (view.goodObj != nil) {//从商品列表选择
                GoodObj *goodObj = view.goodObj;
                productClsId = [NSString stringWithFormat:@"%@",goodObj.clsInfo.id] ;
                if (goodObj.shearPicUrl != nil && ![goodObj.shearPicUrl isEqualToString:@""] ) {
                    productpictureurl = goodObj.shearPicUrl;
                }else
                {
                    //合成需要
                    NSRange tmpRange = [detailpictureurl rangeOfString:@"$blank_"];
                    if (tmpRange.length== 7) {
                         productLayoutpictureurl =[self stitchedTogetherImageDataWithbankpicUrl:detailpictureurl withproductPictureUrl:goodObj.clsPicUrl.filE_PATH withMentallyView:view];
                    }
                   
                    
                    productpictureurl = goodObj.clsPicUrl.filE_PATH;
                }
                
                productName = goodObj.clsInfo.name;
                productCode = goodObj.clsInfo.code;
                productPrice = goodObj.clsInfo.sale_price;
                productColorCode = goodObj.productColorMapping.code;
                productColorNam = goodObj.productColorMapping.name;
                
                if (goodObj.sourceType == nil) {
                    productsourceType = @"1";
                }else{
                    productsourceType = goodObj.sourceType;
                }
                
            }else if(view.materialMapping != nil){
                MaterialMapping *materialMapping = view.materialMapping;
                
                if (materialMapping.id != nil) {
                    productClsId = [NSString stringWithFormat:@"%@",materialMapping.id];
                }
                
                if (materialMapping.shearPicUrl != nil && ![materialMapping.shearPicUrl isEqualToString:@""] ) {
                    productpictureurl = materialMapping.shearPicUrl;
                }else
                {
                    productpictureurl = materialMapping.pictureUrl;
                }
                productsourceType = @"2";
                productName = @"素材";
                productCode = @"09";
                productPrice = @"0.0";
                productColorCode = @"09";
                productColorNam = @"无色";
                

            }else if(view.contentInfo != nil)
            {
                DetailMapping *goodDetailMapping = view.detailMapping;
//                ContentInfo *contentInfo = view.contentInfo;
                productClsId =[NSString stringWithFormat:@"%@",goodDetailMapping.id];
                //                if (goodObj.shearPicUrl != nil && ![goodObj.shearPicUrl isEqualToString:@""] ) {
                //                    productpictureurl = goodObj.shearPicUrl;
                //                }else
                //                {
                
                //合成需要
                NSRange tmpRange = [detailpictureurl rangeOfString:@"$blank_"];
                if (tmpRange.length== 7) {
                    productLayoutpictureurl = [self stitchedTogetherImageDataWithbankpicUrl:detailpictureurl withproductPictureUrl:goodDetailMapping.productPictureUrl withMentallyView:view];
                }
                productpictureurl = goodDetailMapping.productPictureUrl;//contentInfo.pictureUrl
                
                //                }
                
                productName = goodDetailMapping.productName;
                productCode = goodDetailMapping.productCode;
                productPrice = goodDetailMapping.productPrice;
                productColorCode = goodDetailMapping.colorCode;
                productColorNam = goodDetailMapping.colorName;
                if (goodDetailMapping.sourceType == nil)//sourceType 1是商品2是图片素材
                {
                    productsourceType = @"1";
                }else{
                    productsourceType = goodDetailMapping.sourceType;
                }
                
            }else{//解决 模板上有图片和没模板只有图片
            
                if(view.detailMapping != nil )
                {
                    DetailMapping *goodDetailMapping = view.detailMapping;
                    productClsId = goodDetailMapping.productClsId;
                    if (goodDetailMapping.shearPicUrl != nil && ![goodDetailMapping.shearPicUrl isEqualToString:@""] ) {
                        productpictureurl = goodDetailMapping.shearPicUrl;
                    }else
                    {
                        
                        NSRange tmpRange = [detailpictureurl rangeOfString:@"$blank_"];
                        if (tmpRange.length== 7&&goodDetailMapping.productPictureUrl.length != 0) {
                            productLayoutpictureurl = [self stitchedTogetherImageDataWithbankpicUrl:detailpictureurl withproductPictureUrl:goodDetailMapping.productPictureUrl withMentallyView:view];
                        }
                        productpictureurl = goodDetailMapping.productPictureUrl;
                       
                        
                    }
                    
                    
                    productName = goodDetailMapping.productName;
                    productCode = goodDetailMapping.productCode;
                    productPrice = goodDetailMapping.productPrice;
                    productColorCode = goodDetailMapping.colorCode;
                    productColorNam = goodDetailMapping.colorName;
                    if (goodDetailMapping.sourceType == nil)
                    {
                        productsourceType = @"1";
                    }else{
                       productsourceType = goodDetailMapping.sourceType;
                    }
                    
                }

            
            
            
            
            }

     
            
            //商品信息
    
             NSMutableArray *contentList = [NSMutableArray new];
//            CGPoint point = [self.view convertPoint:view.gesturesImageView.center fromView:view];

            if (productLayoutpictureurl != nil) {//contentList  里的XYPosition 是 模板容器的中心坐标
                [contentList addObject:@{@"ProductClsId":productClsId != nil?[NSNumber numberWithInt:productClsId.intValue]:[NSNumber numberWithInt:-1],
                                         @"ProductName":productName,
                                         @"LayoutId":[NSNumber numberWithInt:productlayoutId.intValue],
                                         @"Index":[NSNumber numberWithInt:productindex.intValue],
                                         @"Width":[NSNumber numberWithInt:view.gesturesImageView.frame.size.width],
                                         @"Height":[NSNumber numberWithInt:view.gesturesImageView.frame.size.height],
                                         @"XPosition":[NSNumber numberWithInt:view.center.x],//+view.gesturesImageView.center.x
                                         @"YPosition":[NSNumber numberWithInt:view.center.y],
                                         @"PictureUrl":productLayoutpictureurl!=nil ?productLayoutpictureurl:@"",//productpictureurl
                                         @"RectSx":[NSNumber numberWithFloat:view.transform.a],
                                         @"RectRx":[NSNumber numberWithFloat:view.transform.b],
                                         @"RectRy":[NSNumber numberWithFloat:view.transform.c],
                                         @"RectSy":[NSNumber numberWithFloat:view.transform.d],
                                         @"ItemType":[NSNumber numberWithInt:2]
                                         }];
                //            1 占位符 2 图片
            }
            
          
            
            
                //detaillist  放商品
                [detaillist addObject:@{@"ProductClsId":productClsId!=nil?[NSNumber numberWithInt:productClsId.intValue]:[NSNumber numberWithInt:-1],
                                        @"ProductName":productName,
                                        @"ProductCode":productCode,
                                        @"ColorCode":productColorCode,
                                        @"ColorName":productColorNam,
                                        @"ProductPrice":productPrice,
                                        @"ProductPictureUrl":productpictureurl,
                                        @"SourceType":[NSNumber numberWithInt:productsourceType.intValue]}];
            
            
            
            NSLog(@"%@---------%@",productindex,productlayoutId);
            

            //模板信息
            NSDictionary *layoutDic = @{@"ProductClsId":[NSNumber numberWithInt:detailClsId.intValue],
                                        @"ProductName":detailName,
                                        @"LayoutId":[NSNumber numberWithInt:detaillayoutId.intValue],
                                        @"Index":[NSNumber numberWithInt:detailindex.intValue],
                                        @"Width":[NSNumber numberWithInt:view.bankWidth.intValue],//view.frame.size.width
                                        @"Height":[NSNumber numberWithInt:view.bankHeight.intValue],//view.frame.size.height
                                        @"XPosition":[NSNumber numberWithInt:view.center.x],
                                        @"YPosition":[NSNumber numberWithInt:view.center.y],
                                        @"PictureUrl":detailpictureurl,
                                        @"RectSx":[NSNumber numberWithFloat:view.transform.a],
                                        @"RectRx":[NSNumber numberWithFloat:view.transform.b],
                                        @"RectRy":[NSNumber numberWithFloat:view.transform.c],
                                        @"RectSy":[NSNumber numberWithFloat:view.transform.d],
                                        @"ItemType":[NSNumber numberWithInt:1]
                                        ,
                                        @"TextFont_Id":view.layoutMapping.textFont_Id!=nil?[NSNumber numberWithInt:view.layoutMapping.textFont_Id.intValue]:[NSNumber numberWithInt:-1],
                                        @"TextPoint":view.layoutMapping.textPoint!=nil?[NSNumber numberWithInt:view.layoutMapping.textPoint.intValue]:[NSNumber numberWithInt:-1],
                                        @"TextScale":view.layoutMapping.textScale!=nil?[NSNumber numberWithFloat:view.layoutMapping.textScale.floatValue]:[NSNumber numberWithInt:-1],
                                        @"TextContent":view.layoutMapping.textContent!=nil?view.layoutMapping.textContent:@"-1",
                                        @"TextColor":view.layoutMapping.textColor!=nil?view.layoutMapping.textColor:@"-1",
                                        @"ContentList":contentList
                                        };
            [layoutMappingList addObject:layoutDic];
        }
        
        //@"9999" @"Miaozhang"
        //        SNSStaffFull *userinfo =  [[Globle shareInstance] getUserInfo];
        
        
        NSString *backWidthStr = [NSString stringWithFormat:@"%f",[Globle shareInstance].globleWidth];
        
        [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
        }complete:^(SNSStaffFull *staff, BOOL success){
            if (success)
            {
                NSLog(@"staff.nick_name----%@",staff.nick_name);
                [self requestDraftCreateWithtopicName:@"" BackWidth:backWidthStr Description:@"ios保存草稿" UserId:sns.ldap_uid CreateUser:staff.nick_name DetailList:(NSMutableArray *)detaillist LayoutMappingList:layoutMappingList  TemplateId:maintemplateId];
                
            }
        }];
        
    }
}

#pragma mark -- 拼接合成图片url
-(NSString *)stitchedTogetherImageDataWithbankpicUrl:(NSString *)detailpictureurl withproductPictureUrl:(NSString *)productPictureUrl withMentallyView:(MentallySuperView *)view{
  
    NSString * bankdicString = [[detailpictureurl componentsSeparatedByString:@"$blank_"] objectAtIndex:1];
    NSArray *bankdicArray =    [bankdicString   componentsSeparatedByString:@"--"];
    NSString *lastBankdicStr ;
    if(bankdicArray.count == 2){
        
        lastBankdicStr = bankdicArray[0];
    }else{
        NSString *tmpStr = [bankdicArray objectAtIndex:0];
        NSMutableString *tmpBankString = [[NSMutableString alloc] initWithString:[tmpStr substringToIndex:tmpStr.length-4]];
        lastBankdicStr = tmpBankString;
        
    }
    //                {"w":200,"h":200,"b":1,"bc":"FF0000"}
    NSDictionary *oldBankdic = [NSString dictionaryWithJsonString:lastBankdicStr];
    
    NSMutableDictionary *bankDic = [NSMutableDictionary new];
    [bankDic setObject:[oldBankdic objectForKey:@"w"] forKey:@"w"];
    [bankDic setObject:[oldBankdic objectForKey:@"h"] forKey:@"h"];
    [bankDic setObject:[NSNumber numberWithInt:0] forKey:@"b"];
    [bankDic setObject:@"FF0000" forKey:@"bc"];
    NSString *lastMainBankStr = [NSString stringWithFormat:@"$blank_%@.png",[NSString stringByJson:bankDic]];
    NSData *tmpMainBankdata = [lastMainBankStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64MainBankStr =[ASIHTTPRequest base64forData:tmpMainBankdata];//p
    //goodDetailMapping.productPictureUrl
    NSArray *picStrarray = [productPictureUrl componentsSeparatedByString:@"--"];
    NSString *picUrlStr;
    if (picStrarray.count ==2) {
        picUrlStr =[NSString stringWithFormat:@"%@--MTD_",[ picStrarray objectAtIndex:0]];
    }else{
        NSString *tmpStr = [ picStrarray objectAtIndex:0];
        NSMutableString *lastString = [[NSMutableString alloc] initWithString:[tmpStr substringToIndex:tmpStr.length-4]];
        picUrlStr =[NSString stringWithFormat:@"%@--MTD_",lastString];
    }
    
    NSMutableDictionary *_sourceDic = [NSMutableDictionary new];
    [_sourceDic setObject:base64MainBankStr forKey:@"p"];
    
    NSString *aStr = [NSString stringWithFormat:@"%@",view.layoutMapping.rectSx];
    float a = [aStr floatValue];
    NSString *bStr = [NSString stringWithFormat:@"%@",view.layoutMapping.rectRx];
    float b = [bStr floatValue];
    NSString *cStr = [NSString stringWithFormat:@"%@",view.layoutMapping.rectRy];
    float c = [cStr floatValue];
    NSString *dStr = [NSString stringWithFormat:@"%@",view.layoutMapping.rectSy];
    float d = [dStr floatValue];
    if (b != 0) {
         view.transform = CGAffineTransformMake(a, 0, 0, d, 0.0f, 0.0f);
    }

//
//    NSString *aStr2 = [NSString stringWithFormat:@"%f",view.gesturesImageView.transform.a];
//    float a2 = [aStr2 floatValue];
//    NSString *bStr2 = [NSString stringWithFormat:@"%@",view.contentInfo.rectRx];
//    float b2 = [bStr2 floatValue];
//    NSString *cStr2 = [NSString stringWithFormat:@"%@",view.contentInfo.rectRy];
//    float c2 = [cStr2 floatValue];
//    NSString *dStr2 = [NSString stringWithFormat:@"%f",view.gesturesImageView.transform.d];
//    float d2 = [dStr2 floatValue];
//    if (b2 != 0) {
//        view.gesturesImageView.transform =  CGAffineTransformMake(a2, 0, 0, d2, 0.0f, 0.0f);
//    }
//
    
    
    CGPoint point1 = [self.view convertPoint:CGPointMake(view.gesturesImageView.frame.origin.x, view.gesturesImageView.frame.origin.y) fromView:view];
//    if (b2 == 0) {
        [_sourceDic setObject:[NSNumber numberWithInt:abs((int)(point1.x -view.center.x))] forKey:@"x"];
        [_sourceDic setObject:[NSNumber numberWithInt:abs((int)(point1.y -view.center.y))] forKey:@"y"];
//    }else{
    
//        [_sourceDic setObject:[NSNumber numberWithInt:abs(point1.x -view.center.x)+30] forKey:@"x"];
//        [_sourceDic setObject:[NSNumber numberWithInt:abs(point1.y -view.center.y)+30] forKey:@"y"];
//    }
   
    [_sourceDic setObject:[NSNumber numberWithInt:view.bankWidth.intValue] forKey:@"w"];
    [_sourceDic setObject:[NSNumber numberWithInt:view.gesturesImageView.frame.size.width] forKey:@"iw"];//
    NSString *lastPicString =[NSString stringWithFormat:@"%@%@--%dx%d.png",picUrlStr,[NSString stringByJson:_sourceDic],view.bankWidth.intValue,view.bankHeight.intValue];
   
    if (b != 0) {
        view.transform = CGAffineTransformMake(a, b, c, d, 0.0f, 0.0f);
    }
//    if (b2 != 0) {
//        view.gesturesImageView.transform =  CGAffineTransformMake(a2, b2, c2, d2, 0.0f, 0.0f);
//    }
    return lastPicString;
    //p是原图的相对路径path x、y是抠图模板的中心坐标 w是抠图模板宽 iw是原图的宽
    
}

//只保存到草稿箱
-(void)requestDraftCreateWithtopicName:(NSString *)name BackWidth:(NSString *)backwidth Description:(NSString *)description UserId:(NSString *)userId CreateUser:(NSString *)creatuser DetailList:(NSMutableArray *)detaillist LayoutMappingList:(NSMutableArray *)layoutMappingList TemplateId:(NSString *)templateId{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //    [dic setObject:name forKey:@"Name"];
    [dic setObject:[NSNumber numberWithInt:backwidth.intValue] forKey:@"BackWidth"];
    [dic setObject:description forKey:@"Description"];
    [dic setObject:userId forKey:@"UserId"];
    [dic setObject:creatuser forKey:@"CREATE_USER"];
    [dic setObject:detaillist forKey:@"DetailList"];
//    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"autofit"];
    [dic setObject:layoutMappingList forKey:@"LayoutMappingList"];
    //11.20 add by miao
    [dic setObject:templateId forKey:@"TemplateId"];
    
    if (_uniquesessionid == nil) {
        _uniquesessionid = [NSString stringWithFormat:@"%@%@%@",[[Globle shareInstance] getuuid],[[Globle shareInstance] getTimeNow],[[Globle shareInstance] getRandomWord]];
    }
    NSLog(@"_uniquesessionid------%@",_uniquesessionid);
    [dic setObject:_uniquesessionid forKey:@"uniquesessionid"];
    
    [[HttpRequest shareRequst] httpRequestPostCollocationDraftCreate:dic success:^(id obj) {
        
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            //          [self performSegueWithIdentifier:@"MyViewController" sender:nil];
            // 12.9 add by miao
//            [self cleanCanvasSource];
//            for(UIView *view in self.mentallViewArray)
//            {
//                [view removeFromSuperview];
//            }
//            [self.mentallViewArray removeAllObjects];
            
            [self.view makeToast:@"保存草稿箱成功"];
            _uniquesessionid = nil;
        }else{
            
            [self.view makeToast:[obj objectForKey:@"message"]];
            
        }
        
    } ail:^(NSString *errorMsg) {
        [self.view makeToast:@"保存草稿失败"];
    }];
    
    
}

#pragma mark --MLKMenuPopoverDelegate
- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex{
    [self.menuPopover dismissMenuPopover];
    
    switch (selectedIndex) {
        case 0:
            NSLog(@"发布");
            
            if (self.mentallViewArray == nil||self.mentallViewArray.count == 0) {
                
                
                if (self.mentallViewArray == nil||self.mentallViewArray.count == 0) {
                    //提示没有可保存的gesturesView
                    
                    [self.view makeToast:@"没有可发布的内容"];
                    return;
                }
                
            }
            if (self.mentallViewArray.count == 1) {
                
                
                if (self.mentallViewArray.count == 1) {
                    //提示没有可保存的gesturesView
                    
                    [self.view makeToast:@"单个单品不能发布"];
                    return;
                }
                
            }
            
            
            [self performSegueWithIdentifier:@"TemplatePublishCollocationVC" sender:self.mentallViewArray];
            
            break;
            
        case 1:{
            NSLog(@"保存");
            
            
            if (self.mentallViewArray == nil||self.mentallViewArray.count == 0) {
                
                
                if (self.mentallViewArray == nil||self.mentallViewArray.count == 0) {
                    //提示没有可保存的gesturesView
                    
                    [self.view makeToast:@"亲,没有可保存的内容"];
                    return;
                }
                
            }
            if (self.mentallViewArray.count == 1) {
                
                
                if (self.mentallViewArray.count == 1) {
                    //提示没有可保存的gesturesView
                    
                    [self.view makeToast:@"亲,单个单品不能保存"];
                    return;
                }
                
            }
            
            [self uploaddataWithModelTemplate:self.mentallViewArray];
            
        }
            break;
        case 2:
            
        {
            NSLog(@"新建");
            
            
            if (self.mentallViewArray.count == 0 || self.mentallViewArray == nil) {
                return;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"造型师" message:@"亲,确定要放弃搭配吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 7777;
            [alert show];
            
        }
            break;
        case 3:
            NSLog(@"打开");
            [self performSegueWithIdentifier:@"MentallyMyViewController" sender:nil];
            //                [self performSegueWithIdentifier:@"MyViewController" sender:nil];
            
            break;
            
        default:
            
            break;
    }




}

#pragma mark --UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 555) {
        
        switch (buttonIndex) {
            case 0:
                NSLog(@"发布");
                
                if (self.mentallViewArray == nil||self.mentallViewArray.count == 0) {
                    
              
                    if (self.mentallViewArray == nil||self.mentallViewArray.count == 0) {
                        //提示没有可保存的gesturesView
                        
                        [self.view makeToast:@"没有可发布的内容"];
                        return;
                    }
                    
                }
                if (self.mentallViewArray.count == 1) {
                    

                    if (self.mentallViewArray.count == 1) {
                        //提示没有可保存的gesturesView
                        
                        [self.view makeToast:@"单个单品不能发布"];
                        return;
                    }
                    
                }
                
                
                [self performSegueWithIdentifier:@"TemplatePublishCollocationVC" sender:self.mentallViewArray];
                
                break;
                
            case 1:{
                NSLog(@"保存");
                
                
                if (self.mentallViewArray == nil||self.mentallViewArray.count == 0) {
                    

                    if (self.mentallViewArray == nil||self.mentallViewArray.count == 0) {
                        //提示没有可保存的gesturesView
                        
                        [self.view makeToast:@"亲,没有可保存的内容"];
                        return;
                    }
                    
                }
                if (self.mentallViewArray.count == 1) {
                    

                    if (self.mentallViewArray.count == 1) {
                        //提示没有可保存的gesturesView
                        
                        [self.view makeToast:@"亲,单个单品不能保存"];
                        return;
                    }
                    
                }
                
                [self uploaddataWithModelTemplate:self.mentallViewArray];
                
                }
                break;
            case 2:
                
            {
                NSLog(@"新建");
                
                
                if (self.mentallViewArray.count == 0 || self.mentallViewArray == nil) {
                    return;
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"造型师" message:@"亲,确定要放弃搭配吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 7777;
                [alert show];
                
            }
                break;
            case 3:
                NSLog(@"打开");
                 [self performSegueWithIdentifier:@"MentallyMyViewController" sender:nil];
//                [self performSegueWithIdentifier:@"MyViewController" sender:nil];
                
                break;
                
            default:
                break;
        }
    }
    
    
    
}


#pragma mark ---UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    
    if (alertView.tag == 7777) {
        if (buttonIndex == 1) {
            
            for(UIView *view in self.mentallViewArray)
            {
                [view removeFromSuperview];
            }
            [self.mentallViewArray removeAllObjects];
//            [self cleanCanvasSource];
        }
    }
    
}

#pragma mark -- MentallySuperViewDelegate 点击容器回调
-(void)callBackMentallySuperViewWithDetailMapping:(DetailMapping *)detailMapping LayoutMapping:(LayoutMapping *)layoutMapping withMentallView:(id)mentallyView{
    
    _mentallSuperView.gesturesImageView.isFirstClick = NO;
    [_mentallSuperView.gesturesImageView crossBorderDisappearevent];
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, belowwidth);
    } completion:^(BOOL finished) {
        _mentallSuperView = mentallyView;
    }];

    _mentallSuperView = mentallyView;
    [self performSegueWithIdentifier:@"CategoryViewController" sender:nil];
    
}
#pragma mark -- MentallySuperViewDelegate 点击商品图片回调
//
-(void)callBackMentallySuperViewWithMentallView:(id)mentallyView withGesturesImageView:(GesturesImageView *)gesturesImageView isFirstClickmark:(BOOL)mark{

    MentallySuperView *clickmentallyView = (MentallySuperView *)mentallyView;
    //解决多个问题
    if (_mentallSuperView != mentallyView && _mentallSuperView.gesturesImageView.isFirstClick == YES) {
        
        _mentallSuperView.gesturesImageView.isFirstClick = NO;
        [_mentallSuperView.gesturesImageView crossBorderDisappearevent];
        clickmentallyView.gesturesImageView.isFirstClick = NO;
        [clickmentallyView.gesturesImageView crossBorderDisappearevent];
        [UIView animateWithDuration:0.3 animations:^{
            _bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, belowwidth);
        } completion:^(BOOL finished) {
            _mentallSuperView = mentallyView;
        }];
       
        return;
    }
    
        _mentallSuperView = mentallyView;
    //解决单个问题
        if (mark == NO) {
            [UIView animateWithDuration:0.3 animations:^{
                
                _bottomView.frame = CGRectMake(0, self.view.frame.size.height-positionHeight, self.view.frame.size.width, belowwidth);
                NSLog(@"%@",NSStringFromCGRect(_bottomView.frame));
                [self.view bringSubviewToFront:_bottomView];
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                _bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, belowwidth);
            } completion:^(BOOL finished) {
                
            }];
        }

       
}

#pragma MyViewControllerDelegate  模板回调 回调和方法都需要
-(void)callBackMyViewControllerWithServicemubantemplateElement:(id)sender{
    for(UIView *view in self.mentallViewArray)
    {
        [view removeFromSuperview];
    }
    [self.mentallViewArray removeAllObjects];
    
    TemplateElement *tmp_templateElement = (TemplateElement *)sender;
    [self requestCollocationModuleEditFilterWithModuleid:tmp_templateElement.templateInfo.id];
  
    
}

#pragma MyViewControllerDelegate  草稿搭配回调 毁掉和方法都需要
-(void)callBackMyViewControllerWithServiceCollocationInfo:(id)sender{

    for(UIView *view in self.mentallViewArray)
    {
        [view removeFromSuperview];
    }
    [self.mentallViewArray removeAllObjects];
    [self requestHttpCollocationEditFilterWithCollocationInfo:sender];

}

#pragma mark -- 根据模板id查找模板详细信息
-(void)requestCollocationModuleEditFilterWithModuleid:(NSString *)moduleid{
    
    [[HttpRequest shareRequst] httpRequestGetCollocationModuleEditFilterWithDic:(NSMutableDictionary *)@{@"ID":[NSNumber numberWithInteger:moduleid.integerValue]} success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                //遍历数组解析
                
                for (NSDictionary *dic in data)
                {
                    
                    TemplateElement *templateElement = [[TemplateElement alloc] init];
                    
                    TemplateInfo *templateInfo;
                    templateInfo=[JsonToModel objectFromDictionary:[dic objectForKey:@"moduleInfo"] className:@"TemplateInfo"];
                    templateElement.templateInfo = templateInfo;
                    
                    id detaildata =[dic objectForKey:@"detailList"];
                    if ([detaildata isKindOfClass:[NSArray class]])
                    {
                        for (NSDictionary *detaildic in detaildata)
                        {
                            DetailMapping*detailMapping ;
                            detailMapping = [JsonToModel objectFromDictionary:detaildic className:@"DetailMapping"];
                            [templateElement.detailMappingList addObject:detailMapping];
                        }
                        
                    }
                    
                    id layoutdata = [dic objectForKey:@"layoutMappingList"];
                    if ([layoutdata isKindOfClass:[NSArray class]])
                    {
                        for (NSDictionary *layoutdic in layoutdata)
                        {
                            LayoutMapping *layoutMapping;
                            layoutMapping = [JsonToModel objectFromDictionary:layoutdic className:@"LayoutMapping"];
                            //add by miao 4.8
                            NSArray *contentList = [layoutdic objectForKey:@"contentList" ];
                            if (contentList>0) {
                                layoutMapping.contentInfo = [JsonToModel objectFromDictionary:contentList.firstObject  className:@"ContentInfo"];
                               layoutMapping.contentInfo.crossInfo = [JsonToModel objectFromDictionary:[contentList.firstObject objectForKey:@"crossInfo"] className:@"CrossInfo"];
                                
                            }
                            
                            [templateElement.layoutMappingList addObject:layoutMapping];
                        }
                    }
                    _templateElement = templateElement;
                      [self createMentallViewsbytemplateElement:_templateElement];
//                    [_datatemplateElementarray addObject:templateElement];
                    
                }
            }
        }

    } fail:^(NSString *errorMsg) {
        
    }];
    
    
    
}
#pragma mark -根据collocationInfo的id请求编辑信息

-(void)requestHttpCollocationEditFilterWithCollocationInfo:(CollocationInfo *)collocationInfo{
    
    [[HttpRequest shareRequst] httpRequestGetCollocationEditFilterWithDic:(NSMutableDictionary *)@{@"id":collocationInfo.id} success:^(id obj)
     {
         
         if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
         {
             id data = [obj objectForKey:@"results"];
             if ([data isKindOfClass:[NSArray class]])
             {
                 //遍历数组解析
                 
                 for (NSDictionary *dic in data)
                 {
                     CollocationElement *collocationElement = [[CollocationElement alloc] init];
                     
                     CollocationInfo *collocationInfo;
                     collocationInfo=[JsonToModel objectFromDictionary:[dic objectForKey:@"collocationInfo"] className:@"CollocationInfo"];
                     collocationElement.collocationInfo = collocationInfo;
                     
                     id topicdata =[dic objectForKey:@"topicMapping"];
                     if ([topicdata isKindOfClass:[NSArray class]])
                     {
                         for (NSDictionary *topicdic in topicdata)
                         {
                             TopicMapping *topicMapping ;
                             topicMapping = [JsonToModel objectFromDictionary:topicdic className:@"TopicMapping"];
                             [collocationElement.topicMappingList addObject:topicMapping];
                         }
                         
                     }
                     
                     id tagdata =[dic objectForKey:@"tagMapping"];
                     if ([tagdata isKindOfClass:[NSArray class]])
                     {
                         for (NSDictionary *tagdic in topicdata)
                         {
                             TagMapping *tagMapping ;
                             tagMapping = [JsonToModel objectFromDictionary:tagdic className:@"TagMapping"];
                             [collocationElement.tagMappingList addObject:tagMapping];
                         }
                         
                     }
                     
                     id detaildata =[dic objectForKey:@"detailList"];
                     if ([detaildata isKindOfClass:[NSArray class]])
                     {
                         for (NSDictionary *detaildic in detaildata)
                         {
                             DetailMapping*detailMapping ;
                             detailMapping = [JsonToModel objectFromDictionary:detaildic className:@"DetailMapping"];
                             [collocationElement.detailMappingList addObject:detailMapping];
                         }
                         
                     }
                     
                     id layoutdata = [dic objectForKey:@"layoutMappingList"];
                     if ([layoutdata isKindOfClass:[NSArray class]])
                     {
                         for (NSDictionary *layoutdic in layoutdata)
                         {
                             LayoutMapping *layoutMapping;
                             layoutMapping = [JsonToModel objectFromDictionary:layoutdic className:@"LayoutMapping"];
                             //add by miao 4.8
                             NSArray *contentList = [layoutdic objectForKey:@"contentList" ];
                             if (contentList>0) {
                                 layoutMapping.contentInfo = [JsonToModel objectFromDictionary:contentList.firstObject  className:@"ContentInfo"];
                                  layoutMapping.contentInfo.crossInfo = [JsonToModel objectFromDictionary:[contentList.firstObject objectForKey:@"crossInfo"] className:@"CrossInfo"];
                             }
                             
                             [collocationElement.layoutMappingList addObject:layoutMapping];
                         }
                     }
                     [self createMentallViewsbycollocationElement:collocationElement];
                 }
                
             }
             
           
             
         }
         
         
     } ail:^(NSString *errorMsg) {
         NSLog(@"%@",errorMsg);
     }];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"TemplatePublishCollocationVC"]) {
        TemplatePublishCollocationVC * templatePublishCollocationVC = segue.destinationViewController;
        templatePublishCollocationVC.mentallyViewArray = (NSMutableArray *)sender;
    }
    if ([segue.identifier isEqualToString:@"MentallyMyViewController"]) {
        MentallyMyViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}


@end
