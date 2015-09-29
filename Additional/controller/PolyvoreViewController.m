//
//  ViewController.m
//  newdesigner
//
//  Created by Miaoz on 14-9-11.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "PolyvoreViewController.h"
#import "GesturesImageView.h"
#import "GesturesView.h"
#import "MakeViewController.h"
#import "MyViewController.h"
#import "CategoryViewController.h"
#import "PublishCollocationViewController.h"
#import "PhotoObj.h"
#import "PhotoVO.h"
#import "DraftVO.h"
#import "DataBase.h"
#import "Globle.h"
#import "GoodObj.h"
#import "CollocationElement.h"
#import "TemplateElement.h"
#import "TagMapping.h"
#import "MaterialMapping.h"
//#import "MainTabViewController.h"
#import "ShareTopView.h"
#import "NavigationTitleView.h"
#import "SimilarGoodsViewController.h"
#import "FontTextEditViewController.h"
#import "NSDateAdditions.h"
#import "SwipeSaveGoodsViewController.h"
#import "MLKMenuPopover.h"

@interface PolyvoreViewController ()<UIGestureRecognizerDelegate,GesturesImageViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,GesturesViewDelegate,MyViewControllerDeleagte,UIAlertViewDelegate,MLKMenuPopoverDelegate>
@property(strong,nonatomic)    UITapGestureRecognizer *singleFinger;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic)  GesturesView *gesturesView;
@property (strong,nonatomic) NSMutableArray *gesturesViewArray;
@property (strong,nonatomic) DraftVO *callbackDraftVo;

@property (strong,nonatomic) NSMutableArray *previousAndNextArray;
@property (nonatomic,strong)NSString *replaceStr;
@property (nonatomic,strong)NSString * uniquesessionid;
//@property(nonatomic,strong)NavigationTitleView *navview;
@property(nonatomic,strong)MLKMenuPopover *menuPopover;
@end

@implementation PolyvoreViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self hideTabbar];
    
    self.navigationController.navigationBarHidden = NO;
    //     self.gesturesView.centerImgView.hidden = NO;
    NSLog(@"sns.ldap_uid-----%@",sns.ldap_uid);
    NSLog(@"[AppSetting getUserID]---%@",[AppSetting getUserID]);
  NSLog(@"[AppSetting getFafaJid]---%@",[AppSetting getFafaJid]);
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:-62135596800000];
//    NSLog(@"1363948516  = %@",confromTimesp);
}


-(void)creatLineViews{
    UIView *boardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width -20,self.view.frame.size.width -20)];
//    boardView.layer.masksToBounds = YES;
//    boardView.backgroundColor = [UIColor redColor];
    boardView.center = CGPointMake(self.view.center.x, self.view.center.y-60);
    [self.view addSubview:boardView];
    UIView *toplineView = [[UIView alloc] initWithFrame:CGRectMake(boardView.bounds.origin.x, boardView.bounds.origin.y, boardView.frame.size.width, 0.5)];
    toplineView.backgroundColor = [UIColor lightGrayColor];
    [boardView addSubview:toplineView];
    
    UIView *rightlineView = [[UIView alloc] initWithFrame:CGRectMake(boardView.bounds.size.width, boardView.bounds.origin.y, 0.5, boardView.frame.size.height)];
    rightlineView.backgroundColor = [UIColor lightGrayColor];
    [boardView addSubview:rightlineView];

    UIView *bottomlineView = [[UIView alloc] initWithFrame:CGRectMake(boardView.bounds.origin.x,  boardView.frame.size.height, boardView.frame.size.width, 0.5)];
    bottomlineView.backgroundColor = [UIColor lightGrayColor];
    [boardView addSubview:bottomlineView];

    UIView *leftlineView = [[UIView alloc] initWithFrame:CGRectMake(boardView.bounds.origin.x, boardView.bounds.origin.y, 0.5, boardView.frame.size.height)];
    leftlineView.backgroundColor = [UIColor lightGrayColor];
    [boardView addSubview:leftlineView];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   
//    _navview = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    
//    _navview.lbTitle.text = @"添加搭配";
//    [_navview createTitleView:CGRectMake(0, 0, self.view.frame.size.width, 60) delegate:self selectorBack:@selector(backHome)  selectorOk:nil selectorMenu:@selector(rightBtnClick)];
//    [self.view addSubview:_navview];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [Toast hideToastActivity];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self creatollocation];

    //添加线框12.30
//    [self creatLineViews];
    if (IOS7_OR_LATER) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#262626"];
       
    }else{
    　self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#262626"];
    }
   [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]];
    [self SetLeftButton:@"关闭" Image:nil];
    
    
    
    [self creatGesturesView];
    if (_gesturesView != nil) {
        _gesturesView.belowScrollView.hidden = NO;
    }
   
    
    if (_previousAndNextArray == nil) {
          _previousAndNextArray = [NSMutableArray new];
    }
   
    [self creatNotificationCenter];
 
    [self addTapRecognizer];
   
    [self requestHttpCollocationSystemModuleFilter];
   
    
 
//    [self requestServiceAccesstoken];
//       [self creatgesturesImageView];
       }
