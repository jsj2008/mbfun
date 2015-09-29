//
//  FilterContentHeaderReusableView.h
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterContentHeaderReusableView : UICollectionReusableView

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, weak) IBOutlet UILabel *showNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@end
