//
//  CustomContentModelView.m
//  WeFFDemo
//
//  Created by fafatime on 14-4-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
// 焦点图 和应用列表

#import "CustomContentModelView.h"
#import "UIButton+WebCache.h"
#import "CustomListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppSetting.h"

#import "JSON.h"
#import "EScrollerView.h"
#import "PullingRefreshTableView.h"
@implementation CustomContentModelView
@synthesize listTabView;
@synthesize tableViewDataSouse;
- (id)initWithFrame:(CGRect)frame withStyleDic:(NSDictionary *)styleDic withDictionary:(NSDictionary *)dic withlistDic:(NSDictionary *)listDic withSecondSelectNum:(int)clickBtn withNameStr:(NSString *)nameStr
{
    self = [super init];
    if (self) {
        self.frame=frame;
        detailNameStrs = [[NSString alloc]initWithFormat:@"%@",nameStr];
        changeSecondBtn =clickBtn;
//        NSLog(@"clickBtn=====%d",clickBtn);
        ns=0;
        
        backslView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [backslView setBackgroundColor:[UIColor clearColor]];
        backslView.userInteractionEnabled=YES;
        [backslView setContentSize:CGSizeMake(0, self.frame.size.height+10)];
        [self addSubview:backslView];
        dictionary = [[NSDictionary alloc]initWithDictionary:dic];
        self.tableViewDataSouse=[[NSDictionary alloc]initWithDictionary:listDic];
        styleDictionary = [[NSDictionary alloc]initWithDictionary:styleDic];

//        NSLog(@"类型style---%@",styleDictionary);
        NSString *versionStr=[[styleDictionary objectForKey:@"list"]objectForKey:@"_style"];

        if ([[styleDictionary objectForKey:@"list"] objectForKey:@"_style"]==nil)
        {
        
            if ([[dictionary objectForKey:@"list"]objectForKey:@"_style"]!=nil)
            {
                versionStr = [[dictionary objectForKey:@"list"] objectForKey:@"_style"];
            }

            // 模板数
            if ([versionStr isEqualToString:@"GRID3"])
            {
             
                [self modelOne];
            }
            if ([versionStr isEqualToString:@"GRID4"])
            {
                [self modelOne];
            }
            if ([versionStr isEqualToString:@"NORMAL"])
            {
                [self modelTwo];
            }
        }
        else
        {
                // 模板数
                if ([versionStr isEqualToString:@"GRID3"])
                {
                  
                    [self modelOne];
                }
                if ([versionStr isEqualToString:@"GRID4"])
                {
                    [self modelOne];
                }
                if ([versionStr isEqualToString:@"NORMAL"])
                {
                    [self modelTwo];
                }

        }
        
        if (num)
        {
            if (lie==4)
            {
                [backScrollView setContentSize:CGSizeMake(0, (float)(num/lie/2)*backScrollView.frame.size.height+50)];
                [backslView setContentSize:CGSizeMake(0, self.frame.size.height+(float)(num/lie/2)*110)];
            }
            else
            {
//                NSLog(@"abc--3列 ---num=-%d--lie-%d-%f",num,lie,self.frame.size.height+(float)(num/lie/2)*110);
                
//            [backScrollView setContentSize:CGSizeMake(0, (float)(num/lie/2)*backScrollView.frame.size.height+10)];
   
                
                if (num%lie==0)
                {
//                    NSLog(@"num---%d，--------lie---%d",num,lie);
                    ns=num/lie;
                    
                    
                }
                else
                {
//                    NSLog(@"-没除尽--%d",num/lie+1);
                    ns=num/lie+1;
   
                }
                [backScrollView setFrame:CGRectMake(0,0, self.frame.size.width,ns*110)];
                
                [listTabView setFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
                [backslView setContentSize:CGSizeMake(0, self.frame.size.height-30+(float)(num/lie/2)*110-30)];
                if (ns ==0)
                {
                    [backslView setContentSize:CGSizeMake(0, self.frame.size.height-30+(float)(num/lie/2)*110-30)];
                    
                }
                else
                {
                    [backslView setContentSize:CGSizeMake(0, backScrollView.frame.size.height)];
                }
                
                if (iPhone5)
                {
                    [backslView setContentSize:CGSizeMake(0, self.frame.size.height-88+(float)(num/lie/2)*110)];
                }
            }
            
        }

        //滚动列表
        NSArray *scrollArray = [[NSArray alloc]init];

            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *DataNameFile=[NSString stringWithFormat:@"%@",[AppSetting getXMLFilePath]];
            //每个模块对应相应的缓存文件夹
            NSString *detailNameFile=[DataNameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",detailNameStrs]];
            if ([fileManager fileExistsAtPath:detailNameFile])
            {
                
            }
            else
            {
                [fileManager createDirectoryAtPath:detailNameFile withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (nameStr==nil)
            {
                detailNameFile = DataNameFile;
            }
            NSString *FocusText=[NSString stringWithFormat:@"%@/focusDataSouse%d",detailNameFile,clickBtn];

            if([fileManager fileExistsAtPath:FocusText])//判断文件是否存在
            {
                NSString *DataNameFile=[NSString stringWithFormat:@"%@",[AppSetting getXMLFilePath]];
                NSString *detailNameFile=[DataNameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",detailNameStrs]];
                
                NSString *st=[NSString stringWithFormat:@"%@/focusDataSouse%d",detailNameFile,clickBtn];
                NSString *focusTextStr=[NSString stringWithContentsOfFile:st encoding:NSUTF8StringEncoding error:nil];
                NSDictionary *focusDic = [focusTextStr JSONValue];
                scrollArray =[focusDic objectForKey:@"listitems"];
                
//                NSLog(@"———LLLLLL—--url---%@",[[styleDictionary objectForKey:@"switch"] objectForKey:@"listurl"]);
                if ([scrollArray count]==0)
                {
                    ASIHTTPRequest *focusUrl=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[[styleDictionary objectForKey:@"switch"] objectForKey:@"listurl"]]];
                    focusUrl.delegate=self;
                    [focusUrl setDownloadDestinationPath:FocusText];
                    [focusUrl setAllowResumeForFileDownloads:YES];//支持断点续传
                    [focusUrl startAsynchronous];
                    
                }
                else
                {
                    NSMutableArray *imageVArrays=[[NSMutableArray alloc]init];
                    NSMutableArray *textArray = [[NSMutableArray alloc]init];
                    for (int a=0; a<[scrollArray count]; a++)
                    {
                        [imageVArrays addObject:[[scrollArray objectAtIndex:a]objectForKey:@"icon"]];
                        [textArray addObject:[[scrollArray objectAtIndex:a]objectForKey:@"title"]];
                    }
                    EScrollerView *esc=[[EScrollerView alloc]initWithFrameRect:CGRectMake(0, 0, UI_SCREEN_WIDTH, 130) ImageArray:imageVArrays TitleArray:textArray];
                    esc.delegate=self;
                    
                    if (listDic==nil)
                    {
                        
                        [backslView addSubview:esc];
                        
                    }
                    else
                    {
                        listTabView.tableHeaderView =esc;
                    }
      
               

                    [backScrollView setFrame:CGRectMake(0,esc.frame.size.height, self.frame.size.width, ns*110)];
          
                    [listTabView setFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
//                    [backslView setContentSize:CGSizeMake(0, self.frame.size.height+(float)(num/lie/2)*110-30)];
                    
                    if (ns ==0)
                    {
                        [backslView setContentSize:CGSizeMake(0, self.frame.size.height)];
                        
                    }
                    else
                    {
                        [backslView setContentSize:CGSizeMake(0,esc.frame.size.height+backScrollView.frame.size.height)];
                    }
                 
                    if (iPhone5)
                    {
                        
                        [backslView setContentSize:CGSizeMake(0, self.frame.size.height-88+(float)(num/lie/2)*110)];
                    }
              
                }
                
                
            }
            else
            {
             
                [fileManager createFileAtPath:FocusText contents:nil attributes:nil];
//                NSLog(@"FOCUStEXT---%@",FocusText);
                
                ASIHTTPRequest *focusUrl=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[[styleDictionary objectForKey:@"switch"] objectForKey:@"listurl"]]];
//                NSLog(@"STYLE-----%@",styleDictionary);
                
//                NSLog(@"————--url---%@",[[styleDictionary objectForKey:@"switch"] objectForKey:@"listurl"]);
                focusUrl.delegate=self;
                [focusUrl setDownloadDestinationPath:FocusText];
                [focusUrl setAllowResumeForFileDownloads:YES];//支持断点续传
                [focusUrl startAsynchronous];
                
            }
            

    }

    return self;
}
-(void)modelOne
{
//    NSLog(@"九宫格paibu");
    backScrollView=[[UIScrollView alloc]init];
    backScrollView.userInteractionEnabled=YES;
    backScrollView.showsVerticalScrollIndicator=YES;
    
    NSArray *iconArray =[NSArray arrayWithArray:[dictionary objectForKey:@"list"]];

    num =(int)[iconArray count];
    
    NSString *typeStr=[[styleDictionary objectForKey:@"list"]objectForKey:@"_type"];

    if ([typeStr isEqualToString:@"3"])
    {
        lie=3;
        for (int a=0; a<num; a++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            CGRect labelframe;
            labelframe.size.width=100;
            labelframe.size.height=40;
            labelframe.origin.x = (a%lie)*(Btn_WITHE+40)+10;
            
            CGRect frame;
            frame.size.width=Btn_WITHE;
            frame.size.height=Btn_HIGHT;
            frame.origin.x = (a%lie)*(Btn_WITHE+40)+30;
            frame.origin.y = floor(a/lie)*(Btn_HIGHT+40)+20;
            labelframe.origin.y=frame.origin.y+frame.size.height;
            [button setFrame:frame];
            [button setBackgroundImageWithURL:[NSURL URLWithString:[[iconArray objectAtIndex:a] objectForKey:@"logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Icon-80.png"]];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[iconArray objectAtIndex:a]
                                                               options:NSJSONWritingPrettyPrinted error:nil];
            NSString *ss = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            button.titleLabel.text=ss;
            button.titleLabel.hidden=YES;
            [button setBackgroundColor:[UIColor blackColor]];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(gotodetail:)
             forControlEvents:UIControlEventTouchUpInside];
            [backScrollView addSubview:button];
            UILabel *namelabel = [[UILabel alloc]init];
            [namelabel setFrame:labelframe];
            namelabel.font=[UIFont systemFontOfSize:14];
            namelabel.text = [[iconArray objectAtIndex:a]objectForKey:@"appname"];
            namelabel.textAlignment = NSTextAlignmentCenter;
            namelabel.backgroundColor=[UIColor clearColor];
            [backScrollView addSubview:namelabel];
//            [namelabel release];
            
        }
    }
    if ([typeStr isEqualToString:@"4"])
    {
        lie=4;
      
        
        for (int a=0; a<num; a++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            CGRect labelframe;
            labelframe.size.width=80;
            labelframe.size.height=40;
            labelframe.origin.x = (a%lie)*(Btn_WITHE+20)+5;
            
            CGRect frame;
            frame.size.width=Btn_WITHE;
            frame.size.height=Btn_HIGHT;
            frame.origin.x = (a%lie)*(Btn_WITHE+20)+15;
            frame.origin.y = floor(a/lie)*(Btn_HIGHT+40)+20;
            labelframe.origin.y=frame.origin.y+frame.size.height;
            [button setFrame:frame];
            [button setBackgroundImageWithURL:[NSURL URLWithString:[[iconArray objectAtIndex:a] objectForKey:@"logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon.png"]];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(gotodetail:)
             forControlEvents:UIControlEventTouchUpInside];
            [backScrollView addSubview:button];
            UILabel *namelabel = [[UILabel alloc]init];
            [namelabel setFrame:labelframe];
          
            namelabel.text = [[iconArray objectAtIndex:a]objectForKey:@"text"];
            namelabel.textAlignment = NSTextAlignmentCenter;
            namelabel.backgroundColor=[UIColor magentaColor];
            [backScrollView addSubview:namelabel];

            
        }
    }

    [backslView addSubview:backScrollView];
 
}
-(void)searchResult:(NSNotification*)transDic
{
    dictionary = [transDic userInfo];
//    NSLog(@"-----trans%@",[transDic userInfo]);
//    [dictionary retain];
    listTabView.hidden=NO;
    [listTabView reloadData];
    
}
-(void)modelTwo
{

    listTabView  = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) pullingDelegate:self];
    listTabView.userInteractionEnabled=YES;
