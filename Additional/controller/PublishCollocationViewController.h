//
//  PublishCollocationViewController.h
//  newdesigner
//
//  Created by Miaoz on 14-10-14.
//  Copyright (c) 2014年 mb. All rights reserved.
//
#define wordNum 70
#import <UIKit/UIKit.h>
#import "GesturesView.h"
#import "BaseViewController.h"

#import "Globle.h"
#import "TopicMapping.h"
#import "TagMapping.h"
#import "UIPlaceHolderTextVIew.h"
#import "CustomScrollView.h"
#import "GesturesImageView.h"
#import "Globle.h"
#import "UMButton.h"
#import "CommMBBusiness.h"
#import "GoodObj.h"
@interface PublishCollocationViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray *gesturesViewArray;
@property(nonatomic,strong)GesturesView *gesturesView;




@property(strong,nonatomic)    UITapGestureRecognizer *singleFinger;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *titleTextView;
@property(strong,nonatomic)UIScrollView *scrollView;

@property(strong,nonatomic)UIPlaceHolderTextView *descTextView;
@property(strong,nonatomic)UIPlaceHolderTextView *tagTextView;
@property(strong,nonatomic)UILabel *descpromptLab;
@property(strong,nonatomic)UILabel *tagpromptLab;

@property (nonatomic,strong) UILabel *topicLab;
@property (nonatomic,strong) UILabel *tagLab;
@property(nonatomic,strong)NSMutableArray *dataTopicarray;
@property(nonatomic,strong)NSMutableArray *dataTagarray;

@property(nonatomic,strong)NSString *uniquesessionid;

@property(nonatomic,strong)NSMutableArray *postTopicarray;
@property(nonatomic,strong)NSMutableArray *postTagarray;
@property(nonatomic,strong)NSMutableArray *postCustomTagarray;
@property(nonatomic,strong)ShareRelated *shareRelated;
@property(nonatomic,strong)UIImage *shareRelatedImage;

@property(nonatomic,strong)UIBarButtonItem *rightBarButton;

- (IBAction)rightBarButtonItemClickevent:(id)sender;
- (IBAction)leftBarButtonItemClickevent:(id)sender;
-  (int)convertToInt:(NSString*)strtemp;
#pragma mark--发布请求接口
-(void)requestCreatcollocationWithtitleName:(NSString *)name BackWidth:(NSString *)backwidth Description:(NSString *)description UserId:(NSString *)userId CreateUser:(NSString *)creatuser DetailList:(NSMutableArray *)detaillist LayoutMappingList:(NSMutableArray *)layoutMappingList TopicMappingList:(NSMutableArray *)topicMappingList TagMapping:(NSMutableArray *)TagMappingList TemplateId:(NSString *)templateId CustomTagList:(NSMutableArray *)customTagList;

@end
