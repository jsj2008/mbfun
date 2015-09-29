//
//  MentallySuperView.h
//  Wefafa
//
//  Created by Miaoz on 15/3/24.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LayoutMapping;
@class DetailMapping;
@class TemplateElement;
@class TemplateInfo;
@class GoodObj;
@class MaterialMapping;
@class GesturesImageView;
@class ContentInfo;
@class CollocationInfo;
@protocol MentallySuperViewDelegate <NSObject>

@optional
-(void)callBackMentallySuperViewWithDetailMapping:(DetailMapping *)detailMapping LayoutMapping:(LayoutMapping *)layoutMapping withMentallView:(id)mentallyView;

-(void)callBackMentallySuperViewWithMentallView:(id)mentallyView withGesturesImageView:(GesturesImageView *)gesturesImageView isFirstClickmark:(BOOL)mark;

@end

@interface MentallySuperView : UIImageView
@property(nonatomic,strong)CollocationInfo *collocationInfo;//搭配草稿
@property(nonatomic,strong)TemplateInfo *templateInfo;//模板
@property(nonatomic,strong)LayoutMapping * layoutMapping;
@property(nonatomic,strong)DetailMapping *detailMapping;


//容器内部数据
@property(nonatomic,strong)GoodObj *goodObj;
@property(nonatomic,strong)ContentInfo *contentInfo;
@property(nonatomic,strong)MaterialMapping *materialMapping;
@property(nonatomic,strong)GesturesImageView *gesturesImageView;

@property (strong, nonatomic)UIScrollView    *bottomView;
@property (strong,nonatomic)UIView *mainSuperView;
@property (strong,nonatomic)NSString *bankWidth;
@property  (strong,nonatomic)NSString *bankHeight;

@property(nonatomic,strong)NSString *changeX;
@property(nonatomic,strong)NSString *changeY;
@property(nonatomic,weak)id <MentallySuperViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
-(void)changeMentallySuperViewWithLayoutMapping:(LayoutMapping *)layoutMapping withDetailMapping:(DetailMapping *)detailMapping withtemplateElement:(TemplateElement *)templateElement;
-(void)addGesturesImageViewToMentallySuperView:(CGRect)rect image:(UIImage *)image center:(CGPoint)centerpoint withTransformStr:(NSString *)draftNum withtGoodObj:(GoodObj *)goodObj;
#pragma mark -- 复原草稿 搭配
-(void)repetitionMentallyGesturesImageViewWithServicedata:(LayoutMapping *)layoutMapping withdetailMapping:(DetailMapping *)detailMapping withCollocationInfo:(CollocationInfo *)collocationInfo withtemplateInfo:(TemplateInfo *)templateInfo withContentInfo:(ContentInfo *)contentInfo;
@end
