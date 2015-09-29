//
//  FilterContentHeaderReusableView.m
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "FilterContentHeaderReusableView.h"
#import "SUtilityTool.h"

@implementation FilterContentHeaderReusableView

- (void)awakeFromNib {
    // Initialization code
    [_lineImageView setBackgroundColor:COLOR_C9];
    
}

- (void)setTitleName:(NSString *)titleName{
    _titleName = [titleName copy];
    self.showNameLabel.text = _titleName;
}

@end
