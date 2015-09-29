//
//  GesturesImageView.h
//  newdesigner
//
//  Created by Miaoz on 14-9-11.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodObj.h"
#import "DetailMapping.h"
#import "LayoutMapping.h"
#import "MaterialMapping.h"
@protocol GesturesImageViewDelegate <NSObject>

@optional
-(void)callBackGesturesImageViewWithview:(id)sender isFirstClickmark:(BOOL)mark;
-(void)callBackPreviousAndNextGesturesImageViewWithview:(id)sender;
@end

@interface GesturesImageView : UIImageView <UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIActivityIndicatorView *spinner;
@property(nonatomic,strong) UIView                          *toplineview;
@property(nonatomic,strong) UIView                          *rightlineview;
@property(nonatomic,strong) UIView                          *bottomlineview;
@property(nonatomic,strong) UIView                          *leftlineview;
@property(nonatomic,strong) UIRotationGestureRecognizer     *rotationG;
@property(nonatomic,strong) UIPinchGestureRecognizer        *pinchGesture;
@property(nonatomic,strong) UIPanGestureRecognizer          *panGesture;
@property(nonatomic,strong) UITapGestureRecognizer          *singleFinger;
@property(nonatomic)BOOL    isFirstClick;
@property(nonatomic,strong)NSString *fliptagStr;
@property(nonatomic,strong) UIView                          *parentView;
@property(nonatomic,weak)   id <GesturesImageViewDelegate> delegate;

@property(nonatomic)        CGFloat height;
@property(nonatomic)        CGFloat width;
@property (nonatomic,assign)int     gesturePosition;//位置层
@property(nonatomic)        CGPoint centerpoint;//中心坐标
@property(nonatomic)        CGAffineTransform publictransform;//缩Transform
@property (nonatomic)       CGFloat pinchGesturescale;//缩放手势scale
@property (nonatomic)       CGFloat rotationGesturerotation;//旋转手势rotation
@property(nonatomic,strong) NSString                        *imageurl;//图片url
@property(nonatomic,strong) NSString *draftid;
@property(nonatomic,strong) NSString *savetag;
@property(nonatomic,strong) NSString *draftname;
@property(nonatomic,strong) NSData *jiepingImageData;


@property(nonatomic,strong)GoodObj *goodObj;
@property(nonatomic,strong)DetailMapping *detailMapping;
@property(nonatomic,strong)LayoutMapping *layoutMapping;
@property(nonatomic,strong)MaterialMapping *materialMapping;
//11.20 add by miao 发布、保存使用
@property(nonatomic,strong)NSString *templateId;

//画边框
-(void)crossBorderevent;
-(void)crossBorderDisappearevent;

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

-(void)addGestures;
-(void)addlineView;

//处理单指事件
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender;
-(void)stopSpinerAnddisappearBorderWithgesturesImageView:(GesturesImageView *)gesturesImageView;
@end
