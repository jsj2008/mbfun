//
//  GoodsOrderBaseTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "GoodsOrderBaseTableViewCell.h"

@implementation GoodsOrderBaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)completeDownloadImage:(id)sender imageLocalPath:(NSString *)imageLocalPath
{
}

//基类接口方法，子类重载
-(void)setData:(id)data1
{
}

//基类接口方法，子类重载
+(int)getCellHeight:(id)data1
{
    return 44;
}

@end
