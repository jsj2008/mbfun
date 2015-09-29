//
//  FaFaScrollView.m
//  FaFa
//
//  Created by mac on 13-5-1.
//
//

#import "FaFaScrollView.h"

@implementation FaFaScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(view)];
    if ([strClassName isEqualToString:@"UIPickerTable"])
    {
        return NO;
    }
    return YES;
}
 

@end
