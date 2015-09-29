//
//  PublishCustomView.h
//  Wefafa
//
//  Created by Miaoz on 15/5/8.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIPlaceHolderTextView;
@protocol PublishCustomViewDelegate <NSObject>

-(void)callBackPublishCustomViewWithShareButton:(id)sender;

@end
@interface PublishCustomView : UIView
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *shareRelatedImageView;
@property(nonatomic,strong)NSMutableArray *dataTopicarray;
@property(nonatomic,strong)NSMutableArray *dataTagarray;
@property(nonatomic,strong)NSMutableArray *postTopicarray;
@property(nonatomic,strong)NSMutableArray *postTagarray;
@property(nonatomic,strong)NSMutableArray *postCustomTagarray;
@property(strong,nonatomic)UIPlaceHolderTextView *descTextView;
@property(strong,nonatomic)UIPlaceHolderTextView *tagTextView;
@property(strong,nonatomic)UILabel *descpromptLab;
@property(strong,nonatomic)UILabel *tagpromptLab;
@property(weak,nonatomic)id <PublishCustomViewDelegate> delegate;
@end
