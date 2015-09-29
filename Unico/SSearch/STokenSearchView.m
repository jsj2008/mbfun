//
//  STokenSearchView.m
//  PHMDevelopmentFramework
//
//  Created by PHM on 9/9/15.
//  Copyright (c) 2015 haoming pei. All rights reserved.

#import "STokenSearchView.h"
#import "SUtilityTool.h"
#import "Toast.h"
static const NSInteger fieldHeight = 20;    //field高度
static const NSInteger fieldPointY = 3;     //field内部view Y坐标
@interface STokenSearchView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *tokenScrollView;//Token容器
@property (nonatomic, strong) UIScrollView *textFieldScrollView;//存放textField用
@property (nonatomic, strong) NSMutableArray *tokenViews; //放入TokenView
@property (nonatomic, strong) NSMutableArray *tokens; //放入Token
@property (nonatomic, assign) CGPoint tokenPoint; //当前token的Point
@end

@implementation STokenSearchView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        [self initSubviews];
    }
    return self;
}

-(NSMutableArray *)tokenViews{
    if (!_tokenViews) {
        _tokenViews = [NSMutableArray array];
    }
    return _tokenViews;
}

#pragma mark - 设置Token Search Bar的UI
#pragma mark - 初始化搜索views
- (void)initSubviews
{
    _searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/token_search.png"]];
    [_searchImageView setFrame:CGRectMake(10, 10, 12, 12)];
    _searchImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_searchImageView];
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_searchImageView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.f
                                                         constant:7.f],
                           [NSLayoutConstraint constraintWithItem:_searchImageView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:7.f],
                           [NSLayoutConstraint constraintWithItem:_searchImageView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:-7.f],
                           [NSLayoutConstraint constraintWithItem:_searchImageView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:12]
                           ]];
    
    
    _tokenScrollView = [[UIScrollView alloc] init];
    _tokenScrollView.backgroundColor = [UIColor clearColor];
    _tokenScrollView.showsHorizontalScrollIndicator = NO;
    _tokenScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_tokenScrollView];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_tokenScrollView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_searchImageView
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:7.f],
                           [NSLayoutConstraint constraintWithItem:_tokenScrollView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:0.f],
                           [NSLayoutConstraint constraintWithItem:_tokenScrollView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:0.f],
                           [NSLayoutConstraint constraintWithItem:_tokenScrollView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:0.f]
                           ]];
    UITapGestureRecognizer *tapgestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClick:)];
    [_tokenScrollView addGestureRecognizer:tapgestureRecognizer];
    
    _textFieldScrollView = [[UIScrollView alloc] init];
    _textFieldScrollView.backgroundColor = [UIColor clearColor];
    _textFieldScrollView.showsHorizontalScrollIndicator = NO;
    _textFieldScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_textFieldScrollView];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_textFieldScrollView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_searchImageView
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:7.f],
                           [NSLayoutConstraint constraintWithItem:_textFieldScrollView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:0.f],
                           [NSLayoutConstraint constraintWithItem:_textFieldScrollView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:0.f],
                           [NSLayoutConstraint constraintWithItem:_textFieldScrollView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:0.f]
                           ]];
    
    
    _textField = [[UITextField alloc] init];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.tintColor = UIColorFromRGB(0xfedc32);
    _textField.font = FONT_t3;
    _textField.placeholder = @"搜索:用户、品牌、标签";
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.delegate = self;
    _textField.frame = CGRectMake(0, fieldPointY, self.frame.size.width-self.frame.size.height-10, fieldHeight);
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_textFieldScrollView addSubview:_textField];
    [_textFieldScrollView setContentSize:CGSizeMake(_textField.frame.size.width, _tokenScrollView.frame.size.height)];
    [self reloadData];
}

#pragma mark 排列数据
- (void)reloadData
{
    //初始化数据
    _textField.text = @"";
    //是否显示tokenview
    if (!_isHidetokenView) {
        //获取的数据为nil或@“”时 add textField
        if ([self.dataSource accessTokenText] != nil&&![[self.dataSource accessTokenText] isEqualToString:@""]) {
            
            _textFieldScrollView.hidden = YES;
            _tokenScrollView.hidden = NO;
            
            _tokenPoint = CGPointMake(0, fieldPointY);
            _tokens = [self removeDuplicateSpaces:[self.dataSource accessTokenText]];
            //clear ScrollView subview
            for (UIView *view in [_tokenScrollView subviews]) {
                [view removeFromSuperview];
            }
            [self.tokenViews removeAllObjects];
            //循环粘贴token
            for (int i = 0 ; i < [_tokens count]; i++) {
                UIView *tokenView = [self viewForTokenAtIndex:i viewPoint:_tokenPoint];
                _tokenPoint = CGPointMake(tokenView.frame.origin.x+tokenView.frame.size.width, fieldPointY);
                [_tokenScrollView addSubview:tokenView];
                [self.tokenViews addObject:tokenView];
            }
            [_tokenScrollView setContentSize:CGSizeMake(_tokenPoint.x<150?_tokenPoint.x:_tokenPoint.x+100, _tokenScrollView.frame.size.height)];
        }else{
            _textFieldScrollView.hidden = NO;
            _tokenScrollView.hidden = YES;
        }
    }else{
        _textFieldScrollView.hidden = NO;
        _tokenScrollView.hidden = YES;
        
        NSString *testString = @"";
        if ([self.dataSource respondsToSelector:@selector(accessTokenText)]) {
            if ([self.dataSource accessTokenText] != nil&&![[self.dataSource accessTokenText] isEqualToString:@""]) {
                _tokens = [self removeDuplicateSpaces:[self.dataSource accessTokenText]];
                for (int i = 0 ; i < [_tokens count]; i++) {
                    testString =[testString stringByAppendingString:[NSString stringWithFormat:@"%@ ",_tokens[i]]];
                }
            }
        }
        _textField.text = testString;
        [_textField becomeFirstResponder];
    }
}

