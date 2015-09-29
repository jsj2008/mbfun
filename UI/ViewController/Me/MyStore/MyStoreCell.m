//
//  MyStoreCell.m
//  Wefafa
//
//  Created by su on 15/1/26.
//  Copyright (c) 2015年 fafatime. All rights reserved.
// w:156 h:170
#import "MyStoreCell.h"

#define kImageWidth 116
#define kImageHeight 120
#define kContentHeight 140
#define kLeftWidthBetweenCell 10
#define kWidthBetweenViews 10
@interface CellSubView : UIView
@property (nonatomic,strong)UIUrlImageView *imageView;
@property (nonatomic,strong)UILabel *discussLabel;//评论数label
@property (nonatomic,strong)UIImageView *heartImg;//心型图片
@property (nonatomic,strong)UILabel *loveLabel;//喜欢的数目的label
@property (nonatomic,strong)UIImageView *discussImage;
@property (nonatomic,strong)CollocationDetail *detail;
@end

@implementation CellSubView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
        [self addGestureRecognizer:tap];
        _imageView = [[UIUrlImageView alloc] initWithFrame:CGRectMake((frame.size.width-116)/2, 16, kImageWidth, kImageHeight)];
        [self addSubview:_imageView];
        
        _discussImage = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftWidthBetweenCell, kContentHeight+3, 15, 15)];
        [_discussImage setImage:[UIImage imageNamed:@"new_apprise_show@2x.png"]];
        [self addSubview:_discussImage];
        
        _discussLabel = [[UILabel alloc] initWithFrame:CGRectMake((kLeftWidthBetweenCell + kWidthBetweenViews + 22), kContentHeight, 60, 22)];
        [_discussLabel setTextAlignment:NSTextAlignmentLeft];
        [_discussLabel setTextColor:[UIColor blackColor]];
        [_discussLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_discussLabel];
        
        _heartImg = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 60 -14, kContentHeight+3, 15, 15)];
        [_heartImg setImage:[UIImage imageNamed:@"new_like_show@2x.png"]];
        [self addSubview:_heartImg];
        
        _loveLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 30 -14, kContentHeight, 60, 22)];
        [_loveLabel setTextAlignment:NSTextAlignmentCenter];
        [_loveLabel setTextColor:[UIColor blackColor]];
        [_loveLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_loveLabel];
    }
    return self;
}

- (void)clearAllMessage
{
    [_imageView setImage:nil];
    [_discussImage setImage:nil];
    [_discussLabel setText:@""];
    [_heartImg setImage:nil];
    [_loveLabel setText:@""];
}

- (void)updateSubViewWithInfo:(CollocationDetail *)model
{
    if (!model) {
        [self clearAllMessage];
        return;
    }
    _detail = model;
    [self downloadImage:_imageView url:model.pictureUrl];
    [_discussLabel setText:[NSString stringWithFormat:@"%d",(int)model.commentCount]];
    NSString *loveStr = [NSString stringWithFormat:@"%d",(int)model.favoriteCount];
    CGSize aSize = [loveStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20)];
    CGRect loveFrame = _loveLabel.frame;
    loveFrame.size.width = aSize.width;
    loveFrame.origin.x = self.frame.size.width - aSize.width - kLeftWidthBetweenCell;
    _loveLabel.frame = loveFrame;
    [_loveLabel setText:loveStr];
    
    CGRect aFrame = _heartImg.frame;
    aFrame.origin.x = loveFrame.origin.x - aFrame.size.width - kWidthBetweenViews;
    _heartImg.frame = aFrame;
}

-(void)downloadImage:(UIUrlImageView* )imageView url:(NSString *)url
{
    if (imageView==nil) return;
    if (!url) {
        [imageView setImage:nil];
        return;
    }
    NSString *defaultImg=DEFAULT_LOADING_MEDIUM;
    if (!url || [url isEqual:[NSNull null]]) {
        [imageView setImage:[UIImage imageNamed:defaultImg]];
    } else{
        [imageView downloadImageUrl:[CommMBBusiness changeStringWithurlString:url size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
    }
}

- (void)tapView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyStoreCollocationNotifyKey object:_detail];
}

@end

@implementation MyStoreCell{
    CellSubView *leftView;
    CellSubView *rightView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        CGFloat width = self.frame.size.width / 2;
        leftView = [[CellSubView alloc] initWithFrame:CGRectMake(1, 0.5, width - 1.5, 169)];
        rightView = [[CellSubView alloc] initWithFrame:CGRectMake(width + 0.5, 0.5, width - 1.5, 169)];
        [self.contentView addSubview:leftView];
        [self.contentView addSubview:rightView];
    }
    return self;
}

- (void)updateCellWithLeftInfo:(CollocationDetail *)leftDict rightInfo:(CollocationDetail *)rigthDict
{
    [leftView updateSubViewWithInfo:leftDict];
    [rightView updateSubViewWithInfo:rigthDict];
}
@end
