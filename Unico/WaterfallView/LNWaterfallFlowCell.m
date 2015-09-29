//
//  LNWaterfallFlowCell.m
//  WaterfallFlowDemo
//
//  Created by Lining on 15/5/3.
//  Copyright (c) 2015年 Lining. All rights reserved.
//

#import "LNWaterfallFlowCell.h"
#import "LNGood.h"
#import "UIImageView+WebCache.h"

@interface LNWaterfallFlowCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property ( nonatomic)  UILabel *itemText;
@property ( nonatomic)  UILabel *likeNum;
@property ( nonatomic)  UILabel *nameLabel;
@property ( nonatomic)  UIImageView *likeView;
@property ( nonatomic)  UIImageView *headView;




@end

@implementation LNWaterfallFlowCell

- (void)setGood:(LNGood *)good {
    _good = good;
    NSURL *url = [NSURL URLWithString:good.img];
    [self.iconView sd_setImageWithURL:url];
//    [self.iconView setImageWithURL:url];
//    [self.iconView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        _bgView2.frame = CGRectMake(0, image.size.height -100 , self.frame.size.width, 100);
//    }];
    

    

   
}

-(void) initWaterFallFlowCell{
    float fontSize = 12;
//    _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.iconView.frame.size.height , self.frame.size.width, 100)];
//    _bgView.backgroundColor = [UIColor blackColor];
//    [self.iconView addSubview:_bgView];

    _itemText = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-5,_bgView.frame.size.height/2 )];
    [_itemText setNumberOfLines:2];
    _itemText.text = @"检查一下你的storyboard,再检查一下你的代码,根据你给出的代码，我只能说通常是被重新设置了背景或者是因为其他view的障眼法造成的,先检查代码再说咯。";
    _itemText.textColor = [UIColor whiteColor];
    _itemText.font = [UIFont systemFontOfSize:fontSize];
    
    [_bgView addSubview:_itemText];
    
    _headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"brand_pic"]];
    _headView.frame = CGRectMake(5, _bgView.frame.size.height/2 , 40, 40);
    _headView.layer.cornerRadius = _headView.frame.size.height/2;
    _headView.clipsToBounds = YES;
    [_bgView addSubview:_headView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40+5,_bgView.frame.size.height*3/4-40/2, 50,40 )];
    _nameLabel.text = @"不错";
    _nameLabel.font = [UIFont systemFontOfSize:fontSize];
    _nameLabel.textColor = [UIColor whiteColor];
    [_bgView addSubview:_nameLabel];
    
    _likeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like_heart"]];
    _likeView.frame = CGRectMake(self.frame.size.width - 60, _bgView.frame.size.height*3/4-13/2, 30/2, 26/2);
    [_bgView addSubview:_likeView];
    
    _likeNum = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 40  , _bgView.frame.size.height/2, 35,50)];
    _likeNum.text = @"1111";
    _likeNum.textColor = [UIColor whiteColor];
    _likeNum.font = [UIFont systemFontOfSize:fontSize];
    [_bgView addSubview:_likeNum];
    
}


@end
