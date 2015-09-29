//
//  NavigationTitleView.m
//  Wefafa
//
//  Created by mac on 14-9-23.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "NavigationTitleView.h"
#import "Utils.h"

@implementation NavigationTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)awakeFromNib
{
    [self innerInit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)innerInit
{
//    self.backgroundColor=NAVI_BACKGROUNDCOLOR;
    self.lbTitle.textColor=TITLE_TEXTCOLOR;
    self.backgroundColor=[Utils HexColor:0x262626 Alpha:1];
    
    self.imageLine.backgroundColor=[Utils HexColor:0x040000 Alpha:1.0];
//    [self.btnOk setTitleColor:[Utils HexColor:0xf46c56 Alpha:1.0] forState:UIControlStateNormal];
//    [self.btnOk setTitleColor:[Utils HexColor:0xf46c56 Alpha:1.0] forState:UIControlStateHighlighted];
    [self.btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.btnOk setTitleColor:[Utils HexColor:0xf46c56 Alpha:1.0] forState:UIControlStateHighlighted];

    [_btnOk setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}

- (IBAction)btnBackClick:(id)sender {
}

- (IBAction)btnOkClick:(id)sender {
}

- (IBAction)btnMenuClick:(id)sender {
    
}

-(void)createTitleView:(CGRect)frame delegate:(id)delegate selectorBack:(SEL)selectorBack selectorOk:(SEL)selectorOk selectorMenu:(SEL)selectorMenu
{
    NavigationTitleView *view=self;
    
    view.frame = frame;
    
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight;
    
    
    UIImageView *img=(UIImageView *)[view viewWithTag:3001];
    img.hidden=YES;
    view.btnBack.hidden=YES;
    if (selectorBack!=nil && [delegate respondsToSelector:selectorBack])
    {
        view.btnBack.hidden=NO;
        img.hidden=NO;
//        [img setImage:[UIImage imageNamed:@"ion_back"]];/
        [img setImage:[UIImage imageNamed:@"Unico/icon_back"]];
        
        
//        UIImage imageNamed:@"new_back"10 32
        
        [view.btnBack addTarget:delegate action:selectorBack forControlEvents:UIControlEventTouchUpInside];
    }
    view.btnOk.hidden=YES;
    if (selectorOk!=nil && [delegate respondsToSelector:selectorOk])
    {
        view.btnOk.hidden=NO;
        [view.btnOk addTarget:delegate action:selectorOk forControlEvents:UIControlEventTouchUpInside];
    }
    view.btnMenu.hidden=YES;
    if (selectorMenu!=nil && [delegate respondsToSelector:selectorMenu])
    {
        view.btnMenu.hidden=NO;
        [view.btnMenu addTarget:delegate action:selectorMenu forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
