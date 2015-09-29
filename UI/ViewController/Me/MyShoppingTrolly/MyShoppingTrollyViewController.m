//
//  MyShoppingTrollyViewController.m
//  Wefafa
//
//  Created by mac on 14-9-2.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyShoppingTrollyViewController.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "MyShoppingTrollyGoodsTableViewCell.h"
#import "NavigationTitleView.h"
#import "MBCreateGoodsOrderViewController.h"
#import "Appsetting.h"
#import "MyShoppingTrollyGoodsTableHeaderView.h"
#import "AppDelegate.h"

#import "Globle.h"
#import "SProductDetailViewController.h"
#import "SMBCouponActivityVC.h"
#import "SUtilityTool.h"
#import "JASwipeCell.h"
#import "JAActionButton.h"
#import "TalkingData.h"
#import "HttpRequest.h"
/////
//#import "BuyCollocationViewController.h"
#import "GoodCollectionController.h"

//
#import "MBGoodsDetailesSpecModel.h"
#import "MBCollocationDetailListModel.h"
#import "OrderActivityProductListModel.h"
#import "JSWebViewController.h"


static const CGFloat kCellH = 85.f;
@interface MyShoppingTrollyViewController ()
<UITableViewDelegate, UITableViewDataSource,JASwipeCellDelegate,
GoodCollectionControllerDelegate>
{
    NSLock *refreshLock;
    NSString *couponStr;
//    UIButton *btnEdit;
    NSRecursiveLock*requestlock;
    NSInteger currentRow;
    NSInteger currentSection;
    BOOL isNotRequestFinish;
    
    NSIndexPath *_currentIndexPath;
}
@property(nonatomic,strong) ZMAlertView *zmAlertView;   // pop view (equal alert view)
@property(nonatomic,strong) UIButton *deleteAllBtn;
@property(nonatomic,strong) UIButton *collectionLikeBtn;
@property (nonatomic, strong) UIButton *btnEdit;
@property (nonatomic, strong) GoodCollectionController *goodCollectionVc;
@end

@implementation MyShoppingTrollyViewController
@synthesize goodsArray = goodsArray;
@synthesize shTrGoodsData = shTrGoodsData;
@synthesize btnEdit = btnEdit;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIButton *)deleteAllBtn{
    // CGRectMake(UI_SCREEN_WIDTH-125.f, 0, 125.f, 55.f);
    if (!_deleteAllBtn) {
        _deleteAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteAllBtn.hidden = YES;
        _deleteAllBtn.frame = CGRectMake(UI_SCREEN_WIDTH-125.f*UI_SCREEN_WIDTH/375.0, 0, 125.f*UI_SCREEN_WIDTH/375.0, 49.f);
        [_deleteAllBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteAllBtn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
        _deleteAllBtn.titleLabel.font = FONT_T1;//[UIFont systemFontOfSize:12.0f];
        _deleteAllBtn.backgroundColor = COLOR_C12;//[UIColor colorWithHexString:@"#ff3b30"];
        [_deleteAllBtn addTarget:self action:@selector(deleteAllBtnClickMothel:) forControlEvents:UIControlEventTouchUpInside];
        //        _deleteAllBtn.layer.cornerRadius = 3.0f;
        //        _deleteAllBtn.layer.masksToBounds = YES;
    }
    
    return _deleteAllBtn;
}

-(UIButton *)collectionLikeBtn{
    if (!_collectionLikeBtn) {
        _collectionLikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionLikeBtn.hidden = YES;
        CGFloat x = UI_SCREEN_WIDTH-125.f*UI_SCREEN_WIDTH/375.0*2;//CGRectGetMinX(_btnPay.frame)-125.f;
        _collectionLikeBtn.frame = CGRectMake(x, 0, 125.f*UI_SCREEN_WIDTH/375.0, 49.f);
        [_collectionLikeBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectionLikeBtn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
        _collectionLikeBtn.titleLabel.font = FONT_T1;//[UIFont systemFontOfSize:12.0f];
        _collectionLikeBtn.backgroundColor = COLOR_C2;//[UIColor colorWithHexString:@"#acacac"];/320
        [_collectionLikeBtn addTarget:self action:@selector(collectionLikeBtnClickMothel:) forControlEvents:UIControlEventTouchUpInside];
        //        _collectionLikeBtn.layer.cornerRadius = 3.0f;
        //        _collectionLikeBtn.layer.masksToBounds = YES;
    }
    return _collectionLikeBtn;
    
}

-(void)deleteAllBtnClickMothel:(UIButton *)sender{
    NSMutableArray *removedata=[[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0;i<goodsArray.count;i++)
    {
        NSArray *rowArray=goodsArray[i];
        for (MyShoppingTrollyGoodsData *data in rowArray) {
            if (data.selected==YES)
            {
                [removedata addObject:data];
            }
        }
    }
    
    [self deleteDataMothel:removedata withIndexPath:nil];
    
}
-(void)collectionLikeBtnClickMothel:(UIButton *)sender{
    NSMutableArray *collectionLikeData=[[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0;i<goodsArray.count;i++)
    {
        NSArray *rowArray=goodsArray[i];
        for (MyShoppingTrollyGoodsData *data in rowArray) {
            if (data.selected==YES)
            {
                [collectionLikeData addObject:data];
            }
        }
    }
    
    [self collectionLikeDataMothel:collectionLikeData withIndexPath:nil];
}

#pragma mark - 完成和编辑状态下的按钮隐藏和显示
-(void)performEditMothel{
    _btnPay.backgroundColor= COLOR_C1;//[Utils HexColor:0xe2e2e2 Alpha:1.0];
    _btnPay.enabled = NO;
    _btnPay.hidden = YES;
    _lbSum.hidden = YES;
    _lbTrans.hidden = YES;
    _deleteAllBtn.hidden = NO;
    //隐藏
    _collectionLikeBtn.hidden = NO;
    
    [self.tvShoppingTrolly reloadData];
}
-(void)performCompleteMothel{
    _btnPay.backgroundColor=COLOR_C1;//[Utils HexColor:0xffde00 Alpha:1.0];
    _btnPay.enabled = YES;
    _btnPay.hidden = NO;
    _lbSum.hidden = NO;
    _lbTrans.hidden = NO;
    _deleteAllBtn.hidden = YES;
    _collectionLikeBtn.hidden = YES;
    
    [self.tvShoppingTrolly reloadData];
}
- (void)setupNavbar {
    [super setupNavbar];
    
    [self.tvShoppingTrolly registerClass:[MyShoppingTrollyGoodsTableViewCell  class] forCellReuseIdentifier:@"MyShoppingTrollyGoodsTableViewCell"];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       
                                       target:nil action:nil];
    
    negativeSpacer.width = 0;
    
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    
    // 这里可以试试 UIBarButtonItem的customView来处理2个btn
    UIButton *btnBack=[[UIButton alloc]init];
    btnBack.backgroundColor=[UIColor clearColor];
    btnBack.frame=CGRectMake(0, 0, 75, 44);
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    btnBack.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 7);
    
    [btnBack setTitle:@"编辑" forState:UIControlStateNormal];
    
    btnBack.titleLabel.font = FONT_T3;//BUTTONBIGFONT;
    btnEdit=btnBack;
    btnEdit.hidden=YES;
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnEditClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           
                                           target:nil action:nil];
        
        negativeSpacer.width = -10;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
    }
    else{
        
        self.navigationItem.rightBarButtonItem=backItem;
        
    }
    self.title=@"购物袋";
    
    
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}

-(void)onCancleClick:(UIButton *)sender{
    
    
    
}
- (void)addHeader
{
    __weak typeof(self) vc = self;
    
    // 添加下拉刷新头部控件
    [self.tvShoppingTrolly addHeaderWithCallback:^{
        
        [vc refreshTableView];
        
        //        // 模拟延迟加载数据，因此2秒后才调用）
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc.tvShoppingTrolly headerEndRefreshing];
        //             结束刷新
        
        //        });
    }];
    
#warning 自动刷新(一进入程序就下拉刷新)
    //    [_tvShoppingTrolly headerBeginRefreshing];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentIndexPath = [[NSIndexPath alloc] init];
    
    self.tvShoppingTrolly.backgroundColor = COLOR_C6;
    
    if (_btnSelectedAll.selected) {
        [_btnSelectedAll setImage:[UIImage imageNamed:@"Unico/present_uncheck"]
                         forState:UIControlStateSelected];
        
    }else{
        [_btnSelectedAll setImage:[UIImage imageNamed:@"Unico/uncheck_zero"]
                         forState:UIControlStateNormal];
        
    }
    
    //空数据展示图
    _shoppimgTrollyNil.image = [UIImage imageNamed:NONE_DATA_SHOPPING_BAG];
    _shoppimgTrollyNil.hidden = YES;
    
    refreshLock =[[NSLock alloc]init];
    
    requestlock = [[NSRecursiveLock alloc] init];
    goodsArray=[[NSMutableArray alloc] initWithCapacity:10];
    
    
    [self setupNavbar];
    
    isShowEditButton=YES;
    _tvShoppingTrolly.backgroundColor = TITLE_BG;
    
    UIView* v = [[UIView alloc]init];
    _tvShoppingTrolly.tableFooterView = v;
    _tvShoppingTrolly.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tvShoppingTrolly.rowHeight = kCellH;
    
    MyShoppingTrollyGoodsTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MyShoppingTrollyGoodsTableViewCell" owner:self options:nil] objectAtIndex:0];
    cellheight=cell.frame.size.height;
    
    //    [Toast makeToastActivity:@"正在获取数据" hasMusk:NO];
    [self refreshTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notif_refreshShoppingCartTableView:) name:@"notif_refreshShoppingCartTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"notification_refreshtableView" object:nil];
    
    
    /*  [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(arrowDirectionChange)
     name:@"arrowDirectionChange"
     object:nil];*/
    
    //old views
    
    _lbSum.textColor=COLOR_C2;//[Utils HexColor:0x333333 Alpha:1.0];
    _lbSum.font = FONT_T4;
    _lbTrans.textColor=COLOR_C6;//[Utils HexColor:0xacacac Alpha:1.0];
    _lbTrans.font = FONT_t7;
    _SelectLb.textColor = COLOR_C2;
    _SelectLb.font = FONT_T3;//FONT_t7;
    
    _btnPay.backgroundColor=COLOR_C2;//[Utils HexColor:0xffde00 Alpha:1.0];
    _btnPay.backgroundColor = COLOR_C1;
    _btnPay.titleLabel.font = FONT_T1;
    _btnPay.titleLabel.textColor = COLOR_C2;
    //    _btnPay.layer.cornerRadius = 3.0;
    //    _btnPay.layer.masksToBounds = YES;
    
    
    
    //
    VIEWHEIGHT=_tvShoppingTrolly.frame.size.height;
    
    MyShoppingTrollyGoodsTableHeaderView *headerview=[[[NSBundle mainBundle] loadNibNamed:@"MyShoppingTrollyGoodsTableHeaderView" owner:self options:nil] lastObject];
    TABLE_HEADER_HEIGHT=headerview.frame.size.height;
    
    [self setupForDismissKeyboard];
    _tvShoppingTrolly.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;// tableview滚动，键盘消失
    
    self.bottom_showView.layer.masksToBounds = NO;
    self.bottom_showView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bottom_showView.layer.shadowOffset = CGSizeMake(0, -3);
    CGRect frame = self.bottom_showView.bounds;
    frame.size.height = UI_SCREEN_WIDTH;
    self.bottom_showView.layer.shadowPath = [UIBezierPath bezierPathWithRect:frame].CGPath;
    [self addHeader];
    
    [_bottom_showView addSubview:self.deleteAllBtn];    // 删除
    [_bottom_showView addSubview:self.collectionLikeBtn];   // 收藏
    
    [self requestAndJudge];
}

