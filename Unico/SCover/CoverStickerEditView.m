//
//  CoverStickerEditView.m
//
//
//  Created by Ryan on 15/4/4.
//
//

#import "CoverStickerEditView.h"
#import "CoverEditViewController.h"
#import "PureLayout.h"


@interface CoverStickerEditView ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation CoverStickerEditView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    self.userInteractionEnabled = YES;
//    self.backgroundColor = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:0.3f];
    self.tintColor = [UIColor whiteColor];

    return self;
}

- (void)switchPos
{
    if (self.frame.origin.y <= 0) {
        [self bottom];
    }
    else {
        [self top];
    }
}

- (void)top
{
    [UIView animateWithDuration:0.5 animations:^{
//        float height = [UIScreen mainScreen].bounds.size.height;
//        self.frame = CGRectMake(0, height/4, self.frame.size.width, self.frame.size.height);
        CGPoint center = CGPointMake(CGRectGetMidX(self.superview.frame), CGRectGetMinY(self.superview.frame) + self.frame.size.height );
        self.center = center;
    }];

}

- (void)moveCenter
{
    [UIView animateWithDuration:0.5 animations:^{
        self.center = self.superview.center;
    }];
}

- (void)bottom
{
    
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint center = CGPointMake(CGRectGetMidX(self.superview.frame), CGRectGetMaxY(self.superview.frame) - self.frame.size.height );
        self.center = center;
    }];

}

- (void)setType:(CoverStickerType)type {
    [self removeAllButtons];
    switch (type) {
        case CoverStickerTypeText:
            // , @"字距＋", @"字距－"
            [self createBtnList:@[ @"字体", @"颜色", @"阴影", @"方向", @"透明＋", @"透明－"]];
            break;
        case CoverStickerTypeImage:
            [self createBtnList:@[ @"图库", @"相机", @"编辑", @"阴影", @"透明＋", @"透明－"]];
            break;
        case CoverStickerTypeShape:
            [self createBtnList:@[ @"形状", @"颜色", @"阴影", @"透明＋", @"透明－"]];
            break;
        case CoverStickerTypeBackground:
            [self createBtnList:@[ @"图库", @"相机", @"编辑"]];
            // 点击空白区域需要取消选择。
            break;
        default:
            break;
    }
}

- (void)removeAllButtons{
    NSArray *ary = [self subviews];
    for (int i=0; i<[ary count]; i++) {
        UIView *view = [ary objectAtIndex:i];
        [view removeFromSuperview];
    }
}


- (void)createBtnList:(NSArray*)titles{
    int inset = 5;
    int buttonWidth = 50;
    int buttonHeight = buttonWidth;
    int i = 0;
    for (NSString* title in titles) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];

        [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0] forState:UIControlStateNormal];
        // 保留title，因为后面比较暴力的用title判断的
        [button setTitle:title forState:UIControlStateNormal];

        button.frame = CGRectMake( i*inset + buttonWidth * i++, 0, buttonWidth, buttonHeight);
//        button.backgroundColor = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:1.0f/(i+2)];
//        button.clipsToBounds = YES;

        [button addTarget:self action:@selector(onButtonList:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:button];
    }
    
    self.bounds = CGRectMake(0, 0, buttonWidth * [titles count] + inset * ([titles count]-1), buttonHeight);
//    [self setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)onButtonList:(UIButton*)sender
{
    [[CoverEditViewController sharedVC] editAction:sender];
}

// 暂时没开启。
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        NSArray *views = [self subviews];
        if (views.count<=0) {
            return;
        }
        UIView *firstView = views[0];
        [views autoSetViewsDimension:ALDimensionHeight toSize:50.0];
        [views autoSetViewsDimension:ALDimensionWidth toSize:50.0];
        [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0.0 insetSpacing:YES matchedSizes:NO];
        [firstView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}


@end
