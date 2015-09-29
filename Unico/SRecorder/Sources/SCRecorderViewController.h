//
//  VRViewController.h
//  VideoRecorder
//
//  Created by Simon CORSIN on 8/3/13.
//  Copyright (c) 2013 rFlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"



/**
 *   相机模式
 */
typedef NS_ENUM(NSInteger, RecorderViewStyle)
{
    RecorderViewOnlyPhotoStyle,
    RecorderViewPhotoAndVideoStyle,
};


@class SCRecorderViewController;

@protocol SCRecorderViewControllerDelegate<NSObject>

- (void)recorderViewController:(SCRecorderViewController *)recorderViewController didFinishCaptureImage:(UIImage *)image;
- (void)recorderViewController:(SCRecorderViewController *)recorderViewController didFinishCaptureVideo:(AVAsset *)avAsset;
- (void)recorderViewControllerDidPickingSystemPhoto:(SCRecorderViewController *)recorderViewController;

@optional

- (void)recorderViewControllerDidCancel:(SCRecorderViewController *)recorderViewController;

@end


@interface SCRecorderViewController : SBaseViewController<SCRecorderDelegate, UIImagePickerControllerDelegate>


@property(weak, readwrite, nonatomic)id<SCRecorderViewControllerDelegate>delegate;

@property(assign, readwrite, nonatomic)RecorderViewStyle recorderStyle;


- (IBAction)switchCameraMode:(id)sender;
- (IBAction)switchFlash:(id)sender;
- (IBAction)capturePhoto:(id)sender;
- (IBAction)switchGhostMode:(id)sender;



@end
