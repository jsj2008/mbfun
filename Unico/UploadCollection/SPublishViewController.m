//
//  SPublishViewController.m
//  Wefafa
//
//  Created by chencheng on 15/8/25.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SPublishViewController.h"
#import "SSelectBodyTypeViewController.h"
#import "SUtilityTool.h"
#import "Toast.h"
#import "KVNProgress.h"
#import "Dialog.h"
#import "SDataCache.h"
#import "QiniuSDK.h"
#import "SProductTagEditeInfo.h"
#import "WeFaFaGet.h"
#import "SUploadColllocationControlCenter.h"

#define sizeK UI_SCREEN_WIDTH/750.0


@protocol TouchTableViewDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end
///重写tableview以实现touch方法
@interface  TouchTableView : UITableView
{
@private
    id  touchDelegate;
}
@property (nonatomic,assign) id<TouchTableViewDelegate> touchDelegate;
@end

@implementation TouchTableView
@synthesize touchDelegate = _touchDelegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
    {
        [_touchDelegate tableView:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)])
    {
        [_touchDelegate tableView:self touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)])
    {
        [_touchDelegate tableView:self touchesEnded:touches withEvent:event];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)])
    {
        [_touchDelegate tableView:self touchesMoved:touches withEvent:event];
    }
}
@end




@interface SPublishViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,TouchTableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    UINavigationBar *_navigationBar;
    TouchTableView *_myTable;
    
    ///标签输入框
    UITextField *_txtField;
    ///标签
    UILabel *_tagLabel;
    ///标签个数
    UILabel *_tagNumLabel;
    ///标签table
    TouchTableView *_tagTable;
    ///添加按钮
    UIButton *_btnAdd;
    ///标签输入界面
    UIView *_tagView;
    ///标签提示按钮
    UIButton *_tipsButton;
    ///标签section分割线
    UIView *_lineV;
    
    ///标签表数组
    NSMutableArray *_tagTableArray;
    ///标签数组
    NSMutableArray *_tagArray;
    
    UIPickerView *heightPicker;
    ///记录位移量
    CGFloat _scrollHeight;
    
    ///组成的字典数组
    NSMutableArray *_productDicArray;
    
    ///年龄数组
    NSMutableArray *ageArray;
    ///身高数组
    NSMutableArray *heightArray;
    
    ///搭配描述
    NSString *_descriptStr;
    ///性别
    NSInteger _sex;
    NSArray *_sexArray;
    ///身高
    NSInteger _height;
    ///年龄
    NSInteger _age;
    ///体重
    NSInteger _weight;
    NSArray *_weightArray;
    ///公开/非公开
    NSInteger _publish;
    
    NSMutableArray *_brandList;
}

@end

@implementation SPublishViewController

#pragma mark - 构造与析构


- (id)init
{
    self = [super init];
    if (self != nil)
    {
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        self.navigationItem.leftBarButtonItems = @[backButtonItem];
        
        UIButton *pulishButton=[UIButton buttonWithType:UIButtonTypeSystem];
        pulishButton.frame=CGRectMake(0, 0, 36, 30);
        [pulishButton setTintColor:COLOR_C1];
        pulishButton.titleLabel.font=FONT_SIZE(18);
        [pulishButton setTitle:@"发布" forState:UIControlStateNormal];
        [pulishButton addTarget:self action:@selector(pulishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:pulishButton];
        
        UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pulishButton];
        self.navigationItem.rightBarButtonItems = @[nextButtonItem];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"发布搭配";
        
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}

#pragma mark - 视图控制器接口

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if ([self.view.gestureRecognizers count] > 0)
    {
        for(UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers)
        {
            if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
            }
        }
    }
    if (screenEdgePanGestureRecognizer != nil)
    {
        [self.view removeGestureRecognizer:screenEdgePanGestureRecognizer];//此处禁止屏幕边界右滑时返回上一级界面的手势
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor=COLOR_C4;
    
    _descriptStr=@"";
    _weightArray=@[@"纤细",@"匀称",@"微胖",@"肥胖"];
    _weight=-1;
    _sexArray=@[@"男",@"女"];
    _sex=0;
    _publish=1;
    _brandList=[NSMutableArray array];
    
    
    _myTable=[[TouchTableView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44) style:UITableViewStyleGrouped];
    _myTable.backgroundColor=COLOR_C4;
    _myTable.tableFooterView=[[UIView alloc] init];
    _myTable.sectionFooterHeight=0;
    _myTable.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
    _myTable.dataSource=self;
    _myTable.delegate=self;
    _myTable.touchDelegate=self;
    _myTable.showsVerticalScrollIndicator=NO;
    _myTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTable];
    
    [self setupNavbar];
    [self.view addSubview:_navigationBar];
    
