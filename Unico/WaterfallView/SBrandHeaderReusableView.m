//
//  SBrandHeaderReusableView.m
//  Wefafa
//
//  Created by unico_0 on 6/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SBrandHeaderReusableView.h"
#import "StopicSelectedButton.h"
#import "SBrandStoryDetailModel.h"
#import "UIImageView+WebCache.h"
#import "SUtilityTool.h"
#import "SMineViewController.h"
#import "MBSettingMainViewController.h"
#import "SFilterSelectedModel.h"
#import "WeFaFaGet.h"

@interface SBrandHeaderReusableView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandStoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageViewCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *showUserCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

- (IBAction)likeButtonAction:(UIButton *)sender;
- (IBAction)moreBtnAction:(id)sender;

//--------------
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) CAGradientLayer *maskLayer;
@property (nonatomic, strong) SFilterSelectedModel *selectedIndexModel;

@end

static NSString *cellIndentifier = @"SBrandHeaderUserCollectionViewCellIdenfier";
@implementation SBrandHeaderReusableView

- (void)awakeFromNib {
    CGRect rect = self.contentImageView.bounds;
    rect.size.width = UI_SCREEN_WIDTH;
    rect.size.height = rect.size.height * UI_SCREEN_WIDTH/ 320;
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = rect;
    layer.colors = @[(id)[UIColor whiteColor].CGColor, (id)[[UIColor whiteColor]colorWithAlphaComponent:0].CGColor];
    layer.locations = @[@0, @0.8];
    layer.startPoint = CGPointMake(0.5, 1);
    layer.endPoint = CGPointMake(0.5, 0);
    [self.contentImageView.layer addSublayer:layer];
    _maskLayer = layer;
    
    self.showUserCollectionView.delegate = self;
    self.showUserCollectionView.dataSource = self;
    [self.showUserCollectionView registerClass:[SBrandHeaderCollectionViewCell class] forCellWithReuseIdentifier:cellIndentifier];
    
    _lineLayer = [CALayer layer];
    _lineLayer.zPosition = 5;
    _lineLayer.frame = CGRectMake(0, 0, 60, 3);
    CGPoint position = _lineLayer.position;
    position.x = UI_SCREEN_WIDTH/ 4;
    _lineLayer.position = position;
    _lineLayer.backgroundColor = COLOR_C1.CGColor;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)setContentModel:(SBrandStoryDetailModel *)contentModel{
    if (!contentModel) {
        return;
    }
    _contentModel = contentModel;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.pic_img] placeholderImage:[UIImage imageNamed:@"pic_loading.png"]];
    self.brandNameLabel.text = contentModel.english_name;
//CMS商品款同步时创建(自有品牌) 需要隐藏？
    self.brandStoryLabel.text = [NSString stringWithFormat:@"    %@", contentModel.story];
    
    self.likeButton.selected = contentModel.is_love.boolValue;
    self.pageViewCountLabel.text = [NSString stringWithFormat:@"浏览%@", contentModel.look_num];
    
    [_arrowButton setTitle:[NSString stringWithFormat:@"%d", (int)contentModel.like_count.intValue] forState:UIControlStateNormal];
    CGRect frame = self.arrowButton.frame;
    frame.origin.x = MIN(UI_SCREEN_WIDTH - frame.size.width - 15, contentModel.like_user_list.count * 40 - 5 + self.showUserCollectionView.frame.origin.x);
    self.arrowButton.frame = frame;
    [self.showUserCollectionView reloadData];
}

#pragma mark collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModel.like_user_list.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30, 30);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SBrandHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.contentModel = _contentModel.like_user_list[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SBrandStoryUserModel *model = _contentModel.like_user_list[indexPath.row];
    if ([model.user_id isEqualToString:sns.ldap_uid]) {
        MBSettingMainViewController *controller = [MBSettingMainViewController new];
        [self.jumpController.navigationController pushViewController:controller animated:YES];
    }else{
        SMineViewController *vc = [[SMineViewController alloc]init];
        vc.person_id = model.user_id;
        [self.jumpController.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)likeButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(brandHeader:likeButton:)]) {
        [self.delegate brandHeader:self likeButton:sender];
    }
}

- (IBAction)moreBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(brandHeader:moreButton:)]) {
        [self.delegate brandHeader:self moreButton:sender];
    }
}
@end

@implementation SBrandHeaderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = self.bounds.size.height/ 2;
        
        [self addSubview:_imageView];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        _head_V_View =[[UIImageView alloc]initWithFrame:CGRectMake(_imageView.frame.origin.x+_imageView.frame.size.width-7,_imageView.frame.size.height+_imageView.frame.origin.y-13, 12, 12)];
        _head_V_View.layer.masksToBounds = YES;
        _head_V_View.layer.cornerRadius= _head_V_View.frame.size.height/2;
        [_head_V_View setImage:[UIImage imageNamed:@"peoplevip@2x"]];
        
        [self addSubview:_head_V_View];
        
    }
    return self;
}

- (void)setContentModel:(SBrandStoryUserModel *)contentModel{
    _contentModel = contentModel;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:contentModel.head_img] placeholderImage:[UIImage imageNamed:@"Unico/default_header_image.png"]];
    NSString *head_v_type=[NSString stringWithFormat:@"%@",_contentModel.head_v_type];
    
    switch ([head_v_type integerValue]) {
        case 0:
        {
            _head_V_View.hidden=YES;
        }
            break;
        case 1:
        {
            _head_V_View.hidden=NO;
            [_head_V_View setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [_head_V_View setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            _head_V_View.hidden=NO;
        }
            break;
        default:
            break;
    }
}

@end