-(void)addTapRecognizer
{
    //点击手势
    if (_singleFinger == nil) {
        UITapGestureRecognizer *singleFinger;
        
        singleFinger = [[UITapGestureRecognizer alloc] initWithTarget:self action:
                        @selector(handleEvent:)];
        singleFinger.numberOfTouchesRequired = 1;
        singleFinger.numberOfTapsRequired = 1;
        _singleFinger = singleFinger;
        [self.view addGestureRecognizer:singleFinger];
    }
   
}
-(void)handleEvent:(id)sender{

    [self performSegueWithIdentifier:@"CategoryViewController" sender:nil];
    

}
-(void)creatNotificationCenter{
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addChooseGoodsMethods:) name:NOTICE_ADDCHOOSEGOODS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanCanvasSource) name:NOTICE_CLEANCANCANVAS object:nil];

}
-(void)addChooseGoodsMethods:(NSNotification *)notification{
    
    self.gesturesView.centerImgView.hidden = YES;
    [_singleFinger setEnabled:NO];
    //add by miao 3.7 选择商品时重置其他的数据对象
    self.gesturesView.templateElement = nil;
    self.gesturesView.collocationElement.collocationInfo = nil;

    NSDictionary *notificationdic = notification.userInfo;
    GoodObj *goodObj = [notificationdic objectForKey:@"GoodObj"];
    //11.25 add by Miao
    CGFloat ratioNum  ;
    NSLog(@"============goodObj.clsPicUrl.width.floatValue -%f",goodObj.clsPicUrl.width.floatValue);
    if (goodObj.clsPicUrl.width == nil ) {
        goodObj.clsPicUrl.width = [NSString stringWithFormat:@"1000"];
        goodObj.clsPicUrl.height =[NSString stringWithFormat:@"1000"];
    }
    if (goodObj.clsPicUrl.width.floatValue >=[Globle shareInstance].globleWidth) {
        ratioNum = [Globle shareInstance].globleWidth/(2.5*goodObj.clsPicUrl.width.floatValue);
    }else{
        
//        if (goodObj.clsPicUrl.height.floatValue >[Globle shareInstance].globleWidth) {
//            ratioNum = [Globle shareInstance].globleWidth/(2.5*goodObj.clsPicUrl.width.floatValue);
//        }else{
            ratioNum = 0.4;
//        }
       
    }
    
    //11.21 add by miao
    //如果是下方漂浮框替换功能
    if ([_replaceStr isEqualToString:@"replaceYES"]) {
//
        [self.gesturesView.clickGesturesImageView removeFromSuperview];
//        CGRectMake(self.gesturesView.clickGesturesImageView.frame.origin.x,self.gesturesView.clickGesturesImageView.frame.origin.y, goodObj.clsPicUrl.width.floatValue*ratioNum, goodObj.clsPicUrl.height.floatValue*ratioNum)
        goodObj.isReplace = @"1";//frame
        [self.gesturesView addGesturesImageView:self.gesturesView.clickGesturesImageView.bounds image:nil center:self.gesturesView.clickGesturesImageView.center withdraftNum:NSStringFromCGAffineTransform(self.gesturesView.clickGesturesImageView.transform) withtGoodObj:goodObj];
        _replaceStr = @"replaceNO";
        return;
    }
    
    [self.gesturesView addGesturesImageView:CGRectMake(0, 0, goodObj.clsPicUrl.width.floatValue*ratioNum, goodObj.clsPicUrl.height.floatValue*ratioNum) image:nil center:CGPointMake(self.view.center.x, self.view.center.y-100) withdraftNum:nil withtGoodObj:goodObj];
    
}



