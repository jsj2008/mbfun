//
//  ParallaxView.h
//  MCPagerView
//
//  Created by wave on 15/9/15.
//
//

#import <UIKit/UIKit.h>

@interface ParallaxView : UIView
/**
 *  skip the Guide page to app
 */
@property (nonatomic, strong, readwrite) void (^skipBtnDidClickedBlock) ();
@property (nonatomic, strong) NSArray *imgArray;
/**
 *  @param frame: the whole paging view’s frame(UIScrollView contentSize)
 *  @param array: the array containing images
 */
- (instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray*)imgArray;
- (void)updataUI:(CGPoint)point;

@end