#pragma mark -
#pragma mark - 关于数据
- (void)requestAndJudge
{
    
}


#
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"notif_refreshShoppingCartTableView"
                                                  object:nil];
    /*
     [[NSNotificationCenter defaultCenter] removeObserver:self
     name:@"arrowDirectionChange"
     object:nil];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    /** 设置xib下的控件frame */
    /*
     _bottom_showView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-55, UI_SCREEN_WIDTH, 55);
     CGFloat bottomViewH = self.bottom_showView.bounds.size.height;
     
     _btnSelectedAll.frame = CGRectMake(10, (bottomViewH-30)/2, 30, 30);
     _SelectLb.frame = CGRectMake(CGRectGetMaxX(_btnSelectedAll.frame)+10, (bottomViewH-10)/2, 40, 10);
     
     CGFloat sumAndTranX = CGRectGetMaxX(_SelectLb.frame)+20.f;
     _lbSum.frame = CGRectMake(sumAndTranX, 13, 200, 18);
     
     CGFloat transY = CGRectGetMaxY(_lbSum.frame)+3;
     _lbTrans.frame = CGRectMake(sumAndTranX, transY, 100, 15);
     //    NSLog(@"__%@", NSStringFromCGRect(_SelectLb.frame));
     
     _btnPay.frame = CGRectMake(UI_SCREEN_WIDTH-125.f, 0, 125.f, 55.f);
     
     */
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    /* [[NSNotificationCenter defaultCenter] removeObserver:self
     name:@"arrowDirectionChange"
     object:nil];*/
    
    [super viewWillDisappear:animated];
}

- (void)setupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    
    [self.tvShoppingTrolly reloadData];
    //使用endEditing:YES 会出现问题
    //    [self.view endEditing:YES];
    currentSection = 0;
    currentRow = 0;
}

- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    //
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    VIEWHEIGHT = _tvShoppingTrolly.frame.size.height;
    [self setFrameWithHeight:keyboardRect.size.height];
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self setFrameWithHeight:0];
}

- (void)setFrameWithHeight:(int)height {
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];//49
    _tvShoppingTrolly.frame = CGRectMake(_tvShoppingTrolly.frame.origin.x,_tvShoppingTrolly.frame.origin.y,_tvShoppingTrolly.frame.size.width, (float)(VIEWHEIGHT+(height>0?49:0)-height));
    int y1=height-49;
    
    if (height == 0) {
        [_tvShoppingTrolly setContentOffset:CGPointMake(0, (float)(y1<=0?0:y1)) animated:YES];
        [UIView commitAnimations];
        currentSection = 0;
        currentRow =0;
        return;
    }
    if (currentSection == 0) {
        if (currentRow <2) {
            [_tvShoppingTrolly setContentOffset:CGPointMake(0,0) animated:YES];
            
        }else{
            [_tvShoppingTrolly setContentOffset:CGPointMake(0, (float)(y1<=0?0:y1)) animated:YES];
        }
        
    }else{
        [_tvShoppingTrolly setContentOffset:CGPointMake(0, (float)(y1<=0?0:y1)) animated:YES];
    }
    
    currentSection = 0;
    currentRow =0;
    
    [UIView commitAnimations];
}

- (void)notif_refreshShoppingCartTableView:(NSNotification*) notification
{
    //    id obj = [notification object];//获取到传递的对象
    [self refreshTableView];
}

#pragma mark - 编辑（完成）按钮点击事件
-(void)btnEditClick:(UIButton *)sender
{
    isShowEditButton=!isShowEditButton;
    [self editOpration:isShowEditButton];
}

- (void)editOpration:(BOOL)isEdit{
    if (isEdit)
    {
        [self performCompleteMothel];
        [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        
        //按下完成按钮   //add by miao 6.8 4.点击编辑
        
        for (int i=0;i<goodsArray.count;i++)
        {
            PlatFormInfo *tmpPlatFormInfo = nil;
            NSArray *rowArray=goodsArray[i];
            for (MyShoppingTrollyGoodsData *data in  rowArray)
            {
                if ([data isUsed])
                {
                    if (data.selected==YES)
                    {
                        if (data.platFormInfo) {
                            
                            tmpPlatFormInfo = data.platFormInfo;
                            break;
                        }
                    }
                }
            }
            
            
            if (tmpPlatFormInfo)
            {
                NSMutableArray *tmparray = [NSMutableArray new];
                for (MyShoppingTrollyGoodsData *data in  rowArray)
                {
                    if ([data isUsed])
                    {
                        if (data.selected==YES)
                        {
                            data.platFormInfo = tmpPlatFormInfo;
                            [tmparray addObject:data];
                        }
                        
                    }
                }
                
                if (tmparray.count > 0) {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        
                        
                        [requestlock lock];
                        //请求活动
                        [self requestGoodsCouponDataWithdataArray:tmparray];
                        
                        sleep(2.5f);
                        [Toast hideToastActivity];
                        [requestlock unlock];
                        
                    });
                    
                }
            }
            
        }
    }
    else
    {
        [self performEditMothel];
        [btnEdit setTitle:@"完成" forState:UIControlStateNormal];
        //         self.tvShoppingTrolly.editing = YES;
        //        [self.tvShoppingTrolly setEditing:YES animated:YES];
        [self.tvShoppingTrolly reloadData];
    }
    
    
}