-(void)creatGesturesView{
    if (_gesturesView == nil) {
        GesturesView *gesturesView =
//        gesturesView = [[GesturesView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width -20,self.view.frame.size.width -20)];
//        gesturesView.layer.masksToBounds = YES;
        gesturesView = [[GesturesView alloc] initWithFrame:self.view.frame];
        gesturesView.backgroundColor = [UIColor clearColor];
       gesturesView.delegate = self;
        _gesturesView = gesturesView;
//       self.gesturesView.polyvoreVC = self;
        [self.view addSubview:gesturesView];
    }
   

}
#pragma mark ----裁剪相关回调

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"MakeViewController"]) {
        MakeViewController *makeViewController = segue.destinationViewController;
        
//        makeViewController.selectImage = self.gesturesView.clickGesturesImageView.image;
        GesturesImageView *gesturesImageView = (GesturesImageView *)sender;
        makeViewController.mainGesturesImageView = gesturesImageView;
        makeViewController.lastWidth = gesturesImageView.frame.size.width;
        makeViewController.lastHeight = gesturesImageView.frame.size.height;
//        makeViewController.lastWidth = gesturesImageView.image.size.width;
//        makeViewController.lastHeight = gesturesImageView.image.size.height;
        //回调
        [makeViewController makeViewVCSourceVoBlockWithsourceVO:^(id sender, UIImage *shearimage) {
            NSString *shearimageurl;
            if ([sender isKindOfClass:[GoodObj class]]) {
                GoodObj *goodobj = (GoodObj *)sender;
                shearimageurl =goodobj.shearPicUrl;
            }else if([sender isKindOfClass:[MaterialMapping class]]){
                MaterialMapping *materialMapping = (MaterialMapping *)sender;
                shearimageurl =materialMapping.shearPicUrl;
            }else if([sender isKindOfClass:[DetailMapping class]]){
                DetailMapping *detailMapping = (DetailMapping *)sender;
                shearimageurl =detailMapping.shearPicUrl;
            
            }
            //如果是剪裁替换
            
            if ([sender isKindOfClass:[GoodObj class]]) {
                
                GoodObj *goodobj = (GoodObj *)sender;
                [self.gesturesView.clickGesturesImageView removeFromSuperview];//shearimage.size.width/4
                
                [self.gesturesView addGesturesImageView:CGRectMake(self.gesturesView.clickGesturesImageView.frame.origin.x,self.gesturesView.clickGesturesImageView.frame.origin.y,shearimage.size.width , shearimage.size.height) image:shearimage center:self.gesturesView.clickGesturesImageView.center withdraftNum:NSStringFromCGAffineTransform(self.gesturesView.clickGesturesImageView.transform) withtGoodObj:goodobj];
                //self.gesturesView.clickGesturesImageView.width , self.gesturesView.clickGesturesImageView.width
                
                
            }else if([sender isKindOfClass:[MaterialMapping class]]){
                
                MaterialMapping *materialMapping = (MaterialMapping *)sender;
                
                [self.gesturesView.clickGesturesImageView removeFromSuperview];
                
                [self.gesturesView addGesturesImageView:CGRectMake(self.gesturesView.clickGesturesImageView.frame.origin.x,self.gesturesView.clickGesturesImageView.frame.origin.y,shearimage.size.width , shearimage.size.height) image:shearimage center:self.gesturesView.clickGesturesImageView.center withdraftNum:NSStringFromCGAffineTransform(self.gesturesView.clickGesturesImageView.transform) MaterialMapping:materialMapping];
                
                
                
            }else if([sender isKindOfClass:[DetailMapping class]]){
                
                DetailMapping *detailMapping = (DetailMapping *)sender;
//                shearimage.size.width , shearimage.size.height
                [self.gesturesView.clickGesturesImageView removeFromSuperview];
                NSLog(@" shearimage.size.width----%f----%f", shearimage.size.width, shearimage.size.height);
                [self.gesturesView addGesturesImageView:CGRectMake(self.gesturesView.clickGesturesImageView.frame.origin.x,self.gesturesView.clickGesturesImageView.frame.origin.y,shearimage.size.width , shearimage.size.height) image:shearimage center:self.gesturesView.clickGesturesImageView.center withdraftNum:NSStringFromCGAffineTransform(self.gesturesView.clickGesturesImageView.transform) withtDetailMapping:detailMapping];
                
            }


        }];
        
        
    }
    
    if ([segue.identifier isEqualToString:@"MyViewController"]) {
        MyViewController *myViewController =segue.destinationViewController;
        myViewController.delegate = self;
        if ([sender isEqualToString:@"3"]) {
             myViewController.clickNumStr = (NSString *)sender;//3是更多模板点击
        }
      
    }
    if ([segue.identifier isEqualToString:@"CategoryViewController"]) {
        CategoryViewController *categoryVC = segue.destinationViewController;
        //12.17 add by miao
        if ([_replaceStr isEqualToString:@"replaceYES"]) {
            categoryVC.replaceStr = @"replaceYES";
        }else{
         categoryVC.replaceStr = @"replaceNO";
        }
        [categoryVC categoryVCMaterialBlockWithMaterialMapping:^(id sender) {
            
            MaterialMapping *materialMapping = (MaterialMapping *)sender;
            
            self.gesturesView.centerImgView.hidden = YES;
            [_singleFinger setEnabled:NO];
            
            //11.25 add by miao
            if (materialMapping.width !=nil && materialMapping.width.intValue != 0) {
                
                CGFloat ratioNum ;
                if (materialMapping.width.floatValue >=[Globle shareInstance].globleWidth) {
                    ratioNum = [Globle shareInstance].globleWidth/(2*materialMapping.width.floatValue);
                }else{
                    if (materialMapping.height.floatValue >[Globle shareInstance].globleWidth) {
                        ratioNum = [Globle shareInstance].globleWidth/(2*materialMapping.width.floatValue);
                    }else{
                    ratioNum = 1;
                    }
                    
                }
                if ([_replaceStr isEqualToString:@"replaceYES"])
                {
                    
                    [self.gesturesView.clickGesturesImageView removeFromSuperview];
                    [self.gesturesView addGesturesImageView:CGRectMake(self.gesturesView.clickGesturesImageView.frame.origin.x,self.gesturesView.clickGesturesImageView.frame.origin.y,materialMapping.width.intValue*ratioNum, materialMapping.height.intValue*ratioNum) image:nil center:self.gesturesView.clickGesturesImageView.center withdraftNum:nil MaterialMapping:materialMapping];
                    
                    _replaceStr = @"replaceNO";
                    return;
                }
                
                //添加素材
                [self.gesturesView  addGesturesImageView:CGRectMake(0, 0, materialMapping.width.intValue*ratioNum, materialMapping.height.intValue*ratioNum) image:nil center:CGPointMake(self.view.center.x, self.view.center.y-100) withdraftNum:nil  MaterialMapping:materialMapping];
            }else
            {
            
            //11.21  暂不修改
            UIImageFromURL([NSURL URLWithString:materialMapping.pictureUrl], ^(UIImage *image) {
                //如果是下方漂浮框替换功能
                if ([_replaceStr isEqualToString:@"replaceYES"])
                {
                   
                    [self.gesturesView.clickGesturesImageView removeFromSuperview];
                    [self.gesturesView addGesturesImageView:CGRectMake(self.gesturesView.clickGesturesImageView.frame.origin.x,self.gesturesView.clickGesturesImageView.frame.origin.y, image.size.width/4, image.size.height/4) image:image center:self.gesturesView.clickGesturesImageView.center withdraftNum:nil MaterialMapping:materialMapping];
                    
                    _replaceStr = @"replaceNO";
                    return;
                }
                
                //添加素材
                [self.gesturesView  addGesturesImageView:CGRectMake(0, 0, image.size.width/4, image.size.height/4) image:image center:CGPointMake(self.view.center.x, self.view.center.y-100) withdraftNum:nil  MaterialMapping:materialMapping];
            }, ^{
                
            });
            
            }
           
        }];

    }
    if ([segue.identifier isEqualToString:@"PublishCollocationViewController"]) {
        PublishCollocationViewController *publishCollocationVC = segue.destinationViewController;
        publishCollocationVC.gesturesViewArray = _gesturesView.subviewArray;
        publishCollocationVC.gesturesView = self.gesturesView;
    }

    if ([segue.identifier isEqualToString:@"SimilarGoodsViewController"]) {//
        SimilarGoodsViewController *similarGoodsVC = segue.destinationViewController;
        similarGoodsVC.datasource = sender;
    }
    
    if ([segue.identifier isEqualToString:@"FontTextEditViewController"]) {//
        FontTextEditViewController *fontTexteditVC = segue.destinationViewController;
         fontTexteditVC.backGroundImage = sender;
        [fontTexteditVC fontTextEditVCBlockWithGesturesImgView:^(id sender) {
            if ([sender isKindOfClass:[GesturesImageView class]]) {
                GesturesImageView * gesturesImageView= (GesturesImageView *)sender;
//                [self.gesturesView addSubview:gesturesImageView];
//                 gesturesImageView.delegate = self;
                
                //添加素材 gesturesImageView.image
                [self.gesturesView  addGesturesImageView:CGRectMake(0, 0, gesturesImageView.image.size.width, gesturesImageView.image.size.height) image:nil center:gesturesImageView.center withdraftNum:NSStringFromCGAffineTransform(gesturesImageView.transform)   MaterialMapping:gesturesImageView.materialMapping];
            }
        }];
       
    }
}

