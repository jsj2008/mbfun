//
//  CommunicateViewController.h
//  Wefafa
//
//  Created by fafa  on 13-6-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifyViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *leftscrollview;
    NSMutableArray *_commentArray;

    NSMutableArray *_nameArray;
    NSMutableArray *_pictureUrlArr;
    
    NSMutableArray *_menuArray;
    
    NSMutableArray *listInfo;
    
    NSMutableDictionary *updatadic;
    int selectedButtonTag;
    
    UIView *_filterCollocationView;
}


@property (weak, nonatomic) IBOutlet UIView *headView;

- (IBAction)searchBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searshTextfield;
@property (nonatomic,strong)UIScrollView *rightScrollView;
//@property (nonatomic,strong)UIImageView *headimage;
@property (nonatomic,strong)UIView *lineView;
- (IBAction)textDidEndOnExit:(id)sender;

@property (strong, nonatomic) NSDictionary * functionXML;//本级function
@property (strong, nonatomic) NSDictionary * rootXML;
@property (strong, nonatomic) NSDictionary * valueDict;//上级viewcontroller点击参数
@property (weak, nonatomic) IBOutlet UIView *viewCenter;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;

@property (strong, nonatomic) IBOutlet UIView *viewSearchComplete;
@property (weak, nonatomic) IBOutlet UILabel *lbSearchText;
- (IBAction)btnCompleteClicked:(id)sender;
- (IBAction)btnSearchCancelClicked:(id)sender;

@end