#pragma mark -- 删除商品
-(void)deleteDataMothel:(NSMutableArray *)removeData withIndexPath:(NSIndexPath *)indexPath{
    if (removeData == nil || removeData.count <=0) {
        [Utils alertMessage:@"请先选中商品"];
        return;
    }
    __weak MyShoppingTrollyViewController *vc = self;
    _zmAlertView = [[ZMAlertView alloc] initWithTitle:@"是否确定删除商品?" contentText:nil leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    [_zmAlertView show];
    _zmAlertView.leftBlock = ^() {
        NSLog(@"left button clicked");
    };
    
    _zmAlertView.rightBlock = ^() {
        [Toast makeToastActivity:@"正在删除..." hasMusk:NO];
        //        NSMutableString *ids = [NSMutableString new];;
        if (removeData.count > 0) {
            NSMutableArray *idsArray = [[NSMutableArray alloc]init];
            
            for (MyShoppingTrollyGoodsData *data in removeData) {
                
                //                [ids appendString:[NSString stringWithFormat:@"%@,",data.shoppingcartid]];
                [idsArray addObject:[NSString stringWithFormat:@"%@",data.shoppingcartid]];
                
            }
            NSString *ids = [idsArray componentsJoinedByString:@","];
            
            NSDictionary *param=@{
                                  @"IDS":ids,
                                  @"userId":sns.ldap_uid
                                  };
            
            [HttpRequest getRequestPath:kMBServerNameTypeCart methodName:@"ShoppingCartDeleteList" params:param success:^(NSDictionary *dict) {
                if ([dict[@"isSuccess"] integerValue] == 1) {
                    
                    if (indexPath) {
                        [vc.goodsArray[indexPath.section] removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
                        
                        //                        [vc.tvShoppingTrolly beginUpdates];
                        //                        [vc.tvShoppingTrolly  deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                        //                        [vc.tvShoppingTrolly endUpdates];
                        //
                        //
                        [vc.tvShoppingTrolly  beginUpdates];
                        if ([vc.goodsArray[indexPath.section] count]<=0)
                        {
                            [vc.goodsArray removeObjectAtIndex:indexPath.section];
                            [vc.tvShoppingTrolly  deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]withRowAnimation:UITableViewRowAnimationFade];
                            
                        }
                        [vc.tvShoppingTrolly  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [vc.tvShoppingTrolly  endUpdates];
                        //[vc.tvShoppingTrolly reloadData];
                        
                        if (vc.goodsArray.count<=0) {
                            vc.shoppimgTrollyNil.hidden = NO;
                            vc.shoppingTrollyNilView.hidden = NO;
                            vc.bottom_showView.hidden = YES;
                            vc.tvShoppingTrolly.hidden = YES;
                            vc.btnEdit.hidden = YES;
                        }
                    }
                    else{
                        [vc refreshTableView];
                        
                    }
                    //                        [vc.tvShoppingTrolly deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //                        [vc.tvShoppingTrolly endUpdates];
                    
                    [Toast hideToastActivity];
                    //                    [Toast makeToast:@"已删除"];
                    [Toast makeToastSuccess:@"已删除"];
                    [vc editOpration:YES];
                    [vc  calcSum];
                    
                    
                }else{
                    [Toast hideToastActivity];
                    [Toast makeToast:@"删除失败"];
                }
                
                
            } failed:^(NSError *error) {
                [Toast hideToastActivity];
                [Toast makeToast:@"删除失败"];
            }];
            
            
        }
        
        
        NSLog(@"right button clicked");
        
        
    };
    _zmAlertView.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
}

#pragma mark --收藏商品

-(void)collectionLikeDataMothel:(NSMutableArray *)collectionLikeData withIndexPath:(NSIndexPath *)indexPath{
    if (collectionLikeData == nil || collectionLikeData.count <=0) {
        [Utils alertMessage:@"请先选中商品"];
        return;
    }
    
    
    __weak MyShoppingTrollyViewController *vc = self;//收藏商品 被砍掉
    _zmAlertView = [[ZMAlertView alloc] initWithTitle:@"是否确定收藏商品?" contentText:nil leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    [_zmAlertView show];
    _zmAlertView.leftBlock = ^() {
        NSLog(@"left button clicked");
    };
    
    _zmAlertView.rightBlock = ^() {
        //
        //         NSMutableArray *sourcE_IDS = [NSMutableArray new];
        //        for (MyShoppingTrollyGoodsData *tmpdata in collectionLikeData) {
        //            [sourcE_IDS addObject:[NSNumber numberWithInteger:tmpdata.prodid.integerValue]];
        //        }
        //        [HttpRequest postRequestPath:kMBServerNameTypeOrder methodName:@"LoginUserProdClsFavorite" params:@{@"loginUserId":sns.ldap_uid,@"pageIndex":@(1),@"pageSize":@(100),@"sourcE_IDS":sourcE_IDS} success:^(NSDictionary *dict) {
        //            if ([dict[@"isSuccess"] integerValue] == 1) {
        //                NSArray *results = dict[@"results"];
        //                for (NSDictionary *favoriteDic in results) {
        //
        //                    for (int j = 0;j<collectionLikeData.count ; j++) {
        //                        MyShoppingTrollyGoodsData *tmpdaata = collectionLikeData[j];
        //                        if ([favoriteDic[@"sourcE_ID"] integerValue] == tmpdaata.prodid.integerValue) {
        //                            [collectionLikeData removeObject:tmpdaata];
        //                        }
        //                    }
        //
        //
        //                }
        //            }
        //        } failed:^(NSError *error) {
        //
        //        }];
        
        [Toast makeToastActivity:@"正在喜欢..."];
        if (collectionLikeData.count > 0) {
            NSMutableArray *favoriteList = [NSMutableArray new];
            for (MyShoppingTrollyGoodsData *data in collectionLikeData) {
                NSDictionary *param=@{
                                      @"userId":sns.ldap_uid,
                                      @"sourcE_TYPE":@(1),
                                      @"product_code": [NSNumber numberWithInteger:data.productcode.integerValue],
                                      @"creatE_USER":sns.myStaffCard.nick_name
                                      };
                [favoriteList addObject:param];
            }
            
            NSDictionary * postParam =@{@"favoriteList":favoriteList};
            
            //kMBServerNameTypeOrder
            [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCProduct methodName:@"FavoriteCreateList" params:postParam success:^(NSDictionary *dict) {
                [Toast hideToastActivity];
                
                NSLog(@"FavoriteCreateList -- %@", dict[@"message"]);
                NSString *isSuccess=[NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
                NSString *message = [NSString stringWithFormat:@"%@",dict[@"message"]];
                
                if([isSuccess boolValue]==1)
                {
                    [Toast makeToast:@"已收藏"];
                }
                else
                {
                    
                    if( [Utils getSNSString:message].length==0)
                    {
                        [Toast makeToast:@"收藏失败"];
                    }else
                    {
                        [Toast makeToast:message];
                    }
                }
                [vc.tvShoppingTrolly reloadData];
                
                
            } failed:^(NSError *error) {
                [Toast hideToastActivity];
                
                [Toast makeToast:@"收藏失败"];
            }];
            
            
            
            /*
             [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"FavoriteCreateList" params:@{@"favoriteList":favoriteList} success:^(NSDictionary *dict) {
             [Toast hideToastActivity];
             [vc.tvShoppingTrolly reloadData];
             [Toast makeToast:@"已收藏"];
             
             //                if ([dict[@"isSuccess"] integerValue] == 1) {
             //
             //                    if (indexPath) {
             //
             //                    }
             //                    else{
             //
             //
             //                    }
             //                    //                        [vc.tvShoppingTrolly deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
             //                    //                        [vc.tvShoppingTrolly endUpdates];
             //
             //                    [Toast hideToastActivity];
             //                    [Toast makeToast:@"已收藏"];
             //
             //                }else{
             //                    [Toast hideToastActivity];
             //                    [Toast makeToast:@"收藏失败"];
             //                }
             //
             } failed:^(NSError *error) {
             [Toast hideToastActivity];
             [Toast makeToast:@"收藏失败"];
             }];
             */
        }
        
        
        NSLog(@"right button clicked");
        
        
    };
    _zmAlertView.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
    
    
    
    
}


- (NSArray *)rightButtons
{
    __typeof(self) __weak weakSelf = self;
    
    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"   删除" color:[UIColor redColor] handler:^(UIButton *actionButton, JASwipeCell*cell) {
        //        [cell completePinToTopViewAnimation];
        //        [weakSelf rightMostButtonSwipeCompleted:cell];
        
        NSIndexPath *indexPath = [self.tvShoppingTrolly indexPathForCell:cell];
        NSMutableArray *removedata = [NSMutableArray new];
        [removedata addObject:weakSelf.goodsArray[indexPath.section][indexPath.row]];
        
        [weakSelf deleteDataMothel:removedata withIndexPath:indexPath];
        NSLog(@"Right Button: 删除 Pressed");
        
        
    }];
    
    //    JAActionButton *button2 = [JAActionButton actionButtonWithTitle:@"收藏" color:[UIColor colorWithHexString:@"#acacac"] handler:^(UIButton *actionButton, JASwipeCell*cell) {
    //
    //        [actionButton setTitle:@"已收藏" forState:UIControlStateNormal];
    //        NSIndexPath *indexPath = [self.tvShoppingTrolly indexPathForCell:cell];
    //        NSMutableArray *collectionLikeData = [NSMutableArray new];
    //        [collectionLikeData addObject:weakSelf.goodsArray[indexPath.section][indexPath.row]];
    //         [self collectionLikeDataMothel:collectionLikeData withIndexPath:indexPath];
    //        NSLog(@"Right Button: 收藏 Pressed");
    //    }];
    //    JAActionButton *button3 = [JAActionButton actionButtonWithTitle:@"More" color:kMoreButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
    //        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"More Options" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Option 1" otherButtonTitles:@"Option 2",nil];
    //        [sheet showInView:weakSelf.view];
    //        NSLog(@"Right Button: More Pressed");
    //    }];
    
    return @[button1];//, button2
}

-(void)refreshTableView
{
    //    [Toast makeToastActivity:@"正在加载"];
    [Toast makeToastActivity:@"正在获取数据" hasMusk:NO];
    
    
    [HttpRequest getRequestPath:kMBServerNameTypeCart methodName:@"ShoppingCartFilter"
                         params:@{@"userId":sns.ldap_uid} success:^(NSDictionary *dict) {
                             if ([dict[@"isSuccess"] integerValue] == 1)
                             {
                                 
                                 for (NSMutableArray *rArr in goodsArray)
                                 {
                                     [rArr removeAllObjects];
                                 }
                                 [goodsArray removeAllObjects];
                                 
                                 NSMutableArray *list = dict[@"results"];
                                 int validDataCount=0;
                                 for (int i=0;i<list.count;i++)
                                 {
                                     MyShoppingTrollyGoodsData *newdata=[[MyShoppingTrollyGoodsData alloc] init];
                                     newdata.value=list[i];
                                     //                    //过滤无效数据
                                     //                    if (newdata.designerid.length==0||newdata.prodid.length==0)
                                     //                    {
                                     //                        continue;
                                     //                    }
                                     validDataCount++;
                                     
                                     // add buy miao 解决库存
                                     if (newdata.listqty>=0) {
                                         newdata.stocknum = newdata.listqty;
                                     }
                                     
                                     BOOL isNewData=YES;
                                     for (int c=0;c<goodsArray.count;c++)
                                     {
                                         NSMutableArray *rowArray=goodsArray[c];
                                         if (rowArray.count>0)
                                         {
                                             MyShoppingTrollyGoodsData *data=rowArray[0];//designerid
                                             
                                             if ([[Utils getSNSString:[NSString stringWithFormat:@"%@",data.platFormInfo.promotionId]] isEqualToString:[Utils getSNSString:[NSString stringWithFormat:@"%@",newdata.platFormInfo.promotionId]]]&&[[Utils getSNSString:[NSString stringWithFormat:@"%@",data.collocationid]] isEqualToString:[Utils getSNSString:[NSString stringWithFormat:@"%@",newdata.collocationid]]])
                                             {
                                                 
                                                 isNewData=NO;
                                                 
                                                 [rowArray addObject:newdata];
                                             }
                                             
                                             
                                         }
                                     }
                                     if (isNewData)
                                     {
                                         NSMutableArray *rowArray=[[NSMutableArray alloc] init];
                                         [rowArray addObject:newdata];
                                         
                                         [goodsArray addObject:rowArray];
                                     }
                                 }
                                 
                                 if (validDataCount>0)
                                     btnEdit.hidden=NO;
                                 
                                 //购物车为空时，显示图片
                                 if (goodsArray.count == 0) {
                                     _shoppimgTrollyNil.hidden = NO;
                                     _shoppingTrollyNilView.hidden = NO;
                                     _bottom_showView.hidden = YES;
                                     _tvShoppingTrolly.hidden = YES;
                                     btnEdit.hidden = YES;
                                 }
                                 else
                                 {
                                     _shoppimgTrollyNil.hidden = YES;
                                     _shoppingTrollyNilView.hidden = YES;
                                     _bottom_showView.hidden = NO;
                                     _tvShoppingTrolly.hidden = NO;
                                     btnEdit.hidden = NO;
                                 }
                                 
                             }else{
                                 
                                 [self initNoDataView];
                                 
                             }
                             
                             [_tvShoppingTrolly reloadData];
                             //            float totalprice = [MyShoppingTrollyGoodsData totalPrice:goodsArray];
                             _lbSum.text=[NSString stringWithFormat:@"合计: ￥0"];
                             _lbTrans.text=[NSString stringWithFormat:@" 不含运费"];
                             //                             if (_lbTrans==nil) {
                             //
                             //                             }else
                             //                             {
                             //                                 NSMutableAttributedString *attrbutdestring = [[NSMutableAttributedString alloc]initWithString: _lbTrans.text];
                             //
                             //                                 [attrbutdestring addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                             //                                                                  NSForegroundColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                             //                                                                  NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                             //                                                                  NSFontAttributeName:FONT_t7
                             //                                                                  }range:NSMakeRange(0, _lbTrans.text.length-5)];
                             //
                             //                                 _lbTrans.attributedText =attrbutdestring;
                             //
                             //                             }
                             
                             _btnSelectedAll.selected=NO;
                             if (_btnSelectedAll.selected) {
                                 [_btnSelectedAll setImage:[UIImage imageNamed:@"Unico/present_uncheck"] forState:UIControlStateSelected];
                                 
                             }else{
                                 [_btnSelectedAll setImage:[UIImage imageNamed:@"Unico/uncheck_zero"] forState:UIControlStateNormal];
                             }
                             
                             
                             [Toast hideToastActivity];
                         } failed:^(NSError *error) {
                             [Toast hideToastActivity];
                         }];
    
}
-(void)initNoDataView
{
    
    UIView * noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) WithImage:NONE_DATA_ORDER andImgSize:CGSizeMake(39, 50) andTipString:@"数据异常" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];
    [self.view addSubview:noneDataView];
    
}
#pragma mark -- 支付按钮
- (IBAction)btnPayClick:(id)sender {
    [TalkingData trackEvent:@"购物袋页面" label:@"点击'立即购买'"];
    if (isNotRequestFinish) {
        return;
    }
    NSMutableArray *payList=[[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0;i<goodsArray.count;i++)
    {
        NSArray *rowArray=goodsArray[i];
        for (MyShoppingTrollyGoodsData *data in rowArray) {
            if (data.selected==YES)
            {
                if (data.status!=2)
                {
                    [Utils alertMessage:@"商品已下架!"];
                    NSString *messageString = data.lM_PROD_CLS_ID? data.lM_PROD_CLS_ID: @"异常数据";
                    [TalkingData trackEvent:@"购物袋页面" label:@"购买失败(商品已下架)" parameters:@{@"下架商品ID": messageString}];
                    return;
                }
                [payList addObject:data];
            }
        }
    }
    if (payList.count==0)
    {
        [Utils alertMessage:@"请您选择商品后再购买！"];
        [TalkingData trackEvent:@"购物袋页面" label:@"购买失败(未选择商品)"];
        return;
    }
    [Toast makeToastActivity:@"核对商品数量..." hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL isNoStock=NO;
            NSMutableString *msgstr=[[NSMutableString alloc] initWithFormat:@"商品库存不足！\n"];
            NSMutableArray *noneDataArray = [NSMutableArray array];
            for (int i=0;i<payList.count;i++)
            {
                MyShoppingTrollyGoodsData *data = payList[i];
                if (data.number> data.listqty)
                {
                    NSString *messageString = data.lM_PROD_CLS_ID? data.lM_PROD_CLS_ID: @"异常数据";
                    [noneDataArray addObject:messageString];
                    [msgstr appendString:[NSString stringWithFormat:@"【%@】\n",data.prodname]];
                    isNoStock=YES;
                }
            }
            if (isNoStock)
            {
                [TalkingData trackEvent:@"购物袋页面" label:@"购买失败(库存不足)" parameters:@{@"库存不足商品ID数组": noneDataArray}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    [self refreshTableView];
                    [Utils alertMessage:msgstr];
                });
                return;
            }
            [TalkingData trackEvent:@"购物袋页面" label:@"购买成功(跳转确认订单页面)"];
            MBCreateGoodsOrderViewController *orderVC=[[MBCreateGoodsOrderViewController alloc] initWithNibName:@"MBCreateGoodsOrderViewController" bundle:nil];
            orderVC.goodsArray=payList;
            orderVC.sumInfo=nil;
            NSString *totalMoney=[NSString stringWithFormat:@"%@",_lbSum.text];
            NSArray *totalArray =[totalMoney componentsSeparatedByString:@"合计: ￥"];
            NSString *numberTotal=[NSString stringWithFormat:@"%@",[totalArray lastObject]];
            
            orderVC.totalMoney = numberTotal;
            
            [Toast hideToastActivity];
            
            [self.navigationController pushViewController:orderVC animated:YES];
        });
    });
}