-(void)requestServiceAccesstoken{
    [[HttpRequest shareRequst] httpRequestGetSOAaccessTokenWithdic:nil success:^(id obj) {
        
        NSString *access_token =  [obj objectForKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:@"AccessToken"];
        
//        [self requestHttpCollocationSystemModuleFilter];
    } fail:^(NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
        
        
    }];
}
#pragma mark -请求模板信息接口
-(void)requestHttpCollocationSystemModuleFilter{
    
    [[HttpRequest shareRequst] httpRequestGetCollocationSystemModuleFilter:(NSMutableDictionary *)@{@"pageIndex":[NSNumber numberWithInt:1],
                                                                             @"pageSize":[NSNumber numberWithInt:9]} success:^(id obj)
    {
        
            
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            //遍历数组解析
            NSMutableArray *templateElementArray = [NSMutableArray new];
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                
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

                           DetailMapping* detailMapping = [JsonToModel objectFromDictionary:detaildic className:@"DetailMapping"];
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
                            }
                            
                            [templateElement.layoutMappingList addObject:layoutMapping];
                        }
                    }
                    [templateElementArray addObject:templateElement];
                    
                }
                
              
            }
            
            //添加底部悬浮框循环数据
            
             [self.gesturesView addMoretemplateButtonTobelowScrollView];
            if (templateElementArray == nil || templateElementArray.count == 0) {
                return ;
            }
            for (int i = 0; i<templateElementArray.count; i++) {
                TemplateElement *indextemplateElement = templateElementArray[i];
                [self.gesturesView addBottombuttonwithindex:i withServiceTemplateElement:indextemplateElement withtemplateElementArray:templateElementArray];
            }

        }
    } ail:^(NSString *errorMsg) {
//        [self requestHttpCollocationSystemModuleFilter];
    }];


}



#pragma mark -MyVIewControllerDelegate
//模板
-(void)callBackMyViewControllerWithServicemubantemplateElement:(id)sender{
    
    TemplateElement *templateElement = (TemplateElement *)sender;
    for(UIView *view in self.gesturesView.subviews)
    {
        if ([view isKindOfClass:GesturesImageView.class])
        {
            
            [view removeFromSuperview];
            [self.gesturesView.subviewArray removeObject:view];
        }
        
    }
    
   /*
    //请求过后添加编辑
    self.gesturesView.templateElement = templateElement;
    //11.24add by miao
    UIImageFromURL([NSURL URLWithString:[templateElement.templateInfo.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], ^(UIImage *image) {
        
       CGFloat rationalNum = templateElement.templateInfo.backWidth.intValue/[Globle shareInstance].globleWidth;
        NSString *rationalNumStr = [NSString stringWithFormat:@"%f",rationalNum];
        
        NSLog(@"--------------x--%f",rationalNum);
        
        if (templateElement.layoutMappingList!= nil) {
            for (int i = 0; i< templateElement.layoutMappingList.count; i++) {
                LayoutMapping *layoutMapping = templateElement.layoutMappingList[i];
                DetailMapping *detailMapping = templateElement.detailMappingList[i];
                [self.gesturesView repetitionGesturesImageViewWithServicedata:layoutMapping withDetailMapping:detailMapping withTemplateId:self.gesturesView.templateElement.templateInfo.id rationalNum:rationalNumStr];
            }
        }
        

        
    }, ^{
        
    });
    */
    self.gesturesView.centerImgView.hidden = YES;
     [_singleFinger setEnabled:NO];
    self.gesturesView.belowScrollView.hidden = YES;
    self.gesturesView.fuzzyView.hidden = NO;
    
    
    [self requestCollocationModuleEditFilterWithModuleid:templateElement.templateInfo.id];
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
                     self.gesturesView.templateElement = templateElement;
                    self.gesturesView.collocationElement = nil;
                    
                        CGFloat rationalNum = templateElement.templateInfo.backWidth.intValue/[Globle shareInstance].globleWidth;
                        NSString *rationalNumStr = [NSString stringWithFormat:@"%f",rationalNum];
                        
                        NSLog(@"--------------x--%f",rationalNum);
                        
                        if (templateElement.layoutMappingList!= nil) {
                            for (int i = 0; i< templateElement.layoutMappingList.count; i++) {
                                LayoutMapping *layoutMapping = templateElement.layoutMappingList[i];
                                DetailMapping *detailMapping = templateElement.detailMappingList[i];
                                [self.gesturesView repetitionGesturesImageViewWithServicedata:layoutMapping withDetailMapping:detailMapping withTemplateId:self.gesturesView.templateElement.templateInfo.id rationalNum:rationalNumStr];
                            }
                        }
                    
                }
            }
        }
        
    } fail:^(NSString *errorMsg) {
        
    }];
    
    
    
}

-(void)callBackMyViewControllerWithDraftvo:(DraftVO *)draftvo{
    
    
/*本地数据库时代码
    for(UIView *view in self.gesturesView.subviews)
    {
        if ([view isKindOfClass:GesturesImageView.class])
        {
            
            [view removeFromSuperview];
            [self.gesturesView.subviewArray removeObject:view];
        }
        
    }
   
    DraftVO *draftVO = draftvo;
    _callbackDraftVo = draftVO;
    NSString *str = [draftVO valueForKey:@"draftid"];
   NSString *str2 = [NSString stringWithFormat:@"%d",[str integerValue]+1] ;
    NSArray *photoArray = [[DataBase sharedDataBaseManager] queryPhotoArraybyDrftvo:draftVO];
    for (PhotoVO *photovo in photoArray) {
        [self.gesturesView repetitionGesturesImageView:photovo withDraftVO:draftvo draftNum:str2];
      
    }
    self.gesturesView.centerImgView.hidden = YES;
    self.gesturesView.belowScrollView.hidden = YES;
    self.gesturesView.fuzzyView.hidden = NO;
*/

}
//草稿 、 搭配
-(void)callBackMyViewControllerWithServiceCollocationInfo:(id)sender{
    CollocationInfo *collocationInfo = (CollocationInfo *)sender;

    for(UIView *view in self.gesturesView.subviews)
    {
        if ([view isKindOfClass:GesturesImageView.class])
        {
            
            [view removeFromSuperview];
            [self.gesturesView.subviewArray removeObject:view];

        }
        
    }
    
//    self.gesturesView.collocationElement = collocationElement;
//    
//    for (LayoutMapping *layoutMapping in collocationElement.layoutMappingList) {
//        [self.gesturesView repetitionGesturesImageViewWithServicedata:layoutMapping];
//    }
//    
    self.gesturesView.centerImgView.hidden = YES;
     [_singleFinger setEnabled:NO];
    self.gesturesView.belowScrollView.hidden = YES;
    self.gesturesView.fuzzyView.hidden = NO;
    
    //根据collocationInfo的id请求编辑信息
    [self requestHttpCollocationEditFilterWithCollocationInfo:collocationInfo];

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
                         }
                        
                         [collocationElement.layoutMappingList addObject:layoutMapping];
                     }
                 }
                 //请求过后添加编辑 11.24 add by miao
                 self.gesturesView.collocationElement = collocationElement;
                 self.gesturesView.templateElement = nil;// add by miao 3.3
