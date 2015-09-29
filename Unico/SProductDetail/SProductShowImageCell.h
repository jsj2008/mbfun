//
//  SProductShowImageCell.h
//  Wefafa
//
//  Created by Jiang on 8/3/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SProductShowImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
-(void)initData:(NSDictionary *)dict;
@end
