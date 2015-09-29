//
//  GesturesView.h
//  newdesigner
//
//  Created by Miaoz on 14-9-19.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GesturesImageView.h"
#import "PhotoVO.h"
#import "DraftVO.h"
#import "CollocationElement.h"
#import "PolyvoreViewController.h"
#import "TopImageView.h"
#import "TemplateElement.h"
@class GoodObj;
@protocol GesturesViewDelegate <NSObject>

@optional
-(void)callBackGesturesImageViewWithPhotovoArray:(id)sender;
-(void)callBackGesturesImageViewWithtemplateElement:(id)sender withbuttonTag:(int)buttontag;
-(void)callBackGesturesImageViewWithClickButton:(id)sender;

-(void)callBackPreviousAndNextGesturesViewWithGestureImageview:(id)sender;
-(void)callBackPreviousAndNextButtonClick:(id)sender withtype:(NSString *)type;


@end

@interface GesturesView : UIView <UIGestureRecognizerDelegate,GesturesImageViewDelegate,UIScrollViewDelegate>
//@property(nonatomic,strong) PolyvoreViewController *polyvoreVC;
@property(nonatomic,weak)NSTimer *repeatingTimer;
@property (strong, nonatomic)GesturesImageView  *clickGesturesImageView;
@property (strong, nonatomic)UIView    *fuzzyView;
@property (strong, nonatomic) UIView  *clickSuperView;
@property (strong, nonatomic)UIScrollView     *belowScrollView;
@property (strong, nonatomic)UIScrollView    *bottomView;
@property (strong, nonatomic)UILabel   *centerLable;
@property (strong, nonatomic)UIImageView *centerImgView;
@property (strong, nonatomic)UIButton *previousButton;
@property (strong, nonatomic)UIButton *nextButton;
@property (strong, nonatomic)TopImageView    *topfuzzyView;//在导航条上覆盖的模糊层

@property (assign,nonatomic) BOOL               flipbool;
@property (nonatomic,strong) NSMutableArray     *subviewArray;
@property (nonatomic,assign) int                position;
@property (nonatomic,assign) id <GesturesViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *bottomtemplateElementArray;

//服务端
//从草稿箱获得
@property (strong,nonatomic)CollocationElement *collocationElement;
//从模板获得
@property (strong,nonatomic)TemplateElement  *templateElement;



-(void)addGesturesImageView:(CGRect)rect image:(UIImage *)image center:(CGPoint)centerpoint withdraftNum:(NSString *)draftNum withtGoodObj:(GoodObj *)goodObj;
-(void)addGesturesImageView:(CGRect)rect image:(UIImage *)image center:(CGPoint)centerpoint withdraftNum:(NSString *)draftNum withtransform:(NSString *)transform WithmainOldGesturesImageView:(GesturesImageView *)oldGesturesImageView;

-(void)repetitionGesturesImageView:(PhotoVO *)photovo;
-(void)repetitionGesturesImageView:(PhotoVO *)photovo withDraftVO:(DraftVO *)draftvo draftNum:(NSString *)draftNum;
-(void)repetitionGesturesImageViewWithServicedata:(LayoutMapping *)layoutMapping withDetailMapping:(DetailMapping *)detailMapping withTemplateId:(NSString *)templateId rationalNum:(NSString *)rationalNumStr;

//获得某个范围内的屏幕图像
- (UIImage *)imageFromView:(UIView *) theView  atFrame:(CGRect)r;
-(void)addBottombuttonwithindex:(int)index withServiceTemplateElement:(TemplateElement *)templateElement withtemplateElementArray:(NSMutableArray *)templateElementArray;
#pragma mark --素材添加
-(void)addGesturesImageView:(CGRect)rect image:(UIImage *)image center:(CGPoint)centerpoint withdraftNum:(NSString *)draftNum MaterialMapping:(MaterialMapping *)materialMapping;
#pragma mark -- 添加更多模板按钮
-(void)addMoretemplateButtonTobelowScrollView;
#pragma mark --detailMapping添加
-(void)addGesturesImageView:(CGRect)rect image:(UIImage *)image center:(CGPoint)centerpoint withdraftNum:(NSString *)draftNum withtDetailMapping:(DetailMapping *)detailMapping;

#pragma mark -- 处理下方浮动框
-(void)disposeBrlowScrollViewAndBottomView;

-(void)resetRecoveryGesturesImageView;
-(void)stopSpinerAnddisappearBorder:(GesturesImageView *)gesturesImageView;
@end
