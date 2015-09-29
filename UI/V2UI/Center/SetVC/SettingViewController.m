//
//  SettingViewController.m
//  BanggoPhone
//
//  Created by ISSUser on 14-6-30.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "SettingViewController.h"
#import "HelpCenterVC.h"
#import "OutInUserDefaults.h"
#import "V2UIGlobleMacro.h"
#import "DetectionSystem.h"

@interface SettingViewController (){
//    MBProgressHUD *HUD;
    NSString *cacheSize;
}

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.title=@"设置";
    [self SetRightButton:@"帮助" Image:nil];
//    if (!IOS7) {
        UIView *vie=[[UIView alloc]init];
        vie.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        self.tableView.backgroundView=vie;
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];

    self.tableView.tableFooterView=self.vieFoot;
    

         _dataAry = [NSArray arrayWithObjects:@[@"开启省流量模式",@"清除缓存"],@[@"购买须知",@"应用评分",@"关于"], nil];

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 15)];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 14,self.tableView.frame.size.width, 0.5)];
    line.backgroundColor=LineColor;
    [self.tableView.tableHeaderView  addSubview:line];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)RightReturn:(UIButton *)sender{
    HelpCenterVC *helpCenter=[[HelpCenterVC alloc]init];
    [self.navigationController pushViewController:helpCenter animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return _dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[_dataAry objectAt:section] count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vie=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView .frame.size.width, 20)];
    vie.backgroundColor=[UIColor clearColor];
    if (section!=[self.tableView numberOfSections]-1) {
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 19.5,self.tableView .frame.size.width, .5)];
        line.backgroundColor=LineColor;
        [vie addSubview:line];
    }
    return vie;
}
//绘制Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor whiteColor];
    }
    else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    NSArray *sectionData = [self.dataAry objectAt:indexPath.section];
    cell.textLabel.font=TABLECELLFONT;
    cell.textLabel.text = [sectionData objectAt:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                UISwitch *switchs=[[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
                switchs.on=[OutInUserDefaults GetSaveByte];
                [switchs addTarget:self action:@selector(ChangSave:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView=switchs;
            }
                break;
            case 1:
            {
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-230, 0, 200-cellEdge, 44)];
                lab.text=cacheSize;
                lab.font=TABLECELLFONT;
                lab.backgroundColor=[UIColor clearColor];
                lab.textAlignment=NSTextAlignmentRight;
                [cell.contentView addSubview:lab];
            }
                break;
            default:
            {
                
            }
                break;
        }
       
    }
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

      if(indexPath.section==0){
         switch (indexPath.row) {
             case 1:
             {
                 UIAlertView *alr=[DetectionSystem ShowDoubleAlert:@"清除缓存" Message:@"确定清除本地缓存？"];
                 alr.delegate=self;
                
             }
                 break;
                 
             default:
                 break;
         }
     }
     else if(indexPath.section==1){
         switch (indexPath.row) {
             case 0:
             {

             }
                 break;
            
             case 1:
             {
                 NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/bang-gou-shang-cheng-mei-te/id427543233?mt=8"];

                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
             }
                 break;
                 case 2:
             {

             }
                 break;
             default:
                 break;
         }
     }

}

-(void)ChangSave:(UISwitch *)swicths{
    [OutInUserDefaults SetSaveByte:swicths.on];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"确定"]) {
        NSTimer *myTimer = [NSTimer  timerWithTimeInterval:0.3 target:self selector:@selector(timerFired:)userInfo:nil repeats:NO];
        [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
    }
    
}

-(void)timerFired:(id)sender{
    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_sync(concurrentQueue, ^{
            while (1) {
                if ([cacheSize floatValue]>0.00) {

                }
                else{
                    break;
                }
            }
           
        });
        dispatch_sync(dispatch_get_main_queue(), ^{

        });
        
        
    });
    
 }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PressExit:(UIButton *)sender {
    [self ShowHUD:@"正在退出"];
  }

@end
