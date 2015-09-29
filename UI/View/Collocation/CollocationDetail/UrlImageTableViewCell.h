//
//  UrlImageTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"

@interface UrlImageTableViewCell : UITableViewCell<UIUrlImageViewDelegate>
{
    UIUrlImageView *imageView;
//    UILabel *_lbTitle;
}

@property (strong, nonatomic) id data;

-(void)downloadImage:(NSString *)url;
-(void)setCollocationInfo:(NSDictionary *)collocationDict;
-(void)innerInit;

//过渡上下级传参数
//-(void)setCollocationGoodsInfo:(NSMutableArray *)collocationArr andFunctionXml:(NSDictionary*)functionXML orRootXml:(NSDictionary*)rootXml;
+(int)getCellHeight:(id)data1;

@end