#pragma mark -- 全选按钮
- (IBAction)btnSelectedAll:(id)sender {
    
    _btnSelectedAll.selected=!_btnSelectedAll.selected;
    double totalprice = 0;
    double maketAllPrice = 0;
    for (int i=0;i<goodsArray.count;i++)
    {
        NSArray *rowArray=goodsArray[i];
        for (MyShoppingTrollyGoodsData *data in rowArray)
        {
            if ([data isUsed])
            {
                data.selected = _btnSelectedAll.selected;
                
                if (data.prodInfo == nil) {
                    totalprice+=data.saleprice * (double)data.number;
                    maketAllPrice+=data.price *(double)data.number;
                    
                }else{
                    double salePrice = (int)(data.saleprice * 100)/ 100.0;
                    double disPrice = (int)(data.prodInfo.spec_price.doubleValue * 100)/ 100.0;
                    if (salePrice >= disPrice) {
                        //                        totalprice+=(data.saleprice - data.prodInfo.dec_price.doubleValue) * (double)data.number;
                        totalprice+=[data.prodInfo.total_price doubleValue];
                        maketAllPrice += [data.prodInfo.market_price doubleValue];
                        
                    }else{
                        totalprice+=data.saleprice*(float)data.number;
                        maketAllPrice += data.price *(float)data.number;
                    }
                    
                }
                
            }
            else
                data.selected=NO; //不能使用
        }
    }
    
    if (_btnSelectedAll.selected==NO)
    {
        _lbSum.text=[NSString stringWithFormat:@"合计: ￥0"];
        _lbTrans.text=[NSString stringWithFormat:@"不含运费"];
    }
    else
    {
        NSString *totalPriceStr = [NSString stringWithFormat:@"%.2f",totalprice];
        //        NSString *marketPriceStr = [NSString stringWithFormat:@"%.2f",maketAllPrice];
        
        _lbSum.text=[NSString stringWithFormat:@"合计: ￥%@", [Utils getSNSRMBMoneyWithoutMark:totalPriceStr]];
        _lbTrans.text=[NSString stringWithFormat:@" 不含运费"];
        //        if ([totalPriceStr floatValue]>=[marketPriceStr floatValue]) {
        //            _lbTrans.text=[NSString stringWithFormat:@" 不含运费"];
        //        }
        //        else
        //        {
        //            _lbTrans.text=[NSString stringWithFormat:@"¥%@ 不含运费",[Utils getSNSRMBMoneyWithoutMark:marketPriceStr]];
        //        }
        
        //        _lbSum.text=[NSString stringWithFormat:@"商品合计: ￥%0.2f",totalprice];
    }
    
    
    [_tvShoppingTrolly reloadData];
    
    if (_btnSelectedAll.selected) {
        [_btnSelectedAll setImage:[UIImage imageNamed:@"Unico/present_uncheck"] forState:UIControlStateSelected];
        
    }else{
        [_btnSelectedAll setImage:[UIImage imageNamed:@"Unico/uncheck_zero"] forState:UIControlStateNormal];
    }
    
    //add by miao 6.8 3点击全选
    
    for (int i=0;i<goodsArray.count;i++)
    {
        PlatFormInfo *tmpPlatFormInfo = nil;
        NSArray *rowArray=goodsArray[i];
        for (MyShoppingTrollyGoodsData *data in  rowArray)
        {
            if ([data isUsed])
            {
                if (data.selected==YES)
                {
                    if (data.platFormInfo) {
                        
                        tmpPlatFormInfo = data.platFormInfo;
                        break;
                    }
                }
                
            }
        }
        
        
        if (tmpPlatFormInfo)
        {
            NSMutableArray *tmparray = [NSMutableArray new];
            for (MyShoppingTrollyGoodsData *data in  rowArray)
            {
                if ([data isUsed])
                {
                    if (data.selected==YES)
                    {
                        data.platFormInfo = tmpPlatFormInfo;
                        [tmparray addObject:data];
                    }
                    
                }
            }
            
            if (tmparray.count > 0) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    
                    [requestlock lock];
                    
                    [self requestGoodsCouponDataWithdataArray:tmparray];
                    
                    sleep(2.5f);
                    [Toast hideToastActivity];
                    [requestlock unlock];
                });
            }
        }
    }
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backHome:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)calcSum
{
    float val=0;
    float allPrice = 0;//所有标价
    BOOL isSelectedAll=YES;
    
    for (int i=0;i<goodsArray.count;i++)
    {
        NSArray *rowArray=goodsArray[i];
        for (MyShoppingTrollyGoodsData *data in rowArray)
        {
            if ([data isUsed])
            {
                if (data.selected==NO)
                {
                    isSelectedAll=NO;
                }
                else
                {
                    if (data.prodInfo == nil) {
                        val+=data.saleprice*(float)data.number;
                        allPrice += data.price *(float)data.number;
                    }else{
                        val+=[data.prodInfo.total_price doubleValue];
                        allPrice+=[data.prodInfo.market_price doubleValue];
                        
                        /*
                         不需要算  直接取totalprice
                         double salePrice = (int)(data.saleprice * 100)/ 100.0;
                         double disPrice = (int)(data.prodInfo.dec_price.doubleValue * 100)/ 100.0;
                         if (salePrice >= disPrice) {
                         val+=(data.saleprice - data.prodInfo.dec_price.floatValue)*(float)data.number;
                         }else{
                         val+=data.saleprice*(float)data.number;
                         }
                         */
                        
                    }
                }
            }
        }
    }
    NSString *totalPriceStr = [NSString stringWithFormat:@"%.2f",val];
    //    NSString *allPriceStr = [NSString stringWithFormat:@"%.2f",allPrice];
    
    _lbSum.text=[NSString stringWithFormat:@"合计: ￥%@", [Utils getSNSRMBMoneyWithoutMark:totalPriceStr]];
    _lbTrans.text=[NSString stringWithFormat:@" 不含运费"];
    
    //    if ([totalPriceStr floatValue]>=[allPriceStr floatValue]) {
    //      _lbTrans.text=[NSString stringWithFormat:@" 不含运费"];
    //    }
    //    else
    //    {
    //         _lbTrans.text=[NSString stringWithFormat:@"¥%@ 不含运费",[Utils getSNSRMBMoneyWithoutMark:allPriceStr]];
    //        NSMutableAttributedString *attrbutdestring = [[NSMutableAttributedString alloc]initWithString: _lbTrans.text];
    //
    //        [attrbutdestring addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
    //                                         NSForegroundColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
    //                                         NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
    //                                         NSFontAttributeName:FONT_t7
    //                                         }range:NSMakeRange(0, _lbTrans.text.length-5)];
    //
    //        _lbTrans.attributedText =attrbutdestring;
    //    }
    
    
    
    
    //    _lbSum.text=[NSString stringWithFormat:@"商品合计: ￥%0.2f",val];
    _btnSelectedAll.selected=isSelectedAll;
    
    if([goodsArray count]==0)
    {
        _btnSelectedAll.selected=NO;
    }
    if (_btnSelectedAll.selected) {
        [_btnSelectedAll setImage:[UIImage imageNamed:@"Unico/present_uncheck"] forState:UIControlStateSelected];
        
    }else{
        [_btnSelectedAll setImage:[UIImage imageNamed:@"Unico/uncheck_zero"] forState:UIControlStateNormal];
        
    }
}

