//
//  HomeViewController.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"

@class SBaseViewController;
@protocol LLCameraControllerDelegate;

@interface LLCameraViewController : SBaseViewController
@property (unsafe_unretained) id<LLCameraControllerDelegate> cameraDelegate;
//@property (nonatomic) BOOL animatedBack;
@property (nonatomic,strong) SObjectFunc completeHandler;
- (void)loadTemplateJSON:(NSString*)json;
- (void)loadTemplate:(NSArray*)ary;
@end

@protocol LLCameraControllerDelegate <NSObject>
@optional
// The picker does not dismiss itself; the client dismisses it in these callbacks.
// The delegate will receive one or the other, but not both, depending whether the user
// confirms or cancels.
- (void)llCameraController:(LLCameraViewController*)cameraController didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo;
- (void)llCameraControllerDidSelectGallary:(LLCameraViewController*)cameraController;
- (void)llCameraControllerDidSelectTemplate:(LLCameraViewController*)cameraController;
- (void)llCameraControllerDidCancel:(LLCameraViewController*)cameraController;

- (void)llCameraControllerDidSwipeLeft:(LLCameraViewController*)cameraController;
- (void)llCameraControllerDidSwipeRight:(LLCameraViewController*)cameraController;
@end
