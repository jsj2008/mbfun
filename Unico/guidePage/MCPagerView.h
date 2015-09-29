//
//  MCPagerView.h
//  MCPagerView
//
//  Created by wave on 15/9/17.
//
//

#import <UIKit/UIKit.h>

#define MCPAGERVIEW_DID_UPDATE_NOTIFICATION @"MCPageViewDidUpdate"

@protocol MCPagerViewDelegate;

@interface MCPagerView : UIView

- (void)setImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage forKey:(NSString *)key;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,readonly) NSInteger numberOfPages;
@property (nonatomic,copy) NSString *pattern;
@property (nonatomic,assign) id<MCPagerViewDelegate>delegate;

@property (nonatomic, strong) void(^SkipBlock)();

@end

@protocol MCPagerViewDelegate <NSObject>

@optional
- (BOOL)pageView:(MCPagerView *)pageView shouldUpdateToPage:(NSInteger)newPage;
- (void)pageView:(MCPagerView *)pageView didUpdateToPage:(NSInteger)newPage;

@end