#pragma mark - cell delegate
#pragma mark -- cell按钮选择    tableViewCellDelegate
-(void)goodsSelectButtonClick:(id)sender button:(UIButton *)button
{
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"Unico/present_uncheck"] forState:UIControlStateSelected];
        
    }else{
        
        [button setImage:[UIImage imageNamed:@"Unico/uncheck_zero"] forState:UIControlStateNormal];
    }
    MyShoppingTrollyGoodsTableViewCell *cell=sender;
    MyShoppingTrollyGoodsData *data = goodsArray[cell.indexPath.section][cell.indexPath.row];
    data.selected=button.selected;
    //    data.platFormInfo =
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.indexPath.row inSection:cell.indexPath.section];
    //    NSArray *arr=[[NSArray alloc] initWithObjects:indexPath, nil];
    //    [_tvShoppingTrolly reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
    //    MyShoppingTrollyGoodsTableHeaderView *headerView = (MyShoppingTrollyGoodsTableHeaderView *)[self tableView:_tvShoppingTrolly viewForHeaderInSection:indexPath.section];
    //add by miao 6.8 1.点击单个cell
    PlatFormInfo *tmpPlatFormInfo = nil;
    for (MyShoppingTrollyGoodsData *data in  goodsArray[cell.indexPath.section])
    {
        if ([data isUsed])
        {
            if (data.selected==YES)
            {
                if (data.platFormInfo) {
                    
                    tmpPlatFormInfo = data.platFormInfo;
                    break;
                }
            }
            
        }
    }
    
    if (tmpPlatFormInfo)
    {
        NSMutableArray *tmparray = [NSMutableArray new];
        for (MyShoppingTrollyGoodsData *data in  goodsArray[cell.indexPath.section])
        {
            if ([data isUsed])
            {
                if (data.selected==YES)
                {
                    //只有有活动的 才请求 wwp
                    if (data.platFormInfo) {
                        [tmparray addObject:data];
                    }
                    //                        data.platFormInfo = tmpPlatFormInfo;
                    //                        [tmparray addObject:data];
                }
            }
        }
        
        if (tmparray.count > 0) {
            [self requestGoodsCouponDataWithdataArray:tmparray];
        }
        
    }else{
        [self calcSum];
        [_tvShoppingTrolly reloadData];
    }
}

#pragma mark -
#pragma mark - 弹出视图
- (void)popDetailViewBtnClick:(id)sender btn:(UIButton *)btn WithIndexPath:(NSIndexPath *)indexPath
{
    //    _currentIndexPath = indexPath;
    if(_currentIndexPath==nil)
    {
        _currentIndexPath = indexPath;
        //        if (!_goodCollectionVc) {
        __block MyShoppingTrollyGoodsData *data = goodsArray[indexPath.section][indexPath.row];
        __weak MyShoppingTrollyViewController *weakSelf = self;
        
        _goodCollectionVc = [[GoodCollectionController alloc] initWithParameter:data];
        _goodCollectionVc.block = ^(NSDictionary *dict){
            data.sizename = dict[@"size"];
            data.colorname = dict[@"color"];
            data.imageurl = dict[@"coloR_FILE_PATH"];
            
            [weakSelf.tvShoppingTrolly reloadData];
        };
    }
    else
    {
        if (![_currentIndexPath isEqual:indexPath]) {
            _currentIndexPath = indexPath;
            //        if (!_goodCollectionVc) {
            NSLog(@"11111111______%@", indexPath);
            __block MyShoppingTrollyGoodsData *data = goodsArray[indexPath.section][indexPath.row];
            __weak MyShoppingTrollyViewController *weakSelf = self;
            
            _goodCollectionVc = [[GoodCollectionController alloc] initWithParameter:data];
            _goodCollectionVc.block = ^(NSDictionary *dict){
                data.sizename = dict[@"size"];
                data.colorname = dict[@"color"];
                data.imageurl = dict[@"coloR_FILE_PATH"];
                [weakSelf.tvShoppingTrolly reloadData];
            };
            _goodCollectionVc.delegate = self;
            //        }
            
        }
    }
    [_goodCollectionVc showInView:self.navigationController.view];
    
    //    NSIndexPath *tempIndexPath = _currentIndexPath;
    //    __weak MyShoppingTrollyViewController *weakSelf = self;
    _goodCollectionVc.changeBtnState = ^{
        /*     NSIndexPath *indexPath = tempIndexPath;
         if (tempIndexPath.length==0) {
         return ;
         }
         MyShoppingTrollyGoodsTableViewCell *cell = (MyShoppingTrollyGoodsTableViewCell *)[weakSelf.tvShoppingTrolly cellForRowAtIndexPath:indexPath];
         [cell changePopBtnStatusWithBtn:cell.popBtn];*/
        btn.selected = !btn.selected;
        
    };
}

#pragma mark - 用通知中心改变箭头的方向，ps:处理不是很自然
/*- (void)arrowDirectionChange
 {
 NSIndexPath *indexPath = _currentIndexPath;
 if (_currentIndexPath.length==0) {
 return ;
 }
 MyShoppingTrollyGoodsTableViewCell *cell = (MyShoppingTrollyGoodsTableViewCell *)[_tvShoppingTrolly cellForRowAtIndexPath:indexPath];
 [cell changePopBtnStatusWithBtn:cell.popBtn];
 
 }*/

#pragma mark - GoodCollectionController代理方法
/*- (void)goodsCollectionController:(GoodCollectionController *)goodCollectionVC cancaelClicked:(UIButton *)cancaelBtn
 {
 [goodCollectionVC hide];
 }*/

- (void)goodsCollectionController:(GoodCollectionController *)goodCollectionVC doneClicked:(UIButton *)doneBtn
{
    [goodCollectionVC hide];
}

#pragma mark -
-(void)headerSelectAllButtonClick:(id)sender button:(UIButton *)button sectionIndex:(int)sectionIndex
{
    MyShoppingTrollyGoodsTableHeaderView *headerview=sender;
    
    headerview.btnSelected.selected=!headerview.btnSelected.selected;
    for (MyShoppingTrollyGoodsData *data in goodsArray[headerview.sectionIndex])
    {
        if ([data isUsed])
            data.selected=headerview.btnSelected.selected;
        else
            data.selected=NO;
    }
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"Unico/present_uncheck"] forState:UIControlStateSelected];
        
    }else{
        [button setImage:[UIImage imageNamed:@"Unico/uncheck_zero"] forState:UIControlStateNormal];
        
    }
    
    //add by miao 6.8 2.点击header
    PlatFormInfo *tmpPlatFormInfo = nil;
    for (MyShoppingTrollyGoodsData *data in  goodsArray[sectionIndex])
    {
        if ([data isUsed])
        {
            if (data.selected==YES)
            {
                if (data.platFormInfo) {
                    
                    tmpPlatFormInfo = data.platFormInfo;
                    break;
                }
            }
            
        }
    }
    
    if (tmpPlatFormInfo)
    {
        NSMutableArray *tmparray = [NSMutableArray new];
        for (MyShoppingTrollyGoodsData *data in  goodsArray[sectionIndex])
        {
            if ([data isUsed])
            {
                if (data.selected==YES)
                {                   //只有有活动的 才请求 wwp
                    if (data.platFormInfo) {
                        [tmparray addObject:data];
                    }
                    //                        data.platFormInfo = tmpPlatFormInfo;
                    //                        [tmparray addObject:data];
                }
                
            }
        }
        if (tmparray.count>0) {
            [self requestGoodsCouponDataWithdataArray:tmparray];
        }
        
    }else{
        [self calcSum];
        
        [_tvShoppingTrolly reloadData];
    }
    
    
    
}

-(BOOL)isHeaderSelectedDesigner:(NSArray *)arr
{
    BOOL selected=YES;
    for (MyShoppingTrollyGoodsData *data in arr)
    {
        if ([data isUsed])
        {
            if (data.selected==NO)
            {
                selected=NO;
                break;
            }
        }
    }
    return selected;
}

-(BOOL)isHeaderExistUsed:(NSArray *)arr
{
    BOOL existUsed=NO;
    for (MyShoppingTrollyGoodsData *data in arr)
    {
        if ([data isUsed])
        {
            existUsed=YES;
        }
    }
    return existUsed;
}


#pragma mark - cell delegate methods(增加数量)

-(void)buyNumberChanged:(id)sender number:(int)number
{
    MyShoppingTrollyGoodsTableViewCell *cell=sender;
    MyShoppingTrollyGoodsData *data = goodsArray[cell.indexPath.section][cell.indexPath.row];
    currentRow = cell.indexPath.row;
    currentSection = cell.indexPath.section;
    //如果修改的数量与data里的number不一样 则进入更新数量
    
    if (number!=data.number)
    {
        data.number=number;
        
        
        [HttpRequest getRequestPath:kMBServerNameTypeCart methodName:@"ShoppingCartUpdate" params:@{@"ID":data.shoppingcartid, @"QTY":@(data.number),@"userId":sns.ldap_uid} success:^(NSDictionary *dict) {
            [Toast hideToastActivity];
        } failed:^(NSError *error) {
            [Toast hideToastActivity];
        }];
        
        /*
         [HttpRequest postRequestPath:kMBServerNameTypeCart methodName:@"ShoppingCartUpdate" params:@{@"ID":data.shoppingcartid, @"QTY":@(data.number),@"userId":sns.ldap_uid} success:^(NSDictionary *dict) {
         [Toast hideToastActivity];
         
         } failed:^(NSError *error) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
         [Toast hideToastActivity];
         });
         
         }];
         */
        
        
        //add by miao 6.8 2.点击header
        PlatFormInfo *tmpPlatFormInfo = nil;
        for (MyShoppingTrollyGoodsData *data in  goodsArray[cell.indexPath.section])
        {
            if ([data isUsed])
            {
                if (data.selected==YES)
                {
                    if (data.platFormInfo) {
                        
                        tmpPlatFormInfo = data.platFormInfo;
                        break;
                    }
                }
                
            }
        }
        
        if (tmpPlatFormInfo)
        {
            NSMutableArray *tmparray = [NSMutableArray new];
            for (MyShoppingTrollyGoodsData *data in  goodsArray[cell.indexPath.section])
            {
                if ([data isUsed])
                {
                    if (data.selected==YES)
                    {
                        data.platFormInfo = tmpPlatFormInfo;
                        [tmparray addObject:data];
                        
                    }
                    
                }
            }
            if (tmparray.count>0) {
                [self requestGoodsCouponDataWithdataArray:tmparray];
            }
            
        }else{
            //            [_tvShoppingTrolly reloadData];
            [self calcSum];
        }
    }
}

