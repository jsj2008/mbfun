//
//  AppraiseViewController.m
//  BanggoPhone
//
//  Created by Juvid on 14-7-14.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "AppraiseViewController.h"
#import "AppraiseCell.h"
//#import "MGetOrderDetailgoodsInfo.h"
//#import "UIImageView+ModCache.h"
//#import "BGSever+User.h"
//#import "MGetOrderDetail.h"
#define ROWHEIGHT 128
@interface AppraiseViewController (){
    CGFloat tablePoint;
}
@property (weak, nonatomic) IBOutlet UILabel *labTime;

@end

@implementation AppraiseViewController
@synthesize arrList;
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
    self.tableView.rowHeight=ROWHEIGHT;
   self.title=@"评价";
    if (IOS7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    if (self.strOrderSn) {

    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)LeftReturn:(UIButton *)sender{
    UIAlertView *alr=[DetectionSystem ShowDoubleAlert:@"放弃评论" Message:nil];
    alr.delegate=self;
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *strTitle=[alertView buttonTitleAtIndex:buttonIndex];
    if ([strTitle isEqualToString:@"确定"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}
-(void)GobackRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
       return 10;
}
//绘制Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *CellIdentifier = @"AppraiseCell";
    AppraiseCell *cell=(AppraiseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[AppraiseCell alloc]  initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
 
    for (int i=1;i<6; i++) {
        UIButton *btnAppraise=(UIButton *)[cell viewWithTag:i];
        [btnAppraise addTarget:self action:@selector(PressStar:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    cell.txtAppraise.delegate=self;
    return cell;
    
}
-(void)PressStar:(UIButton *)sender{
  
    for (UIButton *subView in sender.superview.subviews) {
        if (subView.tag<=sender.tag) {
            [subView setImage:[UIImage imageNamed:@"icon_evaluation_star"] forState:UIControlStateNormal];
           
        }
        else{
            [subView setImage:[UIImage imageNamed:@"icon_profile_favor"] forState:UIControlStateNormal];
        }
    }
   
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
     [self.tableView setContentOffset:CGPointMake(0, tablePoint) animated:YES];
   
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
   /* NSIndexPath *path=[DetectionSystem SubView:textField TableView:self.tableView];
    MGetOrderDetailgoodsInfo *goods=arrList[path.row];
    goods.content=textField.text;
*/
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    tablePoint=self.tableView.contentOffset.y;
     NSIndexPath *path=[DetectionSystem SubView:textField TableView:self.tableView];
    [self.tableView setContentOffset:CGPointMake(0,ROWHEIGHT*path.row) animated:YES];
    
//    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PressSend:(UIButton *)sender {

}


@end
