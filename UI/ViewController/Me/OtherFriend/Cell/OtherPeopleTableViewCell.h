//
//  OtherPeopleTableViewCell.h
//  Wefafa
//
//  Created by Jiang on 2/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    cellTypePlain = 1,
    cellTypeContentText = 1 << 1,
    cellTypeIndicator = 1 << 2,
    cellTypeQRCode = 1<< 3
} CellType;

static NSString *cellIdentifier = @"OtherPeopleTableViewCellIdentifier";

@interface OtherPeopleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (assign, nonatomic) CellType cellType;
@property (copy, nonatomic) Class jumpControllerName;
@property (weak, nonatomic) IBOutlet UIImageView *imgQRcode;

@end
