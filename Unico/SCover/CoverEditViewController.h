//
//  CoverEditViewController
//  封面编辑，这个应当不再使用
//  已经拆分几个环节
//  1 拍摄，选取 2 裁剪 3 
// 

#import <UIKit/UIKit.h>

@protocol CoverEditControllerDelegate;
@class SCRecordSession;

@interface CoverEditViewController : SBaseViewController
@property (nonatomic) UIImage* image;
@property (nonatomic) NSString* templateJSON;
@property (nonatomic) NSMutableArray* topicData;


- (id)initWithImage:(UIImage*)image;
- (id)initWithVideo:(SCRecordSession*)video;


- (void)editText;
- (void)editClipImage;
- (void)showShapeSelect;
- (void)showCustomLibray;

- (void)editAction:(UIButton*)sender;

- (void)publish:(NSString*)contentInfo;

- (UIImage*)coverImage;
- (NSString*)getTemplateJSON;

+ (CoverEditViewController*)sharedVC;
@property (unsafe_unretained) id<CoverEditControllerDelegate> coverDelegate;
@end


#pragma mark - CoverEditControllerDelegate 后面可以改成兼容block的方式，使用时候代码简洁点。
@protocol CoverEditControllerDelegate <NSObject>
@optional
// The picker does not dismiss itself; the client dismisses it in these callbacks.
// The delegate will receive one or the other, but not both, depending whether the user
// confirms or cancels.
- (void)coverEditController:(CoverEditViewController*)controller didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo;
- (void)coverEditController:(CoverEditViewController*)controller;
@end