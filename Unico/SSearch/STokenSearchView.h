//
//  STokenSearchView.h
//  PHMDevelopmentFramework
//
//  Created by PHM on 9/9/15.
//  Copyright (c) 2015 haoming pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STokenSearchViewDataSource;
@protocol STokenSearchViewDelegate;

@interface STokenSearchView : UIControl

@property (nonatomic, assign) id<STokenSearchViewDataSource>  dataSource;
@property (nonatomic, assign) id<STokenSearchViewDelegate>  delegate;
@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, assign) BOOL isNotBecomeFirstResponder;
@property (nonatomic, assign) BOOL isHidetokenView;  //显示tikenView
//排列数据
- (void)reloadData;
- (void)indexOfTokenView:(UIView *)view;

/**
 *	@简要 去除重复空格后 以空格为分隔符返回数组
 *	@参数 text : 搜索栏中字符串
 *
 *  @返回 包装view
 */
- (NSMutableArray *)removeDuplicateSpaces:(NSString *)text;

/**
 *	@简要 获取固定Token
 *	@参数 index
 *
 *  @返回 包装view
 */
- (UIView *)viewForTokenAtIndex:(NSUInteger)index viewPoint:(CGPoint)point;
@end

@protocol STokenSearchViewDataSource <NSObject>
@required
/**
 *	@简要 获取生成Token String
 *
 *  @返回 token text
 */
- (NSString *)accessTokenText;

@optional
/**
 *	@简要 获取生成Token Array
 *
 *  @返回 总数
 */
- (NSMutableArray *)accessTokenArray;

@end

@protocol STokenSearchViewDelegate <NSObject>
@optional
/**
 *	@简要 确认搜索
 *	@参数 searchView : self
 *	@参数 text : Token
 *
 *  @返回 nil
 */
- (void)tokenSearchView:(STokenSearchView *)searchView didReturnWithText:(NSString *)text;
/**
 *	@简要 删除Token
 *	@参数 searchView : self
 *	@参数 text : Token
 *
 *  @返回 nil
 */
- (void)tokenSearchView:(STokenSearchView *)searchView didRemoveTokenSting:(NSString *)text;


/**
 *	@简要 输入文本实时更新时调用
 *	@参数 searchView : self
 *	@参数 index : Token所在位置
 *
 *  @返回 nil
 */
- (void)tokenSearchView:(STokenSearchView *)searchView didtTextDidChange:(NSString *)text;

/**
 *	@简要 开始编辑Token
 *	@参数 searchView : self
 *	@参数 textField : 内容
 *
 *  @返回 nil
 */
- (void)tokenSearchView:(STokenSearchView *)searchView textFieldShouldBeginEditing:(UITextField *)textField;

/**
 *	@简要 编辑变化
 *	@参数 searchView : self
 *	@参数 textField : 编辑内容
 *
 *  @返回 nil
 */
- (void)tokenSearchView:(STokenSearchView *)searchView textFieldDidChange:(UITextField *)textField;

@end