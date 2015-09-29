//
//  DataBase.h
//  newdesigner
//
//  Created by Miaoz on 14-9-24.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DraftVO;
@class GesturesView;

@interface DataBase : NSObject
+ (DataBase *)sharedDataBaseManager;

//插入、更新数据photovo
- (void)addAndupdatePothVOSourceWithGesturesImageViewArray:(id)sender withGestureView:(GesturesView *)_gesturesView;
////查询photovo根据标示符查询
-(NSArray *)queryPhotoVObysavetag:(NSString *)savetag;
//查询photovo
- (NSArray *)queryPhotoArraybyDrftvo:(id)sender;
//删除根据driftid删除
- (void)deletephotoVObydraftid:(id)sender;
//添加或更新draftvo
-(void)addAndUpdateDraftVOwithGesturesImageView:(id)sender;
//查询全部DraftVO
- (NSArray *)queryDraftVOArray:(id)sender;
//根据savetag查询DraftVO
-(NSArray *)queryDraftVObysavetag:(NSString *)savetag;
//删除相对应的DraftVO
-(void)deleteDraftVObydraftid:(NSString *)draftid;

//根据savetag 删除photovo
- (void)deletephotoVObydraftsavetag:(NSString *)savetag;
//删除相对应的DraftVO根据savetag
-(void)deleteDraftVObydraftsavetag:(NSString *)savetag;
//通过draftvo添加更新
-(void)addAndUpdateDraftVO:(DraftVO *)draftvo;
//插入、更新数据photovo根据photoarray
- (void)addAndupdatePothVOSourceWithphotoArray:(id)sender;

//根据transform 删除photovo
- (void)deletephotoVObydtransform:(NSString *)transform;
//查询photovo根据dratvoid
- (NSArray *)queryPhotoArraybyDrftvoid:(NSString *)dratvoid;
@end
