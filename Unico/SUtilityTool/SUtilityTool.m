//
//  SUtilityTool.m
//  Wefafa
//
//  Created by unico on 15/5/16.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SUtilityTool.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "WeFaFaGet.h"

#import "SClothingCategoryViewController.h"
#import "SUploadColllocationControlCenter.h"

// 这里追加新的API
// 1 显示用户页面
// 2 显示搭配页面
// 3 显示品牌页面
// 4 显示话题页面
// 5 显示单品页面
// 6 显示专题
// 7 显示相机
#import "MBBrandViewController.h"
// TODO:Topic
// TODO:Special
#import "JSWebViewController.h"
#import "SVideoWelcomeController.h"
#import "SearchViewController.h"
#import "SIntroController.h"
#import "SSearchViewController.h"
#import "ContactCustomerServiceViewController.h"
#import "SProductDetailViewController.h"
#import "SCollocationDetailViewController.h"
#import "SBrandSotryViewController.h"
#import "STopicDetailViewController.h"
#import "SBrandShowListControllerViewController.h"
#import "STopicViewController.h"
#import "SMineViewController.h"
#import "SFashionInfomationViewController.h"
#import "SItemViewController.h"
#import "SBestCollocationViewController.h"
#import "SStarStoreViewController.h"
#import "SBrandViewController.h"
#import "SBaseViewController.h"
#import "SDataCache.h"
#import "LNGood.h"
#import "SMainViewController.h"
#import "SActivityDiscountViewController.h"
#import "SHomeViewController.h"
#import "SActivityListViewController.h"
#import "ScanViewController.h"
#import "SLeftMainView.h"
#import "MBSettingViewController.h"
#import "SMBRedPacketViewController.h"
#import "MyOrderViewController.h"
#import "MyIncomeViewController.h"
#import "SLeftMainView.h" 
#import "MyLikeViewController.h"
#import "MBSettingMainViewController.h"
#import "SActivityReceiveViewController.h"
#import "SActivityListModel.h"
#import "SChatListController.h"
#import "MBSettingViewController.h"
#import "MyShoppingTrollyViewController.h"
#import "SMyTopicViewController.h"

#import "SCollocationDetailNoneShopController.h"

#import "SBrandStoryDetailViewController.h"
#import "SBrandPavilionViewController.h"
#import "DailyNewViewController.h"
#import "SBrandPavilionViewController.h"
#import "SDiscoverBrandListViewController.h"
#import "SClothingCategoryViewController.h"
#import "SDesignerViewController.h"
#import "PraiseBoxView.h"
#import "SLeftMainViewModel.h"
#import "GoodCollectionController.h"
#import "STagView.h"

static UIWindow *g_cameraStartSlideWindow = nil;


@interface SUtilityTool()<kLeftMainViewDelegate>{
    SIntroController *introductionView;
    SLeftMainView *leftSideView;
    GoodCollectionController *_goodCollectionVc;
}
@end

@implementation SUtilityTool
__strong static SUtilityTool *instance = nil;

static NSMutableDictionary *globalChatDict;

+(id)shared{
    if (!instance) {
        instance = [SUtilityTool new];
    }
    return instance;
}

#pragma mark - JSON helper
- (NSString*)getJSON:(NSObject*)info
{
    
    if ([NSJSONSerialization isValidJSONObject:info]) {
        NSError* error;
        NSData* registerData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        //去掉空格和换行符
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        
        NSRange range = {0,jsonString.length};
        
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        
        NSRange range2 = {0,mutStr.length};
        
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        return mutStr;
    }
    else {
        return nil;
    }
}

- (id)getObject:(NSString*)json
{
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSArray* info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return info;
}

#pragma mark -

-(CGSize) getStrLenByFontStyle:(NSString*) str fontStyle:(UIFont*) fontStyle{
    CGSize labelSize;
    if (!fontStyle) {
        fontStyle = [UIFont systemFontOfSize:17];
    }
    labelSize = [str sizeWithAttributes:@{ NSFontAttributeName : fontStyle }];
    return labelSize;
}



-(CGSize) getStrLenByFontStyle:(NSString*) str fontStyle:(UIFont*) fontStyle textWidth:(float) textWidth{
    if (!fontStyle) {
        fontStyle = [UIFont systemFontOfSize:17];
    }
    if ([str isEqual:[NSNull null]] || [str isEqualToString:@"(null)"]) {
        return CGSizeZero;
    }
    NSDictionary *attributes = @{NSFontAttributeName: fontStyle};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(textWidth, 0)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    return rect.size;
}

//生成带箭头的线
-(UIImage*)getArrowLine{
    UIImage* tempImage = [UIImage imageNamed:@"djt_line"];
    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 750/2, 2, 750/2-1) resizingMode:UIImageResizingModeStretch];
    return tempImage;
}

//带箭头的线
-(UIView*)getArrowLineUIView{
    UIImageView *imageView;
//    UIImage* tempImage = [UIImage imageNamed:@"xiaosanjiao"];
////    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 750/2, 2, 750/2-1) resizingMode:UIImageResizingModeStretch];
    imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/xiaosanjiao" rect:CGRectMake(26/2, 0, 17/2, 9/2)];
    UIView *tempUI = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 9/2)];
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, tempUI.height -1, UI_SCREEN_WIDTH, 1)];
     line.backgroundColor  = UIColorFromRGB(0xc4c4c4);
    [tempUI addSubview:line];
    [tempUI addSubview:imageView];
//    imageView = [[UIImageView alloc]initWithImage:tempImage];
//    [imageView setSize:CGSizeMake(UI_SCREEN_WIDTH, 10/2)];
    return tempUI;
}

//生成普通的线
-(UIImage*)getNormalLine{
    UIImage* tempImage = [UIImage imageNamed:@"line"];
    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeStretch];
    return tempImage;
}

//生成虚线
-(UIImage*)getDottedLine{
    UIImage* tempImage = [UIImage imageNamed:@"Unico/dotted_line"];
    return tempImage;
}

//生成label 中间文字 两边虚线
-(UIView*)createUILabelDottedLine:(NSString*)str height:(float)height color:(UIColor*) fontColor fontStyle:(UIFont*)fontStyle interval:(float) interval{
    if (!fontStyle) {
        fontStyle = FONT_T4;
    }
    if (!fontColor) {
        fontColor = COLOR_C2;
    }
    UIView *tempUI;
    CGSize labelSize = [self getStrLenByFontStyle:str fontStyle:fontStyle];
    tempUI = [self createUIViewByHeight:height coordY:0];
    tempUI.backgroundColor = [UIColor clearColor];
    UIImageView *tempView = [[UIImageView alloc]initWithImage:[self getDottedLine]];
    tempView.frame = CGRectMake(0, tempUI.frame.size.height/2, UI_SCREEN_WIDTH/2 - labelSize.width/2 - interval, 1);
    tempView.contentMode =  UIViewContentModeScaleAspectFill ;
    tempView.clipsToBounds = YES;
    [tempUI addSubview:tempView];
    tempView = [[UIImageView alloc]initWithImage:[self getDottedLine]];
    tempView.frame = CGRectMake(UI_SCREEN_WIDTH/2 +labelSize.width/2+interval, tempUI.frame.size.height/2, UI_SCREEN_WIDTH/2 - labelSize.width/2 - interval, 1);
    tempView.contentMode =  UIViewContentModeScaleAspectFill ;
    tempView.clipsToBounds = YES;
    [tempUI addSubview:tempView];
    
    UILabel *tempLabel = [self createUILabelByStyle:str fontStyle:fontStyle color:fontColor rect:CGRectMake(tempUI.frame.size.width/2-labelSize.width/2, tempUI.height/2 - labelSize.height/2, 0, labelSize.height)  isFitWidth:YES isAlignLeft:YES];
    [tempUI addSubview:tempLabel];
    tempUI.backgroundColor = [UIColor whiteColor];
    return  tempUI;
    
}

