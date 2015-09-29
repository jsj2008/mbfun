//
//  SCAssetExportSession+Animation.m
//  SCRecorderExamples
//
//  Created by Ryan on 15/5/1.
//
//

#import "SCAssetExportSession+Animation.h"

@implementation SCAssetExportSession(Animation)
static NSArray* _animationLayers;
-(void)setAnimationLayers:(NSArray *)animationLayers{
    _animationLayers = animationLayers;
}

- (AVVideoComposition *)_buildVideoCompositionOfVideoTrack:(AVAssetTrack *)videoTrack {
    UIImage *watermarkImage = self.videoConfiguration.watermarkImage;
    
    if (watermarkImage != nil) {
        CGSize videoSize = videoTrack.naturalSize;
        CALayer *aLayer = [CALayer layer];
        aLayer.contents = (id)watermarkImage.CGImage;
        
        CGRect watermarkFrame = self.videoConfiguration.watermarkFrame;
        
        switch (self.videoConfiguration.watermarkAnchorLocation) {
            case SCWatermarkAnchorLocationTopLeft:
                watermarkFrame.origin.y += videoSize.height - watermarkFrame.size.height;
                break;
            case SCWatermarkAnchorLocationTopRight:
                watermarkFrame.origin.y += videoSize.height - watermarkFrame.size.height;
                watermarkFrame.origin.x = videoSize.width - watermarkFrame.size.width - watermarkFrame.origin.x;
                break;
            case SCWatermarkAnchorLocationBottomLeft:
                
                break;
            case SCWatermarkAnchorLocationBottomRight:
                watermarkFrame.origin.x = videoSize.width - watermarkFrame.size.width - watermarkFrame.origin.x;
                break;
        }
        
        aLayer.frame = watermarkFrame;
        
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
        videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
        [parentLayer addSublayer:videoLayer];
        [parentLayer addSublayer:aLayer];
        
        AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
        videoComp.renderSize = videoSize;
        videoComp.frameDuration = CMTimeMake(1, (int)videoTrack.nominalFrameRate);
        
        videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        
        /// instruction
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.inputAsset duration]);
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
        videoComp.instructions = [NSArray arrayWithObject:instruction];
        
        return videoComp;
    }
    
    if (_animationLayers) {
        CGSize videoSize = videoTrack.naturalSize;
        
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
        videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
        [parentLayer addSublayer:videoLayer];
        
        for (CALayer *layer in _animationLayers) {
            [parentLayer addSublayer:layer];
        }
        
        AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
        videoComp.renderSize = videoSize;
        videoComp.frameDuration = CMTimeMake(1, (int)videoTrack.nominalFrameRate);
        
        videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        
        /// instruction
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.inputAsset duration]);
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
        videoComp.instructions = [NSArray arrayWithObject:instruction];
        
        return videoComp;
    }
    
    return nil;
}

@end
