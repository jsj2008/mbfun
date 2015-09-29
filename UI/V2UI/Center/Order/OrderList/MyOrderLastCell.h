//
//  MyOrderLastCell.h
//  Designer
//
//  Created by Juvid on 15/1/19.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyOrderLastDelegate <NSObject>

-(void)PressBtnTitle:(NSString *)str;

@end
@interface MyOrderLastCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
-(void)OrderStatus:(NSInteger)orderStatus;
@property(nonatomic,assign) id<MyOrderLastDelegate>delegate;
@end