//    [_myTable addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    _tagArray=[NSMutableArray array];
    _tagTableArray=[[NSMutableArray alloc] initWithCapacity:0];
    _productDicArray=[NSMutableArray array];
    [self createTagTable];
    
    //初始化数组
    //身高
    heightArray=[[NSMutableArray alloc] initWithCapacity:0];
    for (int i=30; i<200; i++)
    {
        [heightArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _height=-1;
    //年龄
    ageArray=[NSMutableArray array];
    for (int i=0; i<=100; i++)
    {
        [ageArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _age=-1;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_tagTable) {
        return 1;
    }
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tagTable) {
        return _tagTableArray.count;
    }
    
    if (section==2) {
        return 4;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_tagTable) {
        return 0;
    }
    if (section==1) {
        return 180*sizeK;
    }
    return 80*sizeK;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tagTable) {
        return 100*sizeK;
    }
    if (indexPath.section==0)
    {
        return 200*sizeK;
    }
    if (indexPath.section==1) {
        return [self getTagCellHeight];
    }
    return 100*sizeK;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    if (tableView==_myTable) {
        if (indexPath.section==0)
        {
            cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 200*sizeK)];
            
            UITextView *txtView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 200*sizeK)];
            txtView.textColor=COLOR_C6;
            txtView.text=@"请简单描述搭配秘诀...";
            txtView.font=FONT_t4;
            if (_descriptStr.length>0) {
                txtView.textColor=COLOR_C2;
                txtView.text=_descriptStr;
            }
            txtView.backgroundColor=[UIColor whiteColor];
            txtView.textContainerInset=UIEdgeInsetsMake(20*sizeK, 26*sizeK, 20*sizeK, 26*sizeK);
            txtView.delegate=self;
            
            [cell addSubview:txtView];
            //分割线
            UIView *lineV=[[UIView alloc] initWithFrame:CGRectMake(0, 199*sizeK, UI_SCREEN_WIDTH, 1*sizeK)];
            lineV.tag=1;
            lineV.backgroundColor=COLOR_C9;
            [cell addSubview:lineV];
        }
        else if (indexPath.section==2)
        {
            static NSString *cellIdentifier=@"cell";
            cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
                //分割线
                UIView *lineV=[[UIView alloc] initWithFrame:CGRectMake(0, 100*sizeK, UI_SCREEN_WIDTH, 1*sizeK)];
                lineV.tag=1;
                lineV.backgroundColor=COLOR_C9;
                [cell addSubview:lineV];
                
                //标题
                UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(34*sizeK, 0, 100*sizeK, 100*sizeK)];
                lblTitle.tag=2;
                lblTitle.font=FONT_t4;
                lblTitle.textColor=COLOR_C2;
                [cell addSubview:lblTitle];
                
                //星号
                UILabel *lblV=[[UILabel alloc] initWithFrame:CGRectMake(106*sizeK, (100*sizeK-30)/2+15*sizeK, 30, 30)];
                lblV.tag=3;
                lblV.font=[UIFont systemFontOfSize:30];
                lblV.textColor=COLOR_C10;
                lblV.text=@"*";
                [cell addSubview:lblV];
                
                //描述
                UILabel *lblDes=[[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-236*sizeK, 0, 152*sizeK, 100*sizeK)];
                lblDes.textAlignment=NSTextAlignmentRight;
                lblDes.font = FONT_t5;
                lblDes.textColor = COLOR_C2;
                lblDes.tag=4;
                [cell addSubview:lblDes];
            }
            UILabel *lblTitle=(UILabel*)[cell viewWithTag:2];
            UILabel *lblV=(UILabel*)[cell viewWithTag:3];
            lblV.hidden=YES;
            UILabel *lblDes=(UILabel *)[cell viewWithTag:4];
            lblDes.text=@"";
            UIView *lineV=[cell viewWithTag:1];
            
            if (indexPath.row==3) {
                lineV.frame=CGRectMake(0, 99*sizeK, UI_SCREEN_WIDTH, 1*sizeK);
                lblTitle.text=@"体型";
                if (_weight>-1) {
                    lblDes.text=_weightArray[_weight];
                }
            }
            else
            {
                lineV.frame=CGRectMake(34*sizeK, 99*sizeK, UI_SCREEN_WIDTH-34*sizeK, 1*sizeK);
                if (indexPath.row==0) {
                    lblV.hidden=NO;
                    lblTitle.text=@"性别";
                    lblDes.text=_sexArray[_sex];
                }
                if (indexPath.row==1) {
                    lineV.frame=CGRectMake(34*sizeK, 98*sizeK, UI_SCREEN_WIDTH-34*sizeK, 1*sizeK);
                    lblTitle.text=@"身高";
                    if (_height>-1) {
                        lblDes.text=[NSString stringWithFormat:@"%@cm",heightArray[_height]];
                    }
                }
                if (indexPath.row==2) {
                    lblTitle.text=@"年龄";
                    if (_age>-1) {
                        lblDes.text=[NSString stringWithFormat:@"%ld",(long)_age];
                    }
                }
            }
        }
        else if(indexPath.section==3)
        {
            cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100*sizeK)];
            
            //标题
            UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(34*sizeK, 0, UI_SCREEN_WIDTH- 34*sizeK, 100*sizeK)];
            lblTitle.font=FONT_t4;
            lblTitle.tag=2;
            lblTitle.textColor=COLOR_C2;
            lblTitle.text=@"公开";
            if (_publish==0) {
                lblTitle.text=@"非公开";
            }
            [cell addSubview:lblTitle];
            
            UISwitch *switchU=[[UISwitch alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-34*sizeK-51, (100*sizeK-31)/2, 51, 31)];
            switchU.onTintColor=COLOR_C1;
            ///开关
            switchU.on=_publish;
            [switchU addTarget:self action:@selector(switchUChange:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchU];
        }
        else
        {
            cell=[[UITableViewCell alloc] init];
            CGSize size;
            
            int marginX=44*sizeK;
            int marginY=28*sizeK;
            
            for ( int i=0;i<_tagArray.count;i++ ) {
                
                NSString *tagString=_tagArray[i];
                
                UILabel *lblTag=[[UILabel alloc] init];
                lblTag.font=FONT_t6;
                lblTag.textColor=COLOR_C3;
                lblTag.text=tagString;
//                size=[tagString sizeWithFont:lblTag.font constrainedToSize:CGSizeMake(MAXFLOAT, lblTag.frame.size.height)];
                size=[tagString sizeWithAttributes:@{NSFontAttributeName:lblTag.font}];
                lblTag.frame=CGRectMake(18*sizeK, 0, size.width, 44*sizeK);
                
                int btnWidth=66*sizeK+size.width;
                if (marginX+btnWidth>UI_SCREEN_WIDTH-54*sizeK) {
                    marginY+=72*sizeK;
                    marginX=44*sizeK;
                }
                
                UIButton *tagButton=[UIButton buttonWithType:UIButtonTypeCustom];
                tagButton.backgroundColor=COLOR_C7;
                tagButton.layer.cornerRadius=6*sizeK;
                tagButton.frame=CGRectMake(marginX, marginY, btnWidth, 44*sizeK);
                [tagButton addTarget:self action:@selector(removeTagButton:) forControlEvents:UIControlEventTouchUpInside];
                tagButton.tag=i+1;
                [cell addSubview:tagButton];
                
                [tagButton addSubview:lblTag];
                
                UIImageView *tagV=[[UIImageView alloc] initWithFrame:CGRectMake(lblTag.frame.origin.x+size.width+12*sizeK, 12*sizeK, 20*sizeK, 20*sizeK)];
                tagV.image=[UIImage imageNamed:@"Unico/tagdelete"];
                [tagButton addSubview:tagV];
                
                marginX+=btnWidth+10*sizeK;
                
            }
            
        }
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"tagCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tagCell"];
            cell.separatorInset=UIEdgeInsetsMake(0, 40*sizeK, 0, 0);
            //标题
            UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(40*sizeK, 0,  UI_SCREEN_WIDTH-40*sizeK, 100*sizeK)];
            lblTitle.tag=2;
            lblTitle.font=FONT_t4;
            lblTitle.textColor=COLOR_C2;
            [cell addSubview:lblTitle];
        }
        
        UILabel *lblTitle=(UILabel*)[cell viewWithTag:2];
        lblTitle.text=_tagTableArray[indexPath.row];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionBG=[[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 80*sizeK)];
    sectionBG.backgroundColor=[UIColor whiteColor];
    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 80*sizeK)];
    sectionView.backgroundColor=COLOR_C4;
    [sectionBG addSubview:sectionView];
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(34*sizeK, 0, 200, 80*sizeK)];
    lblTitle.font=FONT_t6;
    lblTitle.textColor=COLOR_C2;
    [sectionView addSubview:lblTitle];
    
    //描述
    UILabel *lblDescript=[[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-270*sizeK, 0, 250*sizeK, 80*sizeK)];
    lblDescript.font=FONT_t6;
    lblDescript.textColor=COLOR_C7;
    lblDescript.textAlignment=NSTextAlignmentRight;
    [sectionView addSubview:lblDescript];
    
    if (section==0)
    {
        lblTitle.text=@"搭配描述";
        lblDescript.text=@"最多140个字";
    }
    if (section==1) {
        lblTitle.text=@"标签";
        lblDescript.text=@"最多14个字";
        
        sectionBG.frame=CGRectMake(0, 0, UI_SCREEN_WIDTH, 180*sizeK);
        
        UIImageView *picImage=[[UIImageView alloc] initWithFrame:CGRectMake(34*sizeK, 115*sizeK, 30*sizeK, 30*sizeK)];
        picImage.image=[UIImage imageNamed:@"Unico/biaoqian"];
        [sectionBG addSubview:picImage];
        
        ///描述
        _txtField=[[UITextField alloc] initWithFrame:CGRectMake(84*sizeK, 80*sizeK, UI_SCREEN_WIDTH-84*sizeK-65*sizeK, 100*sizeK)];
        _txtField.font=FONT_t4;
        _txtField.placeholder=@"图案、场景、种类、季节等";
        _txtField.delegate=self;
        //添加对输入框的通知监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(txtFieldChange:) name:UITextFieldTextDidChangeNotification object:_txtField];
        [sectionBG addSubview:_txtField];
        _tipsButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _tipsButton.frame=_txtField.frame;
        _tipsButton.enabled=NO;
        [_tipsButton addTarget:self action:@selector(tipsButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [sectionBG addSubview:_tipsButton];
        
        _btnAdd=[UIButton buttonWithType:UIButtonTypeSystem];
        _btnAdd.frame=CGRectMake(UI_SCREEN_WIDTH-60*sizeK, 110*sizeK, 40*sizeK, 40*sizeK);
        [_btnAdd setBackgroundImage:[UIImage imageNamed:@"Unico/btn_add-tag"] forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
        _btnAdd.hidden=YES;
        [sectionBG addSubview:_btnAdd];
        
        //分割线
        _lineV=[[UIView alloc] initWithFrame:CGRectMake(0, 179*sizeK,UI_SCREEN_WIDTH, 1*sizeK)];
        _lineV.tag=1;
        _lineV.backgroundColor=COLOR_C9;
        [sectionBG addSubview:_lineV];
        
    }
    if (section==2) {
        lblTitle.text=@"模特资料";
    }
    if (section==3) {
        lblTitle.text=@"公开/非公开";
    }
    
    return sectionBG;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tagTable)
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        UILabel *lblTitle=(UILabel*)[cell viewWithTag:2];
        [self addTagWithString:lblTitle.text];
    }
    else
    {
        if (indexPath.section==2)
        {
            if (indexPath.row==0) {
                UIActionSheet *acticonSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
                [acticonSheet showInView:self.view];
            }
            if(indexPath.row==1)
            {
                [self showHeightView:1];
            }
            if (indexPath.row==2)
            {
                [self showHeightView:2];
            }
            if (indexPath.row==3) {
                SSelectBodyTypeViewController *sSelectBodyTypeVC=[[SSelectBodyTypeViewController alloc] init];
                sSelectBodyTypeVC.selectType=_weight;
                sSelectBodyTypeVC.didFinishBrand=^(NSInteger selectType){
                    [self modifyTableCellWithIndexPath:[NSIndexPath indexPathForRow:3 inSection:2] string:[NSString stringWithFormat:@"%ld",(long)selectType]];
                    _weight=selectType;
                };
                [self presentViewController:sSelectBodyTypeVC animated:YES completion:nil];
            }
        }
    }
}
///index：1为身高，2为年龄
-(void)showHeightView:(NSInteger)index
{
    UIView *v_iew=[self.view viewWithTag:10010];
    //判断是否存在
    if (v_iew)
    {
        return;
    }
    v_iew=[[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 520*sizeK)];
    v_iew.backgroundColor=COLOR_C7;
    v_iew.tag=10010;
    [self.view addSubview:v_iew];
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.tag=3;
    btnCancel.frame=CGRectMake(40*sizeK, 26*sizeK, 72*sizeK, 36*sizeK);
    btnCancel.titleLabel.font=[UIFont systemFontOfSize:36*sizeK];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];
    [v_iew addSubview:btnCancel];
    UIButton *btnOK=[UIButton buttonWithType:UIButtonTypeCustom];
    btnOK.tag=4;
    btnOK.frame=CGRectMake(UI_SCREEN_WIDTH-112*sizeK, 26*sizeK, 72*sizeK, 36*sizeK);
    btnOK.titleLabel.font=[UIFont systemFontOfSize:36*sizeK];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];
    [v_iew addSubview:btnOK];
    
    heightPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 88*sizeK, UI_SCREEN_WIDTH, 432*sizeK)];
    heightPicker.delegate=self;
    heightPicker.dataSource=self;
    heightPicker.tag=index;
    heightPicker.backgroundColor=[UIColor whiteColor];
