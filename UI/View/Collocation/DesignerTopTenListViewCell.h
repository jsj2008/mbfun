//
//  DesignerTopTenListViewCell.h
//  Wefafa
//
//  Created by mac on 14-12-7.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignerTopTenListViewCell : UITableViewCell
{
    NSDictionary *_data;
    NSCondition *download_lock;
}
@property (assign, nonatomic) int row;

@property (weak, nonatomic) IBOutlet UILabel *lbTop;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbCollNum;
@property (weak, nonatomic) IBOutlet UILabel *lbFansNum;
@property (weak, nonatomic) IBOutlet UIButton *btnAtten;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgAtten;

- (IBAction)btnAttenClick:(id)sender;

-(void)setData:(NSDictionary *)data;

@end
