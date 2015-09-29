//
//  FilterViewController.m
//  newdesigner
//
//  Created by Miaoz on 14/10/22.
//  Copyright (c) 2014年 mb. All rights reserved.
//  废弃 不用 

#import "FilterViewController.h"
#import "Globle.h"
#import "GoodCategoryObj.h"
#import "FilterClassifyViewController.h"
#import "FilterBrandViewController.h"
#import "FilterColorViewController.h"
#import "UMButton.h"
#import "BrandMapping.h"
#import "ColorMapping.h"
#import "PriceMapping.h"
//@"#E52027"
//@"#ffffff"
//@"#353535"
#define buttonWight 11
#define  ClickBtnBgcolor  @"#E52027"//@"#65cbcb"

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UMButton *priceButton1;
@property (weak, nonatomic) IBOutlet UMButton *priceButton2;
@property (weak, nonatomic) IBOutlet UMButton *priceButton3;
@property (weak, nonatomic) IBOutlet UMButton *priceButton4;
@property (weak, nonatomic) IBOutlet UMButton *priceButton5;
@property (weak, nonatomic) IBOutlet UMButton *priceButton6;
@property (weak, nonatomic) IBOutlet UMButton *priceButton7;
@property (weak, nonatomic) IBOutlet UMButton *priceButton8;

@property (weak, nonatomic) IBOutlet UMButton *classifyButton;
@property (weak, nonatomic) IBOutlet UIButton *brandButton;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIView *rightShowColorView;
@property (weak, nonatomic) IBOutlet UILabel *rightShowBrandLab;

@property (weak, nonatomic) IBOutlet UIView *line1View;
@property (weak, nonatomic) IBOutlet UIView *line2View;
@property (weak, nonatomic) IBOutlet UIView *line3View;

@property(nonatomic,strong) NSMutableArray *priceButtonarray;
@property(nonatomic,strong) NSMutableArray *dataPricearray;

@property(nonatomic,strong)NSMutableDictionary *priceDic;//价格区间字典
@property(nonatomic,strong)NSMutableDictionary *brandDic;//品牌字典
@property(nonatomic,strong)NSMutableDictionary *categoryDic;//分类字典
@property(nonatomic,strong)NSMutableDictionary *colorDic;//颜色字典