#pragma mark -
#pragma mark tableViewDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [goodsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [goodsArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AIdentifier=@"MyShoppingTrollyGoodsTableViewCell";
    MyShoppingTrollyGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier forIndexPath:indexPath] ;
    
    cell.delegate=self;
    //cell.delegate_JA = self;
    // 删除按钮
    
    //    [cell addActionButtons:[self rightButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
    //
    //    [cell setNeedsLayout];
    //    [cell setNeedsUpdateConstraints];
    //    [cell updateConstraintsIfNeeded];
    
    
    
    if ([goodsArray[indexPath.section] count]!=0) {
        [cell setGoodsData:goodsArray[indexPath.section][indexPath.row]];
    }
    
    cell.indexPath=indexPath;
    
    if (cell.btnSelectGoods.selected) {
        [cell.btnSelectGoods setImage:[UIImage imageNamed:@"Unico/present_uncheck"] forState:UIControlStateSelected];
    } else {
        [cell.btnSelectGoods setImage:[UIImage imageNamed:@"Unico/uncheck_zero"] forState:UIControlStateNormal];
    }
    
    // add
    if (isShowEditButton) {
        // 完成状态下;
        cell.lbName.hidden = NO;
        cell.lbNumber.hidden = NO;
        cell.goodsNum.hidden = YES;
        cell.lbNum.hidden = NO;
        cell.popBtn.hidden = YES;
        cell.deleteButton.hidden = YES;
        [cell lbclolrAddpopBtn:NO];
    } else {
        // 编辑状态下;
        cell.lbName.hidden = YES;
        cell.lbNumber.hidden = YES;
        cell.goodsNum.hidden = NO;
        cell.lbNum.hidden = YES;
        cell.deleteButton.hidden = NO;
        [cell lbclolrAddpopBtn:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *AIdentifier=@"MyShoppingTrollyGoodsTableHeaderView";
    MyShoppingTrollyGoodsTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AIdentifier];
    if (view == nil) {
        view = [[[NSBundle mainBundle] loadNibNamed:AIdentifier owner:self options:nil] objectAtIndex:0];
        view.delegate=self;
    }
    
    view.btnSelected.hidden=![self isHeaderExistUsed:goodsArray[section]];
    view.btnSelected.selected=[self isHeaderSelectedDesigner:goodsArray[section]];
    
    if (view.btnSelected.selected) {
        [view.btnSelected setImage:[UIImage imageNamed:@"Unico/present_uncheck"] forState:UIControlStateSelected];
        
    }else{
        [view.btnSelected setImage:[UIImage imageNamed:@"Unico/uncheck_zero"] forState:UIControlStateNormal];
        
    }
    view.sectionIndex=(int)section;
    
    MyShoppingTrollyGoodsData *data = goodsArray[section][0];
    view.platFormInfo = data.platFormInfo;
    
    float val=0;
    for (MyShoppingTrollyGoodsData *data in goodsArray[section])
    {
        if ([data isUsed])
        {
            if (data.selected)
            {
                if (data.prodInfo == nil) {
                    val+=data.saleprice*(float)data.number;
                }else{
                    
                    if (view.platFormBasicInfo == nil) {
                        PlatFormBasicInfo *tmpPlatFormBasicInfo = [PlatFormBasicInfo new];
                        tmpPlatFormBasicInfo.code = [NSString stringWithFormat:@"%@",data.platFormInfo.promotionId];
                        tmpPlatFormBasicInfo.web_url=[NSString stringWithFormat:@"%@",data.platFormInfo.web_url];
                        tmpPlatFormBasicInfo.activityName =[NSString stringWithFormat:@"%@",data.platFormInfo.promName];
                        view.platFormBasicInfo = tmpPlatFormBasicInfo;
                        
                        
                    }else{
                        view.platFormBasicInfo.code = [NSString stringWithFormat:@"%@",data.platFormInfo.promotionId];
                        view.platFormBasicInfo.web_url =[NSString stringWithFormat:@"%@",data.platFormInfo.web_url];
                        view.platFormBasicInfo.activityName =[NSString stringWithFormat:@"%@",data.platFormInfo.promName];
                        
                    }
                    
                    
                    if (data.saleprice >= data.prodInfo.spec_price.floatValue) {
                        //                        val+=(data.saleprice - data.prodInfo.dec_price.floatValue)*(float)data.number;
                        val += [data.prodInfo.total_price floatValue];
                    }else{
                        val+=data.saleprice*(float)data.number;
                    }
                    
                    //                    if (data.saleprice >= data.prodInfo.dec_price.floatValue) {
                    //                        val+=(data.saleprice - data.prodInfo.dec_price.floatValue)*(float)data.number;
                    //                    }else{
                    //                        val+=data.saleprice*(float)data.number;
                    //                    }
                    //
                }
                
            }
        }
    }
    
    NSString *valPriceStr = [NSString stringWithFormat:@"%.2f",val];
    if (view.platFormInfo == nil) {
        
        view.lbName.text=[NSString stringWithFormat:@"套装合计: ￥%@", [Utils getSNSRMBMoneyWithoutMark:valPriceStr]];
        view.arrowRightImgView.hidden=YES;
        //        view.lbName.text=[[NSString alloc] initWithFormat:@"套装合计:￥%0.2f",val];
        
    }else{
        view.arrowRightImgView.hidden=NO;
        if ([NSString stringWithFormat:@"%@",view.platFormInfo.platPromId].length == 0) {
            view.lbName.text=[[NSString alloc] initWithFormat:@"全场活动"];
        }
        else{
            
            view.lbName.text=[NSString stringWithFormat:@"套装合计: ￥%@", [Utils getSNSRMBMoneyWithoutMark:valPriceStr]];
            //             view.lbName.text=[[NSString alloc] initWithFormat:@"套装合计:￥%0.2f",val];
        }
    }
    
    if (view.platFormInfo.promName) {
        view.lbSum.text = [NSString stringWithFormat:@"%@",view.platFormInfo.promName];
    }else{
        //     view.lbSum.text = @"活动优惠";
    }
    
    
    //    view.lbSum.textColor = COLOR_C1;//[UIColor colorWithHexString:@"#ffde00"];
    view.lbName.font = FONT_T3;
    view.lbName.textColor = COLOR_C2;
    
    view.lbSum.font = FONT_t6;
    view.lbSum.textColor = UIColorFromRGB(0xffc13c);
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MyShoppingTrollyGoodsData *data=goodsArray[indexPath.section][indexPath.row];
    SProductDetailViewController *goodDetailVC = [SProductDetailViewController new];
#warning  要传商品的code
    //    goodDetailVC.productID = data.lM_PROD_CLS_ID;
    goodDetailVC.productID = [NSString stringWithFormat:@"%@",data.productcode];
    [self pushController:goodDetailVC animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"----------isshoweditbutton------%hhd",isShowEditButton);
    if (isShowEditButton)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;//UITableViewCellEditingStyleDelete
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        __typeof(self) __weak weakSelf = self;
        NSMutableArray *removedata = [NSMutableArray new];
        [removedata addObject:weakSelf.goodsArray[indexPath.section][indexPath.row]];
        [weakSelf deleteDataMothel:removedata withIndexPath:indexPath];
        
        //        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"删除提示" message:@"是否从购物车删除该商品？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        //        [alertView show];
        /*
         __weak MyShoppingTrollyViewController *vc = self;
         _zmAlertView = [[ZMAlertView alloc] initWithTitle:@"是否确定删除商品?" contentText:nil leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
         [_zmAlertView show];
         _zmAlertView.leftBlock = ^() {
         NSLog(@"left button clicked");
         };
         _zmAlertView.rightBlock = ^() {
         [Toast makeToastActivity:@"正在删除..." hasMusk:NO];
         
         vc.shTrGoodsData = vc.goodsArray[indexPath.section][indexPath.row];
         NSLog(@"shTrGoodsData: %@",vc.shTrGoodsData);
         NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
         NSDictionary *param=@{
         @"ID":vc.shTrGoodsData.shoppingcartid,
         @"UserId":sns.ldap_uid
         };
         
         [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"ShoppingCartDelete" params:param success:^(NSDictionary *dict) {
         
         if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
         {
         [Toast hideToastActivity];
         [vc.goodsArray[indexPath.section] removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
         if ([vc.goodsArray[indexPath.section] count]==0)
         {
         [vc.goodsArray removeObjectAtIndex:indexPath.section];
         
         }
         [vc.tvShoppingTrolly reloadData];
         
         //                    if (!vc.goodsArray) {
         //                        vc.shoppimgTrollyNil.hidden = NO;
         //                        vc.shoppingTrollyNilView.hidden = NO;
         //                        vc.bottom_showView.hidden = YES;
         //                        vc.tvShoppingTrolly.hidden = YES;
         //                    }
         
         [Toast makeToastSuccess:@"已删除"];
         [vc editOpration:YES];
         [vc calcSum];
         }
         else
         {
         [Toast hideToastActivity];
         [Toast makeToast:@"删除失败"];
         }
         
         
         } failed:^(NSError *error) {
         
         [Toast hideToastActivity];
         [Toast makeToast:@"删除失败"];
         
         }];
         //
         //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         //
         //                vc.shTrGoodsData = vc.goodsArray[indexPath.section][indexPath.row];
         //                NSLog(@"%@",vc.shTrGoodsData);
         //                NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
         //                NSDictionary *param=@{
         //                                      @"ID":vc.shTrGoodsData.shoppingcartid,
         //                                      @"UserId":sns.ldap_uid
         //                                      };
         //
         //
         //
         //
         //                BOOL suc=[SHOPPING_GUIDE_ITF requestPostUrlName:@"ShoppingCartDelete" param:param responseAll:nil responseMsg:msg];
         //
         //                if (suc)
         //                {
         //                    dispatch_async(dispatch_get_main_queue(), ^{
         //                        [Toast hideToastActivity];
         //                        [vc.goodsArray[indexPath.section] removeObjectAtIndex:[indexPath row]];  删除数组里的数据
         //                        if ([vc.goodsArray[indexPath.section] count]==0)
         //                        {
         //                            [vc.goodsArray removeObjectAtIndex:indexPath.section];
         //
         //                        }
         //                         [vc.tvShoppingTrolly reloadData];
         //
         //                        [Toast makeToast:@"已删除"];//rstSt
         //                           [Toast makeToastSuccess:@"已删除"];
         //                            [vc editOpration:YES];
         //                           [vc calcSum];
         //
         //                    });
         //                }
         //                else
         //                {
         //                    dispatch_async(dispatch_get_main_queue(), ^{
         //                        [Toast hideToastActivity];
         //                        [Toast makeToast:@"删除失败"];
         //                    });
         //                }
         //            });
         //
         
         NSLog(@"right button clicked");
         
         
         };
         _zmAlertView.dismissBlock = ^() {
         NSLog(@"Do something interesting after dismiss block");
         };
         */
    }
}

-(void)netConnectMessage:(NSString *)msg
{
    [self hideToast];
    if (msg==nil || [@"" isEqualToString:msg]) {
        msg=@"无法连接服务器，请稍后重试！";
    }
    [Toast makeToast:msg];
    [self timerHideToast];
}

- (void)timerHideToast {
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                   selector:@selector(hideToast)
                                   userInfo:nil repeats:NO];
}

- (void)hideToast {
    [Toast hideToastActivity];
}

