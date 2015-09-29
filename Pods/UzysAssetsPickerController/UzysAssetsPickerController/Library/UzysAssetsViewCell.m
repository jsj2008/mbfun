//
//  UzysAssetsViewCell.m
//  UzysAssetsPickerController
//
//  Created by Uzysjung on 2014. 2. 12..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//

#import "UzysAssetsViewCell.h"
#import "UzysAppearanceConfig.h"

@interface UzysAssetsViewCell()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *videoImage;

@property (strong, readwrite, nonatomic)UIImageView *checkImageView;

@end
@implementation UzysAssetsViewCell

static UIFont *videoTimeFont = nil;

static CGFloat videoTimeHeight;
static UIImage *videoIcon;
static UIColor *videoTitleColor;
static UIImage *checkedIcon;
static UIImage *uncheckedIcon;
static UIColor *selectedColor;
static CGFloat thumnailLength;
+ (void)initialize
{
    UzysAppearanceConfig *appearanceConfig = [UzysAppearanceConfig sharedConfig];
    
    videoTitleColor      = [UIColor whiteColor];
    videoTimeFont       = [UIFont systemFontOfSize:12];
    videoTimeHeight     = 20.0f;
    videoIcon       = [UIImage imageNamed:@"UzysAssetPickerController.bundle/uzysAP_ico_assets_video"];
    
    //暂时去掉复选框图片、因为现在是单选
    checkedIcon     = nil;//[UIImage Uzys_imageNamed:appearanceConfig.assetSelectedImageName];
    uncheckedIcon   = nil;//[UIImage Uzys_imageNamed:appearanceConfig.assetDeselectedImageName];
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
    
    if(IS_IPHONE_6_IOS8)
    {
        thumnailLength = kThumbnailLength_IPHONE6;
    }
    else if(IS_IPHONE_6P_IOS8)
    {
        thumnailLength = kThumbnailLength_IPHONE6P;
    }
    else
    {
        thumnailLength = kThumbnailLength;
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.opaque = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
    }
    return self;
}
- (void)applyData:(ALAsset *)asset
{
    if (asset == nil)
    {
        self.image  = nil;
        self.asset  = nil;
        self.type = nil;
        self.title = nil;
    }
    else
    {
        self.asset  = asset;
        self.image  = [UIImage imageWithCGImage:asset.thumbnail];
        self.type   = [asset valueForProperty:ALAssetPropertyType];
        self.title  = [UzysAssetsViewCell getTimeStringOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    }
    
    [self setNeedsDisplay];
}

- (void)tap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (self.delegate != nil)//支持多选
        {
            if ([self.delegate respondsToSelector:@selector(uzysAssetsViewCellClick:)])
            {
                [self.delegate performSelector:@selector(uzysAssetsViewCellClick:) withObject:self];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (self.selected)
    {
        if (self.checkImageView == nil)
        {
            self.checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/zhaopianduoxuan"]];
            float checkImageViewWidth = 24;
            float checkImageViewHeight = 24;
            self.checkImageView.frame = CGRectMake(self.bounds.size.width-checkImageViewWidth, self.bounds.size.height-checkImageViewHeight, checkImageViewWidth, checkImageViewHeight);
        }
        
        [self addSubview:self.checkImageView];
    }
    else
    {
        [self.checkImageView removeFromSuperview];
    }
}

/*- (void)setSelected:(BOOL)selected
 {
 BOOL  backupSelected = self.selected;
 
 [super setSelected:selected];
 [self setNeedsDisplay];
 
 if(selected)
 {
 [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
 self.transform = CGAffineTransformMakeScale(0.97, 0.97);
 } completion:^(BOOL finished) {
 [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
 self.transform = CGAffineTransformIdentity;
 } completion:^(BOOL finished) {
 
 }];
 }];
 }
 else
 {
 [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
 self.transform = CGAffineTransformMakeScale(1.03, 1.03);
 } completion:^(BOOL finished) {
 [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
 self.transform = CGAffineTransformIdentity;
 } completion:^(BOOL finished) {
 
 }];
 }];
 
 }
 
 
 if (backupSelected != selected && self.delegate != nil)
 {
 if ([self.delegate respondsToSelector:@selector(uzysAssetsViewCellSelectedStateChanged:)])
 {
 [self.delegate performSelector:@selector(uzysAssetsViewCellSelectedStateChanged:) withObject:self];
 }
 }
 
 if (self.delegate != nil)//支持多选
 {
 if ([self.delegate respondsToSelector:@selector(uzysAssetsViewCellSelectedStateChanged:)])
 {
 [self.delegate performSelector:@selector(uzysAssetsViewCellSelectedStateChanged:) withObject:self];
 }
 }
 }*/


- (void)drawRect:(CGRect)rect
{
    // Image
    [self.image drawInRect:CGRectMake(0, 0, thumnailLength, thumnailLength)];
    
    // Video title
    if ([self.type isEqual:ALAssetTypeVideo])
    {
        // Create a gradient from transparent to black
        CGFloat colors [] =
        {
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.8,
            0.0, 0.0, 0.0, 1.0
        };
        
        CGFloat locations [] = {0.0, 0.75, 1.0};
        
        CGColorSpaceRef baseSpace   = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient      = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
        CGContextRef context    = UIGraphicsGetCurrentContext();
        
        CGFloat height          = rect.size.height;
        CGPoint startPoint      = CGPointMake(CGRectGetMidX(rect), height - videoTimeHeight);
        CGPoint endPoint        = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
        
        NSDictionary *attributes = @{NSFontAttributeName:videoTimeFont,NSForegroundColorAttributeName:videoTitleColor};
        CGSize titleSize        = [self.title sizeWithAttributes:attributes];
        [self.title drawInRect:CGRectMake(rect.size.width - (NSInteger)titleSize.width - 2 , startPoint.y + (videoTimeHeight - 12) / 2, thumnailLength, height) withAttributes:attributes];
        
        [videoIcon drawAtPoint:CGPointMake(2, startPoint.y + (videoTimeHeight - videoIcon.size.height) / 2)];
        
    }
    
    /*  if (self.selected)
     {
     CGContextRef context    = UIGraphicsGetCurrentContext();
     CGContextSetFillColorWithColor(context, selectedColor.CGColor);
     CGContextFillRect(context, rect);
     [checkedIcon drawAtPoint:CGPointMake(CGRectGetMaxX(rect) - checkedIcon.size.width -2, CGRectGetMinY(rect)+2)];
     }
     else
     {
     [uncheckedIcon drawAtPoint:CGPointMake(CGRectGetMaxX(rect) - uncheckedIcon.size.width -2, CGRectGetMinY(rect)+2)];
     
     }*/
}


+ (NSString *)getTimeStringOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *dateRef = [[NSDate alloc] init];
    NSDate *dateNow = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:dateRef];
    
    unsigned int uFlags =
    NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit |
    NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    
    NSDateComponents *components = [calendar components:uFlags
                                               fromDate:dateRef
                                                 toDate:dateNow
                                                options:0];
    NSString *retTimeInterval;
    if (components.hour > 0)
    {
        retTimeInterval = [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)components.second];
    }
    
    else
    {
        retTimeInterval = [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)components.second];
    }
    return retTimeInterval;
}


@end
