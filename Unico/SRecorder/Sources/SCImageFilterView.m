//
//  SCImageFilterView.m
//  Wefafa
//
//  Created by Ryan on 15/5/18.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

//
//  SCFilterSwitcherView.m
//  SCRecorderExamples
//
//  Created by Simon CORSIN on 29/05/14.
//
//

#import "SCImageFilterView.h"
#import "CIImageRendererUtils.h"
#import "SCSampleBufferHolder.h"
#import "SCFilterSelectorViewInternal.h"

@interface SCImageFilterView()
{
    CGFloat _filterGroupIndexRatio;
    UIView *masker1;
    UIView *masker2;
}

@end

@implementation SCImageFilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (void)dealloc
{
    
}

- (void)commonInit
{
    [super commonInit];
    
    masker1 = [UIView new];
    masker2 = [UIView new];
    
    masker1.backgroundColor = [UIColor blackColor];
    
    masker2.backgroundColor = [UIColor blackColor];
    
    [self addSubview:masker1];
    [self addSubview:masker2];
    
    self.backgroundColor = [UIColor blackColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)render:(CIImage *)image toContext:(CIContext *)context inRect:(CGRect)rect
{
    
    CGRect extent = [image extent];
    
    id obj = [self.filters objectAtIndex:0];
    CIImage *imageToUse = image;
    
    if ([obj isKindOfClass:[SCFilter class]])
    {
        imageToUse = [((SCFilter *)obj) imageByProcessingImage:imageToUse];
    }
    
    CGRect outputRect = [CIImageRendererUtils processRect:rect withImageSize:extent.size contentScale:self.contentScaleFactor contentMode:self.contentMode];
    
    [context drawImage:imageToUse inRect:outputRect fromRect:extent];
    
    [self tempMasker:outputRect];
}

- (void)setFilters:(NSArray *)filters
{
    [super setFilters:filters];
    
    [self setSelectedFilter:filters[0]];
}

- (void)refresh
{
    [self setNeedsDisplay];
}



// FIXME : temp fix bug here
- (void)tempMasker:(CGRect)rect
{
    if (rect.origin.y<=0)
    {
        return;
    }
    
    CGSize size = self.frame.size;
    float rate = (size.width/rect.size.width);
    float width = size.width;
    float height = rect.size.height * rate;
    CGRect frame1 = CGRectMake(0, 0, width, rect.origin.y*rate);
    CGRect frame2 = CGRectMake(0, rect.origin.y*rate + height, width, size.height);
    masker1.frame = frame1;
    masker2.frame = frame2;
}

@end