//生成label 中间文字 两边实线
-(UIView*)createUILabeLine:(NSString*)str color:(UIColor*) fontColor fontStyle:(UIFont*)fontStyle interval:(float) interval{
    UIView *tempUI;
    UIView *tempView;
    if (!fontStyle) {
        fontStyle = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    CGSize labelSize = [self getStrLenByFontStyle:str fontStyle:fontStyle];
    tempUI = [self createUIViewByHeight:labelSize.height coordY:0];
    
    tempUI.backgroundColor = [UIColor clearColor];
    tempView = [self getNormalLineBySize: UI_SCREEN_WIDTH/2 - labelSize.width/2 - interval -20/2 height:1 color:UIColorFromRGB(0xc4c4c4)];
    [tempView setOrigin:CGPointMake(20/2,  tempUI.frame.size.height/2)];
    [tempUI addSubview:tempView];
     tempView = [self getNormalLineBySize: UI_SCREEN_WIDTH/2 - labelSize.width/2 - interval -20/2 height:1 color:UIColorFromRGB(0xc4c4c4)];
    [tempView setOrigin:CGPointMake(UI_SCREEN_WIDTH/2 +labelSize.width/2+interval,  tempUI.frame.size.height/2)];
    [tempUI addSubview:tempView];
    
    UILabel *tempLabel = [self createUILabelByStyle:str fontStyle:fontStyle color:fontColor rect:CGRectMake(tempUI.frame.size.width/2-labelSize.width/2, 0, 0, 0)  isFitWidth:YES isAlignLeft:YES];
    [tempUI addSubview:tempLabel];
    
    return  tempUI;
}

//生成自定义的线
-(UIView*)getNormalLineBySize:(float)width height:(float)height color:(UIColor*)color{
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    if (!color) {
        color = COLOR_C9;
    }
    line.backgroundColor  = color;
    return line;
}

-(UIView*)getNormalLineByRect:(CGRect)rect color:(UIColor*)color{
    UIView* line = [[UIView alloc]initWithFrame:rect];
    line.backgroundColor  = color;
    return line;
}


//添加标签和闪烁动画
/*
 +-------+    +-------------------+
 |       |  /                     |
 |   o   | o       label          |
 |       |  \                     |
 +-------+    +-------------------+
 说明：正好左边的闪闪的点对齐传入的坐标
 */
-(UIImageView*)addTag:(NSString*) str fontStyle:(UIFont*)fontStyle boardingView:(UIView*)boardingView point:(CGPoint)point{
    if (!fontStyle) {
        fontStyle = FONT_SIZE(12);
    }

    // 我们认为当x的值落在(0-1]的范围内的时候，我们是按照比例
    if (point.x > 0 && point.x < 1.0f)
        point.x *= boardingView.size.width;
    if (point.y > 0 && point.y < 1.0f)
        point.y *= boardingView.size.height;
    
    UIImage *tempImage = [UIImage imageNamed:@"bq_d"];
    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(20/2-1, 34/2-5/2-1, 20/2-1, 5/2) resizingMode:UIImageResizingModeStretch];
    UIImageView *bqView = [[UIImageView alloc]initWithImage:tempImage];
    bqView.userInteractionEnabled = YES;
    NSString *tempStr =str;
    CGSize labelSize  = [tempStr sizeWithAttributes:@{ NSFontAttributeName : fontStyle }];
    
    bqView.frame =  CGRectMake(point.x+40/2/2, point.y-40/2/2, labelSize.width+30, 20);
    
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, labelSize.width, 20)];
    tempLabel.text = tempStr;
    tempLabel.font = fontStyle;
   
    tempLabel.textColor = [UIColor whiteColor];
    [bqView addSubview:tempLabel];
    [boardingView addSubview:bqView];
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    NSString *imageName;
    UIImage *image;
    for (int i = 1; i<9; i++)
    {
        imageName = [[NSString alloc] initWithFormat:@"u_tag_%d",i];
        image =[UIImage imageNamed:imageName];
        [imageArr addObject:image];
    }
    
    UIImageView *animationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-40/2, bqView.frame.size.height/2-40/2/2, 40/2, 40/2)];
    
    animationImageView.animationImages = imageArr;//将序列帧数组赋给UIImageView的animationImages属性
    animationImageView.animationDuration = 2;//设置动画时间
    animationImageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [animationImageView startAnimating];//开始播放动画
    [bqView addSubview:animationImageView];
    
    return bqView;
}

/* param
 attributes =     {
 flip = 1;
 id = 217;
 type = 1;
 };
 text = "\U96f7\U58eb\U897f\U88c5";
 x = "0.5314009661835749";
 y = "0.6167472065358921";
 */
- (UIImageView *)addTagWithDict:(NSDictionary *)dict inView:(UIImageView *)imageView limited:(BOOL)isLimited
{
    CGFloat xPoint = [[dict objectForKey:@"x"] floatValue];
    CGFloat yPoint = [[dict objectForKey:@"y"] floatValue];
    // 我们认为当x的值落在(0-1]的范围内的时候，我们是按照比例
    if (xPoint > 0 && xPoint < 1.0f)
        xPoint *= imageView.size.width;
    if (yPoint > 0 && yPoint < 1.0f)
        yPoint *= imageView.size.height;
    
    UIImage *tempImage = [UIImage imageNamed:@"bq_d"];
    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(20/2-1, 34/2-5/2-1, 20/2-1, 5/2) resizingMode:UIImageResizingModeStretch];
    UIImageView *bqView = [[UIImageView alloc]initWithImage:tempImage];
    bqView.userInteractionEnabled = YES;
    
    NSString *tagTitle = [dict objectForKey:@"text"];
    NSString *tempStr = @"我们是按照比例照比";
    if (isLimited) {
        if ([tagTitle length] <= 8) {
            tempStr = tagTitle;
        }
    }
    CGSize labelSize  = [tempStr sizeWithAttributes:@{ NSFontAttributeName : FONT_SIZE(12)}];
    if ((xPoint + labelSize.width + 30) > UI_SCREEN_WIDTH) {
        xPoint = UI_SCREEN_WIDTH - labelSize.width - 30;
    }
    bqView.frame =  CGRectMake(xPoint, yPoint-10, labelSize.width+30, 20);
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, labelSize.width+5, 20)];
    tempLabel.text = tagTitle;
    tempLabel.font = FONT_SIZE(12);
    tempLabel.textColor = [UIColor whiteColor];
    [bqView addSubview:tempLabel];
    [imageView addSubview:bqView];
    
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    NSString *imageName;
    UIImage *image;
    for (int i = 1; i<9; i++)
    {
        imageName = [[NSString alloc] initWithFormat:@"u_tag_%d",i];
        image =[UIImage imageNamed:imageName];
        [imageArr addObject:image];
    }
    
    UIImageView *animationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-40/2, bqView.frame.size.height/2-40/2/2, 40/2, 40/2)];
    
    animationImageView.animationImages = imageArr;//将序列帧数组赋给UIImageView的animationImages属性
    animationImageView.animationDuration = 2;//设置动画时间
    animationImageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [animationImageView startAnimating];//开始播放动画
    [bqView addSubview:animationImageView];
    
    NSDictionary *attributeDict = [dict objectForKey:@"attributes"];
    NSNumber *number = [attributeDict objectForKey:@"flip"];
    if (number && [number integerValue] == 1)
    {
        bqView.transform = CGAffineTransformMakeRotation(M_PI);
        tempLabel.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return bqView;
}

//- (UIView *)addTagWithDict:(NSDictionary *)dict inView:(UIImageView *)imageView
//{
//    NSDictionary *tabInfo = dict;
//    
//    CoverStickerView* stickerView = [[CoverStickerView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
//    
//    stickerView.userInteractionEnabled = NO;
//    
//    UIImageView* temImageView = [[UIImageView alloc] initWithImage:nil];
//    [temImageView setContentMode:UIViewContentModeScaleAspectFit];
//    [stickerView setContentView:temImageView];
//    
//    NSDictionary *attributes = [tabInfo objectForKey:@"attributes"];
//    int type = [[attributes objectForKey:@"type"] intValue];
//    
//    stickerView.type = type;
//    
//    NSString *text = [tabInfo objectForKey:@"text"];
//    
//    float x =  [[tabInfo objectForKey:@"x"] floatValue] * imageView.frame.size.width;
//    float y =  [[tabInfo objectForKey:@"y"] floatValue] * imageView.frame.size.height;
//    
//        
//    [stickerView setTagName:text withKey:@"test" withType:CoverTagTypeItem];
//    
//    int flip = [[attributes objectForKey:@"flip"] intValue];
//    if (flip == 0)
//    {
//        stickerView.flip = NO;
//        x = x - 20;
//    }
//    else
//    {
//        stickerView.flip = YES;
//        x = x + 20;
//    }
//    
//    [stickerView setOrigin:CGPointMake(x, y)];
//    
//    
//    
//    UIView *stickerViewSuperView = [[UIView alloc] initWithFrame:stickerView.frame];
//    
//    stickerView.frame = stickerViewSuperView.bounds;
//    
//    [stickerViewSuperView addSubview:stickerView];
//    
//    [imageView addSubview:stickerViewSuperView];
//    
//    return stickerViewSuperView;
//}

- (UIView *)addTagWithDict:(NSDictionary *)dict inView:(UIImageView *)imageView{
    NSDictionary *tabInfo = dict;
    
    NSDictionary *attributes = [tabInfo objectForKey:@"attributes"];
   
    if (![attributes isKindOfClass:[NSDictionary class]])
    {
        return [[UIView alloc] init];// 这里是为了处理测试服务器上的垃圾数据
    }

    
    int type = [[attributes objectForKey:@"type"] intValue];
    
    NSString *text = [tabInfo objectForKey:@"text"];
    int flip = [[attributes objectForKey:@"flip"] intValue];
    float x =  [[tabInfo objectForKey:@"x"] floatValue] * imageView.frame.size.width;
    float y =  [[tabInfo objectForKey:@"y"] floatValue] * imageView.frame.size.height;
    STagView *tagView = [[STagView alloc]init];
    tagView.tagType = CoverTagTypeItem;
    tagView.title = text;
    if (type == 100){
        tagView.tagStyle = STagViewStyleCart;
    }
    tagView.toPoint = CGPointMake(x, y);
    tagView.flip = flip;
    [imageView addSubview:tagView];
    return tagView;
}

