//
//  CommunicateViewController.m
//  Wefafa
//
//  Created by fafa  on 13-6-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "ClassifyViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomContentModelView.h"
#import "NavigationTitleView.h"
#import "MBShoppingGuideInterface.h"
#import "Toast.h"
#import "CollocationViewController.h"
#import "ClickClassifyPushViewController.h"
#import "GetViewControllerFile.h"
#import "Utils.h"
#import "AppSetting.h"
#import "UIUrlImageView.h"

@implementation ClassifyViewController
{
    NSString *leftNameStr;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { 
//        self.title = @"分类";
//        self.tabBarItem.image = [UIImage imageNamed:@"fenlei.png"];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //new headview
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"分类";
    [self.headView addSubview:view];
    _commentArray=[[NSMutableArray alloc] initWithCapacity:10];
    listInfo  = [[NSMutableArray alloc]init];
    //左侧按钮
    leftscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 69+50, 80, UI_SCREEN_HEIGHT-49-44)];
    leftscrollview.userInteractionEnabled=YES;
    [leftscrollview setBounces:NO];
    [leftscrollview setPagingEnabled:NO];
    leftscrollview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:leftscrollview];
    
    _rightScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(80, 69+50, UI_SCREEN_WIDTH-80, UI_SCREEN_HEIGHT-44-49)];
    _rightScrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_rightScrollView];
     _menuArray=[[NSMutableArray array]init];

    [self requestInfo:@"0" onRefresh:^(NSMutableArray *arr,int refreshId){
            for (UIView *btn in leftscrollview.subviews)
            {
                [btn removeFromSuperview];
            }
            [_menuArray removeAllObjects];
            
            [_menuArray addObjectsFromArray:arr];
            for (int a=0; a<_menuArray.count; a++)
            {
                UIButton *classifyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 45*a, 80, 45)];
                classifyBtn.tag=[[Utils getSNSInteger:[_menuArray objectAtIndex:a][@"tagInfo"][@"id"]] intValue];
                classifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [classifyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [classifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                if (a==0)
                {
                    [classifyBtn setBackgroundColor:[UIColor whiteColor]];
                    leftNameStr = [NSString stringWithFormat:@"%@",[_menuArray objectAtIndex:a][@"tagInfo"][@"name"]];
                    
                    
                }
                [classifyBtn setTitle:[NSString stringWithFormat:@"%@",[_menuArray objectAtIndex:a][@"tagInfo"][@"name"]] forState:UIControlStateNormal];
                
                [classifyBtn addTarget:self
                                action:@selector(clickBtn:)
                      forControlEvents:UIControlEventTouchUpInside];
                
                [leftscrollview addSubview:classifyBtn];
                
                NSArray *infoarr = [_menuArray objectAtIndex:a][@"mappingList"];
                
                if (infoarr.count!= 0) {
                    [listInfo addObject:infoarr];
                }
            }
            
            _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, 45)];
            _lineView.backgroundColor = [UIColor redColor];
            [leftscrollview addSubview:_lineView];
            selectedButtonTag=[[Utils getSNSInteger:[_menuArray objectAtIndex:0][@"tagInfo"][@"id"]] intValue];
            [self requestInfo:[Utils getSNSInteger:[_menuArray objectAtIndex:0][@"tagInfo"][@"id"]] onRefresh:^(NSMutableArray *arr,int refreshId){
                
//                [_rightScrollView removeFromSuperview];
                UIScrollView *sc=[self creatUI:_commentArray andImageHeight:0];
                if (refreshId==selectedButtonTag)
                {
                    [self.view addSubview:sc];
                    for (UIView *vi in [_rightScrollView subviews]) {
                        [vi removeFromSuperview];
                    }
                    [_rightScrollView removeFromSuperview];
                    _rightScrollView=sc;
                }
            }];
    }];

    
    
//    [self creatFolderPath];

//    //没用
//    [self parentId1HeadImage];
    
    

    
    //添加点击空白区域收回键盘的手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.delegate = self;
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}


