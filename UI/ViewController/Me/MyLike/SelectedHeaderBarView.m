//
//  SearchHeaderToobar.m
//  Designer
//
//  Created by Jiang on 1/27/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "SelectedHeaderBarView.h"
#import "Utils.h"

@interface SelectedHeaderBarView ()

@property (nonatomic, weak) UIView *decorationView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *toolBarButton;
@property (nonatomic, assign) float totalDistance;

- (IBAction)toolBarButtonAction:(UIButton*)sender;

@end

@implementation SelectedHeaderBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SelectedHeaderBarView" owner:nil options:nil];
        self = [array firstObject];
        for (UIButton *button in self.toolBarButton) {
            //设置button选中颜色
//            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button setTitleColor:[Utils HexColor:0x333333 Alpha:1] forState:UIControlStateSelected];
            [button setTitleColor:[Utils HexColor:0x919191 Alpha:1] forState:UIControlStateNormal];
        }
        UIButton *firstButton = [self.toolBarButton firstObject];
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [Utils HexColor:0xfede32 Alpha:1];//0xffed00
        view.frame = CGRectMake(0, CGRectGetMaxY(firstButton.frame) - 2, firstButton.frame.size.width, 2);
        view.centerX = firstButton.centerX;
        [self addSubview:view];
        _decorationView = view;
        [self toolBarButtonAction:firstButton];
        
//        CALayer *lineLayer = [CALayer layer];
//
//        lineLayer.backgroundColor=[UIColor clearColor].CGColor;
//
//        CGFloat self_Height = self.frame.size.height;
//        lineLayer.frame = CGRectMake(0, self_Height - 1, self.frame.size.width, 1);
//        [self.layer addSublayer:lineLayer];
        
        UIButton *lastButton = [self.toolBarButton lastObject];
        self.totalDistance = lastButton.center.x - firstButton.center.x;
    }
    return self;
}

- (void)setHeaderTitlesArray:(NSArray *)headerTitlesArray{
    _headerTitlesArray = headerTitlesArray;
    for (int i = 0; i < MIN(self.toolBarButton.count, headerTitlesArray.count); i++) {
        NSString *title = headerTitlesArray[i];
        UIButton *button = self.toolBarButton[i];
        [button setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setLineLocationPercentage:(CGFloat)percentage{
 
    if (0 <= percentage && percentage <= 1) {
        UIButton *button = [self.toolBarButton firstObject];
        CGRect decorationLayerFrame = self.decorationView.frame;
        decorationLayerFrame.origin.x = self.totalDistance * percentage + button.frame.origin.x;
        self.decorationView.frame = decorationLayerFrame;
        
//        UIColor *rightColor = [UIColor colorWithRed:percentage green:0 blue:0 alpha:1];
//        UIColor *color = [UIColor colorWithRed:(1 - percentage) green:0 blue:0 alpha:1];
//
//        UIButton *buttonRight = self.toolBarButton[1];
//        [button setTitleColor:color forState:UIControlStateNormal];
//        [button setTitleColor:color forState:UIControlStateSelected];
//        [buttonRight setTitleColor:rightColor forState:UIControlStateNormal];
//        [buttonRight setTitleColor:rightColor forState:UIControlStateSelected];
    }

}

- (void)scrollViewEndAction:(int)page{
    for (int i = 0; i < self.toolBarButton.count; i ++) {
        UIButton *button = self.toolBarButton[i];
        if (page == i) {
            self.decorationView.centerX = button.centerX;
            [button setSelected:YES];
        }else{
            [button setSelected:NO];
        }
    }
}

- (IBAction)toolBarButtonAction:(UIButton*)sender{
    if ([sender isSelected]) return;
    for (UIButton *button in self.toolBarButton) {
        [button setSelected:button.tag == sender.tag? YES: NO];
    }
//    self.decorationView.centerX = sender.centerX;
    [self.selectedHeaderBarViewDelegate selectedHeaderToobar:self didSelectNumber:sender.tag - 10];
}
@end