//    [heightPicker selectRow:((index==1)?_height:_age) inComponent:0 animated:YES];
    if (index==1) {
        [heightPicker selectRow:(_height>-1?_height:140) inComponent:0 animated:YES];
    }
    else
    {
        [heightPicker selectRow:(_age>-1?_age:1) inComponent:0 animated:YES];
    }
    [v_iew addSubview:heightPicker];
    
    if (_myTable.frame.origin.y!=44) {
        _myTable.frame=CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44);
    }
    
    CGSize tableSize=_myTable.contentSize;
    [_myTable setContentOffset:CGPointMake(0, tableSize.height-580*sizeK+index*100*sizeK-44*sizeK) animated:YES];
    
    [UIView animateWithDuration:.2 animations:^{
//        _myTable.frame=CGRectMake(0, 44-(tableSize.height-580*sizeK+index*100*sizeK-44*sizeK), UI_SCREEN_WIDTH, tableSize.height);
        v_iew.frame=CGRectMake(0, UI_SCREEN_HEIGHT-510*sizeK, UI_SCREEN_WIDTH, 520*sizeK);
    }];
}

///年龄、身高选择器(确认修改)
-(void)btnOKClick:(UIButton*)sender
{
    UIView *v_iew=sender.superview;
    [self removeView:v_iew];
    
    if (sender.tag==4) {
        if (heightPicker.tag==1)
        {
            _height=[heightPicker selectedRowInComponent:0];
            [self modifyTableCellWithIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] string:[NSString stringWithFormat:@"%@cm",heightArray[_height]]];
        }
        else
        {
            _age=[heightPicker selectedRowInComponent:0];
            [self modifyTableCellWithIndexPath:[NSIndexPath indexPathForRow:2 inSection:2] string:ageArray[_age]];
        }

    }
}

