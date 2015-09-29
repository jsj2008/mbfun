//
//  Emotion.h
//  Wefafa
//
//  Created by fafa  on 13-8-7.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emotion : NSObject

+(NSArray*)emotionNames;
+(NSArray*)emotionNameCNs;
+(NSArray*)emotionImageNames;

+(UIImage*)imageWithName:(NSString*)name;
+(NSString *)getRegularEmotionAndMediaString;
+(NSString *)getEmotionNameCNByStr:(NSString *)emotionstr;
+(NSString *)replaceFaceImage:(NSString *)content ImageWidth:(int)faceImageWidth;
+(NSString *)replaceFaceString:(NSString *)message ImageWidth:(int)faceImageWidth;

@end
