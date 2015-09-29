//
//  GuideViewController
//  MCPagerView
//
//  Created by wave on 15/9/17.
//
//

#import <UIKit/UIKit.h>
#import "MCPagerView.h"
@class WaveScrollView;

@interface GuideViewController : UIViewController <UIScrollViewDelegate, MCPagerViewDelegate>
@property (nonatomic, strong) void(^skipBlock)();
@end