//                 UIImageFromURL([NSURL URLWithString:[collocationElement.collocationInfo.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], ^(UIImage *image) {
//                           }, ^{
//
//                 });
                     CGFloat rationalNum = collocationElement.collocationInfo.backWidth.floatValue/[Globle shareInstance].globleWidth;
                     NSString *rationalNumStr = [NSString stringWithFormat:@"%f",rationalNum];
                     
                     NSLog(@"--------------x--%f",rationalNum);
                     
                     if (collocationElement.layoutMappingList!= nil) {
                         for (int i = 0; i< collocationElement.layoutMappingList.count; i++) {
                             LayoutMapping *layoutMapping = collocationElement.layoutMappingList[i];
                             DetailMapping *detailMapping = collocationElement.detailMappingList[i];
                             [self.gesturesView repetitionGesturesImageViewWithServicedata:layoutMapping withDetailMapping:detailMapping withTemplateId:self.gesturesView.collocationElement.collocationInfo.templateId rationalNum:rationalNumStr];
                             
                             
                         }
                     }
             }
         
        
         }
     }
 
 
 } ail:^(NSString *errorMsg) {
 NSLog(@"%@",errorMsg);
 }];
 
 
 }

#pragma mark -GesturesViewDelegate
-(void)callBackPreviousAndNextGesturesViewWithGestureImageview:(id)sender{
    GesturesImageView *view = (GesturesImageView *)sender;
    [_previousAndNextArray addObject:view];
}

-(void)callBackGesturesImageViewWithPhotovoArray:(id)sender{

    NSMutableArray *array = (NSMutableArray *)sender;
    self.gesturesViewArray = array;
    
    self.gesturesView.centerImgView.hidden = YES;
     [_singleFinger setEnabled:NO];

    

}

#pragma mark -保存到草稿请求
//只保存到草稿箱
-(void)requestDraftCreateWithtopicName:(NSString *)name BackWidth:(NSString *)backwidth Description:(NSString *)description UserId:(NSString *)userId CreateUser:(NSString *)creatuser DetailList:(NSMutableArray *)detaillist LayoutMappingList:(NSMutableArray *)layoutMappingList TemplateId:(NSString *)templateId{
    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setObject:name forKey:@"Name"];
    [dic setObject:[NSNumber numberWithInt:backwidth.intValue] forKey:@"BackWidth"];
    [dic setObject:description forKey:@"Description"];
    [dic setObject:userId forKey:@"UserId"];
    [dic setObject:creatuser forKey:@"CREATE_USER"];
    [dic setObject:detaillist forKey:@"DetailList"];
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
            [self cleanCanvasSource];
            [self.view makeToast:@"保存草稿箱成功"];
            _uniquesessionid = nil;
        }else{
        
            [self.view makeToast:@"保存草稿失败"];
        }
       
    } ail:^(NSString *errorMsg) {
        
    }];

    
}
#pragma mark-GesturesImageViewDelegate  下方模板
-(void)callBackGesturesImageViewWithtemplateElement:(id)sender withbuttonTag:(int)buttontag{
    if (buttontag== 69) {
        
        [self performSegueWithIdentifier:@"MyViewController" sender:@"3"];
        
        return;
    }
    
    TemplateElement *templateElement = (TemplateElement *)sender;
    for(UIView *view in self.gesturesView.subviews)
    {
        if ([view isKindOfClass:GesturesImageView.class])
        {
            
            [view removeFromSuperview];
            [self.gesturesView.subviewArray removeObject:view];
        }
        
    }


    self.gesturesView.centerImgView.hidden = YES;
     [_singleFinger setEnabled:NO];
    self.gesturesView.belowScrollView.hidden = YES;
    self.gesturesView.fuzzyView.hidden = NO;
    
    //    //请求过后添加编辑 11.24 add by miao
    //    self.gesturesView.templateElement = templateElement;
    //    self.gesturesView.collocationElement = nil;
    [self requestCollocationModuleEditFilterWithModuleid:templateElement.templateInfo.id];
}


