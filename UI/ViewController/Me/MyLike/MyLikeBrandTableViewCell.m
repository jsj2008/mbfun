//
//  MyLikeBrandTableViewCell.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "MyLikeBrandTableViewCell.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SBrandStoryDetailModel.h"
#import "SProductDetailViewController.h"
static NSString *cellIdentifier = @"SBrandListShowImageCollectionViewCellIdentifier";
//static NSString *brandDetailCell= @"SBrandListShowImageCollectionViewCellIdentifier";
@implementation MyLikeBrandTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _brandName.textColor=[UIColor blackColor];
    _brandName.font=FONT_T1;
    _brandName.backgroundColor=[UIColor clearColor];
    _descriptionLabel.backgroundColor=[UIColor clearColor];
    _photoNumLabel.backgroundColor=[UIColor clearColor];
    _descriptionLabel.font=FONT_t4;
    _descriptionLabel.textColor=[Utils HexColor:0xf2f2f2 Alpha:1];
    _photoNumLabel.textColor=[Utils HexColor:0xf2f2f2 Alpha:1];
    _photoNumLabel.font=FONT_t4;
    _brandHeadImgV.layer.cornerRadius= _brandHeadImgV.frame.size.width/ 2;
;
    _brandHeadImgV.layer.borderWidth = 1.0;
    _brandHeadImgV.layer.borderColor = [Utils HexColor:0xe2e2e2 Alpha:1].CGColor;
    _brandHeadImgV.layer.masksToBounds = YES;
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    [_photoCollectionView registerClass:[SBrandListShowImageCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
}
-(void)setModel:(SBrandStoryDetailModel *)model
{
    _model=model;
    if(!model.itemList||model.itemList.count==0){
        _photoCollectionView.hidden=YES;
    }else{
        _photoCollectionView.hidden=NO;
    }
    _brandName.text=[Utils getSNSString:_model.english_name];
    [_brandHeadImgV sd_setImageWithURL:[NSURL URLWithString:_model.logo_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    _descriptionLabel.text=@"abcabc。";
    
    [_photoCollectionView reloadData];
    
    
}
#pragma mark - collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.itemList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SBrandListShowImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    SBrandListContentModel *brandModel = _model.itemList[indexPath.row];
    cell.contentModel = brandModel;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
   
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //单品did
    SBrandListContentModel *brandModel = _model.itemList[indexPath.row];
//    NSString *  product_sys_code=@"";
    
       
    //跳单品
    SProductDetailViewController * sproductDVC=[[SProductDetailViewController alloc]init];
    sproductDVC.productID=[NSString stringWithFormat:@"%@",brandModel.product_sys_code];
     [self.parentVc.navigationController pushViewController:sproductDVC animated:YES];
}
@end

@implementation SBrandListShowImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        _showImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _showImageView.layer.masksToBounds = YES;
        _showImageView.layer.borderWidth=1;
        _showImageView.layer.borderColor=COLOR_C4.CGColor;
        _showImageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        [self addSubview:_showImageView];
    }
    return self;
}

- (void)setContentModel:(SBrandListContentModel *)contentModel{
    _contentModel = contentModel;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_contentModel.product_url]];
}

@end

