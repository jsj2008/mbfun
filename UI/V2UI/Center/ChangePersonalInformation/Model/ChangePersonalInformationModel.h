//
//  ChangePersonalInformationModel.h
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangePersonalInformationModel : NSObject
//标题文字
@property (nonatomic, copy) NSString *titleText;
//图片名称
@property (nonatomic, copy) NSString *imageNameString;
//内容标题文字
@property (nonatomic, copy) NSString *contentText;
//是否显示箭头
@property (nonatomic, assign) BOOL isShowArrows;
//操作
@property (nonatomic, copy) void (^operation)();

- (instancetype)initWithTitle:(NSString*)titleText
                    imageName:(NSString*)imageName
                  contentText:(NSString*)contentText
                   showArrows:(BOOL)isShowArrows
                    operation:(void(^)())operation;

@end
