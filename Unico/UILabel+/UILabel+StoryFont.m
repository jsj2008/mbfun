//
//  UILabel+StoryFont.m
//  Story
//
//  Created by Ryan on 15/4/27.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "UILabel+StoryFont.h"

@implementation UILabel (StoryFont)
- (void)story_appFont{
    [self story_appFont:self.font.pointSize];
}

- (void)story_appFont:(float)pointSize{
    self.font = [UILabel story_appFont:pointSize];
}

+ (UIFont*)story_appFont:(float)pointSize{
    NSString* fontFileName = @"fzltxh.ttf";
    NSURL* myFontURL = [[NSBundle mainBundle] URLForResource:fontFileName withExtension:@""];
    NSArray* fontPostScriptNames = [UIFont registerFontFromURL:myFontURL];
    NSString* fontName = [fontPostScriptNames objectAtIndex:0];
    
    UIFont *appFont = [UIFont fontWithName:fontName size:pointSize];
    return appFont;
}
@end
