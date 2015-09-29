//
//  ChangePersonalInformationTableViewCell.m
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ChangePersonalInformationTableViewCell.h"
#import "ChangePersonalInformationModel.h"

@interface ChangePersonalInformationTableViewCell ()

@property (nonatomic, strong) UIImageView *arrowsImageView;

@end

@implementation ChangePersonalInformationTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        UIImage *image = [UIImage imageNamed:@"btn_profile_next.png"];
        self.arrowsImageView = [[UIImageView alloc]initWithImage:image];
        self.arrowsImageView.centerY = 25.0;
        
        self.accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
        [self.accessoryView addSubview:self.showImageView];
        [self.accessoryView addSubview:self.contentLabel];
        [self.accessoryView addSubview:self.arrowsImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.operation();
        [super setSelected:NO animated:NO];
    }

}

- (void)setModel:(ChangePersonalInformationModel *)model{
    _model = model;
    self.showImageView.hidden = YES;
    self.contentLabel.hidden = YES;
    self.arrowsImageView.hidden = YES;
    CGFloat accrssoryView_Width = 0.0;
    self.textLabel.text = model.titleText;
    self.operation = model.operation;
    if (model.imageNameString && ![model.imageNameString isEqualToString:@""]) {
        self.showImageView.hidden = NO;
        self.showImageView.image = [UIImage imageNamed:model.imageNameString];
        accrssoryView_Width += self.showImageView.frame.size.width;
    }else if (model.contentText && ![model.contentText isEqualToString:@""])  {
        CGRect rect = self.contentLabel.frame;
        rect.origin.x = 0;
        rect.size.width = 100;
        accrssoryView_Width += rect.size.width;
        self.contentLabel.frame = rect;
        self.contentLabel.hidden = NO;
        self.contentLabel.text = model.contentText;
    }
    if (model.isShowArrows) {
        CGRect rect = self.arrowsImageView.frame;
        rect.origin.x = accrssoryView_Width;
        rect.origin.x += 15;
        
        accrssoryView_Width += rect.size.width + 15;
        self.arrowsImageView.frame = rect;
        self.arrowsImageView.hidden = NO;
    }
    CGRect accrssoryViewRect = self.accessoryView.frame;
    accrssoryViewRect.size.width = accrssoryView_Width;
    accrssoryViewRect.origin.x = self.frame.size.width - accrssoryView_Width;
    self.accessoryView.frame = accrssoryViewRect;
}

- (UIImageView *)showImageView{
    if (!_showImageView) {
        CGRect rect = CGRectMake(0, 10, 34, 34);
        _showImageView = [[UIImageView alloc]initWithFrame:rect];
    }
    return _showImageView;
}

- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        CGRect rect = CGRectMake(0, 0, 0, 50);
        _contentLabel = [[UILabel alloc]initWithFrame:rect];
        [_contentLabel setTextAlignment:NSTextAlignmentRight];
        _contentLabel.font = [UIFont systemFontOfSize:12.0];
        _contentLabel.textColor = [UIColor lightGrayColor];
    }
    return _contentLabel;
}

@end