@property(nonatomic,strong)NSMutableDictionary *showfilterDic;//展示的筛选字典
@property(nonatomic,strong)NSMutableDictionary *focusMemoryDic;//焦点记忆字典

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.view.backgroundColor =[UIColor colorWithHexString:@"#ffffff"];
    _cleanButton.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    _okButton.backgroundColor = [UIColor colorWithHexString:@"#ffde00"];
    _cleanButton.layer.cornerRadius = 3.0f;
    _cleanButton.layer.masksToBounds = YES;
    _okButton.layer.cornerRadius = 3.0f;
    _okButton.layer.masksToBounds = YES;
    
    [_cleanButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _cleanButton.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [_okButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    _okButton.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
     [self creatpriceButtonarray];
    [self createArrayAndDic];

    NSLog(@"viewDidLoad-------------");
    // Do any additional setup after loading the view.
   
  
}

-(void)createArrayAndDic
{
    //12.12 add by miao 解决点击价格crashbug
    [self.view setUserInteractionEnabled:NO];
    [self requestPriceFilter];
    
    if (_dataPricearray == nil)
    {
        _dataPricearray = [NSMutableArray new];
    }
    if (_priceDic == nil) {
        _priceDic = [NSMutableDictionary new];
    }
    if (_brandDic == nil) {
        _brandDic = [NSMutableDictionary new];
    }
    if (_categoryDic == nil) {
        _categoryDic = [NSMutableDictionary new];
    }
    if (_colorDic == nil) {
        _colorDic = [NSMutableDictionary new];
    }
    
    if (_showfilterDic == nil) {
        _showfilterDic = [NSMutableDictionary new];
    }
    
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    [self getFocusdata];
    _classifyButton.rightImageView.hidden = NO;
//    _brandButton.rightImageView.hidden = NO;
//    _colorButton.rightImageView.hidden = NO;
//    _colorButton.centerImageView.hidden = NO;
}

-(void)getFocusdata{

    if (_focusMemoryDic == nil) {
        _focusMemoryDic = [NSMutableDictionary new];
    }
    
    
    if ([[TMCache sharedCache] objectForKey:focusMemoryFilterDic] != NULL) {
        _focusMemoryDic = [[TMCache sharedCache] objectForKey:focusMemoryFilterDic];
        
    }
    
    NSLog(@"_focusMemoryDic-------%@",_focusMemoryDic);
    if (_focusMemoryDic != nil) {
        
        if ([_focusMemoryDic objectForKey:focusMemoryPrice]!= NULL) {
            NSDictionary *dicdic =[_focusMemoryDic objectForKey:focusMemoryPrice];
            NSString *indexStr = [dicdic objectForKey:@"priceButton"];
            
            switch (indexStr.intValue) {
                case 1:{
                    
                   
                    for (UMButton *btn in _priceButtonarray) {
                        [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
                        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
                    }
                  
                    [_priceButton1 setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
                    [_priceButton1 setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                    
//#warning 价格字典
                    
                    [_priceDic setObject:[NSString stringWithFormat:@"%@",[dicdic objectForKey:@"priceMapping.id"]] forKey:@"PriceId"];
                    //选择项展示需要
                    [_showfilterDic setObject:[NSString stringWithFormat:@"价格:%@",[dicdic objectForKey:@"priceMapping.name"]] forKey:showPrice];
                    //11.4 add by miao 焦点记忆
                    //                    [_focusMemoryDic setObject:priceMapping forKey:focusMemoryPrice];
                    
                    
                    break;
                }
                case 2:{
                    
                    for (UMButton *btn in _priceButtonarray) {
                        [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
                        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
                    }
                    
                    [_priceButton2 setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
                    [_priceButton2 setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                    
//#warning 价格字典
                    
                    [_priceDic setObject:[NSString stringWithFormat:@"%@",[dicdic objectForKey:@"priceMapping.id"]] forKey:@"PriceId"];
                    //选择项展示需要
                    [_showfilterDic setObject:[NSString stringWithFormat:@"价格:%@",[dicdic objectForKey:@"priceMapping.name"]] forKey:showPrice];
                    break;
                }
                case 3:{
                    
                    for (UMButton *btn in _priceButtonarray) {
                        [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
                        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
                    }
                    
                    [_priceButton3 setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
                    [_priceButton3 setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                    
//#warning 价格字典
                    
                    [_priceDic setObject:[NSString stringWithFormat:@"%@",[dicdic objectForKey:@"priceMapping.id"]] forKey:@"PriceId"];
                    //选择项展示需要
                    [_showfilterDic setObject:[NSString stringWithFormat:@"价格:%@",[dicdic objectForKey:@"priceMapping.name"]] forKey:showPrice];
                    break;
                }
                case 4:{
                    
                    for (UMButton *btn in _priceButtonarray) {
                        [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
                        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
                    }
                    
                    [_priceButton4 setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
                    [_priceButton4 setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                    
//#warning 价格字典
                    
                    [_priceDic setObject:[NSString stringWithFormat:@"%@",[dicdic objectForKey:@"priceMapping.id"]] forKey:@"PriceId"];
                    //选择项展示需要
                    [_showfilterDic setObject:[NSString stringWithFormat:@"价格:%@",[dicdic objectForKey:@"priceMapping.name"]] forKey:showPrice];
                    break;
                }
                    
                case 5:{
                    
                    for (UMButton *btn in _priceButtonarray) {
                        [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
                        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
                    }
                    
                    [_priceButton5 setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
                    [_priceButton5 setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
//#warning 价格字典
                    
                    [_priceDic setObject:[NSString stringWithFormat:@"%@",[dicdic objectForKey:@"priceMapping.id"]] forKey:@"PriceId"];
                    //选择项展示需要
                    [_showfilterDic setObject:[NSString stringWithFormat:@"价格:%@",[dicdic objectForKey:@"priceMapping.name"]] forKey:showPrice];
                    break;
                }

                default:
                    break;
            }
            
        }
        if ([_focusMemoryDic objectForKey:focusMemoryClass]!= NULL) {
            
            NSDictionary *dicdic =[_focusMemoryDic objectForKey:focusMemoryClass];
            
            [_classifyButton setTitle:[dicdic objectForKey:@"secondCategory.name"] forState:UIControlStateNormal];
//            _classifyButton.rightImageView.frame = CGRectMake(_classifyButton.rightImageView.frame.origin.x, _classifyButton.rightImageView.frame.origin.y, buttonWight, buttonWight);
            _classifyButton.rightImageView.image = [UIImage imageNamed:@"btn_closelist_normal@3x.png"];
            
            [_classifyButton setBackgroundColor:[UIColor colorWithHexString:@"#E52027"]];
            [_classifyButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
//#warning 分类字典
            [_categoryDic setObject:[dicdic objectForKey:@"secondCategory.id"] forKey:@"CategoryId"];
            
            //选择项展示需要
            [_showfilterDic setObject:[NSString stringWithFormat:@"子类:%@",[dicdic objectForKey:@"secondCategory.name"]] forKey:showClass];
            
            
            
        }
        if ([_focusMemoryDic objectForKey:focusMemoryColor]!= NULL) {
            NSDictionary *dicdic =[_focusMemoryDic objectForKey:focusMemoryColor];
            NSString *colorStr;
            NSString *colorvaule = [dicdic objectForKey:@"colorMapping.coloR_VALUE"];
            if (colorvaule.length<7) {
                colorStr = [NSString stringWithFormat:@"#%@",colorvaule];
            }else{
                colorStr = colorvaule;
            }
           _rightShowColorView.backgroundColor = [UIColor colorWithHexString:colorStr];
            [_colorButton setTitle:@"颜色" forState:UIControlStateNormal];

//#warning 颜色字典
            [_colorDic setObject:[dicdic objectForKey:@"colorMapping.id"] forKey:@"ColorId"];
            
            //选择项展示需要
            [_showfilterDic setObject:[NSString stringWithFormat:@"颜色:%@",[dicdic objectForKey:@"colorMapping.coloR_NAME"]] forKey:showColor];
            
            
        }
        if ([_focusMemoryDic objectForKey:focusMemoryBrand]!= NULL) {
            NSDictionary *dicdic =[_focusMemoryDic objectForKey:focusMemoryBrand];
            
            NSString *str = [NSString stringWithFormat:@"品牌:%@",[dicdic objectForKey:@"brandMapping.branD_NAME"]];
            _rightShowBrandLab.text = [dicdic objectForKey:@"brandMapping.branD_NAME"];
        
//#warning 品牌字典
            [_brandDic setObject:[dicdic objectForKey:@"brandMapping.id"] forKey:@"BrandId"];
            
            //选择项展示需要
            [_showfilterDic setObject:str forKey:showBrand];
        }
        
    }



}
-(void)dealloc{
    
    NSLog(@"FilterViewController---dealloc");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)filterVCBlockWithpostDic:(FilterVCBlock)block{
    _myblock = block;
    
}

-(void)creatpriceButtonarray{
    if (_priceButtonarray == nil) {
        _priceButtonarray = [NSMutableArray new];
        [_priceButtonarray addObject:_priceButton5];
        [_priceButtonarray addObject:_priceButton4];
        [_priceButtonarray addObject:_priceButton3];
        [_priceButtonarray addObject:_priceButton2];
        [_priceButtonarray addObject:_priceButton1];
        
    }
}

#pragma mark--价格区间查询接口
-(void)requestPriceFilter{
    [[HttpRequest shareRequst] httpRequestGetBasePriceFilterWithdic:nil success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                //遍历数组解析
                
                for (NSDictionary *dic in data)
                {
                    PriceMapping *priceMapping;
                    priceMapping=[JsonToModel objectFromDictionary:dic className:@"PriceMapping"];
                    [_dataPricearray addObject:priceMapping];

                }
              
                for (int i = 0; i<5; i++) {
                  PriceMapping *tmpPricrMapping =  _dataPricearray[i];
                   UMButton * tmpbutton = _priceButtonarray[i];
                    
                    [tmpbutton.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
                    [tmpbutton setTitle:tmpPricrMapping.name forState:UIControlStateNormal];
                }
                
                //12.12 add by miao 解决点击价格crashbug
                    [self.view setUserInteractionEnabled:YES];
            }
        }
    } ail:^(NSString *errorMsg) {
        
    }];

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"FilterClassifyViewController"]){
        
        FilterClassifyViewController *filterClassifyViewController = segue.destinationViewController;
        filterClassifyViewController.mainGoodCategoryObj =  (GoodCategoryObj *)sender;
        //回调
        [filterClassifyViewController classifyVCBlockWithGoodCategoryObj:^(id sender) {
            GoodCategoryObj *secondCategory = (GoodCategoryObj *)sender;
           
            
            [_classifyButton setTitle:secondCategory.name forState:UIControlStateNormal];
            _classifyButton.rightImageView.image = [UIImage imageNamed:@"btn_closelist_normal@3x.png"];
            [_classifyButton setBackgroundColor:[UIColor colorWithHexString:@"#E52027"]];
            [_classifyButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
//#warning 分类字典
            [_categoryDic setObject:secondCategory.id forKey:@"CategoryId"];
            
            //选择项展示需要
            [_showfilterDic setObject:[NSString stringWithFormat:@"子类:%@",secondCategory.name] forKey:showClass];
            
            //11.4 add by miao 焦点记忆
            NSDictionary *dicdic = @{@"secondCategory.id":secondCategory.id,
                                     @"secondCategory.parent_Id":secondCategory.parent_Id,
                                     @"secondCategory.name":secondCategory.name,
                                     @"secondCategory.code":secondCategory.code,
                                     @"secondCategory.flaT_URL":secondCategory.flaT_URL,
                                     @"secondCategory.tiP_FLAG":secondCategory.tiP_FLAG,
                                     @"secondCategory.url":secondCategory.url};
            [_focusMemoryDic setObject:dicdic forKey:focusMemoryClass];
            
        }];
    }
    if ([segue.identifier isEqualToString:@"FilterBrandViewController"]){
        
        FilterBrandViewController *filterBrandViewController = segue.destinationViewController;
        filterBrandViewController.dataDic = _brandDic;
        
        [filterBrandViewController brandVCBlockWithBrandMapping:^(id sender) {
            BrandMapping *brandMapping = (BrandMapping *)sender;
            NSString *str = [NSString stringWithFormat:@"品牌:%@",brandMapping.branD_NAME];
            _rightShowBrandLab.text = brandMapping.branD_NAME;

         
//#warning 品牌字典
            [_brandDic setObject:brandMapping.id forKey:@"BrandId"];
            
            //选择项展示需要
            [_showfilterDic setObject:str forKey:showBrand];
            
            //11.4 add by miao 焦点记忆
            NSDictionary *dicdic = @{@"brandMapping.id":brandMapping.id,
                                     @"brandMapping.branD_CODE":brandMapping.branD_CODE,
                                     @"brandMapping.branD_NAME":brandMapping.branD_NAME,
                                    };
            [_focusMemoryDic setObject:dicdic forKey:focusMemoryBrand];
            
        }];
        
    }
    if ([segue.identifier isEqualToString:@"FilterColorViewController"]){
        
        
        FilterColorViewController *filterColorViewController = segue.destinationViewController;

     
    
        [filterColorViewController colorVCBlockWithColorMapping:^(id sender) {
            ColorMapping *colorMapping = (ColorMapping *)sender;
            NSString *colorStr;
            if (colorMapping.coloR_VALUE.length<7) {
                colorStr = [NSString stringWithFormat:@"#%@",colorMapping.coloR_VALUE];
            }else{
                colorStr = colorMapping.coloR_VALUE;
            }
            _rightShowColorView.backgroundColor = [UIColor colorWithHexString:colorStr];

            
//#warning 颜色字典
            [_colorDic setObject:colorMapping.id forKey:@"ColorId"];
            
            //选择项展示需要
            [_showfilterDic setObject:[NSString stringWithFormat:@"颜色:%@",colorMapping.coloR_NAME] forKey:showColor];
            
            //11.4 add by miao 焦点记忆
           
            NSDictionary *dicdic = @{@"colorMapping.id":colorMapping.id,
                                     @"colorMapping.coloR_NAME":colorMapping.coloR_NAME,
                                     @"colorMapping.coloR_VALUE":colorMapping.coloR_VALUE,
                                     @"colorMapping.coloR_CODE":colorMapping.coloR_CODE,
                                   };

            [_focusMemoryDic setObject:dicdic forKey:focusMemoryColor];
            
        }];
       
    }
}

#pragma mark--按钮方法
- (IBAction)filterPrice1ButtonClickEvent:(id)sender {
    UMButton *button = (UMButton *)sender;
    
    NSLog(@"_priceButtonarray------%d",_priceButtonarray.count);
    for (UMButton *btn in _priceButtonarray) {
        [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    }
    [button setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
    [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
  
    PriceMapping *priceMapping =  _dataPricearray[4];
//#warning 价格字典
    [_priceDic setObject:[NSString stringWithFormat:@"%@",priceMapping.id] forKey:@"PriceId"];
    //选择项展示需要
    [_showfilterDic setObject:[NSString stringWithFormat:@"价格:%@",priceMapping.name] forKey:showPrice];
    //11.4 add by miao 焦点记忆
    
    NSDictionary *dicdic = @{@"priceMapping.id":priceMapping.id,
                             @"priceMapping.code":priceMapping.code,
                             @"priceMapping.name":priceMapping.name,
                             @"priceMapping.min_Price":priceMapping.min_Price,
                             @"priceMapping.max_Price":priceMapping.max_Price,
                             @"priceButton":@"1"
                             };
    [_focusMemoryDic setObject:dicdic forKey:focusMemoryPrice];



}

- (IBAction)filterPrice2ButtonClickEvent:(id)sender {
    UMButton *button = (UMButton *)sender;
    for (UMButton *btn in _priceButtonarray) {
        [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    }
    [button setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
    [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    PriceMapping *priceMapping =  _dataPricearray[3];
//#warning 价格字典
    [_priceDic setObject:priceMapping.id forKey:@"PriceId"];

    //选择项展示需要
    [_showfilterDic setObject:[NSString stringWithFormat:@"价格:%@",priceMapping.name] forKey:showPrice];
    
    //11.4 add by miao 焦点记忆
    NSDictionary *dicdic = @{@"priceMapping.id":priceMapping.id,
                             @"priceMapping.code":priceMapping.code,
                             @"priceMapping.name":priceMapping.name,
                             @"priceMapping.min_Price":priceMapping.min_Price,
                             @"priceMapping.max_Price":priceMapping.max_Price,
                             @"priceButton":@"2"
                             };
    [_focusMemoryDic setObject:dicdic forKey:focusMemoryPrice];

}

- (IBAction)filterPrice3ButtonClickEvent:(id)sender {
    UMButton *button = (UMButton *)sender;
    for (UMButton *btn in _priceButtonarray) {
        [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    }
    [button setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
    [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];

    PriceMapping *priceMapping =  _dataPricearray[2];
//#warning 价格字典
    [_priceDic setObject:priceMapping.id forKey:@"PriceId"];
    
    //选择项展示需要
    [_showfilterDic setObject:[NSString stringWithFormat:@"价格:%@",priceMapping.name] forKey:showPrice];
    //11.4 add by miao 焦点记忆
    NSDictionary *dicdic = @{@"priceMapping.id":priceMapping.id,
                             @"priceMapping.code":priceMapping.code,
                             @"priceMapping.name":priceMapping.name,
                             @"priceMapping.min_Price":priceMapping.min_Price,
                             @"priceMapping.max_Price":priceMapping.max_Price,
                             @"priceButton":@"3"
                             };
    [_focusMemoryDic setObject:dicdic forKey:focusMemoryPrice];

}

- (IBAction)filterPrice4ButtonClickEvent:(id)sender {
    UMButton *button = (UMButton *)sender;
    for (UMButton *btn in _priceButtonarray) {
        [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    }
    [button setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
    [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    
    PriceMapping *priceMapping =  _dataPricearray[1];
//#warning 价格字典
    [_priceDic setObject:priceMapping.id forKey:@"PriceId"];
    
    //选择项展示需要
    [_showfilterDic setObject:[NSString stringWithFormat:@"价格:%@",priceMapping.name] forKey:showPrice];
    //11.4 add by miao 焦点记忆
    NSDictionary *dicdic = @{@"priceMapping.id":priceMapping.id,
                             @"priceMapping.code":priceMapping.code,
                             @"priceMapping.name":priceMapping.name,
                             @"priceMapping.min_Price":priceMapping.min_Price,
                             @"priceMapping.max_Price":priceMapping.max_Price,
                             @"priceButton":@"4"
                             };
    [_focusMemoryDic setObject:dicdic forKey:focusMemoryPrice];

}

- (IBAction)filterPrice5ButtonClickEvent:(id)sender {
    UMButton *button = (UMButton *)sender;
    for (UMButton *btn in _priceButtonarray) {
        [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    }
    [button setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
    [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    
    PriceMapping *priceMapping =  _dataPricearray[0];
//#warning 价格字典
    [_priceDic setObject:priceMapping.id forKey:@"PriceId"];
    
    //选择项展示需要
    [_showfilterDic setObject:[NSString stringWithFormat:@"价格:%@",priceMapping.name] forKey:showPrice];
    //11.4 add by miao 焦点记忆
    NSDictionary *dicdic = @{@"priceMapping.id":priceMapping.id,
                             @"priceMapping.code":priceMapping.code,
                             @"priceMapping.name":priceMapping.name,
                             @"priceMapping.min_Price":priceMapping.min_Price,
                             @"priceMapping.max_Price":priceMapping.max_Price,
                             @"priceButton":@"5"
                             };
    [_focusMemoryDic setObject:dicdic forKey:focusMemoryPrice];
    
    
}

- (IBAction)filterClassifyButtonClickEvent:(id)sender {
    
    UMButton *button = (UMButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"子分类"]) {
         [self performSegueWithIdentifier:@"FilterClassifyViewController" sender:_goodCategoryObj];
        
    }else{
        [button  setTitle:@"子分类" forState:UIControlStateNormal];
        button.rightImageView.image = [UIImage imageNamed:@"btn_more@3x"];
        [button setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
        [button setTitleColor:[UIColor colorWithHexString:@"#353535"] forState:UIControlStateNormal];
        
//#warning 分类字典
        [_categoryDic removeObjectForKey:@"CategoryId"];
        
        //选择项展示相关
        [_showfilterDic removeObjectForKey:showClass];
        
        //11.4 add by miao 焦点记忆
        [_focusMemoryDic removeObjectForKey:focusMemoryClass];
        [[TMCache sharedCache] setObject:_focusMemoryDic forKey:focusMemoryFilterDic];
    }
   
}

- (IBAction)filterBrandButtonClickEvent:(id)sender {

    
    UMButton *button = (UMButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"品牌"]) {
           [self performSegueWithIdentifier:@"FilterBrandViewController" sender:nil];
        
    }
//    else{
//        [button  setTitle:@"品牌" forState:UIControlStateNormal];
//        button.rightImageView.image = [UIImage imageNamed:@"btn_more@3x"];
//        [button setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
// 
//        [button setTitleColor:[UIColor colorWithHexString:@"#353535"] forState:UIControlStateNormal];
//#warning 品牌字典
//        [_brandDic removeObjectForKey:@"BrandId"];
//        
//        //选择项展示相关
//        [_showfilterDic removeObjectForKey:showBrand];
//        //11.4 add by miao 焦点记忆
//        [_focusMemoryDic removeObjectForKey:focusMemoryBrand];
//        [[TMCache sharedCache] setObject:_focusMemoryDic forKey:focusMemoryFilterDic];
//    }
}

- (IBAction)filterColorButtonClickEvent:(id)sender {

    
    UMButton *button = (UMButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"颜色"]) {
    [self performSegueWithIdentifier:@"FilterColorViewController" sender:nil];
        
    }
//    else{
//        
//        [button  setTitle:@"颜色" forState:UIControlStateNormal];
//        button.rightImageView.image = [UIImage imageNamed:@"btn_more@3x"];
//        button.centerImageView.backgroundColor = [UIColor clearColor];
//        [button setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
//        
//         [button setTitleColor:[UIColor colorWithHexString:@"#353535"] forState:UIControlStateNormal];
//#warning 颜色字典
//        [_colorDic removeObjectForKey:@"ColorId"];
//
//        //选择项展示相关
//        [_showfilterDic removeObjectForKey:showColor];
//        //11.4 add by miao 焦点记忆
//        [_focusMemoryDic removeObjectForKey:focusMemoryColor];
//        [[TMCache sharedCache] setObject:_focusMemoryDic forKey:focusMemoryFilterDic];
//    }
    
}

- (IBAction)filterCleanButtonClickEvent:(id)sender {
    NSLog(@"_priceButtonarray--------======%d",_priceButtonarray.count);
    for (UMButton *btn in _priceButtonarray) {
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
        
         [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    }

    [_classifyButton  setTitle:@"子分类" forState:UIControlStateNormal];
    _classifyButton.rightImageView.image = [UIImage imageNamed:@"btn_more@3x"];
    [_classifyButton setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    [_classifyButton setTitleColor:[UIColor colorWithHexString:@"#353535"] forState:UIControlStateNormal];
    
    [_brandButton  setTitle:@"品牌" forState:UIControlStateNormal];
    _rightShowBrandLab.text = @"";
    
    [_colorButton  setTitle:@"颜色" forState:UIControlStateNormal];
    _rightShowColorView.backgroundColor = [UIColor clearColor];
  
    
    [_priceDic removeObjectForKey:@"PriceId"];
    [_categoryDic removeObjectForKey:@"CategoryId"];
    [_brandDic removeObjectForKey:@"BrandId"];
    [_colorDic removeObjectForKey:@"ColorId"];
    
    //选择项展示相关
    [_showfilterDic removeObjectForKey:showPrice];
    [_showfilterDic removeObjectForKey:showClass];
    [_showfilterDic removeObjectForKey:showBrand];
    [_showfilterDic removeObjectForKey:showColor];
    
    //焦点记忆删除
    [_focusMemoryDic removeAllObjects];
    [[TMCache sharedCache] removeObjectForKey:focusMemoryFilterDic];


}

- (IBAction)filterOKButtonClickEvent:(id)sender {
        [self saveFilterMothel];
   
}

- (IBAction)leftBarButtonItemClickevent:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonItemClickevent:(id)sender {
    [self saveFilterMothel];
   
}
#pragma mark--筛选获得的参数项
-(void)saveFilterMothel{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if ([_priceDic objectForKey:@"PriceId"] != NULL) {
        [dic setObject:[_priceDic objectForKey:@"PriceId"] forKey:@"PriceId"];
    }
    if ([_categoryDic objectForKey:@"CategoryId"] != NULL) {
        [dic setObject:[_categoryDic objectForKey:@"CategoryId"] forKey:@"CategoryId"];
    }else{
//12.3
        if (_goodCategoryObj.id != nil) {
             [dic setObject:_goodCategoryObj.id forKey:@"CategoryId"];
        }else{
        
            [dic setObject:_descContent forKeyedSubscript:@"Desc"];
        }
       
    }
    
    if ([_brandDic objectForKey:@"BrandId"] != NULL) {
        [dic setObject:[_brandDic objectForKey:@"BrandId"] forKey:@"BrandId"];
    }
    
    if ([_colorDic objectForKey:@"ColorId"] != NULL) {
        [dic setObject:[_colorDic objectForKey:@"ColorId"] forKey:@"ColorId"];
    }
    
    //选择项展示相关
    NSMutableString *filterStr = [NSMutableString new];
    if ([_showfilterDic objectForKey:showPrice] != NULL) {
        [filterStr appendString:[NSString stringWithFormat:@"  %@",[_showfilterDic objectForKey:showPrice]]];
    }
    if ([_showfilterDic objectForKey:showClass] != NULL) {
                [filterStr appendString:[NSString stringWithFormat:@"  %@",[_showfilterDic objectForKey:showClass]]];
    }
    if ([_showfilterDic objectForKey:showColor] != NULL) {
                [filterStr appendString:[NSString stringWithFormat:@"  %@",[_showfilterDic objectForKey:showColor]]];
    }
    if ([_showfilterDic objectForKey:showBrand] != NULL) {
                [filterStr appendString:[NSString stringWithFormat:@"  %@",[_showfilterDic objectForKey:showBrand]]];
    }
    
    //特殊only show for people
    [dic setObject:filterStr forKey:showFilterStr];

    NSLog(@"_focusMemoryDic_focusMemoryDic---%@",_focusMemoryDic);
    [[TMCache sharedCache] setObject:_focusMemoryDic forKey:focusMemoryFilterDic];
   
    //add by miao 12.3
    if (dic.allKeys.count != 0) {
        if (_myblock) {
            _myblock(dic);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

@end
