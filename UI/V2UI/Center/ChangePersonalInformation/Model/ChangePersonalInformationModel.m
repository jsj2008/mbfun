//
//  ChangePersonalInformationModel.m
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ChangePersonalInformationModel.h"

@implementation ChangePersonalInformationModel

- (instancetype)initWithTitle:(NSString *)titleText
                    imageName:(NSString *)imageName
                  contentText:(NSString *)contentText
                   showArrows:(BOOL)isShowArrows
                    operation:(void (^)())operation
{
    if (self = [super init]) {
        self.titleText = titleText;
        self.imageNameString = imageName;
        self.contentText = contentText;
        self.isShowArrows = isShowArrows;
        self.operation = operation;
    }
    return self;
}

@end
