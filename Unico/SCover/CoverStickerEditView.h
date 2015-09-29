//
//  CoverStickerEditView.h
//
//
//  Created by Ryan on 15/4/4.
//  这个是选中贴纸对象时候，显示的编辑菜单。
// 
//

#import <UIKit/UIKit.h>
#import "CoverStickerView.h"

@interface CoverStickerEditView : UIView
- (void)top;
- (void)bottom;
- (void)moveCenter;
- (void)setType:(CoverStickerType)type;
@end
