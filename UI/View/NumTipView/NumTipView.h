//
//  NumTipView.h
//  FaFa
//
//  Created by mac on 13-2-1.
//
//

#import <UIKit/UIKit.h>

@interface NumTipView : UIView
{
    int numValue;
    int numFont;
    CGSize fontRectSize;
    UIColor *numColor;
    int numSplit;
    
    UIImageView *imageView;//not drawrect
    UILabel *numLabel;//not drawrect
}

-(void)setNumberValue:(int)num Font:(int)font Color:(UIColor*)color;
-(int)getNumberValue;
-(int)getTipWidth;

@end
