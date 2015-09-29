//
//  CommunityAttentionHeadView.h
//  Wefafa
//
//  Created by wave on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBOtherUserInfoModel;
typedef NS_ENUM(NSInteger, Arrowstate) {
    arrowUP = 0, //箭头向上
    arrowDOWN
};

typedef void(^InsertBlock)(Arrowstate state);

@interface CommunityAttentionHeadView : UIView
@property (nonatomic, strong) InsertBlock insertBlock;
@property (nonatomic, assign, readonly) Arrowstate arrowState;
@end