//创建自定义组件
-(UILabel*) createUILabelByStyle:(NSString*)str fontStyle:(UIFont*)fontStyle color:(UIColor*)fontColor rect:(CGRect)rect isFitWidth:(BOOL) isFit isAlignLeft:(BOOL)isLeft{
    UILabel *tempLabel;
    
    //如果为空，则使用系统默认字体
    if (!fontStyle) {
        fontStyle = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
   
    if (isFit) {
        CGSize labelSize = [self getStrLenByFontStyle:str fontStyle:fontStyle];
        float coordX =rect.origin.x;
         if (!isLeft) {
             coordX -= labelSize.width;
         }
        //输入为0时，将算出的高度作为高度
        if (rect.size.height == 0) {
            rect.size.height = labelSize.height;
        }
        //如果大于屏幕宽度 则已屏幕宽度为准 但是有一点 如果启示坐标不是从0开始的 则展示不全 蛋疼玩意
        if(labelSize.width>UI_SCREEN_WIDTH)
        {
            labelSize.width=UI_SCREEN_WIDTH-coordX;
        }

         tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(coordX,rect.origin.y, labelSize.width, rect.size.height)];
    }else{
        if (!isLeft) {
            rect.origin.x -= rect.size.width;
        }
        tempLabel = [[UILabel alloc]initWithFrame:rect];
    }
    tempLabel.text = str;
    if(fontColor){
        tempLabel.textColor = fontColor;
    }
    tempLabel.font =fontStyle;
    return tempLabel;
    
}

-(UILabel*) createUILabelByStyleFitHeight:(NSString*)str fontStyle:(UIFont*)fontStyle color:(UIColor*)fontColor width:(float)width point:(CGPoint)point{
    UILabel *tempLabel;
    //如果为空，则使用系统默认字体
    if (!fontStyle) {
        fontStyle = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    CGSize labelSize = [str sizeWithAttributes:@{ NSFontAttributeName : fontStyle }];
    float lines = (labelSize.width/width);
     lines = ceil(lines);
    float height = lines*(labelSize.height+2);
    
    tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(point.x,point.y, width, height)];
    [tempLabel setNumberOfLines:1000];
    tempLabel.text = str;

    tempLabel.font = fontStyle;
    if (fontColor) {
        tempLabel.textColor = fontColor;
    }
   
    return tempLabel;
    
}

// 创建UILabel 文字居中
-(UILabel*) createUILabelMiddleText:(NSString*)str fontStyle:(UIFont*)fontStyle color:(UIColor*)fontColor bgColor:(UIColor*)bgColor rect:(CGRect)rect {
    UILabel *tempLabel;
    if (!fontStyle) {
        fontStyle = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    CGSize labelSize = [str sizeWithAttributes:@{ NSFontAttributeName : fontStyle }];
    tempLabel = [[UILabel alloc]initWithFrame:rect];
    [tempLabel setWidth:labelSize.width+10];
    
    [tempLabel setText:str];
    if (fontStyle) {
        tempLabel.font = fontStyle;
    }
    if (fontColor) {
        tempLabel.textColor = fontColor;
    }
    if (bgColor) {
        tempLabel.backgroundColor = bgColor;
    }
    tempLabel.textAlignment = NSTextAlignmentCenter;
    
    return tempLabel;
    
}

-(UILabel*) createUILabelMiddleLine:(NSString*)str fontStyle:(UIFont*)fontStyle color:(UIColor*)fontColor rect:(CGRect)rect isFitWidth:(BOOL) isFit  isAlignLeft:(BOOL)isLeft{
    UILabel *tempLabel;
    //如果为空，则使用系统默认字体
    if (!fontStyle) {
        fontStyle = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
  
    if (!fontColor) {
        fontColor = [UIColor blackColor];
    }
    if (isFit) {
        CGSize labelSize = [self getStrLenByFontStyle:str fontStyle:fontStyle];
        float coordX =rect.origin.x;
        if (!isLeft) {
            coordX -= labelSize.width;
        }
        //输入为0时，将算出的高度作为高度
        if (rect.size.height == 0) {
            rect.size.height = labelSize.height;
        }
        tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(coordX,rect.origin.y, labelSize.width, rect.size.height)];
    }else{
        if (!isLeft) {
            rect.origin.x -= rect.size.width;
        }

        tempLabel = [[UILabel alloc]initWithFrame:rect];
    }
    tempLabel.text = str;
    if (fontColor) {
        tempLabel.textColor = fontColor;
    }
   
    tempLabel.font =fontStyle;
    //加中间线
    UIView* lineUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:tempLabel.frame.size.width height:1 color:fontColor];
    [lineUI setOrigin:CGPointMake(0, tempLabel.frame.size.height/2)];
    [tempLabel addSubview:lineUI];

    
    return tempLabel;

}

// 创建UIImageView
-(UIImageView*) createUIImageViewByStyle:(NSString*)imageName  rect:(CGRect)rect{
    UIImageView *tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    tempView.userInteractionEnabled = YES;
    tempView.frame = rect;
    return tempView;
}

-(UIImageView*) createUIImageViewByStyleAction:(NSString*)imageName  rect:(CGRect)rect target:(id)target action:(SEL)action{
    UIImage *image = [UIImage imageNamed:@"Unico/icon_navigation_share"];
    if (imageName) {
        image = [UIImage imageNamed:imageName];
        
    }
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    //如果参数高度和宽度为0
    if (rect.size.width == 0 || rect.size.height == 0) {
        rect.size.width = image.size.width;
        rect.size.height = image.size.height;

    }
    imageView.frame =rect;
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:recognizer];
    return imageView;
}

// 创建带圆度的UIImageView
-(UIImageView*) createRoundUIImageView:(NSString*)imageName  rect:(CGRect)rect cornerRadius:(float) value{
    UIImageView *tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    tempView.frame =rect;
    tempView.layer.cornerRadius = value;
    tempView.clipsToBounds = YES;
    return tempView;
}

// 创建带圆度的UIImageView 通过url
-(UIImageView*) createRoundUIImageViewByUrl:(NSString*)url  rect:(CGRect)rect cornerRadius:(float) value{
    if (!url || [url isEqual:@""]) {
        url = DEFAULT_HEADIMG;
    }
    
    UIImageView *tempView = [UIImageView new];
    [tempView sd_setImageWithURL:[NSURL URLWithString:url]placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    tempView.frame =rect;
    tempView.layer.cornerRadius = value;
    tempView.clipsToBounds = YES;
    return tempView;

}
-(UIImageView*) createUIImageViewByUrl:(NSString*)url  rect:(CGRect)rect{
    UIImageView *tempView = [UIImageView new];
    [tempView sd_setImageWithURL:[NSURL URLWithString:url]];
    tempView.frame =rect;
    return tempView;
}
//生成一个uiimageview 上面图片 下面label
-(UIView*)generateImageAndLabel:(NSString*)str color:(UIColor*) fontColor fontStyle:(UIFont*)fontStyle interval:(float) interval imageName:(NSString*) nameStr placeHolderImgStr:(NSString*)placeHolderImgStr imageSize:(CGSize)size{
    UIView *tempView = [UIView new];

    UIImageView *imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:nameStr rect:CGRectMake(0, 0, size.width, size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:nameStr] placeholderImage:[UIImage imageNamed:placeHolderImgStr]];
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:str fontStyle:fontStyle color:fontColor rect:CGRectMake(0, imageView.frame.size.height + interval, 0, 0) isFitWidth:YES isAlignLeft:YES];
    float tempFloat = (imageView.frame.size.width - tempLabel.frame.size.width)/2;
    
    [tempLabel setOrigin:CGPointMake(tempFloat, tempLabel.frame.origin.y)];
    tempLabel.backgroundColor = [UIColor clearColor];
    imageView.layer.cornerRadius = (imageView.frame.size.height/2);
    imageView.layer.masksToBounds = YES;

    tempView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height+interval+tempLabel.frame.size.height);
   [tempView addSubview:imageView];
    [tempView addSubview:tempLabel];
    
    
    
    
    
    
    return  tempView;
}