//    listTabView.pullingDelegate=self;
    
    listTabView.delegate=self;
    listTabView.dataSource=self;
    self.listTabView=listTabView;
    self.listTabView.sectionFooterHeight = 0;
    self.listTabView.sectionHeaderHeight = 0;
    [self addSubview:self.listTabView];
    
}
-(void)gotodetail:(UIButton *)clickBtn
{
    NSString *  ss = clickBtn.titleLabel.text;
    NSDictionary *strDic=[ss JSONValue];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoDetailModel"
                                                        object:nil
                                                      userInfo:strDic];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[dictionary objectForKey:@"list"]objectForKey:@"listitem"];
    [[self.tableViewDataSouse objectForKey:@"listitems"]objectAtIndex:indexPath.row];
    NSDictionary *thirdDic=[NSDictionary dictionaryWithObjectsAndKeys:[dictionary objectForKey:@"list"] ,@"click",[[self.tableViewDataSouse objectForKey:@"listitems"] objectAtIndex:indexPath.row],@"detailModel",nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoDetailDaTaSouse"
                                                        object:nil
                                                      userInfo:thirdDic];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return ListTabViewCellWidth;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[self.tableViewDataSouse objectForKey:@"number"]intValue];
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[CustomListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //图片的地址
    
    NSString *textString =[[[self.tableViewDataSouse objectForKey:@"listitems"]objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    [cell.headImgView setImageWithURL:[NSURL URLWithString:[[[self.tableViewDataSouse objectForKey:@"listitems"] objectAtIndex:indexPath.row]objectForKey:@"icon"]]];
    
    
    cell.titleLabel.text = textString;
    
//    cell.timeLabel.text =[[[self.tableViewDataSouse objectForKey:@"listitems"]objectAtIndex:indexPath.row]objectForKey:@"subhead"];
    
    cell.detailTextView.text = [[[self.tableViewDataSouse objectForKey:@"listitems"]objectAtIndex:indexPath.row]objectForKey:@"summary"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
    
}
#pragma mark  刷新
//下拉刷新
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    NSLog(@"下拉");
    [self performSelector:@selector(refresh) withObject:nil afterDelay:1.0f];
}
//上提刷新
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    NSLog(@"上提");
    [self performSelector:@selector(refreshshang) withObject:nil afterDelay:1.0f];
}
//刷新完成。显示时间
-(NSDate *)pullingTableViewRefreshingFinishedDate
{
    //获取当前时间
    NSDate *date=[NSDate date];
    return date;
}
//点击时候
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [listTabView tableViewDidScroll:scrollView];
}
//松开手指
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [listTabView tableViewDidEndDragging:scrollView];
}
// 刷新 方法有待敲定。具体多少条数据穿参数等。
-(void)refreshshang
{
    [listTabView tableViewDidFinishedLoading];
    [listTabView reloadData];
    
}
-(void)refresh
{
    NSLog(@"下拉刷新");
    [listTabView tableViewDidFinishedLoading];
    [listTabView reloadData];
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败焦点图");
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"焦点图请求失败"
//                                                 message:@"错误"
//                                                delegate:nil
//                                       cancelButtonTitle:@"确定"
//                                       otherButtonTitles:@"取消", nil];
//    [alert show];
    
    EScrollerView *esc = [[EScrollerView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)];
    
    [backslView addSubview:esc];
    [backScrollView setFrame:CGRectMake(0,esc.frame.size.height, self.frame.size.width, ns*110)];
    [listTabView setFrame:CGRectMake(0, esc.frame.size.height, self.frame.size.width, self.frame.size.height-esc.frame.size.height)];
//    [backslView setContentSize:CGSizeMake(0, self.frame.size.height+(float)(num/lie/2)*110-30)];
    if (ns ==0)
    {
        NSLog(@"num--%d-lie---%d",num,lie);
        if (lie==0||num==0)
        {
            
        }
        else
        {
        [backslView setContentSize:CGSizeMake(0, self.frame.size.height-30+(float)(num/lie/2)*110-30)];
        }
        
    }
    else
    {
        [backslView setContentSize:CGSizeMake(0, backScrollView.frame.size.height)];
    }
    
    if (iPhone5)
    {
        if (lie==0||num==0)
        {
            
        }
        else
        {
        [backslView setContentSize:CGSizeMake(0, self.frame.size.height-88+(float)(num/lie/2)*110)];
        }
    }

}

