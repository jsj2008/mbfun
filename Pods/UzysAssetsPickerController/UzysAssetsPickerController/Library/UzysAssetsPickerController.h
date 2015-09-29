//
//  UzysAssetsPickerController.h
//  UzysAssetsPickerController
//
//  Created by Uzysjung on 2014. 2. 12..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UzysAssetsPickerController_Configuration.h"
#import "UzysAppearanceConfig.h"

#import "UzysAssetsViewCell.h"
#import "SCRecorder.h"




/**
 *   多选的UI风格
 */
typedef NS_ENUM(NSInteger, AssetsPickerMulSelectionStyle)
{
    AssetsPickerMulSelectionSimpleStyle = 0,//多选时，cell带选中与否的勾
    AssetsPickerMulSelectionMakingMVStyle,  //当时为了做照片制作MV使用的风格
};



@class UzysCameraViewCell;

@protocol UzysCameraViewCellDelegate <NSObject>

- (void)uzysCameraViewCellClick:(UzysCameraViewCell *)cell;


@end

@interface UzysCameraViewCell : UICollectionViewCell
{
    SCRecorder *_recorder;
}
@property(weak, readwrite, nonatomic)id<UzysCameraViewCellDelegate>delegate;

@end


@class UzysAssetsPickerController;

@protocol UzysAssetsPickerControllerDelegate<NSObject>

@optional

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets;

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssetsWithURLArray:(NSArray *)urlArray;

- (void)uzysAssetsPickerControllerDidPickingCamera:(UzysAssetsPickerController *)picker;
- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker;
- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker;
@end

@interface UzysAssetsPickerController : UIViewController<UzysAssetsViewCellDelegate, UIAlertViewDelegate, UzysCameraViewCellDelegate>

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionVideo;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionPhoto;


//--------------------------------------------------------------------
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionMedia;
@property (nonatomic, assign) NSInteger miniimumNumberOfSelectionMedia;

@property (assign, readwrite, nonatomic) BOOL showCameraCell;
@property (assign, readwrite, nonatomic) AssetsPickerMulSelectionStyle mulSelectionStyle;



@property (nonatomic, assign, readwrite) BOOL cellAnimated;

@property (nonatomic, weak) id <UzysAssetsPickerControllerDelegate> delegate;

+ (ALAssetsLibrary *)defaultAssetsLibrary;
/**
 *  setup the appearance, including the all the properties in UzysAppearanceConfig, check UzysAppearanceConfig.h out for details.
 *
 *  @param config UzysAppearanceConfig instance.
 */
+ (void)setUpAppearanceConfig:(UzysAppearanceConfig *)config;

@end
