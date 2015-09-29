//
//  ClothingCategoryTabBarCell.m
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ClothingCategoryTabBarCell.h"
#import "UIImageView+WebCache.h"
#import "SUtilityTool.h"


@interface ClothingCategoryTabBarCell ()
{
    NSString *_clothingCategoryId;
    
    UIImageView  *_categoryImageView;
    NSURL        *_categoryImageURL;
    
    UILabel      *_categoryNamelabel;
    UIImageView  *_categoryNamelabelBackgroundImageView;
    
    NSString *_tid;
    
    
    BOOL         _selected;
}

@end




@implementation ClothingCategoryTabBarCell


- (void)setCategoryImageURL:(NSURL *)categoryImageURL
{
    if (categoryImageURL == nil || [categoryImageURL isKindOfClass:[NSNull class]]
        || [[categoryImageURL description] length] == 0)
    {
        _categoryImageURL = nil;
    }
    else
    {
        _categoryImageURL = categoryImageURL;
        
        [_categoryImageView sd_setImageWithURL:_categoryImageURL isLoadThumbnail:NO];
    }
}

- (void)setCategoryName:(NSString *)categoryName
{
    _categoryNamelabel.text = categoryName;
    
    [self layoutSubviews];
}

- (NSString *)categoryName
{
    return _categoryNamelabel.text;
}

- (void)setSelected:(BOOL)selected
{
    if (_selected == selected)
    {
        return;
    }
    
    _selected = selected;
    
    if (_selected)
    {
        self.layer.borderColor = [UIColor colorWithRed:0xfe/255.0 green:0xdc/255.0 blue:0x32/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 2;
        
        UIImage *labelBackgroundImage = [UIImage imageNamed:@"Unico/categoryNamelabelBackgroundImageSelected"];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(15, 15, 15, 15);
        _categoryNamelabelBackgroundImageView.image = [labelBackgroundImage resizableImageWithCapInsets:insets];
        
        _categoryNamelabel.textColor = [UIColor colorWithRed: 0x3b/255.0 green:0x3b/255.0 blue:0x3b/255.0 alpha:1];
        _categoryNamelabel.backgroundColor = COLOR_C1;
        _categoryNamelabel.alpha = 1;
    }
    else
    {
        self.layer.borderColor = [UIColor colorWithRed:0xd9/255.0 green:0xd9/255.0 blue:0xd9/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 0.5;
        
        UIImage *labelBackgroundImage = [UIImage imageNamed:@"Unico/categoryNamelabelBackgroundImage"];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(15, 15, 15, 15);
        _categoryNamelabelBackgroundImageView.image = [labelBackgroundImage resizableImageWithCapInsets:insets];

        _categoryNamelabel.textColor = [UIColor whiteColor];
        _categoryNamelabel.backgroundColor = COLOR_C6;
        _categoryNamelabel.alpha = 0.9;
    }
}

- (void)initSubviews
{
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRed:0xd9/255.0 green:0xd9/255.0 blue:0xd9/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 0.5;
    
    _categoryImageView = [[UIImageView alloc] init];
    _categoryImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_categoryImageView];
    
    _categoryNamelabel = [[UILabel alloc] init];
    _categoryNamelabel.textAlignment = NSTextAlignmentCenter;
    _categoryNamelabel.textColor = [UIColor whiteColor];
    _categoryNamelabel.backgroundColor = COLOR_C6;
    _categoryNamelabel.alpha = 0.9;
    _categoryNamelabel.font = FONT_T8; //[UIFont systemFontOfSize:14];
    [self addSubview:_categoryNamelabel];
    
//    _categoryNamelabelBackgroundImageView = [[UIImageView alloc] init];
    
    UIImage *labelBackgroundImage = [UIImage imageNamed:@"Unico/categoryNamelabelBackgroundImage"];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(15, 15, 15, 15);
    _categoryNamelabelBackgroundImageView.image = [labelBackgroundImage resizableImageWithCapInsets:insets];
    
    [self insertSubview:_categoryNamelabelBackgroundImageView belowSubview:_categoryNamelabel];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self initSubviews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self initSubviews];
        
        [self layoutSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _categoryImageView.frame = self.bounds;
    
    if (_categoryNamelabel.text != nil)
    {
//        CGSize labelSize = [_categoryNamelabel.text sizeWithAttributes:@{NSFontAttributeName : _categoryNamelabel.font}];
//        _categoryNamelabel.frame = CGRectMake(0, self.height-20, labelSize.width+10, 20);
        _categoryNamelabel.frame = CGRectMake(0, self.height-20, self.width, 20);
        _categoryNamelabelBackgroundImageView.frame = _categoryNamelabel.frame;
    }
}

@end

