//
//  NibLoad.m
//  YunHK
//
//  Created by Juvid on 14/12/30.
//  Copyright (c) 2014年 Juvid. All rights reserved.
//

#import "NibLoad.h"

@implementation NibLoad

+(UIView*)loadNib:(NSString *)nibName{
    return [NibLoad loadNib:nibName bundle:nil];
}

+(UIView*)loadNib:(NSString*)nibName bundle:bundle{
    NibLoad *loader=[[NibLoad alloc] init];
    UINib *nib=[UINib nibWithNibName:nibName bundle:bundle];
    [nib instantiateWithOwner:loader options:nil];
    return loader.views;
}

@end
