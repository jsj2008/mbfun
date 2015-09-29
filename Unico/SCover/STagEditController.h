//
//  STagEditController
//  图片和视频标签编辑环节。
// 

#import <UIKit/UIKit.h>

@class SCVideoPlayerViewController;
@class SCImageDisplayerViewController;

@class SCRecordSession;

@interface STagEditController : SBaseViewController
{
    SCVideoPlayerViewController *playerVC;
    SCImageDisplayerViewController *photoVC;
    
    SCRecordSession *_recordSession;
}

@property(strong, readonly, nonatomic)SCVideoPlayerViewController *playerVC;
@property(strong, readonly, nonatomic)SCImageDisplayerViewController *photoVC;

@property(strong, readonly, nonatomic)SCRecordSession *recordSession;

// 背景图片
@property (nonatomic) UIImage* image;
// 贴纸信息
@property (nonatomic) UIImage* stickerLayerImage;




- (id)initWithImage:(UIImage*)image;
- (id)initWithVideo:(SCRecordSession*)video;
- (id)initWithVideo:(SCRecordSession*)video withFilterIndex:(int)filterIndex;

- (NSArray*)saveTemplate:(UIImage*)image;


- (void)publish:(NSString*)contentInfo withTag:(NSString*)tag;

@end