-(void)setImageViewByUrl:(NSString*)url size:(CGSize)size imageView:(UIImageView*)imageView{
    float width = size.width;
    float height = size.height;
    NSString *tempStr = url;
    CGSize tempSize = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_WIDTH/width*height);
    // 这里是请求符合屏幕宽度的图片，避免不清晰，并且减少非必要流量
    tempStr = [NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",tempStr,(int)width,(int)height];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [imageView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
//    [imageView setImageWithURL:[NSURL URLWithString:tempStr]];
    [imageView setSize:tempSize];
}


// 创建uiview 宽度为屏幕宽度 高度自定义
-(UIView*) createUIViewByHeight:(CGFloat)height coordY:(CGFloat)coordY{
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, coordY, UI_SCREEN_WIDTH, height)];
    temp.backgroundColor = [UIColor whiteColor];
    return  temp;
}

// 创建uiview 宽度为屏幕宽度 高度自定义
-(UIView*) createUIViewByHeightAndWidth:(CGFloat)height width:(CGFloat)width coordY:(CGFloat)coordY{
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, coordY, width, height)];
    temp.backgroundColor = [UIColor whiteColor];
    return  temp;
}

//创建一个uiview 可以设置边框和边框颜色
-(UIView*) createUIViewWithBorder:(UIColor*)borderColor borderWidth:(CGFloat)width rect:(CGRect)rect{
    UIView *temp = [[UIView alloc] initWithFrame:rect];
    temp.layer.borderWidth = width;
    temp.layer.borderColor = borderColor.CGColor;
    return  temp;
}

//生成一个uiview 上面图片 下面label
-(UIView*)createImageAndLabel:(NSString*)str color:(UIColor*) fontColor fontStyle:(UIFont*)fontStyle interval:(float) interval imageName:(NSString*) nameStr imageSize:(CGSize)size{
    UIView *tempView = [UIView new];
    UIImageView *imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:nameStr rect:CGRectMake(0, 0, size.width, size.height)];
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:str fontStyle:fontStyle color:fontColor rect:CGRectMake(0, imageView.frame.size.height + interval, 0, 0) isFitWidth:YES isAlignLeft:YES];
    float tempFloat = (imageView.frame.size.width - tempLabel.frame.size.width)/2;
    
    [tempLabel setOrigin:CGPointMake(tempFloat, tempLabel.frame.origin.y)];
    tempView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height+interval+tempLabel.frame.size.height);
    [tempView addSubview:imageView];
    [tempView addSubview:tempLabel];
    
    
    
    
    
    
    return  tempView;
}

//创建无数据页面
-(UIView*)createLayOutNoDataViewRect:(CGRect)rect WithImage:(NSString*)image andImgSize:(CGSize)imgSize andTipString:(NSString *)tipString font:(UIFont*)font textColor:(UIColor*)textColor andInterval:(CGFloat)interval
{
    UIView * view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = COLOR_NORMAL;
    
    UIImageView *imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:image rect:CGRectMake((rect.size.width-imgSize.width)/2,rect.size.height/3, imgSize.width, imgSize.height)];
    CGSize  strSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:image fontStyle:font];
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tipString fontStyle:font color:textColor rect:CGRectMake(0, CGRectGetMaxY(imageView.frame) + interval, strSize.width, strSize.height) isFitWidth:YES isAlignLeft:NO];
    
    [tempLabel setOrigin:CGPointMake((rect.size.width-tempLabel.size.width)/2, tempLabel.frame.origin.y)];
    
    [view addSubview:imageView];
    [view addSubview:tempLabel];
    
    return view;

}

//创建按钮 中间字体 背景颜色
-(UIButton*)createTitleButton:(NSString*) str bgColor:(UIColor*)bgColor fontColor:(UIColor*)fontColor fontStyle:(UIFont*)fontStyle rect:(CGRect)rect{
    UIButton *tempButton;
    tempButton = [[UIButton alloc]initWithFrame:rect];
    [tempButton setTitle:str forState:UIControlStateNormal];
    if (fontStyle) {
        [tempButton.titleLabel setFont:fontStyle];
    }
    
    if (bgColor) {
        [tempButton setBackgroundColor:bgColor];
    }
    
    if (fontColor) {
        [tempButton setTitleColor:fontColor forState:UIControlStateNormal];
    }
    
    return tempButton;
    
}