-(void)requestFinished:(ASIHTTPRequest *)request
{

    NSString *DataNameFile=[NSString stringWithFormat:@"%@",[AppSetting getXMLFilePath]];
    NSString *detailNameFile=[DataNameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",detailNameStrs]];

    if ([detailNameFile isEqualToString:nil])
    {
        detailNameFile = DataNameFile;
        
    }
    NSString *st=[NSString stringWithFormat:@"%@/focusDataSouse%d",detailNameFile,changeSecondBtn];

    NSString *focusTextStr=[NSString stringWithContentsOfFile:st encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *focusDic = [focusTextStr JSONValue];
//    NSLog(@"focusDic---%@",focusDic);
//    NSDictionary *focusDic=[NSDictionary dictionaryWithContentsOfFile:st];
//    NSLog(@"focusDic===%@",focusDic);
    NSMutableArray *imageVArrays=[[NSMutableArray alloc]init];
    NSMutableArray *textArray = [[NSMutableArray alloc]init];
    NSArray *scrollArray=[[NSArray alloc]init];
    
    scrollArray =[focusDic objectForKey:@"listitems"];
    if ([scrollArray count]==0)
    {
        EScrollerView *esc=[[EScrollerView alloc]init];
        [esc setFrame:CGRectZero];
        [backslView addSubview:esc];
        [backScrollView setFrame:CGRectMake(0,esc.frame.size.height, self.frame.size.width, ns*110)];
        [listTabView setFrame:CGRectMake(0, esc.frame.size.height, self.frame.size.width, self.frame.size.height-esc.frame.size.height)];
      
        if (ns ==0)
        {
            [backslView setContentSize:CGSizeMake(0, self.frame.size.height-30+(float)(num/lie/2)*110-30)];
            
        }
        else
        {
            [backslView setContentSize:CGSizeMake(0,esc.frame.size.height+ backScrollView.frame.size.height)];
        }
    }
    else
    {
    for (int a=0; a<[scrollArray count]; a++)
    {
        [imageVArrays addObject:[[scrollArray objectAtIndex:a]objectForKey:@"icon"]];
        [textArray addObject:[[scrollArray objectAtIndex:a]objectForKey:@"title"]];
    }
    EScrollerView *esc=[[EScrollerView alloc]initWithFrameRect:CGRectMake(0, 0, UI_SCREEN_WIDTH, 130) ImageArray:imageVArrays TitleArray:textArray];
    [backslView addSubview:esc];
    esc.delegate=self;
        
    [backScrollView setFrame:CGRectMake(0,esc.frame.size.height, self.frame.size.width,ns*110)];
    [listTabView setFrame:CGRectMake(0, esc.frame.size.height, self.frame.size.width, self.frame.size.height-esc.frame.size.height)];
        if (ns ==0)
        {
            [backslView setContentSize:CGSizeMake(0, self.frame.size.height-30+(float)(num/lie/2)*110-30)];
            
        }
        else
        {
            [backslView setContentSize:CGSizeMake(0,esc.frame.size.height+ backScrollView.frame.size.height)];
        }
        
//    [esc release];
    }
    
//    [backslView setContentSize:CGSizeMake(0, self.frame.size.height+(float)(num/lie/2)*110-30)];

    
    if (iPhone5)
    {
        
        [backslView setContentSize:CGSizeMake(0, self.frame.size.height-88+(float)(num/lie/2)*110)];
    }
}
-(void)EScrollerViewDidClicked:(UIImageView *)imageView
{
    NSLog(@"index====%d",imageView.tag);
}
@end
