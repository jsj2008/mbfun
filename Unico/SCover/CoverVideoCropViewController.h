//
//  CoverVideoCropViewController
//  视频编辑
//   这个文件是从CoverEditViewController中复制过来，安装Ryan的意思，现在独立出来专门给Video使用

#import <UIKit/UIKit.h>

@class SCRecordSession;

@interface CoverVideoCropViewController : SBaseViewController<UIScrollViewDelegate>


@property(assign, readwrite, nonatomic)BOOL rotate;//是否考虑旋转

- (id)initWithVideo:(SCRecordSession*)video;



@end
