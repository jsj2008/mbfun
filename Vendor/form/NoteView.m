//
//  NoteView.m
//  Wefafa
//
//  Created by daniel on 14-3-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "NoteView.h"

@implementation NoteView

@synthesize placeholder=_placeholder;

- (id)init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)loadNoteView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginTextViewEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endTextViewEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
    [self.layer setMasksToBounds:YES];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setFont:[UIFont fontWithName:@"Telugu Sangam MN" size:15]];
}

- (void)beginTextViewEditing:(NSNotification *)notification
{
	[[self layer] setShadowOffset:CGSizeMake(0, 0)];
    [[self layer] setShadowRadius:0];
    [[self layer] setShadowOpacity:1];
    [[self layer] setShadowColor:[UIColor clearColor].CGColor];
	[self.layer setBorderColor:[UIColor clearColor].CGColor];
}

- (void)endTextViewEditing:(NSNotification *)notification
{
	[[self layer] setShadowOffset:CGSizeZero];
    [[self layer] setShadowRadius:0];
    [[self layer] setShadowOpacity:0];
    [[self layer] setShadowColor:nil];
}

- (void)drawRect:(CGRect)rect {
    
    if(_placeholder==nil && _isShowPlaceholder==YES) {
        _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x+10, self.font.leading-7, self.frame.size.width-20, 20)];
        [_placeholder setFont:[UIFont fontWithName:@"Telugu Sangam MN" size:15]];
        [_placeholder setBackgroundColor:[UIColor clearColor]];
        [_placeholder setTextColor:[UIColor scrollViewTexturedBackgroundColor]];
        [_placeholder setText:@"非必填项"];
        [self addSubview:_placeholder];
    }
    
    [self loadNoteView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [self setNeedsDisplay];
}

-(void)setShowPlaceholder:(BOOL)isShow {
    _isShowPlaceholder=isShow;
}

-(void)dealloc {
    OBJC_RELEASE(_placeholder);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}

@end
