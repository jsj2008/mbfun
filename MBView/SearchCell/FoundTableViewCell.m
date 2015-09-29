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
#import "Utils.h"
#import "ModelBase.h"
#import "MBMyStoreInfoModel.h"
//#import "MBOtherStoreViewController.h"
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
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
        [imageView setImage:[UIImage imageNamed:@"levelBg"]];
        
        
        [self addSubview:imageView];
        
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1.5, 15, 12)];
        [_levelLabel setTextColor:[Utils HexColor:333333 Alpha:1.0]];
        
        [_levelLabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:14]];
        [_levelLabel setAdjustsFontSizeToFitWidth:YES];
        [_levelLabel setTextAlignment:NSTextAlignmentCenter];
        [_levelLabel setBackgroundColor:[UIColor yellowColor]];
        [_levelLabel.layer setCornerRadius:4.0];
//        [self setCornerWith:_levelLabel radius:4.0 borderColor:[UIColor whiteColor]];
        //                [self.contentView addSubview:_levelLabel];
        //[self addSubview:_levelLabel];
    }
    return self;
}

- (void)setLevelNum:(NSInteger)levelNum
{
    NSString *title = @"";
    CGSize  matchSize = CGSizeMake(15, 15);

    if (levelNum < 10) {
        if (levelNum == 0) {
            levelNum = 1;
        }
        title = [NSString stringWithFormat:@"V%d",1000];
    } else {
        title = [NSString stringWithFormat:@"V%d",100];
    }
    if ([title respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary * fontDic = @{NSFontAttributeName: [ UIFont fontWithName:@"Helvetica-BoldOblique" size:14] };
       matchSize.width = [title boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic context:nil].size.width;
    }
    if ([title respondsToSelector:@selector(sizeWithFont:constrainedToSize:)]) {
        matchSize.width = [title sizeWithFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:14] constrainedToSize:CGSizeZero].width;
    }
    _levelLabel.frame = CGRectMake(_levelLabel.frame.origin.x, _levelLabel.frame.origin.y, matchSize.width+20, 15);
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
    UIImageView * defaultBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, UI_SCREEN_WIDTH, 120)];
    [defaultBG setUserInteractionEnabled:true];
    if ([array count]== 0 ) {
        [defaultBG setImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        
    }
    for(SearchCollocationInfo *info in array){
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(i*(width + 0.5), 0.5, width, 120)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        //        [bgView setTag:1000+i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:bgView.bounds];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        NSString *tmpStr = @"home_cell_default@2x.png";
        [imageView sd_setImageWithURL:[NSURL URLWithString:info.pictureUrl] placeholderImage:[UIImage imageNamed:tmpStr]];
        [imageView setTag:100+i];
        [imageView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIndexCollocationImage:)];
        [imageView addGestureRecognizer:tap];
        [bgView addSubview:imageView];
        [defaultBG addSubview:bgView];
        i ++;
    }
    [self addSubview:defaultBG];
    
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
    UIImageView *_headerImage;
    SearchLevelView *_levelImage;
    UILabel *_nameLabel;
    UILabel *_levelLabel;
    FoundCellSubView *_cellSubView;
    FoundCellModel *cellModel;
    UIView * _upperView;

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
        
        
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake( 15, 5, 34, 34)];
        [self setCornerWith:_headerImage radius:17 borderColor:[UIColor clearColor]];
//        [self.contentView addSubview:_headerImage];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImage.frame.origin.x+_headerImage.frame.size.width+15, 12, 45, 20)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
//        [self.contentView addSubview:_nameLabel];
        
        
        _levelImage = [[SearchLevelView alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 8, 14.5,  30, 15)];
//        [self.contentView addSubview:_levelImage];
        
        _upperView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, _nameLabel.frame.size.height + _nameLabel.frame.origin.y + 10)];
        [_upperView addSubview:_headerImage];
        [_upperView addSubview:_nameLabel];
        [_upperView addSubview:_levelImage];
        [self.contentView addSubview:_upperView];
//                _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 5, _nameLabel.frame.origin.y, 30, 20)];
//                [_levelLabel setBackgroundColor:[UIColor yellowColor]];
//                [_levelLabel setFont:[UIFont systemFontOfSize:14.0]];
//                [_levelLabel setTextAlignment:NSTextAlignmentCenter];
//                [self setCornerWith:_levelLabel radius:4.0 borderColor:[UIColor whiteColor]];
//                [self.contentView addSubview:_levelLabel];
        
        
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
//    MBMyStoreInfoModel *model = [[MBMyStoreInfoModel alloc]init];
//    model.userId = info.userId;
//    model.storeName = info.name;
//    
//    MBOtherStoreViewController * otherStore = [[MBOtherStoreViewController alloc]init];
//    otherStore.model = model;
//    [[AppDelegate rootViewController] pushViewController:otherStore animated:YES];
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
    
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:@"default_header_image@2x.png"]];
    
    NSString *nameStr = model.nickName;
    if ([nameStr length] <= 0) {
        nameStr = model.userName;
    }
    CGSize size;
    if ([[UIDevice currentDevice] systemVersion].floatValue<7.0) {
        size = [nameStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 20)];

    }
    else
    {
        NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        size.width = [nameStr boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size.width;
        size.height = [nameStr boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size.height;
    }
    
    CGRect nameFrame = _nameLabel.frame;
    nameFrame.size.width = size.width;
    _nameLabel.frame = nameFrame;
    
    CGRect levelFrame = _levelImage.frame;
    levelFrame.origin.x = nameFrame.origin.x + size.width + 8;
    _levelImage.frame = levelFrame;
    [_levelImage setLevelNum:model.userLevel];
    
    [_nameLabel setText:nameStr];
    
    
    
    
    [_cellSubView configViewContentWithInfo:model.collocationList];
    //[self headImgClicked];
}
-(void)headImgClicked
{
    [_headerImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headTap)];
    [_upperView addGestureRecognizer:tap];
    
}
-(void)headTap
{

//    MBOtherStoreViewController *otherStore=[[MBOtherStoreViewController alloc]initWithNibName:@"MBOtherStoreViewController" bundle:nil];
//    otherStore.user_ID = cellModel.userId;
//    [[AppDelegate rootViewController] pushViewController:otherStore animated:YES];
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