#pragma mark 设置标签样式并返回显示
- (UIView *)viewForTokenAtIndex:(NSUInteger)index viewPoint:(CGPoint)point{
    static NSInteger buttonWidthandheight = 10;
    UIView *view = [UIView new];
    view.tag = point.x;
    view.backgroundColor = COLOR_C7;
    UITapGestureRecognizer *tokenTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tokenDeletePressed:)];
    [view addGestureRecognizer:tokenTapGestureRecognizer];
    //设置标签
    UILabel *label = [UILabel new];
    label.text = self.tokens[index];
    label.font = FONT_t4;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    //设置删除标签键
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"Unico/tagdelete.png"] forState:UIControlStateNormal];
    //[button setTitle:@"x" forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    CGSize size = [label sizeThatFits:CGSizeMake(1000, 20)];
    [label sizeToFit];
    
    //设置控件大小
    view.frame = CGRectMake(point.x+4, point.y, size.width+25, 20);
    label.frame = CGRectMake(5, 2, size.width, size.height);
    button.frame = CGRectMake(size.width+10, 5, buttonWidthandheight, buttonWidthandheight);
    
    //设置圆角
    view.layer.cornerRadius = 3;
    view.layer.masksToBounds = YES;
    return view;
}

#pragma mark - 替换字符
#pragma mark - 去除重复空格后 以空格为分隔符返回数组
-(NSMutableArray *)removeDuplicateSpaces:(NSString *)text{
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"[' ']+"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];
    NSString *removeDuplicateSpacesText = [regular stringByReplacingMatchesInString:[Utils getSNSString:text]
                                                                            options:NSMatchingReportProgress
                                                                              range:NSMakeRange(0, [[Utils getSNSString:text] length])
                                                                       withTemplate:@" "];
    return [[removeDuplicateSpacesText componentsSeparatedByString:@" "] mutableCopy];
}

#pragma mark 把连续的空格替换
-(NSString *)removeDuplicateSpacesSting:(NSString *)text {
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"[' ']+"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];
    NSString *removeDuplicateSpacesText = [regular stringByReplacingMatchesInString:[Utils getSNSString:text]
                                                                            options:NSMatchingReportProgress
                                                                              range:NSMakeRange(0, [[Utils getSNSString:text] length])
                                                                       withTemplate:@" "];
    return [removeDuplicateSpacesText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


#pragma mark - 对搜索栏标签的操作
#pragma mark - 单击tokenView上的删除操作
- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    [self indexOfTokenView:tokenButton.superview];
}

#pragma mark 点击单个tokenView 进行删除操作
-(void)tokenDeletePressed:(UITapGestureRecognizer *)recognizer{
    [self indexOfTokenView:recognizer.view];
}

#pragma mark 单击背景操作
-(void)backgroundClick:(UITapGestureRecognizer *)recognizer{
    _isHidetokenView = YES;
    [self reloadData];
}

#pragma mark textField上有操作时
- (void)textFieldDidChange:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(tokenSearchView:didtTextDidChange:)]) {
        [self.delegate tokenSearchView:self didtTextDidChange:textField.text];
    }
}

#pragma mark 删除指定位置的TokenView
- (void)indexOfTokenView:(UIView *)view
{
    _isHidetokenView = NO;
    [_tokens removeObjectAtIndex:[_tokenViews indexOfObject:view]];
    NSString *string = @"";
    for (int i = 0; i <[_tokens count]; i++) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@ ",_tokens[i]]];
    }
    
    if ([self.delegate respondsToSelector:@selector(tokenSearchView:didRemoveTokenSting:)]) {
        [self.delegate tokenSearchView:self didRemoveTokenSting:[self removeDuplicateSpacesSting:string]];
    }
    [self reloadData];
}

#pragma mark - TextFieldDelegate
#pragma mark - textField开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _isHidetokenView = YES;
    if ([self.delegate respondsToSelector:@selector(tokenSearchView:textFieldShouldBeginEditing:)]) {
        [self.delegate tokenSearchView:self textFieldShouldBeginEditing:textField];
    }
    
    if (_isNotBecomeFirstResponder) {
        return NO;
    }
    return YES;
}

#pragma mark 键盘上点击搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        [Toast makeToast:@"请输入关键词" duration:1.5f position:@"center" title:nil];
    }else{
        _isHidetokenView = NO;
        if ([self.delegate respondsToSelector:@selector(tokenSearchView:didReturnWithText:)]) {
            [self.delegate tokenSearchView:self didReturnWithText:[self removeDuplicateSpacesSting:textField.text]];
        }
        [textField resignFirstResponder];
        [self reloadData];
    }
    return YES;
}

#pragma mark - ***备用方法 暂时弃用***
#pragma mark 替换TextField数据 让数据不为@“”
-(void)setTextFieldText{
    if ([_textField.text isEqualToString:@""]) {
        if (_tokenViews.count-1 > 0) {
            _textField.text = @"\u200B";
        }
    }
}

@end



