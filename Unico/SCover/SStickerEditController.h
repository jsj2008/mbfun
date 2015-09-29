//
//  CoverEditViewController
//  封面编辑
// 

#import <UIKit/UIKit.h>





@class SCRecordSession;

@interface SStickerEditController : SBaseViewController

@property (assign, readwrite, nonatomic)float heightWidthRatioForVideo;

- (id)initWithImage:(UIImage*)image;
- (id)initWithVideo:(SCRecordSession*)video;


@end

