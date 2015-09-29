//
//  uzysGroupViewCell.m
//  UzysAssetsPickerController
//
//  Created by Uzysjung on 2014. 2. 13..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//
#import "UzysAssetsPickerController_Configuration.h"
#import "UzysGroupViewCell.h"
#import "UzysAppearanceConfig.h"

@interface UzysGroupViewCell()
{
    UIImageView *_posterImageView1;
    UIImageView *_posterImageView2;
    UIImageView *_posterImageView3;
}

@end


@implementation UzysGroupViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:19];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        //UzysAppearanceConfig *appearanceConfig = [UzysAppearanceConfig sharedConfig];
        //self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage Uzys_imageNamed:appearanceConfig.assetsGroupSelectedImageName]];
        self.selectedBackgroundView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _posterImageView1 = [[UIImageView alloc] init];
        _posterImageView1.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_posterImageView1];
        
        _posterImageView2 = [[UIImageView alloc] init];
        _posterImageView2.contentMode = UIViewContentModeScaleToFill;
        [self.contentView insertSubview:_posterImageView2 belowSubview:_posterImageView1];
        
        _posterImageView3 = [[UIImageView alloc] init];
        _posterImageView3.contentMode = UIViewContentModeScaleToFill;
        [self.contentView insertSubview:_posterImageView3 belowSubview:_posterImageView2];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _posterImageView1.frame = CGRectMake(6, 10, self.contentView.bounds.size.height-10, self.contentView.bounds.size.height-10);
    
    _posterImageView2.frame = CGRectMake(_posterImageView1.frame.origin.x + 3, _posterImageView1.frame.origin.y-3, _posterImageView1.frame.size.width-6, _posterImageView1.frame.size.height-3);
    
    _posterImageView3.frame = CGRectMake(_posterImageView1.frame.origin.x + 6, _posterImageView1.frame.origin.y-6, _posterImageView1.frame.size.width-12, _posterImageView1.frame.size.height-6);
    
    self.textLabel.frame = CGRectMake(_posterImageView1.frame.origin.x + _posterImageView1.frame.size.width + 10, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected)
    {
        //self.accessoryView.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        //self.accessoryView.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}


- (void)applyData:(ALAssetsGroup *)assetsGroup
{
    self.assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    
    //size_t height               = CGImageGetHeight(posterImage);
    //float scale                 = height / kThumbnailLength;
    
    //self.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    //_posterImageView1.image = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];

    _posterImageView1.image = [UIImage imageWithCGImage:posterImage];
    
    if (assetsGroup.numberOfAssets >= 2)
    {
        [self.assetsGroup enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:1] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result != nil)
            {
                _posterImageView2.image = [UIImage imageWithCGImage:result.thumbnail];
            }
        }];
    }
    
    if (assetsGroup.numberOfAssets >= 3)
    {
        [self.assetsGroup enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:2] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result != nil)
            {
                _posterImageView3.image = [UIImage imageWithCGImage:result.thumbnail];
            }
        }];
    }
    
    self.textLabel.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    //self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}
@end