//-(void)creatFolderPath
//{
//    //创建文件夹
//    NSString *docPath=[NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *folderName = @"ClassifyList";
//    NSString *folderPath = [NSString stringWithFormat:@"%@/%@", docPath, folderName];
//    NSLog(@"folderPath %@", folderPath);
//    NSError *error = nil;
//    bool isSuc = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
//    if (isSuc) {    //创建成功
//        
////        NSLog(@"创建成功，目录是%@", folderPath);
//        
//    }else{
//        
////        NSLog(@"创建失败，%@", error);
//        
//    }
//}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.view endEditing:YES];
}

-(void)requestInfo:(NSString *)parentId onRefresh:(void (^)(NSMutableArray *arr,int refreshId))onRefresh
{
    
    NSString *path=[NSString stringWithFormat:@"%@/parentId%@",[AppSetting getMBCacheFilePath],parentId];
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (arr.count!=0) {
        //取数据
        [_commentArray removeAllObjects];
        _commentArray=arr;
        if (onRefresh) onRefresh(_commentArray,[parentId intValue]);
//        NSLog(@"有缓存啦");
    }
    else
    {
        [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
    }
    ////请求
    NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:10];
    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
    //WxCollocationTagChildFilter?parentid=0    WxCollocationTagFilter ,@"status":@"1"
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL succ=[SHOPPING_GUIDE_ITF requestGetUrlName:@"WxCollocationTagChildFilter" param:@{@"parentid":parentId} responseList:list responseMsg:msg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if (succ)
            {
                if (![arr isEqualToArray:list])
                {
                    [_commentArray removeAllObjects];
                    [_commentArray addObjectsFromArray:list];
                    [NSKeyedArchiver archiveRootObject:_commentArray toFile:path];
                    
                    if (onRefresh) onRefresh(_commentArray,[parentId intValue]);
                }
            }
        });
    });
}

