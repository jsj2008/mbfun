//
//  HomeStyleTableView.h
//  Wefafa
//
//  Created by zhangjiwen on 15/1/23.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol kHomeTagMapDelegate <NSObject>

-(void)kDidSelecttIndexHomeTag:(NSDictionary *)dict indexRow:(NSInteger)indexRow;

@end


@interface HomeStyleTableView : UIView
{
    NSArray *_data;
}
//@property (strong, nonatomic) UILabel *lbName;
//@property (strong, nonatomic) UILabel *lbPrice;
@property (nonatomic,weak) id<kHomeTagMapDelegate> delegate;
@property (nonatomic)NSInteger indexRow;
//@property (nonatomic,strong) NSArray *styleArray;
@property (nonatomic,strong) NSDictionary *tagDict;
//+(int)getCellHeight:(id)data1;
//-(void)setData:(NSArray *)data;

@end
