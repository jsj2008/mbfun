//
//  NumTipView.m
//  FaFa
//
//  Created by mac on 13-2-1.
//
//

#import "NumTipView.h"
//#import "SNSCommObject.h"
#define BADGE_BACKGROUND_IMAGE_WIDTH 28

@implementation NumTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self innerInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self innerInit];
}

- (void)dealloc
{
//    [imageView release];
//    [numLabel release];
//    [super dealloc];
}

- (void)innerInit
{
    self.hidden = YES;
    self.backgroundColor=[UIColor clearColor];
    numColor = [UIColor whiteColor];
    
    imageView=[[UIImageView alloc] init];
    [self addSubview:imageView];
//    numLabel=[[UILabel alloc] init];
//    [self addSubview:numLabel];
}

-(int)getNumberValue
{
    return numValue;
}

-(int)getTipWidth
{
    return self.frame.size.width;
}
-(void)setNumberValue:(int)num Font:(int)font Color:(UIColor*)color
{
    
    numValue=num;
    numFont=font<16?16:font;
    numColor=color;
    
    if (num<=0)
    {
        [self setHidden:YES];
        return;
    }
    
    [self setHidden:NO];
    
    NSString *numString=[NSString stringWithFormat:@"%d",numValue];
   
    fontRectSize = [numString sizeWithFont:[UIFont boldSystemFontOfSize:numFont] constrainedToSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    
    float digitFontWidth=fontRectSize.width/[numString length];
    numSplit=(BADGE_BACKGROUND_IMAGE_WIDTH-digitFontWidth)/2;

    float h1=BADGE_BACKGROUND_IMAGE_WIDTH;
    float w1=fontRectSize.width+2*numSplit;
    w1=h1>w1?h1:w1;
//    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, w1, h1);

	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGPoint point;
//    CGFloat actualFontSize;

    NSString *numString=[NSString stringWithFormat:@"%d",numValue];
    
    UIImage *backImage1 = [UIImage imageNamed:@"sns_conv_num.png"];
    
    UIImage *backImage = nil;
    backImage = [backImage1 stretchableImageWithLeftCapWidth:backImage1.size.width/2 topCapHeight:backImage1.size.height];

//    int h=backImage1.size.height;
//    if (backImage1.size.height<BADGE_BACKGROUND_IMAGE_WIDTH)
//        h=BADGE_BACKGROUND_IMAGE_WIDTH;
    
    imageView.frame=CGRectMake(0, 0, 8,8);
    imageView.image=backImage;
//    imageView.backgroundColor=[UIColor blueColor];
    
    point = CGPointMake( (self.frame.size.width-fontRectSize.width)/2, (self.frame.size.height-fontRectSize.height)/2-3);

    numLabel.frame=CGRectMake(point.x,point.y,fontRectSize.width,fontRectSize.height);
    numLabel.font=[UIFont boldSystemFontOfSize:numFont];
    numLabel.textColor=numColor;
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.text=[NSString stringWithFormat:@"%@",numString];
}


@end