///移除视图
-(void)removeView:(UIView*)v_iew
{
    [UIView animateWithDuration:.2 animations:^{
        
        if (_scrollHeight<0) {
            _scrollHeight=0;
        }
        [_myTable setContentOffset:CGPointMake(0, _scrollHeight) animated:YES];
        
//        _myTable.frame=CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44);
        
        v_iew.frame=CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 520*sizeK);
    } completion:^(BOOL finished) {
        [v_iew removeFromSuperview];
    }];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖动tableview时移除不相关视图
    UIView *v_iew=[self.view viewWithTag:10010];
    if (v_iew)
    {
        [self removeView:v_iew];
    }
    
    if (scrollView==_myTable) {
        if (_myTable.frame.origin.y!=44) {
            [UIView animateWithDuration:.2 animations:^{
                _myTable.frame=CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44);
            }];
        }
    }
    
    [self.view endEditing:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView==_myTable) {
        _scrollHeight=_myTable.contentOffset.y;
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==1)
    {
        return heightArray.count;
    }
    else
    {
        return ageArray.count;
    }
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_C2;
    titleLabel.font = [UIFont systemFontOfSize:22];
    if (pickerView.tag==1)
    {
        
        titleLabel.text = [NSString stringWithFormat:@"%@cm",heightArray[row]];
    }
    else
    {
        titleLabel.text =ageArray[row];
    }

    return titleLabel;
}