-(void)imageViewSetBackGroundView:(int*)sender
{
    
}
-(void)clickBtn:(UIButton*)sender
{
    UIButton *customBtn = (UIButton *)sender;
    selectedButtonTag=customBtn.tag;

    [[NSUserDefaults standardUserDefaults]setObject:sender.titleLabel.text forKey:@"classifyName"];
    leftNameStr = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
    
    if (customBtn.backgroundColor != [UIColor whiteColor])
    {
        customBtn.backgroundColor = [UIColor whiteColor];
        [customBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        for (UIView *subView in leftscrollview.subviews) {
            
            if ([subView isKindOfClass:[UIButton class]])
            {
                if (subView.tag!=sender.tag)
                {
                    UIButton *other =(UIButton *)subView ;
                    other.backgroundColor = [UIColor clearColor];
                    
                }
            }
            
        }
    }
    
//    _headimage.hidden = YES;
    _lineView.frame = CGRectMake(0, customBtn.frame.origin.y, 2, customBtn.frame.size.height);
    
    [self requestInfo:[NSString stringWithFormat:@"%d",customBtn.tag] onRefresh:
     ^(NSMutableArray *arr,int refreshId){
//         for (UIView *vi in [_rightScrollView subviews]) {
//             [vi removeFromSuperview];
//         }
//
         @synchronized(self) {
             UIScrollView *sc=[self creatUI:_commentArray andImageHeight:0];
             if (refreshId==selectedButtonTag)
             {
                 [self.view addSubview:sc];
                 for (UIView *vi in [_rightScrollView subviews]) {
                     [vi removeFromSuperview];
                 }
                 [_rightScrollView removeFromSuperview];
                 _rightScrollView=sc;
             }
         }
     }];
}

//-(void)parentId1HeadImage
//{
//    _headimage = [[UIImageView alloc]initWithFrame:CGRectMake(80, 64+44, SCREEN_WIDTH - 80, 50)];
//    _headimage.image = [UIImage imageNamed:@"classifyHeadImg.png"];
//    [self.view addSubview:_headimage];
//    _headimage.hidden = YES;
//}

//创建九宫格
-(UIScrollView *)creatUI:(NSMutableArray*)array andImageHeight:(CGFloat)imageHeight
{
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(leftscrollview.bounds.size.width, 64+44+imageHeight, SCREEN_WIDTH-leftscrollview.bounds.size.width, 460)];
    @try {
        _nameArray = [[NSMutableArray alloc]init];
        _pictureUrlArr = [[NSMutableArray alloc]init];
        
        for (int i= 0; i<array.count; i++) {
            NSString *name = [array objectAtIndex:i][@"tagInfo"][@"name"];
            [_nameArray addObject:name];
            NSString *pictureUrl = [array objectAtIndex:i][@"tagInfo"][@"pictureUrl"];
            [_pictureUrlArr addObject:pictureUrl];
        }
        CGFloat width = 60;
        CGFloat height = 60;
        CGFloat margin = 15;
        CGFloat startX = 15;
        CGFloat startY = 15;
        
        NSMutableArray *buttonArray=[[NSMutableArray alloc] init];
        for (int i = 0; i<_nameArray.count; i++) {
           
            // 计算位置
            int row = i/3;
            int column = i%3;
            CGFloat x = startX + column * (width + margin);
            CGFloat y = startY + row * (height + margin+20);
            
            UIUrlImageView *urlImage=[[UIUrlImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [urlImage downloadImageUrl:_pictureUrlArr[i] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_MEDIUM];
            [sc addSubview:urlImage];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x, y, width, height);
            button.tag = i;
            [button addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleLabel.font = [UIFont systemFontOfSize: 13];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buttonArray addObject:button];
            [sc addSubview:button];
            
            UILabel *name = [[UILabel alloc]init];
            name.frame = CGRectMake(x, y+width+10, width, 20);
            name.text = _nameArray[i];
            name.textAlignment = 1;
            name.font = [UIFont systemFontOfSize:13];
            [sc addSubview:name];
            
//              dispatch_async(dispatch_get_main_queue(), ^{  
//                });
        }
        
        CGSize newSize;
        
        if ([_nameArray count]%2 != 0) {
            newSize = CGSizeMake(sc.bounds.size.width, ([_nameArray count]+1)/2*35+([_nameArray count]+1)*margin);
        }else {
            newSize = CGSizeMake(sc.bounds.size.width, [_nameArray count]/2*35+([_nameArray count]+1)*margin);
        }
        
        [sc setContentSize:newSize];
        
        
//        NSMutableArray *imageArray=[[NSMutableArray alloc] init];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            for (int i=0;i<buttonArray.count;i++)
//            {
//                UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_pictureUrlArr[i]]]];
//                if (!img) {
//                    img=[UIImage imageNamed:DEFAULT_LOADING_IMAGE];
//                }
//                [imageArray addObject:img];
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                for (int i=0;i<buttonArray.count; i++) {
//                    if (imageArray[i]!=nil)
//                        [buttonArray[i] setImage:imageArray[i] forState:UIControlStateNormal];
//                };
//            });
//        });
    }
    @catch (NSException *exception) {
        NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    @finally {
        return sc;
    }
}
//-(void)creatUI:(NSMutableArray*)array andImageHeight:(CGFloat)imageHeight
//{
//    
//    _rightScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(leftscrollview.bounds.size.width, 64+44+imageHeight, SCREEN_WIDTH-leftscrollview.bounds.size.width, 460)];
//    _nameArray = [[NSMutableArray alloc]init];
//    _pictureUrlArr = [[NSMutableArray alloc]init];
//    
//    for (int i= 0; i<array.count; i++) {
//        NSString *name = [array objectAtIndex:i][@"tagInfo"][@"name"];
//        [_nameArray addObject:name];
//        NSString *pictureUrl = [array objectAtIndex:i][@"tagInfo"][@"pictureUrl"];
//        [_pictureUrlArr addObject:pictureUrl];
//    }
//    
//    //    for (UIView *vi in [_rightScrollView subviews]) {
//    //        [vi removeFromSuperview];
//    //    }
//    //
//    CGFloat width = 60;
//    CGFloat height = 60;
//    CGFloat margin = 15;
//    CGFloat startX = 15;
//    CGFloat startY = 15;
//    
//    NSMutableArray *buttonArray=[[NSMutableArray alloc] init];
//    for (int i = 0; i<_nameArray.count; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        UILabel *name = [[UILabel alloc]init];
//        
//        // 计算位置
//        int row = i/3;
//        int column = i%3;
//        CGFloat x = startX + column * (width + margin);
//        CGFloat y = startY + row * (height + margin+20);
//        button.frame = CGRectMake(x, y, width, height);
//        button.tag = i;
//        [button addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        button.titleLabel.font = [UIFont systemFontOfSize: 13];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        //        [button setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_pictureUrlArr[i]]]]forState:UIControlStateNormal];
//        [buttonArray addObject:button];
//        
//        name.frame = CGRectMake(x, y+width+10, width, 20);
//        
//        name.text = _nameArray[i];
//        name.textAlignment = 1;
//        name.font = [UIFont systemFontOfSize:13];
//        [_rightScrollView addSubview:name];
//        [_rightScrollView addSubview:button];
//        //        [self.view addSubview:_rightScrollView];
//    }
//    
//    CGSize newSize;
//    
//    if ([_nameArray count]%2 != 0) {
//        newSize = CGSizeMake(_rightScrollView.bounds.size.width, ([_nameArray count]+1)/2*35+([_nameArray count]+1)*margin);
//    }else {
//        newSize = CGSizeMake(_rightScrollView.bounds.size.width, [_nameArray count]/2*35+([_nameArray count]+1)*margin);
//    }
//    
//    [_rightScrollView setContentSize:newSize];
//    
//    
//    NSMutableArray *imageArray=[[NSMutableArray alloc] init];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (int i=0;i<buttonArray.count;i++)
//        {
//            UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_pictureUrlArr[i]]]];
//            if (!img) {
//                img=[UIImage imageNamed:DEFAULT_LOADING_IMAGE];
//            }
//            [imageArray addObject:img];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            for (int i=0;i<buttonArray.count; i++) {
//                if (imageArray[i]!=nil)
//                    [buttonArray[i] setImage:imageArray[i] forState:UIControlStateNormal];
//            };
//        });
//    });
//}


-(void)detail:(id)sender
{
    UIButton *clickBtn = (UIButton*)sender;
//    for (int i = 0; i<_menuArray.count; i++) {
//        UIButton *menuBtn = (UIButton*)[self.view viewWithTag:100+i];
//        
//        if (menuBtn.backgroundColor == [UIColor whiteColor]) {
//            ClickClassifyPushViewController *click = [[ClickClassifyPushViewController alloc]initWithNibName:@"ClickClassifyPushViewController" bundle:nil];
//            click.parentId = [NSString stringWithFormat:@"%d",6-i];
//            click.titleName = menuBtn.titleLabel.text;
//            click.btnTag = clickBtn.tag;
//            click.listInfoArray = _commentArray;
//            GetViewControllerFile *getvc=[GetViewControllerFile getVCFile];
//            NSString *functionid=[getvc getXMLAttributes:_functionXML[@"native"] key:@"functionid" attributes:nil];
//            click.functionXML=[getvc getXMLFunction:_rootXML functionId:functionid];//O2C_MB_CLASSLIST
//            click.rootXML=_rootXML;
//            
//            [self.navigationController pushViewController:click animated:YES];
//            break;
//        }
//    }
    ClickClassifyPushViewController *click = [[ClickClassifyPushViewController alloc]initWithNibName:@"ClickClassifyPushViewController" bundle:nil];
    click.parentId = [NSString stringWithFormat:@"%d",selectedButtonTag];
    click.titleName = [[NSUserDefaults standardUserDefaults]objectForKey:@"classifyName"];
    click.titleName = leftNameStr;
    
    click.btnTag = clickBtn.tag;
    click.listInfoArray = _commentArray;
//    NSLog(@"——————————————————————————————————————*****%@",_commentArray);
    
    GetViewControllerFile *getvc=[GetViewControllerFile getVCFile];
    NSString *functionid=[getvc getXMLAttributes:_functionXML[@"native"] key:@"functionid" attributes:nil];
    click.functionXML=[getvc getXMLFunction:_rootXML functionId:functionid];//O2C_MB_CLASSLIST
    click.rootXML=_rootXML;
    [self.navigationController pushViewController:click animated:YES];
}


////searchBar delegate
- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchBtnClick:(id)sender {
    [_searshTextfield resignFirstResponder];
//    NSDictionary *transDic =[NSDictionary dictionaryWithObjectsAndKeys:_searshTextfield.text,@"filterNameStr", nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"filterName"
//                                                        object:nil
//                                                      userInfo:transDic];
//    [self.navigationController popViewControllerAnimated:YES];

    
    
    NSString *_fileterNameStr = _searshTextfield.text;
    //    NSLog(@"filterNameStrfilterNameStr == %@",_fileterNameStr);
    
    _filterCollocationView = [[UIView alloc]initWithFrame:CGRectMake(0,69, SCREEN_WIDTH, UI_SCREEN_HEIGHT-69)];
    _filterCollocationView.backgroundColor = [UIColor whiteColor];
    
    //创建view
    [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
    CollocationViewController *colloVC=[AppDelegate getTabViewControllerObject:@"CollocationViewController"];
    NSDictionary *dict=[colloVC getCollocationXML];
//    NSDictionary *rootXML=[colloVC getRootXML];
//    NSDictionary *native=dict[@"native"];

    CollocationTableView *collView=[colloVC createFunctionView:dict parentView:_filterCollocationView];
    collView.frame=CGRectMake(0, _viewSearchComplete.frame.size.height, SCREEN_WIDTH, _filterCollocationView.frame.size.height-_viewSearchComplete.frame.size.height);
    [_filterCollocationView addSubview:collView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:10];
        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
        NSString *st = [NSString stringWithFormat:@"2"];
        NSString *choice=[NSString stringWithFormat:@"2"];
        NSDictionary *stDic= @{@"Status":st,
                               @"IsChoiced":choice,
                               @"Name":_fileterNameStr};
        collView.param=[[NSMutableDictionary alloc] initWithDictionary:stDic];
        BOOL rst=[SHOPPING_GUIDE_ITF requestUrl:collView.url param:collView.param responseList:list responseMsg:msg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rst)
            {
                if (list.count == 0) {
                    UIImageView *nofilterPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-50-49)];
                    nofilterPic.backgroundColor=[UIColor whiteColor];
//                    nofilterPic.image = [UIImage imageNamed:@"filterArrNil.png"];
                    [_filterCollocationView addSubview:nofilterPic];
                }
                else
                {
                    collView.dataArray = list;
                }
            }
            [Toast hideToastActivity];
        });
    });
    
    _lbSearchText.text = [NSString stringWithFormat:@"您搜索了:%@",_fileterNameStr];
    [_filterCollocationView addSubview:_viewSearchComplete];
    
    [self.view addSubview:_filterCollocationView];
}

-(void)clickDownBtn:(id)sender
{
    [_filterCollocationView removeFromSuperview];
    _filterCollocationView=nil;
}

- (IBAction)textDidEndOnExit:(id)sender {
    [self searchBtnClick:nil];
}

- (IBAction)btnCompleteClicked:(id)sender {
    [self clickDownBtn:sender];
    [_searshTextfield becomeFirstResponder];
}

- (IBAction)btnSearchCancelClicked:(id)sender {
    [self clickDownBtn:sender];
}

@end