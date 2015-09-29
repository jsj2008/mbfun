//
//  WideGuideCollectionViewCell.h
//  Wefafa
//
//  Created by HuTailong on 15/2/9.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WideGuideCollectionViewCell : UICollectionViewCell
{
    NSCondition *download_lock;
}
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *collocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *concernedLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *personalLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

-(void)makeCell:(NSDictionary *)dic;

@end
