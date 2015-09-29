//
//  BrandListCollectionCell.m
//  Wefafa
//
//  Created by lizhaoxiang on 15/5/26.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "BrandListCollectionCell.h"
#import "SUtilityTool.h"

@implementation BrandListCollectionCell
{
    UIImageView * brandLogo;

}
-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView * bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-0.25, frame.size.height-0.5)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        brandLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-0.25, frame.size.height-0.5)];
        brandLogo.contentMode = UIViewContentModeScaleAspectFit;
        [bgView addSubview:brandLogo];
        [self.contentView addSubview:bgView];
    }
    
    return self;
}
-(void)updateBrandListCellModel:(BrandListCellModel*)model
{
    NSString * imgUrl = model.logoImg;
    [brandLogo sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed: DEFAULT_LOADING_IMAGE ]];
    
}
@end