-(void)callBackGesturesImageViewWithClickButton:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag -40 == 0) {//替换
//        _replaceStr = [NSString stringWithFormat:@"replaceYES"];
//        [self performSegueWithIdentifier:@"CategoryViewController" sender:nil];

        _replaceStr = [NSString stringWithFormat:@"replaceYES"];
        if (self.gesturesView.clickGesturesImageView.goodObj != nil) {
            //商品
            [self performSegueWithIdentifier:@"SimilarGoodsViewController" sender:self.gesturesView.clickGesturesImageView.goodObj];
      
        }else if (self.gesturesView.clickGesturesImageView.materialMapping){
//             [self.view makeToast:@"没有可替换的商品"];
//            return;
            //素材
          [self performSegueWithIdentifier:@"CategoryViewController" sender:nil];
        
        }else if(self.gesturesView.clickGesturesImageView.detailMapping != nil){
            
            if (self.gesturesView.clickGesturesImageView.detailMapping.sourceType.intValue == 1) {
              // 1是商品
                 [self performSegueWithIdentifier:@"SimilarGoodsViewController" sender:self.gesturesView.clickGesturesImageView.detailMapping];
                
            }else if (self.gesturesView.clickGesturesImageView.detailMapping.sourceType.intValue == 2){//标示2是素材
//                 [self.view makeToast:@"没有可替换商品"];
//                return;
              [self performSegueWithIdentifier:@"CategoryViewController" sender:nil];
            }
        }
        
        
    }
    else if(btn.tag -40 == 1){//remove
        
        [_singleFinger setEnabled:YES];
        if (_gesturesView.subviewArray.count == 0 || _gesturesView.subviewArray == nil) {
             self.gesturesView.centerImgView.hidden = NO;
        }
        
    }

    
    else if(btn.tag -40 == 4){//裁切
    //
        if ([_gesturesView.clickGesturesImageView.materialMapping.sourceType isEqualToString:@"3"]) {
             [self.view makeToast:@"文字没有裁剪功能"];
            return;
        }
        [self performSegueWithIdentifier:@"MakeViewController" sender:_gesturesView.clickGesturesImageView];
    
    }
    else if (btn.tag -40 == 7){//文字
        _gesturesView.clickGesturesImageView.alpha = 0.5f;
        //  //去掉划线
        [_gesturesView.clickGesturesImageView crossBorderDisappearevent];
        UIImage *shotImage = [self screenShot];
        [_gesturesView resetRecoveryGesturesImageView];
        [self performSegueWithIdentifier:@"FontTextEditViewController" sender:shotImage];
        
    }

   

}
#pragma mark -creatActionSheet
-(void)creatActionSheet
{

    if([ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone )
    {
        UIActionSheet *actionSheet;
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:@"相机"
                                         otherButtonTitles:
                       @"从相册选择",nil];
        actionSheet.tag = 444;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        [actionSheet showInView:[AppDelegate shareAppdelegate].window];
    }else
    {
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持此功能" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 555) {
        
        switch (buttonIndex) {
            case 0:
                NSLog(@"发布");
                
                if (self.gesturesViewArray == nil||self.gesturesViewArray.count == 0) {
                    
                    self.gesturesViewArray = self.gesturesView.subviewArray;
                    if (self.gesturesViewArray == nil||self.gesturesViewArray.count == 0) {
                        //提示没有可保存的gesturesView
                        
                        [self.view makeToast:@"没有可发布的内容"];
                        return;
                    }

                }
                if (self.gesturesViewArray.count == 1) {
                    
                    self.gesturesViewArray = self.gesturesView.subviewArray;
                    if (self.gesturesViewArray.count == 1) {
                        //提示没有可保存的gesturesView
                        
                        [self.view makeToast:@"单个单品不能发布"];
                        return;
                    }

                }
                

                [self performSegueWithIdentifier:@"PublishCollocationViewController" sender:nil];

                break;
               
            case 1:{
                NSLog(@"保存");
                
               
                if (self.gesturesViewArray == nil||self.gesturesViewArray.count == 0) {
                    
                    self.gesturesViewArray = self.gesturesView.subviewArray;
                    if (self.gesturesViewArray == nil||self.gesturesViewArray.count == 0) {
                        //提示没有可保存的gesturesView
                        
                        [self.view makeToast:@"亲,没有可保存的内容"];
                        return;
                    }
                 
                }
                if (self.gesturesViewArray.count == 1) {
                    
                    self.gesturesViewArray = self.gesturesView.subviewArray;
                    if (self.gesturesViewArray.count == 1) {
                        //提示没有可保存的gesturesView
                        
                        [self.view makeToast:@"亲,单个单品不能保存"];
                        return;
                    }
                  
                }

                [self uploaddata:self.gesturesViewArray];
                

            }
                break;
            case 2:
                
            {
                NSLog(@"新建");
            
                
                if (self.gesturesView.subviewArray.count == 0 || self.gesturesView.subviewArray == nil) {
                    return;
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"造型师" message:@"亲,确定要放弃搭配吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 7777;
                [alert show];
                /*
                for(UIView *view in self.gesturesView.subviews)
                {
                    if ([view isKindOfClass:GesturesImageView.class])
                    {
                        
                        [view removeFromSuperview];
                        [self.gesturesView.subviewArray removeObject:view];
                    }
                    
                }
                
                self.gesturesView.centerImgView.hidden = NO;
                [_singleFinger setEnabled:YES];
                self.gesturesView.belowScrollView.hidden = NO;
                self.gesturesView.fuzzyView.hidden = YES;
                
                [self.gesturesView disposeBrlowScrollViewAndBottomView];
                */

            }
                break;
            case 3:
                NSLog(@"打开");
                
                [self performSegueWithIdentifier:@"MyViewController" sender:nil];
                
                break;
          
            default:
                break;
        }
    }
   
    
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    
//    for (UIView *tempView in actionSheet.subviews) {
//
//        if ([tempView isKindOfClass:[UIButton class]]) {
//
//            UIButton *tempbtn = (UIButton *) tempView;
////            tempbtn.frame = CGRectMake(tempbtn.frame.origin.x, tempbtn.frame.origin.y, tempbtn.frame.size.width, tempbtn.frame.size.height -1);
//            [tempbtn setBackgroundColor:[UIColor blackColor]];
//            [tempbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////            tempbtn.titleLabel.textColor = [UIColor whiteColor];
//  
//        }
//
//    }
  
}






#pragma mark -从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePicker.allowsEditing = YES;
    
    [self presentViewController:_imagePicker animated:YES completion:^{
        
        
        NSLog(@"系统相册调用成功");
    }];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_ADDCHOOSEGOODS object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_CLEANCANCANVAS object:nil];

    NSLog(@"PolyvoreViewController---dealloc");
