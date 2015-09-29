//
//  MyViewController.h
//  newdesigner
//
//  Created by Miaoz on 14-9-26.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftVO.h"
#import "BaseViewController.h"
@class NavTopTitleView;
@class CollocationInfo;
@protocol MyViewControllerDeleagte <NSObject>

@optional
-(void)callBackMyViewControllerWithDraftvo:(DraftVO *)draftvo;

-(void)callBackMyViewControllerWithServiceCollocationInfo:(id)sender;

-(void)callBackMyViewControllerWithServicemubantemplateElement:(id)sender;
@end


@interface MyViewController : BaseViewController
@property(strong ,nonatomic)UICollectionView *collectionView;
@property(strong ,nonatomic)UICollectionView *collectionView2;
@property(strong ,nonatomic)UICollectionView *collectionView3;

@property(strong,nonatomic) NSMutableArray *dataCollocationInfoarray1;//左 草稿
@property(strong,nonatomic) NSMutableArray *dataCollocationInfoarray2;//中 搭配
@property(strong,nonatomic) NSMutableArray *datatemplateElementarray;//右  模板
@property(strong,nonatomic)NavTopTitleView *navTopTitleView;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;


@property(strong,nonatomic)UIScrollView *scrollView;
@property(nonatomic,assign)int numberScroll;
@property(assign,nonatomic)BOOL isEdit;
@property(nonatomic,strong)UIButton *rightbutton;

//@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,weak)id <MyViewControllerDeleagte> delegate;

@property(nonatomic,strong)NSString *clickNumStr;

- (IBAction)rightBarButtonItemClickevent:(UIBarButtonItem *)sender;

- (IBAction)leftBarButtonItemClickevent:(id)sender;

-(void)requestHttpdeleteCollocationInfo:(CollocationInfo *)collocationInfo;
@end