#pragma mark MyShoppingTrollyGoodsClickDelegate
-(void)productDeleteBtnClick:(id)sender WithIndexPath:(NSIndexPath *)indexPath{
    __typeof(self) __weak vc = self;
    NSMutableArray *removeData = [NSMutableArray new];
    [removeData addObject:vc.goodsArray[indexPath.section][indexPath.row]];
    //[weakSelf deleteDataMothel:removedata withIndexPath:indexPath];
    
    
    
    if (removeData == nil || removeData.count <=0) {
        [Utils alertMessage:@"请先选中商品"];
        return;
    }
    _zmAlertView = [[ZMAlertView alloc] initWithTitle:@"是否确定删除商品?" contentText:nil leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    [_zmAlertView show];
    _zmAlertView.leftBlock = ^() {
        NSLog(@"left button clicked");
    };
    
    _zmAlertView.rightBlock = ^() {
        [Toast makeToastActivity:@"正在删除..." hasMusk:NO];
        //        NSMutableString *ids = [NSMutableString new];;
        if (removeData.count > 0) {
            NSMutableArray *idsArray = [[NSMutableArray alloc]init];
            
            for (MyShoppingTrollyGoodsData *data in removeData) {
                
                //                [ids appendString:[NSString stringWithFormat:@"%@,",data.shoppingcartid]];
                [idsArray addObject:[NSString stringWithFormat:@"%@",data.shoppingcartid]];
                
            }
            NSString *ids = [idsArray componentsJoinedByString:@","];
            
            NSDictionary *param=@{
                                  @"IDS":ids,
                                  @"userId":sns.ldap_uid
                                  };
            
            [HttpRequest getRequestPath:kMBServerNameTypeCart methodName:@"ShoppingCartDeleteList" params:param success:^(NSDictionary *dict) {
                if ([dict[@"isSuccess"] integerValue] == 1) {
                    
                    if (indexPath) {
                        [vc.goodsArray[indexPath.section] removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
                        
                        //                        [vc.tvShoppingTrolly beginUpdates];
                        //                        [vc.tvShoppingTrolly  deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                        //                        [vc.tvShoppingTrolly endUpdates];
                        //
                        //
                        [vc.tvShoppingTrolly  beginUpdates];
                        if ([vc.goodsArray[indexPath.section] count]<=0)
                        {
                            [vc.goodsArray removeObjectAtIndex:indexPath.section];
                            [vc.tvShoppingTrolly  deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]withRowAnimation:UITableViewRowAnimationFade];
                            
                        }
                        [vc.tvShoppingTrolly  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [vc.tvShoppingTrolly  endUpdates];
                        //[vc.tvShoppingTrolly reloadData];
                        
                        if (vc.goodsArray.count<=0) {
                            vc.shoppimgTrollyNil.hidden = NO;
                            vc.shoppingTrollyNilView.hidden = NO;
                            vc.bottom_showView.hidden = YES;
                            vc.tvShoppingTrolly.hidden = YES;
                            vc.btnEdit.hidden = YES;
                        }
                    }
                    else{
                        [vc refreshTableView];
                        
                    }
                    //                        [vc.tvShoppingTrolly deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //                        [vc.tvShoppingTrolly endUpdates];
                    
                    [Toast hideToastActivity];
                    //                    [Toast makeToast:@"已删除"];
                    [Toast makeToastSuccess:@"已删除"];
                    [vc editOpration:NO];
                    [vc  calcSum];
                    
                    
                }else{
                    [Toast hideToastActivity];
                    [Toast makeToast:@"删除失败"];
                }
                
                
            } failed:^(NSError *error) {
                [Toast hideToastActivity];
                [Toast makeToast:@"删除失败"];
            }];
            
            
        }
        NSLog(@"right button clicked");
    };
    _zmAlertView.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
}

#pragma mark - section header clicked
-(void)headerBackgroundSelectAllButtonClick:(id)sender button:(UIButton *)button sectionIndex:(int)sectionIndex{
    
    MyShoppingTrollyGoodsTableHeaderView * headerView = (MyShoppingTrollyGoodsTableHeaderView *)sender;
    //全场活动不能跳转
    //    if (headerView.platFormBasicInfo == nil) {
    //        [Toast makeToast:@"单品没有全场活动优惠"];
    //        return;
    //    }
    if (headerView.lbSum.text.length == 0) {
        
        [Toast makeToast:@"该活动不满足条件"];
        return;
    }
    
    //每个section下的所点击的商品
    NSMutableArray *selectArray = [NSMutableArray new];
    
    for (MyShoppingTrollyGoodsData *data in goodsArray[sectionIndex])
    {
        if ([data isUsed])
        {
            if (data.selected)
            {
                //只有有活动的 才请求 wwp
                if (data.platFormInfo) {
                    [selectArray addObject:data];
                }
                //                    [selectArray addObject:data];
            }
        }
    }
    if (selectArray.count <=0) {
        [Toast makeToast:@"请选择商品"];
        return;
    }
    
    PlatFormBasicInfo *tmpplatFormBasicInfo = [PlatFormBasicInfo new];
    
    for (MyShoppingTrollyGoodsData *data in goodsArray[sectionIndex])
    {
        if ([data isUsed])
        {
            if (data.selected)
            {
                
                if (data.platFormInfo) {
                    tmpplatFormBasicInfo.code = [NSString stringWithFormat:@"%@",data.platFormInfo.promotionId] ;
                    //名字
                    tmpplatFormBasicInfo.web_url = [NSString stringWithFormat:@"%@",data.platFormInfo.web_url];
                    tmpplatFormBasicInfo.activityName = [NSString stringWithFormat:@"%@",data.platFormInfo.promName];
                    break;
                }
                
            }
        }
    }
    
    
    SMBCouponActivityVC *vc = [[SMBCouponActivityVC alloc] initWithNibName:@"SMBCouponActivityVC" bundle:nil];
    vc.data = selectArray;
    
    if (headerView.platFormBasicInfo == nil) {
        headerView.platFormBasicInfo = tmpplatFormBasicInfo;
    }
    vc.selectPlatFormBasicInfo = headerView.platFormBasicInfo;
    vc.didSelectedEnter = ^(id sender2) {
        
        //        ActivityOrderModel *tmpPlatFormBasicInfo = sender2;
        
        PlatFormBasicInfo *tmpPlatFormBasicInfo = sender2;
        if (tmpPlatFormBasicInfo != nil) {
            headerView.platFormBasicInfo = tmpPlatFormBasicInfo;
        }
        
        
        for (MyShoppingTrollyGoodsData *data in goodsArray[sectionIndex])
        {
            if ([data isUsed])
            {
                if (data.selected)
                {
                    if (tmpPlatFormBasicInfo != nil)
                    {
                        
                        PlatFormInfo *tmpplaformInfo = [PlatFormInfo new];
                        tmpplaformInfo.collocation_Id = data.collocationid;
                        tmpplaformInfo.diS_Price = tmpPlatFormBasicInfo.price;
                        
                        tmpplaformInfo.proD_ID = data.prodid;
                        tmpplaformInfo.platPromId = tmpPlatFormBasicInfo.code;
                        tmpplaformInfo.qty = [NSString stringWithFormat:@"%d",data.number];
                        data.platFormInfo = tmpplaformInfo;
                        for (OrderActivityProductListModel *huodongProdInfo in tmpPlatFormBasicInfo.productList)
                        {
                            if ([data.prodNum isEqualToString: huodongProdInfo.barcode_sys_code])
                            {
                                data.prodInfo = huodongProdInfo;
                            }
                        }
                    }else{
                        //取消活动优惠
                        data.platFormInfo = nil;
                        data.prodInfo = nil;
                        headerView.platFormBasicInfo = nil;
                    }
                    
                    
                    
                }
            }
        }
        
        //        [_tvShoppingTrolly reloadData];
        //        [self calcSum];
        
        //add by miao 6.12 2.点击header
        PlatFormInfo *tmpPlatFormInfo = nil;
        for (MyShoppingTrollyGoodsData *data in  goodsArray[sectionIndex])
        {
            if ([data isUsed])
            {
                if (data.selected==YES)
                {
                    if (data.platFormInfo) {
                        
                        tmpPlatFormInfo = data.platFormInfo;
                        break;
                    }
                }
                
            }
        }
        
        if (tmpPlatFormInfo) {
            NSMutableArray *tmparray = [NSMutableArray new];
            for (MyShoppingTrollyGoodsData *data in  goodsArray[sectionIndex])
            {
                if ([data isUsed])
                {
                    if (data.selected==YES)
                    {
                        data.platFormInfo = tmpPlatFormInfo;
                        [tmparray addObject:data];
                        
                    }
                    
                }
            }
            if (tmparray.count > 0) {
                [self requestGoodsCouponDataWithdataArray:tmparray];
            }
            
        }else{
            [self calcSum];
            
            [_tvShoppingTrolly reloadData];
        }
        
    };
    
    
    
    NSMutableArray *dicarray = [[NSMutableArray alloc]init];
    
    for (MyShoppingTrollyGoodsData *data in selectArray) {
        NSDictionary *newDic=@{@"barcode":data.prodNum,
                               @"num":[NSString stringWithFormat:@"%d",data.number],
                               @"aid":[NSString stringWithFormat:@"%@",headerView.platFormBasicInfo.code]
                               };
        [dicarray addObject:newDic];
    }
    
    NSMutableDictionary *paramDic =[@{@"userId":sns.ldap_uid,@"cartList":dicarray,@"aid":headerView.platFormBasicInfo.code} mutableCopy];
    //JSWEB 需要
    NSArray* arr = [paramDic allKeys];//post  二维数组转json上传deng
    for(NSString* str in arr)
    {
        if([[paramDic objectForKey:str] isKindOfClass:[NSArray class]])
        {
            NSString *jsonStr=[NSString arrayAnddictoJSONDataStr:[paramDic objectForKey:str]];
            
            [paramDic setValue:jsonStr forKey:str];
        }
        if ([[paramDic objectForKey:str] isKindOfClass:[NSDictionary class]]) {
            NSString *jsonSSS=[NSString arrayAnddictoJSONDataStr:[paramDic objectForKey:str]];
            [paramDic setValue:jsonSSS forKey:str];
        }
        
        
    }
    
    
    if (headerView.platFormBasicInfo != nil) {
        if (headerView.platFormBasicInfo.web_url.length==0) {
            
            [self pushController:vc animated:YES];
            
        }else
        {
            NSString *web_url = [NSString stringWithFormat:@"%@",tmpplatFormBasicInfo.web_url];
            NSString *detailUrlStr= [NSString stringWithFormat:@"%@",web_url];
            
            NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
            NSString *noLastUrlStr=detailUrlStr;
            if ([lastStr isEqualToString:@"?"]) {
                noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
            }
            web_url=[NSString stringWithFormat:@"%@",noLastUrlStr];
            
            NSString *jsonArray_Str=[NSString arrayAnddictoJSONDataStr:dicarray];
            NSString *jsonWeb =[NSString stringWithFormat:@"&cartList=%@&aid=%@",jsonArray_Str,[Utils getSNSString:headerView.platFormBasicInfo.code]];
            NSString * web_urlStr = [web_url stringByAppendingFormat:@"%@",jsonWeb];
            
            NSLog(@"web—_urlStr---%@",web_urlStr);
            
            JSWebViewController *jsweb=[[JSWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@",web_urlStr]];
            jsweb.naviTitle=[NSString stringWithFormat:@"%@", tmpplatFormBasicInfo.activityName];
            [self pushController:jsweb animated:YES];
        }
    }else{
        
        if (headerView.lbSum.text.length == 0) {
            
            [Toast makeToast:@"该活动不满足条件"];
            return;
        }
        //else{
        //        JSWebViewController *jsweb=[[JSWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@",web_urlStr]];
        //        jsweb.naviTitle=[NSString stringWithFormat:@"%@", tmpplatFormBasicInfo.activityName];
        //        [self pushController:jsweb animated:YES];
        
        //    }
        
    }
    
}


#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSArray *indexPaths = [self.tvShoppingTrolly indexPathsForVisibleRows];
    //    for (NSIndexPath *indexPath in indexPaths) {
    //        JASwipeCell *cell = (JASwipeCell *)[self.tvShoppingTrolly cellForRowAtIndexPath:indexPath];
    //        [cell resetContainerView];
    //    }
    
    
    //    [self.tvShoppingTrolly reloadData];
}

#pragma mark -- 活动优惠
-(void)requestGoodsCouponDataWithdataArray:(NSMutableArray *)selectGoodsdata{
    
    
    NSMutableArray *dicarray = [NSMutableArray new];
    
    for (MyShoppingTrollyGoodsData *data in selectGoodsdata) {
        //        NSDictionary *dic = @{@"collocation_Id":[NSNumber numberWithInteger:data.collocationid.integerValue],
        //                              @"proD_ID":[NSNumber numberWithInteger:data.prodid.integerValue],
        //                              @"sale_Price":[NSNumber numberWithFloat:data.saleprice],
        //                              @"qty":[NSNumber numberWithInteger:data.number]};
        //        [dicarray addObject:dic];
        NSDictionary *newDic=@{@"barcode":data.prodNum,
                               @"num":[NSString stringWithFormat:@"%d",data.number],
                               @"cid":data.collocationid,
                               @"aid":[NSString stringWithFormat:@"%@",data.platFormInfo.promotionId]
                               };
        [dicarray addObject:newDic];
    }
    
    isNotRequestFinish=YES;
    
    [Toast makeToastActivity:@"正在加载" hasMusk:NO];
    
    NSDictionary *paramDic =@{@"userId":sns.ldap_uid,@"cartList":dicarray};
    
    [HttpRequest promotionPostRequestPath:nil methodName:@"PlatFormDisAmount" params:paramDic success: ^(NSDictionary *dict){
        isNotRequestFinish=NO;
        //        NSMutableArray *couponDataArray = [NSMutableArray new];
        
        if ([dict[@"isSuccess"] integerValue] == 1)
        {
            
            //            PlatFormBasicInfo *tmpPlatFormBasicInfo =[[PlatFormBasicInfo alloc]initWithDic:dict[@"results"][0]];
            //            return ;
            
            if ([dict[@"results"] count] > 0)
            {
                PlatFormBasicInfo *tmpPlatFormBasicInfo=[[PlatFormBasicInfo alloc ]initWithDic:dict[@"results"][0]];
                
                //                couponDataArray =  [NSMutableArray arrayWithObject:[PlatFormBasicInfo modelDataArrayWithArray:dict[@"results"][0]]];
                //                 PlatFormBasicInfo *tmpPlatFormBasicInfo = [couponDataArray firstObject];
                NSArray *prodlistArray =[[NSArray alloc]initWithArray:tmpPlatFormBasicInfo.productList];
                
                OrderActivityProductListModel *productListM= [prodlistArray firstObject];
                
                for (MyShoppingTrollyGoodsData *data2 in selectGoodsdata) {
                    
                    PlatFormInfo *tmpplaformInfo = [PlatFormInfo new];
                    tmpplaformInfo.collocation_Id = data2.collocationid;
                    tmpplaformInfo.diS_Price = tmpPlatFormBasicInfo.dec_price;
                    tmpplaformInfo.promName =  data2.platFormInfo.promName;
                    
                    tmpplaformInfo.proD_ID = data2.prodid;
                    
                    //                    tmpplaformInfo.platPromId=productListM.aid;//
                    tmpplaformInfo.platPromId=data2.platFormInfo.promotionId;
                    tmpplaformInfo.promotionId =data2.platFormInfo.promotionId;
                    tmpplaformInfo.qty = [NSString stringWithFormat:@"%d",data2.number];
                    tmpplaformInfo.web_url =[NSString stringWithFormat:@"%@",data2.platFormInfo.web_url];
                    //                    tmpplaformInfo.usE_COUPON_FLAG = [NSString stringWithFormat:@"%@",tmpPlatFormBasicInfo.usE_COUPON_FLAG];
                    data2.platFormInfo = tmpplaformInfo;
                    
                    for (OrderActivityProductListModel *huodongProdInfo in tmpPlatFormBasicInfo.productList) {
                        if ([data2.prodNum isEqualToString: huodongProdInfo.barcode_sys_code]) {
                            data2.prodInfo = huodongProdInfo;
                        }
                    }
                }
                
                
                
                [_tvShoppingTrolly reloadData];
                [self calcSum];
                
                
                
            }else
            {
                for (MyShoppingTrollyGoodsData *data2 in selectGoodsdata) {
                    //                    data2.platFormInfo = nil;
                    data2.platFormInfo.usE_COUPON_FLAG = @"1";
                    data2.prodInfo = nil;
                }
                [_tvShoppingTrolly reloadData];
                [self calcSum];
                
            }
            
            
        }
        else
        {
            //            for (MyShoppingTrollyGoodsData *data2 in selectGoodsdata) {
            //                //                    data2.platFormInfo = nil;
            //                data2.platFormInfo.usE_COUPON_FLAG = @"1";
            //                data2.prodInfo = nil;
            //            }
            [_tvShoppingTrolly reloadData];
            [self calcSum];
        }
        
        [Toast hideToastActivity];
    }failed:^(NSError *error){
        NSLog(@"促销错误------%@", error);
        isNotRequestFinish=NO;
        [Toast hideToastActivity];
        
        
    } ];
    
}

//add by miao 6.8
-(void)getAllprice{
    float totalprice = 0;
    float allMartPrice=0;
    
    for (int i=0;i<goodsArray.count;i++)
    {
        NSArray *rowArray=goodsArray[i];
        for (MyShoppingTrollyGoodsData *data in rowArray)
        {
            if ([data isUsed])
            {
                data.selected=_btnSelectedAll.selected;
                
                if (data.prodInfo == nil) {
                    totalprice+=data.saleprice*(float)data.number;
                    allMartPrice += data.price *(float)data.number;
                }else{
                    if (data.saleprice >= data.prodInfo.spec_price.floatValue) {
                        //                        totalprice+=(data.saleprice - data.prodInfo.dec_price.floatValue)*(float)data.number;
                        totalprice += [data.prodInfo.total_price floatValue];
                        allMartPrice += [data.prodInfo.market_price floatValue];
                        
                    }else{
                        totalprice+=data.saleprice*(float)data.number;
                        allMartPrice += data.price*(float)data.number;
                    }
                    
                }
                
            }
            else
                data.selected=NO; //不能使用
        }
    }
    
    if (_btnSelectedAll.selected==NO)
    {
        _lbSum.text=[NSString stringWithFormat:@"合计: ￥0"];
        _lbTrans.text=[NSString stringWithFormat:@" 不含运费"];
        
    }
    else
    {
        NSString *totalPriceStr = [NSString stringWithFormat:@"%.2f",totalprice];
        //        NSString *allMartPriceStr = [NSString stringWithFormat:@"%.2f",allMartPrice];
        
        _lbSum.text=[NSString stringWithFormat:@"合计: ￥%@", [Utils getSNSRMBMoneyWithoutMark:totalPriceStr]];
        _lbTrans.text=[NSString stringWithFormat:@" 不含运费"];
        
        //        if ([totalPriceStr floatValue]>=[allMartPriceStr floatValue]) {
        //             _lbTrans.text=[NSString stringWithFormat:@" 不含运费"];
        //        }
        //        else
        //        {
        //            _lbTrans.text=[NSString stringWithFormat:@"￥%@ 不含运费", [Utils getSNSRMBMoneyWithoutMark:allMartPriceStr]];
        //            NSMutableAttributedString *attrbutdestring = [[NSMutableAttributedString alloc]initWithString: _lbTrans.text];
        //            
        //            [attrbutdestring addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
        //                                             NSForegroundColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
        //                                             NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
        //                                             NSFontAttributeName:FONT_t7
        //                                             }range:NSMakeRange(0, _lbTrans.text.length-5)];
        //            
        //            _lbTrans.attributedText =attrbutdestring;
        //        }
    }
    
}


#pragma mark - ***备用方法 暂时弃用***




#pragma mark - JASwipeCellDelegate methods

- (void)swipingRightForCell:(JASwipeCell *)cell
{
    //    NSArray *indexPaths = [self.tvShoppingTrolly indexPathsForVisibleRows];
    //    for (NSIndexPath *indexPath in indexPaths) {
    //        JASwipeCell *visibleCell = (JASwipeCell *)[self.tvShoppingTrolly cellForRowAtIndexPath:indexPath];
    //        if (visibleCell != cell) {
    //            [visibleCell resetContainerView];
    //        }
    //
    //    }
}

#pragma mark - 滑动显示删除按钮
- (void)swipingLeftForCell:(JASwipeCell *)cell
{
    //    NSArray *indexPaths = [self.tvShoppingTrolly indexPathsForVisibleRows];
    //    for (NSIndexPath *indexPath in indexPaths) {
    //        JASwipeCell *visibleCell = (JASwipeCell *)[self.tvShoppingTrolly cellForRowAtIndexPath:indexPath];
    //        if (visibleCell != cell) {
    //            [visibleCell resetContainerView];
    //        }
    //
    //    }
}

- (void)leftMostButtonSwipeCompleted:(JASwipeCell *)cell
{
    //    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ////    [self.tableData removeObjectAtIndex:indexPath.row];
    //
    //    [self.tableView beginUpdates];
    //    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //    [self.tableView endUpdates];
}

- (void)rightMostButtonSwipeCompleted:(JASwipeCell *)cell
{
    //    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ////    [self.tableData removeObjectAtIndex:indexPath.row];
    //
    //    [self.tableView beginUpdates];
    //    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //    [self.tableView endUpdates];
}


@end