//    [self.view removeGestureRecognizer:_singleFinger];
//    _singleFinger = nil;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)uploaddata:(NSMutableArray *)array{
    
    if (array.count>0) {
        //11.20 add by miao
        GesturesImageView *view = array[0];
        //在最外层添加参数maintemplateId  内部搭配布局中的TemplateId及LayoutId 不再需要
        NSString *maintemplateId;
        if (view.templateId != nil) {
            maintemplateId = view.templateId;
        }else{
            maintemplateId = @"-1";
        }

        
       
        NSMutableArray*detaillist =[NSMutableArray new] ;
        NSMutableArray *layoutMappingList = [NSMutableArray new];
        
        for (int i = 0; i < array.count; i++) {
            GesturesImageView *view = array[i];
           
            
            NSString * productClsId;
            NSString *pictureurl;
            NSString *productName;
            NSString *productCode;
            NSString *productPrice;
            NSString *productColorCode;
            NSString *productColorNam;
            NSString *sourceType;
            NSString *templateId;
            NSString *layoutId = [NSString stringWithFormat:@"%d",i];
            NSString *index = [NSString stringWithFormat:@"%d",i];
          
            
            if (view.goodObj != nil) {//从商品列表选择
                GoodObj *goodObj = view.goodObj;
                productClsId = goodObj.clsInfo.id;
                if (goodObj.shearPicUrl != nil && ![goodObj.shearPicUrl isEqualToString:@""] ) {
                    pictureurl = goodObj.shearPicUrl;
                }else
                {
                  pictureurl = goodObj.clsPicUrl.filE_PATH;
                }

                productName = goodObj.clsInfo.name;
                productCode = goodObj.clsInfo.code;
                productPrice = goodObj.clsInfo.sale_price;
                productColorCode = goodObj.productColorMapping.code;
                productColorNam = goodObj.productColorMapping.name;

            if (goodObj.sourceType == nil) {
                    sourceType = @"1";
                }else{
                    sourceType = goodObj.sourceType;
                }

                templateId = [NSString stringWithFormat:@"-1"];
            }else if(view.detailMapping != nil){//从保存的草稿列表选择和模板选择
                DetailMapping *detailMapping = view.detailMapping;
                productClsId = detailMapping.productClsId;
                if (detailMapping.shearPicUrl != nil && ![detailMapping.shearPicUrl isEqualToString:@""] ) {
                    pictureurl = detailMapping.shearPicUrl;
                }else
                {
                    pictureurl = detailMapping.productPictureUrl;
                }


                productName = detailMapping.productName;
                productCode = detailMapping.productCode;
                  productPrice = detailMapping.productPrice;
                productColorCode = detailMapping.colorCode;
                productColorNam = detailMapping.colorName;
                if (detailMapping.sourceType == nil)
                {
                    sourceType = @"1";
                }else{
                    sourceType = detailMapping.sourceType;
                }

                
                if (self.gesturesView.templateElement.templateInfo != nil) {
                    templateId = self.gesturesView.templateElement.templateInfo.id;
                }else{
                    templateId = [NSString stringWithFormat:@"-1"];
                }

            }else if(view.materialMapping != nil){
                MaterialMapping *materialMapping = view.materialMapping;
                
                if (materialMapping.id != nil) {
                    productClsId = materialMapping.id;
                }
             
                if (materialMapping.shearPicUrl != nil && ![materialMapping.shearPicUrl isEqualToString:@""] ) {
                    pictureurl = materialMapping.shearPicUrl;
                }else
                {
                    pictureurl = materialMapping.pictureUrl;
                }
                sourceType = @"2";
                productName = @"素材";
                productCode = @"09";
                productPrice = @"0.0";
                productColorCode = @"09";
                productColorNam = @"无色";
               
                templateId = [NSString stringWithFormat:@"-1"];
            }
            
            //解决脏数据造成的问题
            if (pictureurl == nil || [pictureurl isEqualToString:@""]) {
                pictureurl = view.imageurl;
            }
           
            
            [detaillist addObject:@{@"ProductClsId":[NSNumber numberWithInt:productClsId.intValue],
                                    @"ProductName":productName,
                                    @"ProductCode":productCode,
                                    @"ColorCode":productColorCode,
                                    @"ColorName":productColorNam,
                                    @"ProductPrice":productPrice,
                                    @"ProductPictureUrl":pictureurl,
                                    @"SourceType":[NSNumber numberWithInt:sourceType.intValue]}];
            
            NSLog(@"%@---------%@",index,layoutId);
            NSDictionary *layoutDic = @{@"ProductClsId":[NSNumber numberWithInt:productClsId.intValue],
                                        @"ProductName":productName,
                                        @"LayoutId":[NSNumber numberWithInt:layoutId.intValue],
                                        @"TemplateId":[NSNumber numberWithInt:templateId.intValue],
                                        @"Index":[NSNumber numberWithInt:index.intValue],
                                        @"Width":[NSNumber numberWithInt:view.width],
                                        @"Height":[NSNumber numberWithInt:view.height],
                                        @"XPosition":[NSNumber numberWithInt:view.center.x],
                                        @"YPosition":[NSNumber numberWithInt:view.center.y],
                                        @"PictureUrl":pictureurl,
                                        @"RectSx":[NSNumber numberWithDouble:view.transform.a],
                                        @"RectRx":[NSNumber numberWithDouble:view.transform.b],
                                        @"RectRy":[NSNumber numberWithDouble:view.transform.c],
                                        @"RectSy":[NSNumber numberWithDouble:view.transform.d],
                                        @"TextFont_Id":view.layoutMapping.textFont_Id!=nil?[NSNumber numberWithInt:view.layoutMapping.textFont_Id.intValue]:[NSNumber numberWithInt:-1],
                                        @"TextPoint":view.layoutMapping.textPoint!=nil?[NSNumber numberWithInt:view.layoutMapping.textPoint.intValue]:[NSNumber numberWithInt:-1],
                                        @"TextScale":view.layoutMapping.textScale!=nil?[NSNumber numberWithFloat:view.layoutMapping.textScale.floatValue]:[NSNumber numberWithInt:-1],
                                        @"TextContent":view.layoutMapping.textContent!=nil?view.layoutMapping.textContent:@"-1",
                                        @"TextColor":view.layoutMapping.textColor!=nil?view.layoutMapping.textColor:@"-1"
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
#pragma mark --MLKMenuPopoverDelegate
- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex{
    [self.menuPopover dismissMenuPopover];
    switch (selectedIndex) {
        case 0:
            NSLog(@"发布");
            
            if (self.gesturesViewArray == nil||self.gesturesViewArray.count == 0) {
                
                self.gesturesViewArray = self.gesturesView.subviewArray;
                if (self.gesturesViewArray == nil||self.gesturesViewArray.count == 0) {
                    //提示没有可保存的gesturesView
                    
                    [self.view makeToast:@"没有可发布的内容"];
                    return;
                }
                
            }
            if (self.gesturesViewArray.count == 1) {
                
                self.gesturesViewArray = self.gesturesView.subviewArray;
                if (self.gesturesViewArray.count == 1) {
                    //提示没有可保存的gesturesView
                    
                    [self.view makeToast:@"单个单品不能发布"];
                    return;
                }
                
            }
            
            
            [self performSegueWithIdentifier:@"PublishCollocationViewController" sender:nil];
            
            break;
            
        case 1:{
            NSLog(@"保存");
            
            
            if (self.gesturesViewArray == nil||self.gesturesViewArray.count == 0) {
                
                self.gesturesViewArray = self.gesturesView.subviewArray;
                if (self.gesturesViewArray == nil||self.gesturesViewArray.count == 0) {
                    //提示没有可保存的gesturesView
                    
                    [self.view makeToast:@"亲,没有可保存的内容"];
                    return;
                }
                
            }
            if (self.gesturesViewArray.count == 1) {
                
                self.gesturesViewArray = self.gesturesView.subviewArray;
                if (self.gesturesViewArray.count == 1) {
                    //提示没有可保存的gesturesView
                    
                    [self.view makeToast:@"亲,单个单品不能保存"];
                    return;
                }
                
            }
            
            [self uploaddata:self.gesturesViewArray];
            
            
        }
            break;
        case 2:
            
        {
            NSLog(@"新建");
            
            
            if (self.gesturesView.subviewArray.count == 0 || self.gesturesView.subviewArray == nil) {
                return;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"造型师" message:@"亲,确定要放弃搭配吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 7777;
            [alert show];
            /*
             for(UIView *view in self.gesturesView.subviews)
             {
             if ([view isKindOfClass:GesturesImageView.class])
             {
             
             [view removeFromSuperview];
             [self.gesturesView.subviewArray removeObject:view];
             }
             
             }
             
             self.gesturesView.centerImgView.hidden = NO;
             [_singleFinger setEnabled:YES];
             self.gesturesView.belowScrollView.hidden = NO;
             self.gesturesView.fuzzyView.hidden = YES;
             
             [self.gesturesView disposeBrlowScrollViewAndBottomView];
             */
            
        }
            break;
        case 3:
            NSLog(@"打开");
            
            [self performSegueWithIdentifier:@"MyViewController" sender:nil];
            
            break;
            
        default:
            break;
    }




}
- (IBAction)rightBarButtonItemClickevent:(id)sender {
    /**系统自带
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布",@"保存草稿",@"新建",@"打开" , nil];
    actionsheet.tag = 555;
     [actionsheet showInView:[AppDelegate shareAppdelegate].window];
**/
    [self.menuPopover dismissMenuPopover];
    self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(0, [Globle shareInstance].globleAllHeight-250+10, self.view.frame.size.width, 250) menuItems:@[@"发布",@"保存草稿",@"新建",@"打开",@"取消"] imageArray:nil];
    self.menuPopover.delectStr = @"";
    self.menuPopover.menuPopoverDelegate = self;
    [self.menuPopover showInView:[AppDelegate shareAppdelegate].window];


}

-(void)LeftReturn:(UIButton *)sender{
//    SwipeSaveGoodsViewController *swipeSaveGoodsVC=[[SwipeSaveGoodsViewController alloc] initWithNibName:@"SwipeSaveGoodsViewController" bundle:nil];
//    [self presentViewController:swipeSaveGoodsVC animated:YES completion:^{
//        
//    }];

    
    if (_gesturesView.subviewArray.count == 0) {
        [self.parentViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"造型师" message:@"亲,确定要放弃搭配吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
        alert.tag = 8888;
        [alert show];
        
        
    }


}
- (IBAction)leftBarButtonItemClickevent:(id)sender {


    if (_gesturesView.subviewArray.count == 0) {
        [self.parentViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"造型师" message:@"亲,确定要放弃搭配吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
        alert.tag = 8888;
        [alert show];
       
    
    }
    
   
}
#pragma mark ---UIalertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 8888) {
        if (buttonIndex == 1) {
             [self cleanCanvasSource];

        }
    }
    
    if (alertView.tag == 7777) {
        if (buttonIndex == 1) {
            
            [self cleanCanvasSource];
        }
    }

}

#pragma mark--清空画布
-(void)cleanCanvasSource{
    for(UIView *view in self.gesturesView.subviews)
    {
        if ([view isKindOfClass:GesturesImageView.class])
        {
            
            [view removeFromSuperview];
            [self.gesturesView.subviewArray removeObject:view];
        }
        
    }
    
    self.gesturesView.centerImgView.hidden = NO;
    [_singleFinger setEnabled:YES];
    self.gesturesView.belowScrollView.hidden = NO;
    self.gesturesView.fuzzyView.hidden = YES;
    
    [self.gesturesView disposeBrlowScrollViewAndBottomView];


}
// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView{


}
- (IBAction)centerTopButtonClickevent:(id)sender {
//    [self creatActionSheet];
    _replaceStr = @"replaceNO";
    [self performSegueWithIdentifier:@"CategoryViewController" sender:nil];
//    NSMutableDictionary *dic = [NSMutableDictionary new];
    
  
//    NSString *str = [NSString stringWithFormat:@"%@/order/saveorder",HTTP_URL];
//    NSURL *url = [NSURL URLWithString:str];
//    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    __weak ASIFormDataRequest *tmp = request;
//    
//    
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)customer.Cid] forKey:@"Cid"];
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)customer.seatid] forKey:@"seatid"];
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)customer.shift] forKey:@"supplierid"];
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)customer.orderstate] forKey:@"shift"];
//    [dic setObject:customer.address forKey:@"address"];
//    [dic setObject:customer.bgdate forKey:@"bgdate"];
//    [dic setObject:customer.eddate forKey:@"eddate"];
//    [dic setObject:customer.linkname forKey:@"linkname"];
//    [dic setObject:customer.linkphone forKey:@"linkphone"];
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)customer.orderstate] forKey:@"orderstate"];
//    
//    NSMutableArray * goodsAry = [NSMutableArray  array];
//    for (List *list in customer.goods)
//    {
//        NSDictionary * dic = @{@"gid":[NSString stringWithFormat:@"%ld",(long)list.gid],@"amount":[NSString stringWithFormat:@"%ld",(long)list.amount],@"price":[NSString stringWithFormat:@"%ld",(long)list.price]};
//        
//        [goodsAry addObject:dic];
//    }
//    NSString * parser = [goodsAry JSONRepresentation];
//    [dic setObject:parser forKey:@"goods"];
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
//    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];   [request setPostBody:tempJsonData];
//    [request setPostBody:tempJsonData];
  
}






/*
 - (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
 
 {
 [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
 
 [self becomeFirstResponder];
 SystemSoundID                 soundID;
 NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
 AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
 AudioServicesPlaySystemSound (soundID);
 
 //检测到摇动
 
 }
 
 
 
 - (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
 
 {
 
 //摇动取消
 
 }
 
 
 
 - (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
 
 {
 
 //摇动结束
 
 if (event.subtype == UIEventSubtypeMotionShake) {
 
 //something happens
 
 }
 
 }
 */


 @end