#pragma mark - 修改表格数据
-(void)modifyTableCellWithIndexPath:(NSIndexPath*)indexPath string:(NSString*)aString
{
    //找到所在单元格
    UITableViewCell *cell=[_myTable cellForRowAtIndexPath:indexPath];
    UILabel *lblDes=(UILabel *)[cell viewWithTag:4];
    if (aString)
    {
        if (indexPath.row==3) {
            lblDes.text=_weightArray[[aString integerValue]];
        }
        else
        {
            lblDes.text=aString;
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2) {
        return;
    }
    [self modifyTableCellWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] string:_sexArray[buttonIndex]];
    _sex=buttonIndex;
}

#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
        textView.textColor=COLOR_C6;
        textView.text=@"请简单描述搭配秘诀...";
    }
    return YES;
}

-(void)endEdit
{
    
    [self.view endEditing:YES];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请简单描述搭配秘诀..."])
    {
        textView.textColor=COLOR_C2;
        textView.text=@"";
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    //如果超过140个字就截断
    //为了防止重复提示，需要判断
    NSString *toBeString = textView.text;
    NSString *lang = [[[UIApplication sharedApplication] textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 140) {
                textView.text = [toBeString substringToIndex:140];
                [[[UIAlertView alloc] initWithTitle:nil message:@"最多输入140个文字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                return;
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    else
    {
        if (toBeString.length > 140) {
            textView.text = [toBeString substringToIndex:140];
        }
    }
    _descriptStr=toBeString;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (![self tagArrayChange]) {
        return NO;
    }
    
    if (textField.text.length>0) {
        _btnAdd.hidden=NO;
    }
    
//    [_myTable setContentOffset:CGPointMake(0, 280*sizeK) animated:YES];
    
        [UIView animateWithDuration:.2 animations:^{
            [_myTable setContentOffset:CGPointMake(0, 0) animated:NO];
            _myTable.frame=CGRectMake(0, 44-280*sizeK, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT+280*sizeK-44);
        }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.text.length<1) {
        _btnAdd.hidden=YES;
    }
    if (!_tagView.hidden) {
        return YES;
    }
    if (_myTable.frame.origin.y!=44) {
        [UIView animateWithDuration:.2 animations:^{
            _myTable.frame=CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44);
        }];
    }
    
    return YES;
}

#pragma mark - NSNotification
-(void)txtFieldChange:(NSNotification*)noti
{
    
    if (_txtField.text.length>0) {
        if (_tagView.hidden) {
            _tagView.hidden=NO;
            _lineV.frame=CGRectMake(40*sizeK, 179*sizeK, UI_SCREEN_WIDTH-40*sizeK, 1*sizeK);
        }
        
        NSString *lang = [[[UIApplication sharedApplication] textInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            NSString *toBeString = _txtField.text;
            UITextRange *selectedRange = [_txtField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [_txtField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 14) {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"最多输入14个文字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                    _txtField.text = [toBeString substringToIndex:14];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
            }
        }
        else
        {
            if (_txtField.text.length > 14) {
                _txtField.text = [_txtField.text substringToIndex:14];
            }
        }
        
        _btnAdd.hidden=NO;
        
        //需要搜索的关键字
        NSString *searchText=_txtField.text;
        UITextRange *selectedRange = [_txtField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [_txtField positionFromPosition:selectedRange.start offset:0];
        if (position) {
            NSInteger num= [_txtField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
            searchText=[_txtField.text substringToIndex:_txtField.text.length-num ];
        }
        
        
        _tagLabel.text=[NSString stringWithFormat:@"包含“%@”的标签",searchText];
        
        if (searchText.length>0) {
            [self getTagList:searchText];
        }
        
    }
    else
    {
        _btnAdd.hidden=YES;
        _tagView.hidden=YES;
        if (_tagArray.count<1) {
            _lineV.frame=CGRectMake(0, 179*sizeK, UI_SCREEN_WIDTH, 1*sizeK);
        }
        [_tagTableArray removeAllObjects];
        [_tagTable reloadData];
    }
}

-(void)getTagList:(NSString*)string
{
    [_tagTableArray removeAllObjects];
    [_tagTable reloadData];
    NSDictionary *data = @{
                           @"m": @"Collocation",
                           @"a": @"getTopicConfigList",
                           @"num": @"100",
                           @"str": [[NSString alloc] initWithFormat:@"%@",string],
                           };
    
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object[@"status"] intValue] != 1) {
            [Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
            return ;
        }
        NSArray *array = object[@"data"];
        
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [_tagTableArray addObject:obj[@"name"]];
        }];
        
        [_tagTable reloadData];
        
        _tagNumLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)_tagTableArray.count];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

-(BOOL)tagArrayChange
{
    if (_tagArray.count>9) {
        _txtField.enabled=NO;
        _tipsButton.enabled=YES;
        return NO;
    }
    else
    {
        _txtField.enabled=YES;
        _tipsButton.enabled=NO;
        return YES;
    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        if (_tagView.hidden) {
            _myTable.scrollEnabled=YES;
        }
        else
        {
            _myTable.scrollEnabled=NO;
        }
}

#pragma mark - 计算标签cell高度
-(int)getTagCellHeight
{
    if (_tagArray.count<1) {
        _lineV.frame=CGRectMake(0, 179*sizeK, UI_SCREEN_WIDTH, 1*sizeK);
        return 0;
    }
    _lineV.frame=CGRectMake(40*sizeK, 179*sizeK, UI_SCREEN_WIDTH-40*sizeK, 1*sizeK);
    CGSize size;
    int marginX=44*sizeK;
    
    int height=100*sizeK;
    
    for (NSString *tagString in _tagArray) {
        
//        size=[tagString sizeWithFont:FONT_t6 constrainedToSize:CGSizeMake(MAXFLOAT, 44*sizeK)];
        size=[tagString sizeWithAttributes:@{NSFontAttributeName:FONT_t6}];
        
        int btnWidth=66*sizeK+size.width;
        
        if (marginX+btnWidth>UI_SCREEN_WIDTH-54*sizeK) {
            height+=72*sizeK;
            marginX=44*sizeK;
        }
         marginX+=btnWidth+10*sizeK;
    }
    
    return height;
}

#pragma mark - 其他UI接口
/**
 *   构建导航栏
 */
- (void)setupNavbar
{
    [super setupNavbar];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    [_navigationBar pushNavigationItem:self.navigationItem animated:NO];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/blackBarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
    
    //添加单击手势以结束编辑
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    tapGesture.numberOfTapsRequired=1;
    tapGesture.numberOfTouchesRequired=1;
    tapGesture.delegate=self;
    [_navigationBar addGestureRecognizer:tapGesture];
}

///创建标签table输入视图
-(void)createTagTable
{
    _tagView=[[UIView alloc] initWithFrame:CGRectMake(0, 44+180*sizeK, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44-180*sizeK)];
    _tagView.tag=10086;
    _tagView.backgroundColor=[UIColor whiteColor];
    _tagView.hidden=YES;
    [_tagView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_tagView];
    
    _tagLabel=[[UILabel alloc] initWithFrame:CGRectMake(40*sizeK, 0, UI_SCREEN_WIDTH-40*sizeK, 50*sizeK)];
    _tagLabel.font=FONT_t4;
    _tagLabel.textColor=COLOR_C6;
    [_tagView addSubview:_tagLabel];
    
    _tagNumLabel=[[UILabel alloc] initWithFrame:CGRectMake(40*sizeK, 0, UI_SCREEN_WIDTH-74*sizeK, 50*sizeK)];
    _tagNumLabel.font=FONT_t4;
    _tagNumLabel.textColor=COLOR_C6;
    _tagNumLabel.textAlignment=NSTextAlignmentRight;
    [_tagView addSubview:_tagNumLabel];
    
    _tagTable=[[TouchTableView alloc] initWithFrame:CGRectMake(0, 50*sizeK, UI_SCREEN_WIDTH, _tagView.frame.size.height-50*sizeK) style:UITableViewStylePlain];
    _tagTable.tableFooterView=[[UIView alloc] init];
    _tagTable.delegate=self;
    _tagTable.dataSource=self;
    [_tagView addSubview:_tagTable];
}

-(void)dealloc
{
    //移除监听
    [_tagView removeObserver:self forKeyPath:@"hidden"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_txtField];
}

#pragma mark - 控件事件接口
-(void)requestSearchTagData
{
    NSDictionary *data = @{
                           @"m": @"Product",
                           @"a": @"getUserProductListByCategory",
                           @"token": @"4772ebe146c006d4adb2ffa6c40032e0",
                           @"page": @(0),
                           @"pageSize": @(20)
                           };
    
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object[@"status"] intValue] != 1) {
            [Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
            return ;
        }
        NSArray *array = object[@"data"][@"list"];
        if (array.count == 0) {
            array = object[@"data"][@"hotlist"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

-(void)switchUChange:(UISwitch*)sender
{
    UILabel *lblTitle=(UILabel*)[sender.superview viewWithTag:2];
    if (sender.on) {
        lblTitle.text=@"公开";
        _publish=1;
    }
    else
    {
        lblTitle.text=@"非公开";
        _publish=0;
    }
}

-(void)removeTagButton:(UIButton*)sender
{
    [_tagArray removeObjectAtIndex:sender.tag-1];
    [self tagArrayChange];
    [_myTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)btnAddClick
{
    if (_txtField.text.length<15) {
        [self addTagWithString:_txtField.text];
    }
    else
    {
        _txtField.text = [_txtField.text substringToIndex:_txtField.text.length-1];
        [self txtFieldChange:nil];
    }
}
///添加标签
-(void)addTagWithString:(NSString*)aString
{
    [_tagArray addObject:aString];
    _txtField.text=@"";
    _btnAdd.hidden=YES;
    _tagView.hidden=YES;
    [_myTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    [self tagArrayChange];
}

-(void)tipsButtonClick
{
    [self.view endEditing:YES];
    UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360*sizeK, 200*sizeK)];
    dialogView.backgroundColor = [UIColor blackColor];
    dialogView.layer.cornerRadius = 8;
    dialogView.layer.masksToBounds = YES;
    dialogView.alpha = 0.8;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/warning"]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(158*sizeK, 40*sizeK, 44*sizeK, 44*sizeK);
    [dialogView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 114*sizeK, dialogView.frame.size.width, 26*sizeK)];
    titleLabel.text = @"最多只可添加10个标签";
    titleLabel.font = FONT_t5;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [dialogView addSubview:titleLabel];
    
    
    [CCDialog showDialogView:dialogView modal:YES showDialogViewAnimationOption:QFShowDialogViewAnimationFromCenter completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [CCDialog closeDialogViewWithAnimationOptions:QFCloseDialogViewAnimationToCenter completion:^(BOOL finished) {
                
            }];
        });
        
    }];
    
}

- (void)backButtonClick:(id)sender
{
    if (self.back != nil)
    {
        self.back();
    }
}

- (void)pulishButtonClick:(UIButton*)sender
{
    //[Toast makeToastActivity:@"搭配上传中，请稍等..." hasMusk:YES];
    
    [MWKProgressIndicator show];
    [MWKProgressIndicator updateProgress:1.0f];
    [MWKProgressIndicator updateMessage:@"正在上传..."];
    
    //先组数据
    [self makeupProductArray];
}


/*
 'token' => "用户标识不能为空",
 'imgUrl' => "搭配图片不能为空",
 'imgWidth' => "搭配图片不能为空",
 'imgHeight' => "搭配图片不能为空",
 'contentInfo' => "内容信息不能为空",
 'tagJson' => "",
 'brandList'=>"",
 'tabList' => "",
 'stickImgUrl' => "",
 'videoUrl' => "",
 'userType' => "搭配类型不能为空",
 'userJson' => "类型信息不能为空",
 'sysUserId' => "上传来源不能为空"
 */
///开始上传搭配 isImg YES 上传图片 NO 上传视频
-(void)uploadProductDataWithImage:(BOOL)isImg URL:(NSString*)url
{
    //开始上传搭配
    //调用接口，上传搭配
    //成功后调用block返回
    
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    NSDictionary *data = @{
                           @"m": @"Collocation",
                           @"a": @"pushUserCollocationV2",
                           @"token":userToken,
                           @"imgUrl": [[NSString alloc] initWithFormat:@"%@",_ProductImageUrl?_ProductImageUrl:@""],
                           @"imgWidth": [[NSString alloc] initWithFormat:@"%f",isImg?_ProductImage.size.width:_ImgSize.width],
                           @"imgHeight":  [[NSString alloc] initWithFormat:@"%f",isImg?_ProductImage.size.height:_ImgSize.height],
                           @"contentInfo": [[NSString alloc]initWithFormat:@"%@",_descriptStr] ,
                           @"tagJson": [self DataTOjsonString:_productDicArray],
                           @"brandList": [self DataTOjsonString:_brandList],
                           @"tabList": [self DataTOjsonString:_tagArray],
                           @"stickImgUrl": @"",
                           @"videoUrl": [[NSString alloc] initWithFormat:@"%@",isImg?@"":url],
                           @"userType": [NSString stringWithFormat:@"%ld",(long)(_sex+1)],
                           @"userJson": [self DataTOjsonString:@{@"type":[NSString stringWithFormat:@"%ld",(long)(_sex+1)],
                                                                 @"info":_sexArray[_sex],
                                                                 @"height":_height>-1?heightArray[_height]:@"",
                                                                 @"age":_age>-1?ageArray[_age]:@"",
                                                                 @"weight":_weight>-1?_weightArray[_weight]:@""}],
                           @"sysUserId": @"",
                           @"isShow":[[NSString alloc] initWithFormat:@"%ld",(long)_publish]
                           };
    NSLog(@"%@",data);
    [[SDataCache sharedInstance]quickPost:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object[@"status"] intValue] != 1) {
            //[Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
            //[MWKProgressIndicator dismiss];
            [MWKProgressIndicator showErrorMessage:@"发布失败了，再试试吧~"];
            return ;
        }
        
        if ([object[@"data"] intValue] ==1) {
            //上传成功
            //[MWKProgressIndicator dismiss];
            [MWKProgressIndicator showSuccessMessage:@"您的创作内容已经成功发布!"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MBFUN_PUBLISH_SUCCESS" object:nil userInfo:nil];
            NSLog(@"您的创作内容已经成功发布!");
            
            [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] exitUploadColllocationWithAnimated:YES];
            //调用评论界面  不要删除
            [SUTILITY_TOOL_INSTANCE performSelector:@selector(showPraiseBox) withObject:nil afterDelay:3];
        }
        
        //[Toast hideToastActivity];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
        
        //[MWKProgressIndicator dismiss];
        //[MWKProgressIndicator showErrorMessage:@"网络不给力..发布失败了"];
        
        [MWKProgressIndicator showErrorMessage:error.domain];
        
        NSLog(@"发布失败了，再试试吧~");
    }];
}

