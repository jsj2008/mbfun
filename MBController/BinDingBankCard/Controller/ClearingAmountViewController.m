//
//  ClearingAmountViewController.m
//  Wefafa
//
//  Created by Jiang on 3/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//
// 废弃  带结算金额
#import "ClearingAmountViewController.h"
#import "AlreadyBinDingBankCardViewController.h"
#import "DesignerProtocolViewController.h"
#import "BinDingBankCardHomeViewController.h"
#import "MBShoppingGuideInterface.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "MyBankCardModel.h"

@interface ClearingAmountViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *bindingBackCardButton;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseTextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgVIew;

- (IBAction)chooseBtnAction:(id)sender;
- (IBAction)bindingBankCardButtonAction:(UIButton *)sender;
- (IBAction)DesignerProtocolButtonAction:(UIButton *)sender;

@property (nonatomic, strong) NSMutableArray *myBankCardArray;

@end

@implementation ClearingAmountViewController
@synthesize allAmount;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavigationBar];
    [self initSubView];
    
    self.bindingBackCardButton.userInteractionEnabled = NO;
    self.bindingBackCardButton.highlighted = NO;
    self.bindingBackCardButton.showsTouchWhenHighlighted = NO;
    self.bindingBackCardButton.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
    _myBankCardArray = [NSMutableArray array];
    [self requestData];
}

- (void)initNavigationBar{
    CGRect headrect = self.headerView.bounds;
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:)  selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"待结算金额";
    [self.headerView addSubview:view];
//    [self.view setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
 
    NSString *moneyString = [NSString stringWithFormat:@"%@ 元", [Utils getSNSMoney:self.allAmount]];
    _moneyLabel.text = moneyString;
    [_lineImgVIew setFrame: CGRectMake(_lineImgVIew.frame.origin.x, _lineImgVIew.frame.origin.y, _lineImgVIew.frame.size.width, 0.5)];
    
    [_chooseBtn setSelected:YES];
    [_chooseTextBtn setSelected:YES];
    self.contentView.userInteractionEnabled = NO;
    self.bindingBackCardButton.userInteractionEnabled = NO;
}
- (void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_myBankCardArray.count == 0 || !_myBankCardArray) {
        self.bindingBackCardButton.selected = YES;
    }else{
        self.bindingBackCardButton.selected = NO;
        [self closeProtocol];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    if (_myBankCardArray.count == 0 || !_myBankCardArray) {
//        self.bindingBackCardButton.selected = YES;
//    }else{
//        self.bindingBackCardButton.selected = NO;
//    }
//}

- (void)initSubView{
    self.bindingBackCardButton.layer.cornerRadius = 3.0;
    self.contentView.layer.masksToBounds = YES;
    if(!self.isProtocol){
        CGRect frame = self.contentView.frame;
        frame.size.height = 230;
        self.contentView.frame = frame;
    }
}

- (void)closeProtocol{
    CGRect frame = self.contentView.frame;
    frame.size.height = 190;
    self.contentView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMyBankCardArray:(NSArray *)myBankCardArray{
    if (myBankCardArray.count == 0 || !myBankCardArray) {
        self.bindingBackCardButton.selected = YES;
    }else{
        self.bindingBackCardButton.selected = NO;
    }
    
    for (NSDictionary *dict in myBankCardArray) {
        MyBankCardModel *model = [[MyBankCardModel alloc] initWithDictionary:dict];
        [_myBankCardArray addObject:model];
    }
}

- (IBAction)chooseBtnAction:(id)sender {
    if ([_chooseBtn isSelected]) {
        [_chooseBtn setSelected:NO];
        [_chooseTextBtn setSelected:NO];
        self.bindingBackCardButton.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
        _bindingBackCardButton.userInteractionEnabled = NO;
    }
    else
    {
        self.bindingBackCardButton.backgroundColor = [Utils HexColor:0x333333 Alpha:1];
        _bindingBackCardButton.userInteractionEnabled = YES;
        [_chooseBtn setSelected:YES];
        [_chooseTextBtn setSelected:YES];
    }
    
}

- (IBAction)bindingBankCardButtonAction:(UIButton *)sender {
    if ([_chooseBtn isSelected])
    {
        if ([self.bindingBackCardButton isSelected]) {
            AlreadyBinDingBankCardViewController *controller = [[AlreadyBinDingBankCardViewController alloc]initWithNibName:@"AlreadyBinDingBankCardViewController" bundle:nil];
            controller.myBankCardArray = self.myBankCardArray;
            UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:controller];
            [self presentViewController:navigation animated:YES completion:^{
                
            }];
            BinDingBankCardHomeViewController *subController = [[BinDingBankCardHomeViewController alloc]initWithNibName:@"BinDingBankCardHomeViewController" bundle:nil];
            [controller.navigationController pushViewController:subController animated:NO];
        }else{
            AlreadyBinDingBankCardViewController *controller = [[AlreadyBinDingBankCardViewController alloc]initWithNibName:@"AlreadyBinDingBankCardViewController" bundle:nil];
            controller.myBankCardArray = self.myBankCardArray;
            UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:controller];
            [self presentViewController:navigation animated:YES completion:^{
                
            }];
        }
    }
    else
    {
        [Utils alertMessage:@"请先选择同意有范协议"];
        
    }

}

- (IBAction)DesignerProtocolButtonAction:(UIButton *)sender {
    DesignerProtocolViewController *controller = [[DesignerProtocolViewController alloc]initWithNibName:@"DesignerProtocolViewController" bundle:nil];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
}

- (void)requestData{
    NSMutableDictionary *requestBankDic = [NSMutableDictionary dictionary];
    NSMutableString *returnMsg=[NSMutableString string];
    [Toast makeToastActivity:@"正在加载数据..." hasMusk:YES];
    
    NSString *searchUrlName=@"WxSellerCardFilter";
    __weak typeof(self) p = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:searchUrlName param:@{@"UserId":sns.ldap_uid} responseAll:requestBankDic responseMsg:returnMsg];
        //银行
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if (success) {
                p.myBankCardArray = requestBankDic[@"results"];
                self.bindingBackCardButton.userInteractionEnabled = YES;
                if ([p.chooseBtn isSelected]) {
                    p.contentView.userInteractionEnabled = YES;
                    self.bindingBackCardButton.backgroundColor = [Utils HexColor:0x333333 Alpha:1];
                }
            }else{
                [Toast makeToastActivity:@"加载失败！" hasMusk:YES];
            }
        });
    });
}

@end