//创建按钮 中间字体 背景颜色
-(UIButton*)createTitleButtonAction:(NSString*) str bgColor:(UIColor*)bgColor fontColor:(UIColor*)fontColor fontStyle:(UIFont*)fontStyle rect:(CGRect)rect target:(id)target action:(SEL)action {
    UIButton *tempButton;
    tempButton = [[UIButton alloc]initWithFrame:rect];
    [tempButton setTitle:str forState:UIControlStateNormal];
    if (fontStyle) {
        [tempButton.titleLabel setFont:fontStyle];
    }
    
    if (bgColor) {
        [tempButton setBackgroundColor:bgColor];
    }
    
    if (fontColor) {
        [tempButton setTitleColor:fontColor forState:UIControlStateNormal];
    }
    if (target && action) {
        [tempButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return tempButton;
    
}


//创建按钮 选中与非选中状态
-(UIButton*)createSelectButtonImage:(UIImage*)selectImg andDeSelectImg:(UIImage*)deselectImg rect:(CGRect)rect target:(id)target action:(SEL)selector
{
    UIButton *tempButton;
    tempButton = [[UIButton alloc]initWithFrame:rect];
    if (selectImg) {
        [tempButton setImage:selectImg forState:UIControlStateSelected];
    }
    
    if (deselectImg) {
        [tempButton setImage:deselectImg forState:UIControlStateNormal];
    }
    
    
    if (target && selector) {
        [tempButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    return tempButton;

}

-(UIScrollView*)createScrollView:(id)delegate rect:(CGRect)rect{
    UIScrollView *tempScrollView = [[UIScrollView alloc]initWithFrame:rect];
    tempScrollView.backgroundColor = [UIColor whiteColor];
    tempScrollView.scrollEnabled = YES;
    tempScrollView.delegate = delegate;
    tempScrollView.showsHorizontalScrollIndicator = NO;
    tempScrollView.directionalLockEnabled = YES;
    tempScrollView.userInteractionEnabled = YES;
//    tempScrollView.contentOffset = CGPointMake(0, 0);
    return tempScrollView;
}

//创建uiview 上面线，下边带箭头线 中间文件中描述
-(UIView*)createUIViewByArrowLine:(NSString*)str height:(float)height bgColor:(UIColor*)bgColor fontColor:(UIColor*)fontColor fontStyle:(UIFont*)fontStyle;{
    UIView *tempUI = [self createUIViewByHeight:height coordY:0];
    if(!bgColor)
    {
        bgColor = UIColorFromRGB(0xf2f2f2);
    }
    tempUI.backgroundColor = bgColor;
    
    UIView* tempUIView = [self getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:UIColorFromRGB(0xc4c4c4)];
    [tempUIView setOrigin:CGPointMake(0, 0)];
    [tempUI addSubview:tempUIView];
    
    UILabel *tempLabel = [self createUILabelByStyle:str fontStyle:fontStyle color:fontColor rect:CGRectMake(0, 0, 0, 0) isFitWidth:YES isAlignLeft:YES];
    
    [tempLabel setOrigin:CGPointMake(20/2, tempUI.height/2 - tempLabel.height/2)];
    [tempUI addSubview:tempLabel];
    
    tempUIView = [self getArrowLineUIView];
    [tempUIView setOrigin:CGPointMake(0, tempUI.height -tempUIView.height)];
    [tempUI addSubview:tempUIView];
    return  tempUI;
}

//创建一个like背景的图标，带数字
-(UIImageView*)createImageViewByLike:(NSInteger) likeNum{
    if (likeNum <0 ) {
        likeNum = 0;
    }
    NSString *tempStr = OTHER_TO_STRING(@"%d", (int)likeNum);
    UIImage *image = [UIImage imageNamed:@"like_num_bg2"];
    [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
    
    UIImageView *tempBg = [[UIImageView alloc]initWithImage:image];
    tempBg.frame = CGRectMake(0,0, 107/2, 40/2);
    CGSize labelSize = [self getStrLenByFontStyle:@"123" fontStyle:FONT_SIZE(12)];
    UILabel *tempLabel  = [self createUILabelByStyle:tempStr fontStyle:FONT_SIZE(12) color:COLOR_C7 rect:CGRectMake(20, tempBg.height/2-labelSize.height/2, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [tempBg  addSubview:tempLabel];
    [tempBg setWidth:(40/2+tempLabel.width+20)];
    return  tempBg;
}

//生成阴影
+ (void)createViewShadow:(UIView*)view direction:(ShowShadowDirection)diretion{
    CGSize offset = CGSizeZero;
    switch (diretion) {
        case shadowShowBottem:
            offset = CGSizeMake(0, 5);
            break;
        case shadowShowTop:
            offset = CGSizeMake(0, -5);
            break;
        case shadowShowLeft:
            offset = CGSizeMake(-5, 0);
            break;
        case shadowShowRight:
            offset = CGSizeMake(5, 0);
            break;
            
        default:
            break;
    }
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = offset;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
}

-(UIButton*)createButtonByImage:(NSString*)imgStr target:(id)target action:(SEL)action rect:(CGRect)rect;
{
    
    UIButton *tempButton = [[UIButton alloc]initWithFrame:rect];
    [tempButton setImage: [UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [tempButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  tempButton;
    
}

-(NSString*) getTimeByToday:(NSDate*)time{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval intervalSec = [nowDate timeIntervalSinceDate:time];
    //NSLog(@"%f",intervalSec);
    NSString * str = nil;
    double day = intervalSec/(24*60*60);
    double hour = 0.0;
    int dayInt = 0;
    int hourInt = 0;
    int minuteInt = 0;
    if(day < 1.0)
    {
        hour = intervalSec/(60*60);
        if(hour < 1.0)
        {
            minuteInt =intervalSec/60;
            str = [NSString stringWithFormat:@"%d 分钟前",minuteInt];
        }
        else
        {
            hourInt = (int) hour;
            str = [NSString stringWithFormat:@"%d 小时前",hourInt];
        }
        
    }
    else
    {
        dayInt = (int) day;
        str = [NSString stringWithFormat:@"%d 天前",dayInt];
    }
    return  str;
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

-(NSString*) getTimeByTodayWithString:(NSString*)dateString{
    NSDate *time = [self dateFromString:dateString];
    NSString *timeStr = [self getTimeByToday:time];
    return timeStr;
}

+ (NSString*)utilltyImageUrlFactory:(NSString*)imageUrl imageWidth:(CGFloat)width{
    return [NSString stringWithFormat:@"%@?imageMogr/v2/auto-orient/thumbnail/%dx/quality/60", imageUrl, (int)(width * [UIScreen mainScreen].scale)];
}

- (NSArray*)getArray:(NSString*)json
{
    if (json == nil) {
        return @[];
    }
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSArray* info = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return info;
}

//给view添加事件 在value中传参数
-(void) addViewAction:(UIView*)view target:(id)target action:(SEL)action{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:recognizer];
}


#pragma mark - UI Helper
- (void)showHome{
    [[AppDelegate rootViewController] popToRootViewControllerAnimated:YES];
}

- (void)showSearch{
    SSearchViewController *controller = [[SSearchViewController alloc]initWithNibName:@"SSearchViewController" bundle:nil];
    [[AppDelegate rootViewController] pushViewController:controller animated:YES];
//    SearchViewController *search = [SearchViewController new];
//    [[AppDelegate rootViewController] pushViewController:search animated:YES];
}

- (void)showTodo {
    SVideoWelcomeController *vc = [SVideoWelcomeController new];
    [[AppDelegate rootViewController] pushViewController:vc animated:YES];
}



-(void)showCamera:(NSDictionary*)tag{
    
    
   /* SClothingCategoryViewController *clothingCategoryViewController = [[SClothingCategoryViewController alloc] init];
    
    [[AppDelegate rootViewController] pushViewController:clothingCategoryViewController animated:YES];
    
    return;*/
    
    
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    
    [[SDImageCache sharedImageCache] clearMemory];
    // 停止当前请求
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
    
    if (tag) {
        [[NSUserDefaults standardUserDefaults] setObject:tag forKey:@"SCAMERA_TAG"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SCAMERA_TAG"];
    }
    
    
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showUploadColllocationHomeViewWithAnimated:YES];
    

   /* [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    // show camera start slide
    UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_up"]];
    UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_down"]];
    
    
    if (g_cameraStartSlideWindow == nil)
    {
        g_cameraStartSlideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    g_cameraStartSlideWindow.windowLevel = UIWindowLevelAlert;
    g_cameraStartSlideWindow.backgroundColor = [UIColor clearColor];
    [g_cameraStartSlideWindow makeKeyAndVisible];

    
    //[[AppDelegate rootViewController].view addSubview:upView];
    //[[AppDelegate rootViewController].view addSubview:downView];
    
    [g_cameraStartSlideWindow addSubview:upView];
    [g_cameraStartSlideWindow addSubview:downView];
    
    upView.frame = downView.frame = [AppDelegate rootViewController].view.frame;
    
    [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
    [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
    SBaseViewController* cameraMainVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCameraStoryBoardID"];
    cameraMainVC.animatedBack = YES;
    [cameraMainVC setHidesBottomBarWhenPushed:YES];
   
    // 关闭动画
    [UIView animateWithDuration:0.3 animations:^{
        [upView setOrigin:CGPointMake(0, 0)];
        [downView setOrigin:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
        
//        [AppDelegate rootViewController].viewControllers = @[cameraMainVC];
        [[AppDelegate rootViewController] pushViewController:cameraMainVC animated:NO];
//        [[AppDelegate rootViewController] presentViewController:cameraMainVC animated:NO completion:nil];
        // Open
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
            [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
            [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
        } completion:^(BOOL finished) {
            [upView removeFromSuperview];
            [downView removeFromSuperview];
            
            g_cameraStartSlideWindow = nil;
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        
    }];*/
}



- (void)showUser:(NSString*)uid{
    
    SMineViewController *vc = [SMineViewController new];
    vc.person_id = uid;
    [[AppDelegate rootViewController] pushViewController:vc animated:YES];
}

- (void)showCollection:(NSString*)cid{
    
   /* SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
    vc.collocationId = [cid intValue];
    [[AppDelegate rootViewController] pushViewController:vc animated:YES];*/
    
    
    
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        
        
        detailNoShoppingViewController.collocationId = cid;
        [[AppDelegate rootViewController] pushViewController:detailNoShoppingViewController animated:YES];
        
        
        
    }
    else
    {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        
        
        collocationDetailVC.collocationId = cid ;
        [[AppDelegate rootViewController] pushViewController:collocationDetailVC animated:YES];
    }

}

- (void)showBrand:(NSString*)bid{
    SBrandSotryViewController *vc = [SBrandSotryViewController new];
//    vc.brandId = [bid intValue];
    vc.brandId = bid;
    
    
    [[AppDelegate rootViewController] pushViewController:vc animated:YES];
}

- (void)showTopic:(NSString*)tid{
    // TODO: Show TopicView 可继续用Webview
}

- (void)showItem:(NSString*)iid{
#warning  要传code
    SProductDetailViewController *vc = [SProductDetailViewController new];
    vc.productID = iid;
    [[AppDelegate rootViewController] pushViewController:vc animated:YES];
}

- (void)showSpecial:(NSString*)sid{
    // TODO: Show Special View 可继续用Webview
}

// 这里应该不小心写死了，很多地方用的，不只是分享邀请码
- (void)showWebpage:(NSString*)url titleName:(NSString*)titleName shareImg:(NSString *)shareImgurl{
    
    NSString *inviteUrl = url;
    
//    if ([url rangeOfString:@"?"].location > 0) {
//        inviteUrl = [inviteUrl stringByAppendingFormat:@"&userID=%@",sns.ldap_uid];
//    } else {
//        inviteUrl = [inviteUrl stringByAppendingFormat:@"?userID=%@",sns.ldap_uid];
//    }
    
    JSWebViewController *web = [[JSWebViewController alloc] initWithUrl:inviteUrl];
    // TODO: Set title in webpage

    [web setNaviTitle:titleName];
    web.shareImgStr = shareImgurl;
    [[AppDelegate rootViewController] pushViewController:web animated:YES];
}

// 显示首次启动的简介按钮。
- (void)showIntro{
    // Added Introduction View Controller
    NSArray *coverImageNames = @[@"Unico/intro_1", @"Unico/intro_2", @"Unico/intro_3", @"Unico/intro_4",@"Unico/intro_5"];
    NSArray *backgroundImageNames = @[@"", @"Unico/intro_2_bg", @"Unico/intro_3_bg", @"Unico/intro_4_bg",@""];
    
    UIButton *enterButton = [UIButton new];
    
    introductionView = [[SIntroController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames button:enterButton];
    
    [[UIApplication sharedApplication].keyWindow addSubview:introductionView.view];
 
    __weak UIView *weakView = introductionView.view;
    introductionView.didSelectedEnter = ^() {
        [weakView removeFromSuperview];
        introductionView = nil;
    };
}

- (void)showIntro:(BOOL)first{
    
    static int i = 0;//AppDelegate的入口函数可能执行两次
    
    if (i > 0)
    {
        return;
    }
    
    i++;
    
    
    // Added Introduction View Controller
    NSArray *coverImageNames = @[@"Unico/intro_1", @"Unico/intro_2", @"Unico/intro_3", @"Unico/intro_4",@"Unico/intro_5"];
    NSArray *backgroundImageNames = @[@"", @"Unico/intro_2_bg", @"Unico/intro_3_bg", @"Unico/intro_4_bg",@""];

    UIButton *enterButton = [UIButton new];
    introductionView = [[SIntroController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames button:enterButton];
    introductionView.first = first;
    
    [[UIApplication sharedApplication].keyWindow addSubview:introductionView.view];
    
    __weak UIView *weakView = introductionView.view;
    __weak __typeof(self) ws = self;
    introductionView.didSelectedEnter = ^() {
        [weakView removeFromSuperview];
        introductionView = nil;
//        //停留在app 1分钟以上
        [ws performSelector:@selector(loginToShow) withObject:nil afterDelay:60];
    };
}

- (void)showService{
    if ([BaseViewController pushLoginViewController]) {
        
        ContactCustomerServiceViewController *controller = [[ContactCustomerServiceViewController alloc]initWithNibName:@"ContactCustomerServiceViewController" bundle:nil];
        [[AppDelegate rootViewController] pushViewController:controller animated:YES];
    }
}

- (void)showOrHideLeftSideView
{
    if (!leftSideView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        leftSideView = [SLeftMainView instance];
        [keyWindow addSubview:leftSideView];
        [leftSideView showWithtarget:self];
    }else{
        [leftSideView hide];
        leftSideView = nil;
    }
}

#pragma mark - recorder
- (NSArray*)recorderFilters{
    // 备注，这里是自己创建的滤镜效果。
    SCFilter *fun_yellow = [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Unico/fun_yellow@2x" withExtension:@"cisf"]];
//    SCFilter *f2 = [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"a_f2" withExtension:@"cisf"]];
//    SCFilter *f3 = [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"a_f3" withExtension:@"cisf"]];
//    SCFilter *f4 = [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"a_f4" withExtension:@"cisf"]];
    
    return @[
             [SCFilter emptyFilter],
             // MARK: - 怀旧
             [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"],
             // MARK: - 黑白
             [SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"],
             // MARK: - 色调
             [SCFilter filterWithCIFilterName:@"CIPhotoEffectTonal"],
             // MARK: - 岁月
             [SCFilter filterWithCIFilterName:@"CIPhotoEffectTransfer"],
             // MARK: - 单色
             [SCFilter filterWithCIFilterName:@"CIPhotoEffectMono"],
             // MARK: - 褪色
             [SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"],
             // MARK: - 冲印
             [SCFilter filterWithCIFilterName:@"CIPhotoEffectProcess"],
             // MARK: - 铬黄
             [SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"],
             // Adding a filter created using CoreImageShop
             fun_yellow,
             ];
}

- (void)getRecentImage:(UIImageView*)container
{
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    
    // Block called for every asset selected
    void (^selectionBlock)(ALAsset*, NSUInteger, BOOL*) = ^(ALAsset* asset,
                                                            NSUInteger index,
                                                            BOOL* innerStop) {
        // The end of the enumeration is signaled by asset == nil.
        if (asset == nil) {
            return;
        }
        
        // Retrieve the image orientation from the ALAsset
        UIImageOrientation orientation = UIImageOrientationUp;
        NSNumber* orientationValue = [asset valueForProperty:@"ALAssetPropertyOrientation"];
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        
        [asset thumbnail];
        
        CGFloat scale  = 1;
        UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]
                                             scale:scale orientation:orientation];
        
        // do something with the image
        
        container.image = image;
    };
    
    // Block called when enumerating asset groups
    void (^enumerationBlock)(ALAssetsGroup*, BOOL*) = ^(ALAssetsGroup* group, BOOL* stop) {
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Get the photo at the last index
        NSInteger index              = [group numberOfAssets] - 1;
        if (index<0){
            return;
        } else {
            NSLog(@" no image");
        }
        NSIndexSet* lastPhotoIndexSet = [NSIndexSet indexSetWithIndex:index];
        [group enumerateAssetsAtIndexes:lastPhotoIndexSet options:0 usingBlock:selectionBlock];
    };
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:enumerationBlock
                         failureBlock:^(NSError* error){
                             // handle error
                         }];
}

- (void)getRecentImage:(UIImageView*)container assetsFilter:(ALAssetsFilter *)assetsFilter
{
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    
    // Block called for every asset selected
    void (^selectionBlock)(ALAsset*, NSUInteger, BOOL*) = ^(ALAsset* asset,
                                                            NSUInteger index,
                                                            BOOL* innerStop) {
        // The end of the enumeration is signaled by asset == nil.
        if (asset == nil) {
            return;
        }
        
        // Retrieve the image orientation from the ALAsset
        UIImageOrientation orientation = UIImageOrientationUp;
        NSNumber* orientationValue = [asset valueForProperty:@"ALAssetPropertyOrientation"];
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        
        [asset thumbnail];
        
        CGFloat scale  = 1;
        UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]
                                             scale:scale orientation:orientation];
        
        // do something with the image
        
        container.image = image;
    };
    
    // Block called when enumerating asset groups
    void (^enumerationBlock)(ALAssetsGroup*, BOOL*) = ^(ALAssetsGroup* group, BOOL* stop) {
        // Within the group enumeration block, filter to enumerate just photos.
        
        if (group == nil)
        {
            return ;
        }
        
        [group setAssetsFilter:assetsFilter];
        
        // Get the photo at the last index
        NSInteger index = [group numberOfAssets] - 1;
        
        NSLog(@"index = %d", index);
        if (index < 0)
        {
             NSLog(@" no image");
            container.image = [UIImage imageNamed:@"Unico/nophoto"];//默认图片
            return;
        }
        
        NSIndexSet* lastPhotoIndexSet = [NSIndexSet indexSetWithIndex:index];
        [group enumerateAssetsAtIndexes:lastPhotoIndexSet options:0 usingBlock:selectionBlock];
    };
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:enumerationBlock
                         failureBlock:^(NSError* error){
                             // handle error
                         }];
}


- (UIButton*)buttonDoubleLine:(NSString*)topText font:(UIFont*)topFont subLine:(NSString*)subText font:(UIFont*)subFont color:(UIColor*)textColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setLineBreakMode:NSLineBreakByWordWrapping];
    NSString *text = [NSString stringWithFormat:@"%@\n%@",topText, subText];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, text.length)];
    
    [str addAttribute:NSFontAttributeName value:topFont range:NSMakeRange(0, topText.length)];
    [str addAttribute:NSFontAttributeName value:subFont range:NSMakeRange(text.length - subText.length, subText.length)];
    
    CGSize sizeTop = [topText sizeWithAttributes:@{NSFontAttributeName : topFont}];
    CGSize sizeSub = [subText sizeWithAttributes:@{NSFontAttributeName : subFont}];
    
    btn.size = CGSizeMake(MAX(sizeTop.width, sizeSub.width), sizeTop.height + sizeSub.height);
    btn.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:.5];
    
    [btn setAttributedTitle:str forState:UIControlStateNormal];
    return btn;
}

//手机号码验证
- (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((1[0-9]))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

// 从UIColor中创建一个像素的UIImage
- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(NSString *)getdate:(NSString *)datestr {
    NSString *dateString=nil;
    NSDate *date ;
    if (datestr.length>1 && [[datestr substringToIndex:1] isEqualToString:@"/"])
    {
        NSArray *arr=[datestr componentsSeparatedByString:@"/Date("];
        NSString *s=[arr lastObject];
        arr=[s componentsSeparatedByString:@")/"];
        
        s=arr[0];
        arr=[s componentsSeparatedByString:@"-"];
        s=arr[0];
        date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateString=[NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }
    return dateString;
}

#pragma mark - Share Helper

- (NSString*)getWatermarkImageURLWithGood:(LNGood *)info{
    // ?watermark/1/image/aHR0cDovL3d3dy5iMS5xaW5pdWRuLmNvbS9pbWFnZXMvbG9nby0yLnBuZw==/dissolve/100/gravity/SouthEast/dx/0/dy/0
    if (info.video_url.length > 0 || !info.stick_img_url) {
        return info.img;
    }
    NSData *baseData = [info.stick_img_url dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [baseData base64EncodedStringWithOptions:0];
    NSString *url = [NSString stringWithFormat:@"%@?watermark/1/image/%@/dissolve/100/dx/0/dy/0",info.img,base64Encoded];
    
    NSLog(@"URL:%@",url);
    NSLog(@"STICKER:%@",info.stick_img_url);
    return url;
}

- (NSString*)getWatermarkImageURL:(NSDictionary *)info{
    // ?watermark/1/image/aHR0cDovL3d3dy5iMS5xaW5pdWRuLmNvbS9pbWFnZXMvbG9nby0yLnBuZw==/dissolve/100/gravity/SouthEast/dx/0/dy/0
    NSData *baseData = [info[@"stick_img_url"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [baseData base64EncodedStringWithOptions:0];
    NSString *url = [NSString stringWithFormat:@"%@?watermark/1/image/%@/dissolve/100/dx/0/dy/0",info[@"img"],base64Encoded];
    return url;
}

- (NSString*)getCollocationURL:(NSDictionary*)data{
    // 后续用网上Pull的配置。
    return [NSString stringWithFormat:SHARE_URL,data[@"id"]];
}

- (void)jumpControllerWithType:(NSInteger)type target:(id)target
{
    /*
     kLeftViewJumpTypeUserCenter,//个人中心
     kLeftViewJumpTypeMyWallet,//我的钱包
     kLeftViewJumpTypeMyTicket,//我的范票
     kLeftViewJumpTypeMyCollect,//我的收藏
     kLeftViewJumpTypeMyScan,//扫一扫
     kLeftViewJumpTypeMyInvite,//我的邀请码
     kLeftViewJumpTypeMyBuy,//我买到的
     kLeftViewJumpTypeMySell,我出售的
     kLeftViewJumpTypeKeFu,//联系客服
     kLeftViewJumpTypeSetting //设置
     */
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    
    target = [[[AppDelegate rootViewController] viewControllers] firstObject];
    UIViewController *controller = nil;
    switch (type) {
        case 0://kLeftViewJumpTypeUserCenter
        {
//            [[(SBaseViewController *)target tabBarController] setSelectedIndex:4];
            MBSettingMainViewController *settingMain = [[MBSettingMainViewController alloc]init];
            controller = settingMain;
            
            
        }
            break;
        case 1:{//kLeftViewJumpTypeMyWallet
            MyIncomeViewController *myIncomeVc=[[MyIncomeViewController alloc]init];
            controller = myIncomeVc;
            
        }
            break;
        case 2:{//kLeftViewJumpTypeMyTicket
//            SBrandPavilionViewController *sbrp=[[SBrandPavilionViewController alloc]init];
//            controller = sbrp;
//            break;
//            SBrandStoryDetailViewController *brandStory=[[SBrandStoryDetailViewController alloc]init];
//            controller = brandStory;
//            break;
            
//            SItemViewController *itemVc = [SItemViewController new];
//            controller = itemVc;
//            DailyNewViewController *dailyNew=[[DailyNewViewController alloc]init];
//            //                dailyNew.brandId=dict[@"tid"];
//            controller = dailyNew;
            
//            SBrandShowListControllerViewController *brandVc = [[SBrandShowListControllerViewController alloc]initWithNibName:@"SBrandShowListControllerViewController" bundle:nil];
//            controller = brandVc;
            
            SMBRedPacketViewController *redPacketVC=[[SMBRedPacketViewController alloc]initWithNibName:@"SMBRedPacketViewController" bundle:nil];
            redPacketVC.isFromOrder=NO;
            controller = redPacketVC;
        
      
        }
            break;
        case 3:{//kLeftViewJumpTypeMyCollect

            MyLikeViewController *mylike=[[MyLikeViewController alloc]init];
            mylike.use_Id=sns.ldap_uid;
            mylike.isMy=true;
            controller = mylike;
            
        }
            break;
        case 4:{//kLeftViewJumpTypeMyScan
            ScanViewController *scanView = [[ScanViewController alloc]initWithNibName:@"ScanViewController" bundle:nil];
            scanView.scanTypeChat = @"0";
            controller = scanView;
        }
            break;
        case 5:{//kLeftViewJumpTypeMyInvite
//            [[SUtilityTool shared] showWebpage:MBH5URL titleName:@"我的推广码"];
            
            if (![BaseViewController pushLoginViewController]) {
                return;
            }
            NSString *inviteUrl = kInviteCodeUrl;
            JSWebViewController *webCon = [[JSWebViewController alloc] initWithUrl:inviteUrl];
            [webCon setNaviTitle:@"我的邀请码"];
            controller = webCon;
        }
            break;
        case 6:{//kLeftViewJumpTypeMyBuy

            MyOrderViewController *myorder=[[MyOrderViewController alloc]init];
            controller=myorder;
        }
            break;
        case 7:{//kLeftViewJumpTypeKeFu
            [SUTIL showService];
        }
            break;
        case 8:{//kLeftViewJumpTypeSetting
            MBSettingViewController *setVC = [NSClassFromString(@"MBSettingViewController") new];
            controller = setVC;
        }
            break;
        case 9:{
            
        }
            break;
            
        default:
            break;
    }
    if (controller) {
      [[AppDelegate rootViewController] pushViewController:controller animated:YES];
    }

}

#pragma mark - jump other VC

- (void)jumpControllerWithContent:(NSDictionary *)dict target:(id)target
{
//    NSInteger is_h5 = [[dict objectForKey:@"is_h5"] integerValue];
    NSInteger is_h5 = 0;
    if ([[dict allKeys] containsObject:@"is_h5"]) {
        is_h5 = [[dict objectForKey:@"is_h5"] integerValue];
    }else {
        is_h5 = [[[dict objectForKey:@"jump"] objectForKey:@"is_h5"]integerValue];
    }
    if (is_h5) {
        if (![BaseViewController pushLoginViewController]) {
            return;
        }
        NSString *url = dict[@"url"];
//        NSArray *array = [url componentsSeparatedByString:@"?"];
//        if (array.count == 2) {
//            url = [url stringByAppendingFormat:@"&userid=%@",sns.ldap_uid];
//        }else{
//            url = [url stringByAppendingFormat:@"?userid=%@",sns.ldap_uid];
//        }
           NSString *name=nil;
        if ([[dict allKeys]containsObject:@"name"])
        {
            
            name = dict[@"name"];
        }
 
        if ([[dict allKeys]containsObject:@"pkgname"]) {
            name=dict[@"pkgname"];
            
        }
        NSString *shareImg=[NSString stringWithFormat:@"%@",dict[@"img"]];
   
        [SUTIL showWebpage:url titleName:name shareImg:shareImg];
    }else{
        // 这里为什么改成show_type?
        NSInteger type = 0;//[[dict objectForKey:@"jump_type"] integerValue];
        
        if ([[dict allKeys] containsObject:@"jump_type"]) {
            type = [[dict objectForKey:@"jump_type"] integerValue];
        }else {
            type = [[dict[@"jump"] objectForKey:@"type"] integerValue];
        }
        
        if ([[dict allKeys] containsObject:@"show_type"]) {
           type = [[dict objectForKey:@"show_type"] integerValue];
        }
    
        if ([[dict allKeys]containsObject:@"pkgname"]) {
            //正式环境 其实应该换成appstore的
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mixme.cn/web"]];
        }
     
        UIViewController *controller = nil;
        switch (type) {
            case 0: {
                if (![BaseViewController pushLoginViewController]) {
                    return;
                }
               /* SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
                vc.collocationId = [[dict objectForKey:@"tid"] integerValue];
                controller = vc;*/
                
                
                extern BOOL g_socialStatus;
                if (g_socialStatus)//是否处于社交状态
                {
                    SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
                    
                    
                    detailNoShoppingViewController.collocationId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tid"] ];
                    controller = detailNoShoppingViewController;
                }
                else
                {
                    SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
                    
                    
                    collocationDetailVC.collocationId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tid"] ];
                    controller = collocationDetailVC;

                }

                
                
                
            }
                break;
            case 1://单品详情
            {
                if (![BaseViewController pushLoginViewController]) {
                    return;
                }
                SProductDetailViewController *vc = [SProductDetailViewController new];
                vc.productID =  [dict objectForKey:@"tid"];
                controller = vc;
                
            }
                break;
            case 2://搭配详情
            {
                if (![BaseViewController pushLoginViewController]) {
                return;
            }
               /* SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
                vc.collocationId = [[dict objectForKey:@"tid"] integerValue];
                controller = vc;*/
                
                
                
                extern BOOL g_socialStatus;
                if (g_socialStatus)//是否处于社交状态
                {
                    SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
                    
                    
                    detailNoShoppingViewController.collocationId =[NSString stringWithFormat:@"%@",[dict objectForKey:@"tid"] ];
                    controller = detailNoShoppingViewController;
                    
                }
                else
                {
                    SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
                    
                    
                    collocationDetailVC.collocationId =[NSString stringWithFormat:@"%@",[dict objectForKey:@"tid"] ];
                    controller = collocationDetailVC;
                }
//                //现在没有社交模式了吧
//                SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
//                
//                
//                collocationDetailVC.collocationId =[NSString stringWithFormat:@"%@",[dict objectForKey:@"tid"] ];
//                controller = collocationDetailVC;
                
            }
                break;
            case 3://品牌详情
            {
                if (![BaseViewController pushLoginViewController]) {
                    return;
                }
                SBrandSotryViewController * vc  = [[SBrandSotryViewController alloc]init];
//                vc.brandId = [[dict objectForKey:@"tid"] integerValue];
                vc.brandId = [NSString stringWithFormat:@"%@",dict[@"tid"]];
                
                controller = vc;
            }
                break;
            case 4://话题详情
            {
                STopicDetailViewController *vc = [[STopicDetailViewController alloc]init];
                vc.topicID = dict[@"tid"];
                vc.titleName = dict[@"name"];
                controller = vc;
            }
                
                break;
            case 5://个人界面
            {
                if ([BaseViewController pushLoginViewController]){
                    NSString *userIdStr = [dict objectForKey:@"tid"];
                    SMineViewController *vc = [[SMineViewController alloc]init];
                    vc.person_id = userIdStr;
                    controller = vc;
                }
            }
                break;
            case 6://专题详情
                
                break;
            case 7://活动详情  活动页面
            {
                SActivityDiscountViewController *saleVC = [SActivityDiscountViewController new];
                saleVC.activityID = dict[@"tid"];
                controller = saleVC;
            }
                break;
            case 8://品牌列表  more
            {
             
                SBrandShowListControllerViewController *brandVc = [[SBrandShowListControllerViewController alloc]initWithNibName:@"SBrandShowListControllerViewController" bundle:nil];
                controller = brandVc;
            }
                
                break;
            case 9://话题列表
            {
                if (![BaseViewController pushLoginViewController]) {
                    return;
                }
                STopicViewController *vc = [[STopicViewController alloc]initWithNibName:@"STopicViewController" bundle:nil];
                controller = vc;
            }
                
                break;
            case 10://专题列表  时尚资讯
            {
                SFashionInfomationViewController *fashionVc = [SFashionInfomationViewController new];
                controller = fashionVc;
            }
                
                break;
            case 11://搭配列表
                
                break;
            case 12://单品列表  单品 点击more
            {
                SItemViewController *itemVc = [SItemViewController new];
                controller = itemVc;
            }
                
                break;
            case 13://活动列表  当前活动
            {
                SActivityListViewController *activityVc = [SActivityListViewController new];
                controller = activityVc;
            }
                
                break;
            case 14://最＋搭配
            {
                SBestCollocationViewController *dbVc = [SBestCollocationViewController new];
                controller = dbVc;
            }
                
                break;
            case 15://明星店铺
            {
                SStarStoreViewController * starStoreVC = [[SStarStoreViewController alloc]init];
                controller = starStoreVC;
            }
                
                break;
            case 16://推荐品牌
            {
                SBrandViewController *Vc = [SBrandViewController new];
                controller = Vc;
            }
                
                break;
            case 17://消息列表
            {
                SChatListController *vc = [SChatListController new];
                vc.index=@"1";
                controller=vc;
            }
                
                break;
            case 18://通知列表
            {
                SChatListController *vc = [SChatListController new];
                vc.index=@"0";
                controller=vc;
            }
                
                break;
            case 19://饭票领取页面
            {
                SActivityReceiveViewController  *receiveVC=[[SActivityReceiveViewController alloc]init];
                receiveVC. activityId=dict[@"tid"];
                controller=receiveVC;
            }
                break;
             case 20:
            {
                //话题心tab列表
                SChatListController *vc = [SChatListController new];
                controller=vc;
            }
                break;
            case 21:
            {
                if ([BaseViewController pushLoginViewController]) {
                    MyShoppingTrollyViewController *shopTrolly=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
                    controller = shopTrolly;
                }
            }
                break;
            case 22:
            {
                if ([BaseViewController pushLoginViewController]) {
                    MyIncomeViewController *myIncomeVc=[[MyIncomeViewController alloc]init];
                    controller = myIncomeVc;
                }
            }
                break;
            case 23:
            {
                if([BaseViewController pushLoginViewController])
                {
                    SMBRedPacketViewController *redPacketVC=[[SMBRedPacketViewController alloc]initWithNibName:@"SMBRedPacketViewController" bundle:nil];
                    redPacketVC.isFromOrder=NO;
                    controller = redPacketVC;
                }

            }
                break;
            case 24:
            {
                if([BaseViewController pushLoginViewController])
                {
                    MyLikeViewController *mylike=[[MyLikeViewController alloc]init];
                    mylike.use_Id=sns.ldap_uid;
                    mylike.isMy=true;
                    controller = mylike;
                    mylike.isMy = YES;
                }
            }
                break;
            case 25:
            {
                ScanViewController *scanView = [[ScanViewController alloc]initWithNibName:@"ScanViewController" bundle:nil];
                scanView.scanTypeChat = @"0";
                controller = scanView;
            }
                break;
            case 26:
            {
                MBSettingViewController *setVC = [NSClassFromString(@"MBSettingViewController") new];
                controller = setVC;
            }
                break;
                case 27:
            {
                if([BaseViewController pushLoginViewController])
                {
                    MyOrderViewController *myOrder=[[MyOrderViewController alloc]init];
                    controller = myOrder;
                }
                
            }break;
                case 28://搜索
            {
//                 saleVC.activityID = dict[@"tid"];
            }break;
                case 29:
            {
                    [SUTIL showService];
            }break;
                case 30:
            {
                UIViewController *controller = target;
                controller.tabBarController.selectedIndex = 1;
                [controller.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
                break;
                case 31:
            {
                if ([BaseViewController pushLoginViewController]) {
                    SMyTopicViewController *myTopicController = [SMyTopicViewController new];
                    controller = myTopicController;
                }
            }break;
            case 32://跳转每日新品
            {
                DailyNewViewController *dailyNew=[[DailyNewViewController alloc]init];
//                dailyNew.brandId=dict[@"tid"];
                controller = dailyNew;
            }
                break;
            case 33://发现场景商品购买页  品类详情
            {
                SClothingCategoryViewController *clothingCategory = [[SClothingCategoryViewController alloc]init];
                clothingCategory.clothingCategoryId =dict[@"tid"];
                clothingCategory.defaultTitle= dict[@"name"];
                controller= clothingCategory;
            }
                break;
            case 34://发现场景more
            {
                SDiscoverBrandListViewController *discoverList=[[SDiscoverBrandListViewController alloc]init];
                discoverList.brandId =[NSString stringWithFormat:@"%@",dict[@"tid"]];
                discoverList.titleStr = [NSString stringWithFormat:@"%@",dict[@"name"]];
                controller =discoverList;
            }
                break;
            case 35://品牌场景more
            {
           
                SBrandPavilionViewController *pavilionVC=[[SBrandPavilionViewController alloc]init];
                pavilionVC.brandId =[NSString stringWithFormat:@"%@",dict[@"tid"]];
                pavilionVC.titleStr =[NSString stringWithFormat:@"%@",dict[@"name"]];
                controller =pavilionVC;
            }
                break;
            case 36://设计师列表
            {
                SDesignerViewController *pavilionVC=[[SDesignerViewController alloc]init];
                controller =pavilionVC;
            }
                break;
            case 37://购物车选择参数
            {
                //选择参数界面
                UIViewController *targetController = target;
                NSString *goodsCode = [NSString stringWithFormat:@"%@", dict[@"tid"]];
                _goodCollectionVc = nil;
                _goodCollectionVc = [[GoodCollectionController alloc] initWithProductCode:goodsCode isProductDetail:YES];
                [_goodCollectionVc requestAndShowInView:targetController.view];
            }
                break;
            default:
                break;
        }
        if (!controller) {
            return;
        }
        if ([controller respondsToSelector:@selector(setFromControllerName:)] && dict[@"titleName"]){
            [controller setValue:dict[@"titleName"] forKey:@"fromControllerName"];
        }
        [[AppDelegate rootViewController] pushViewController:controller animated:YES];
    }
    
}

// 获得50x50的缩略图
- (NSString*)getThumbImageUrl:(NSString*)url{
    NSLog(@"%@",url);
    NSString *ext = [url substringFromIndex:url.length-4];
    NSString *base = nil;
    NSArray *comp = [url componentsSeparatedByString:@"--"];
    if (comp.count>1) {
        base = comp[0];
        base = [base stringByAppendingString:@"--50x50"];
        base = [base stringByAppendingString:ext];
        return base;
    }
    
    comp = [url componentsSeparatedByString:ext];
    if (comp.count) {
        base = comp[0];
        base = [base stringByAppendingString:@"--50x50"];
        base = [base stringByAppendingString:ext];
        return base;
    }
    
    return url;
}

- (void)kLeftMainViewDidSelectWithType:(kLeftViewJumpType)type
{
    [self showOrHideLeftSideView];
    [self jumpControllerWithType:type target:nil];
}

- (void)kLeftMainViewSwipeDelegate
{
    [self showOrHideLeftSideView];
}

- (void)showLeftMenuViewWithTarget:(id)delegate {
    SLeftMainView *leftV = [SLeftMainView instance];
    [leftV showWithtarget:delegate];
}

- (void)hideLeftMenuView {
    SLeftMainView *leftV = [SLeftMainView instance];
    [leftV hide];
}

- (void)showPraiseBox {
    [PraiseBoxView show];
}

- (void)loginToShow {
    [PraiseBoxView loginToShow];
}

@end

@implementation NSString (SString)

- (CGFloat)heightWithRestrictedWidth:(CGFloat)width font:(UIFont*)font{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size;
    return size.height;
}

@end