///组成上传后的单品组成字典数组
-(void)makeupProductArray
{
    for (SProductTagEditeInfo *sproductTEI in _productArray)
    {
        NSString *type=type=@"100";
        if (sproductTEI.productCode.length<1) {
            type=@"101";  //假商品
        }
        
        int flip = 0;
        if (sproductTEI.tagViewFlip)
        {
            flip = 1;
        }
        
        NSDictionary *dic=@{
                            @"x":[[NSString alloc] initWithFormat:@"%f",sproductTEI.tagViewToPoint.x ],
                            @"y":[[NSString alloc] initWithFormat:@"%f",sproductTEI.tagViewToPoint.y ],
                            @"attributes":@{@"type":type,
                                                            @"id":[[NSString alloc] initWithFormat:@"%@",sproductTEI.productId],
                                            @"code":[[NSString alloc] initWithFormat:@"%@",sproductTEI.productCode?sproductTEI.productCode:@""],
                                                            @"flip":[NSString stringWithFormat:@"%d", flip]//是否反转
                                                        },
                            @"text":[[NSString alloc] initWithFormat:@"%@",sproductTEI.productBrandName],
                            @"brandCode":[[NSString alloc] initWithFormat:@"%@",sproductTEI.productBrandCode]
                            };
        [_brandList addObject:[NSString stringWithFormat:@"%@",sproductTEI.productBrandCode?sproductTEI.productBrandCode:@""]];
        [_productDicArray addObject:dic];
    }
    
    //组成字典数组后
    [self getProductImageAndVideoURL];
}

///获取图片和/或视频URL
-(void)getProductImageAndVideoURL
{
    //图片不应为空
    
    if (!_ProductImageUrl) {
        if (!_ProductImage) {
            _ProductImage=[UIImage new];
        }
        [[SDataCache sharedInstance] uploadImageToQiNiuWithImage:_ProductImage complete:^(NSString *url) {
            _ProductImageUrl=url;
            [self getProductImageAndVideoURL];
            }];
    }
    else
    {
        if (!_videoURL) {
            [self uploadProductDataWithImage:YES URL:nil];
        }
        else
        {
            //上传视频
            [[SDataCache sharedInstance] uploadVideoToQiNiuWithURL:_videoURL videoSize:self.ImgSize complete:^(NSString *url) {
                
                NSLog(@"视频 url = %@", url);
                //此处在社区关注页面需要//刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadImageToQiNiuWithImage" object:nil];
                
                [self uploadProductDataWithImage:NO URL:url];
            }];
        }
    }
}

///转JSON
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = @"";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
       jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString=[jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonString=[jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return jsonString;
}

- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




@end
