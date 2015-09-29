//
//  UIUrlImageView.h
//  Wefafa
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIUrlImageViewDelegate <NSObject>

-(void)completeDownloadImage:(id)sender imageLocalPath:(NSString *)imageLocalPath; //return localpath

@end

@interface UIUrlImageView : UIImageView
{
    NSString *localImageFilePath;
}

@property (assign, nonatomic) id<UIUrlImageViewDelegate> delegate;

-(void)downloadImageUrl:(NSString *)imageUrl cachePath:(NSString *)cachePath defaultImageName:(NSString *)defaultImageName;
+(NSString *)fileNameHash:(NSString *)filename;
@end
