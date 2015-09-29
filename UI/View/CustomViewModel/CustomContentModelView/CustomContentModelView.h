//
//  CustomContentModelView.h
//  WeFFDemo
//
//  Created by fafatime on 14-4-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
//#import "ASIHttpRequest/ASIHTTPRequest.h"
#import "ASIHTTPRequest.h"

#import "EScrollerView.h"
@interface CustomContentModelView : UIView<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,ASIHTTPRequestDelegate,EScrollerViewDelegate>
{
    NSDictionary *dictionary;
//     UITableView *listTabView;
    PullingRefreshTableView *listTabView;
    
    NSDictionary *styleDictionary;
    
    
    UIScrollView *backScrollView;
    int lie;
    int num;
    int modelM;
    UIScrollView *backslView;//底部滑动
    int  ns;
    int changeSecondBtn;
    NSString *detailNameStrs;
    
}
@property (nonatomic,retain)NSDictionary *tableViewDataSouse;
//@property (retain,nonatomic)  UITableView *listTabView;
@property (retain,nonatomic)PullingRefreshTableView *listTabView;

- (id)initWithFrame:(CGRect)frame withStyleDic:(NSDictionary *)styleDic withDictionary:(NSDictionary *)dic  withlistDic:(NSDictionary *)listDic withSecondSelectNum:(int)clickBtn withNameStr:(NSString*)nameStr;

@end
