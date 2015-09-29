//
//  ShareCellView.h
//  Wefafa
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCellView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UIButton *btnItem;
- (IBAction)btnItemClicked:(id)sender;

@end
