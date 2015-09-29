//
//  FoundTableViewCell.m
//  Wefafa
//
//  Created by su on 15/1/29.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "FoundTableViewCell.h"
#import "MyStoreViewController.h"
#import "AppDelegate.h"

typedef void(^CollocationImageClick)(SearchCollocationInfo *info);
#define kImageWidth 106
#define kImageHeight 120

@interface SearchLevelView : UIView
@property(nonatomic,assign)NSInteger levelNum;
@end

@implementation SearchLevelView{
    UILabel *_levelLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24.5, 11.5)];
        [imageView setImage:[UIImage imageNamed:@"levelBg@2x.png"]];
        [self addSubview:imageView];
        
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, 12.5, 11.5)];
        [_levelLabel setTextColor:[UIColor colorWithRed:0.424 green:0.282 blue:0.008 alpha:1.0]];
        [_levelLabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:11]];
        [_levelLabel setAdjustsFontSizeToFitWidth:YES];
        [_levelLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_levelLabel];
    }
    return self;
}

- (void)setLevelNum:(NSInteger)levelNum
{
    NSString *title = @"";
    if (levelNum < 10) {
        if (levelNum == 0) {
            levelNum = 1;
        }
        title = [NSString stringWithFormat:@"0%d",levelNum];
    } else {
        title = [NSString stringWithFormat:@"%d",levelNum];
    }
    [_levelLabel setText:title];
}

@end

@interface FoundCellSubView : UIView
@property(nonatomic,copy)CollocationImageClick collocationClick;
@end

@implementation FoundCellSubView{
    NSArray *collocationArr;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat value = 239.0/255.0;
        [self setBackgroundColor:[UIColor colorWithRed:value green:value blue:value alpha:1.0]];
    }
    return self;
}

- (void)configViewContentWithInfo:(NSArray *)array
{
    collocationArr = array;
    NSInteger numCount = array.count;
    int i = 0;
    CGFloat width = (self.frame.size.width - (numCount - 1) * 0.5)/3;
    for(UIView *aView in self.subviews){
        [aView removeFromSuperview];
    }
    for(SearchCollocationInfo *info in array){
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(i*(width + 0.5), 0.5, width, 120)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
//        [bgView setTag:1000+i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:bgView.bounds];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        NSString *tmpStr = @"home_cell_default@2x.png";
        [imageView setImageAFWithURL:[NSURL URLWithString:info.pictureUrl] placeholderImage:[UIImage imageNamed:tmpStr]];
        [imageView setTag:100+i];
        [imageView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIndexCollocationImage:)];
        [imageView addGestureRecognizer:tap];
        [bgView addSubview:imageView];
        [self addSubview:bgView];

        i ++;
    }
}

- (void)tapIndexCollocationImage:(UIGestureRecognizer *)gesture
{
    UIImageView *imgView = (UIImageView *)gesture.view;
    NSInteger index = imgView.tag - 100;
    if (collocationArr.count > index) {
        SearchCollocationInfo *info = [collocationArr objectAtIndex:imgView.tag - 100];
        if (self.collocationClick) {
            self.collocationClick(info);
        }
    }
    
}

//- (void)updateImageFrameWithSize:(CGSize)imgSize
//{
//    
//}

@end

@implementation FoundTableViewCell{
    UIImageView *_bgImage;
    UIImageView *_headerImage;
    SearchLevelView *_levelImage;
    UILabel *_nameLabel;
    UILabel *_levelLabel;
    FoundCellSubView *_cellSubView;
    FoundCellModel *cellModel;
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
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 160)];
//        [_bgImage setContentMode:UIViewContentModeScaleAspectFill];
        _bgImage.contentMode = UIViewContentModeScaleAspectFill;
        _bgImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgImage];
        
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 50) / 2, 125, 50, 50)];
        [self setCornerWith:_headerImage radius:25 borderColor:[UIColor clearColor]];
        [self.contentView addSubview:_headerImage];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 50) / 2, _headerImage.frame.size.height + _headerImage.frame.origin.y + 5, 45, 20)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_nameLabel];
        
        
        _levelImage = [[SearchLevelView alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 5, _nameLabel.frame.origin.y+5,  24.5, 11.5)];
        [self.contentView addSubview:_levelImage];
        
//        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 5, _nameLabel.frame.origin.y, 30, 20)];
//        [_levelLabel setBackgroundColor:[UIColor yellowColor]];
//        [_levelLabel setFont:[UIFont systemFontOfSize:14.0]];
//        [_levelLabel setTextAlignment:NSTextAlignmentCenter];
//        [self setCornerWith:_levelLabel radius:4.0 borderColor:[UIColor whiteColor]];
//        [self.contentView addSubview:_levelLabel];
        
        
        _cellSubView = [[FoundCellSubView alloc] initWithFrame:CGRectMake(0, _nameLabel.frame.size.height + _nameLabel.frame.origin.y + 10, self.frame.size.width, 140)];
        
        __weak FoundTableViewCell *weakSelf = self;
        [_cellSubView setCollocationClick:^(SearchCollocationInfo *info){
            if (info) {
                [weakSelf collocationImageClick:info];
            }
        }];
        [self.contentView addSubview:_cellSubView];
        
    }
    return self;
}

- (void)collocationImageClick:(SearchCollocationInfo *)info
{
    MyStoreViewController *store = [[MyStoreViewController alloc] init];
    store.naviTitle = info.name;
    store.userId = info.userId;
    [[AppDelegate rootViewController] pushViewController:store animated:YES];
}

- (void)setCornerWith:(UIView *)view radius:(CGFloat)radius borderColor:(UIColor *)color
{
    [view.layer setCornerRadius:radius];
    [view.layer setBorderColor:color.CGColor];
    [view.layer setBorderWidth:0.5];
    [view.layer setMasksToBounds:YES];
}

- (void)updateCellInfo:(FoundCellModel *)model
{
    cellModel = model;
    [_bgImage setImageAFWithURL:[NSURL URLWithString:model.backGround] placeholderImage:[UIImage imageNamed:@"home_cell_default@2x.png"]];
    [_headerImage setImageAFWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:@"ico_userprofile_femaleimage@3x.png"]];
    
    NSString *nameStr = model.nickName;
    if ([nameStr length] <= 0) {
        nameStr = model.userName;
    }
    CGSize size = [nameStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 20)];
    
    CGFloat xPoint = (self.frame.size.width - (size.width + 35))/2;
    CGRect nameFrame = _nameLabel.frame;
    nameFrame.origin.x = xPoint;
    nameFrame.size.width = size.width;
    _nameLabel.frame = nameFrame;
    
    CGRect levelFrame = _levelImage.frame;
    levelFrame.origin.x = nameFrame.origin.x + size.width + 5;
    _levelImage.frame = levelFrame;
    [_levelImage setLevelNum:model.userLevel];
    
    [_nameLabel setText:nameStr];
    
//    [_levelLabel setText:[NSString stringWithFormat:@"V%d",model.userLevel]];
    [_cellSubView configViewContentWithInfo:model.collocationList];
}

- (NSString *)imageNameWithLevel:(NSInteger)level
{
    NSString *name = nil;
    switch (level) {
            
        case 1:
            name = @"level1@2x.png";
            break;
        case 2:
            name = @"level2@2x.png";
            break;
        case 3:
            name = @"level3@2x.png";
            break;
        case 4:
            name = @"level4@2x.png";
            break;
        case 5:
            name = @"level5@2x.png";
            break;
        case 6:
            name = @"level6@2x.png";
            break;
            
        default:
            name = @"level1@2x.png";
            break;
    }
    return name;
}
@end
