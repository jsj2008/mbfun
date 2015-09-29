//
//  SDiscoveryShowTopicView.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryShowTopicView.h"
#import "SDiscoveryShowTitleView.h"
#import "StopicListModel.h"
#import "SUtilityTool.h"
#import "STopicViewController.h"
#import "STopicDetailViewController.h"
#import "SDiscoveryFlexibleModel.h"

@interface SDiscoveryShowTopicView ()

@property (nonatomic, strong) NSMutableArray *contentViewArray;

@end

@implementation SDiscoveryShowTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.backgroundColor = [UIColor whiteColor];
    _contentViewArray = [NSMutableArray array];
    
    CGFloat width = (UI_SCREEN_WIDTH - 10)/ 3.0;
    CGRect frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - width - 5, UI_SCREEN_WIDTH - width - 5);
    [self addImageViewWithFrame:frame];
    
    CGRect rect = CGRectMake(CGRectGetMaxX(frame) + 5, 0, width, width);
    [self addImageViewWithFrame:rect];
    
    rect = CGRectMake(CGRectGetMaxX(frame) + 5, 5 + width, width, width);
    [self addImageViewWithFrame:rect];
    
    rect = CGRectMake(0, CGRectGetMaxY(frame) + 5, width, width);
    [self addImageViewWithFrame:rect];
    
    rect = CGRectMake(width + 5, CGRectGetMaxY(frame) + 5, width, width);
    [self addImageViewWithFrame:rect];
    
    rect = CGRectMake(CGRectGetMaxX(frame) + 5, CGRectGetMaxY(frame) + 5, width, width);
    [self addImageViewWithFrame:rect];
    
//    SDiscoveryShowTopicDetailView *view = [_contentViewArray lastObject];
//    view.tag = 999;
//    view.contentImageView.image = [UIImage imageNamed:@"Unico/topic6"];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/cover22.png"]];
//    imageView.frame = view.contentImageView.frame;
//    [view.contentImageView addSubview:imageView];
}

- (void)addImageViewWithFrame:(CGRect)frame{
    SDiscoveryShowTopicDetailView *view = [[SDiscoveryShowTopicDetailView alloc]initWithFrame:frame];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchShowContentView:)];
    [view addGestureRecognizer:tap];
    [self addSubview:view];
    [_contentViewArray addObject:view];
}

- (void)touchShowContentView:(UITapGestureRecognizer*)tap{
    if (tap.view.tag == 999) {
        STopicViewController *controller = [[STopicViewController alloc]init];
        [_target.navigationController pushViewController:controller animated:YES];
    }else{
        if (_contentArray.count <= 0 || !_contentArray) {
            return;
        }
        NSInteger index = [_contentViewArray indexOfObject:tap.view];
        if (index >= _contentArray.count) return;
        StopicListModel *topicModel = _contentArray[index];
        STopicDetailViewController *controller = [[STopicDetailViewController alloc]init];
        controller.topicID = topicModel.aID;
        controller.titleName = topicModel.name;
        [_target.navigationController pushViewController:controller animated:YES];
    }
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    for (int i = 0; i < MIN(contentArray.count, 6); i ++) {
        SDiscoveryShowTopicDetailView *view = _contentViewArray[i];
        view.titleLabel.hidden = NO;
        StopicListModel *topic = contentArray[i];
        [view.contentImageView sd_setImageWithURL:[NSURL URLWithString:topic.img] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
        [view.tagImageView sd_setImageWithURL:[NSURL URLWithString:topic.obl]];
        view.titleLabel.text = topic.name;
    }
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    self.contentArray = contentModel.config;
}

@end

@implementation SDiscoveryShowTopicDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _contentImageView.layer.masksToBounds = YES;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        [self addSubview:_contentImageView];
        
        _tagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width * 6.0 / 25.0, frame.size.height * 6.0 / 25.0)];
        _tagImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_tagImageView];
        
        CGFloat height = 26.0 * UI_SCREEN_WIDTH/ 375.0;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - height, self.bounds.size.width, height)];
        _titleLabel.hidden = YES;
        _titleLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14.0 * UI_SCREEN_WIDTH/ 375.0];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
