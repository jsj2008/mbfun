//
//  TemplateCollectionCell.m
//  Wefafa
//
//  Created by Miaoz on 15/3/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "TemplateCollectionCell.h"
#import "TemplateElement.h"
#import "Globle.h"
@implementation TemplateCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TemplateCollectionCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        CGFloat borderWidth = 0.25f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
        self.layer.borderWidth = borderWidth;
    }
    return self;
}

-(void)setTemplateElement:(TemplateElement *)templateElement{
    _templateElement = templateElement;
    
    NSString *imageurl =[CommMBBusiness changeStringWithurlString:templateElement.templateInfo.pictureUrl size:3];
    
    NSString *url = [imageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImageFromURLTOCache([NSURL URLWithString:url], url, ^(UIImage *image) {
        _imageView.image = image;
    }, ^{
       _imageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    });
}

- (void)awakeFromNib {
    // Initialization code
}


@end
