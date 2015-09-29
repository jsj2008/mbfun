//
//  CoverStickerView.h
//  StoryCam
//
//  Created by Ryan on 15/4/2.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import <UIKit/UIKit.h>

// 3种类型。
typedef enum CoverStickerType {
    CoverStickerTypeText = 0,
    CoverStickerTypeImage,
    CoverStickerTypeShape,
    CoverStickerTypeSVG, // TODO ,use pocket svg now
    CoverStickerTypeTag, // Tag
    CoverStickerTypeBackground // only use to edit bg
} CoverStickerType;

@protocol CoverStickerViewDelegate;

@interface CoverStickerView : UIView <UIGestureRecognizerDelegate> {
    UIImageView* resizeView;
    UIImageView* rotateView;
    UIImageView* closeView;

    BOOL _isShowingEditingHandles;
    BOOL _flip;
}

@property (assign, nonatomic) UIView* contentView;
@property (unsafe_unretained) id<CoverStickerViewDelegate> delegate;

@property(assign, readwrite, nonatomic) CGSize moveSize;

@property(assign, readwrite, nonatomic) BOOL flip;

// TODO: 2种阴影样式，软，硬
@property (nonatomic, assign) BOOL showContentShadow; //Default is NO.
@property (nonatomic, assign) BOOL enableClose; // default is YES. if set to NO, user can't delete the view
@property (nonatomic, assign) BOOL enableResize; // default is YES. if set to NO, user can't Resize the view
@property (nonatomic, assign) BOOL enableRotate; // default is YES. if set to NO, user can't Rotate the view
@property (nonatomic) NSString* text;
@property (nonatomic) NSString* shape;
@property (nonatomic) NSString* tagName;
@property (nonatomic) NSString* tagKey;
@property (nonatomic) CoverTagType tagType;
@property (nonatomic) UIColor* textColor;
@property (nonatomic, assign) BOOL textDirection; //Default is NO.
@property (nonatomic) UIFont* font;
@property (nonatomic) float contentAlpha;
@property (nonatomic) float textVerticalPadding;
@property (nonatomic) float textHorizontalPadding;

// 锁定操作，未完成，锁定后其他操作都无用，只能解锁。方便模板编辑和定型。
@property (nonatomic, assign) BOOL lock;
@property (nonatomic, assign) CoverStickerType type;

//Give call's to refresh. If SuperView is UIScrollView. And it changes it's zoom scale.
- (void)refresh;
- (void)setImage:(UIImage*)image;
- (void)setSVG:(NSString*)fileName;
- (void)setTagName:(NSString*)tag withKey:(NSString*)key withType:(CoverTagType)type;
- (void)hideEditingHandles;
- (void)showEditingHandles;

// 获得不带\n的文字
- (NSString*)plainText;
// 编辑器设置
- (void)setPlainText:(NSString*)text;
- (NSDictionary*)getInfo;
- (void)setInfo:(NSDictionary*)info;
- (id)initWithInfo:(NSDictionary*)info;

+ (CoverStickerView*)currentEditView;

//调整中心，避免出现在图片或视频区域之外
- (CGPoint)adjustCenter:(CGPoint)center;

@end

@protocol CoverStickerViewDelegate <NSObject>
@optional
- (void)stickerViewDidBeginEditing:(CoverStickerView*)sticker;
- (void)stickerViewDidChangeEditing:(CoverStickerView*)sticker;
- (void)stickerViewDidEndEditing:(CoverStickerView*)sticker;

- (void)stickerViewDidClose:(CoverStickerView*)sticker;

- (void)stickerViewDidShowEditingHandles:(CoverStickerView*)sticker;
- (void)stickerViewDidHideEditingHandles:(CoverStickerView*)sticker;
@end
