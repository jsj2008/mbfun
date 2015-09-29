//
//  PersonalInformationViewController.m
//  Designer
//
//  Created by Jiang on 1/14/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "PersonalInformationContentListTableView.h"
#import "PersonalInformationCollectionView.h"

@interface PersonalInformationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

- (IBAction)attentionButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *liftButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *contentListView;

- (IBAction)liftButtonAction:(UIButton *)sender;
- (IBAction)centerButtonAction:(UIButton *)sender;
- (IBAction)rightButtonAction:(UIButton *)sender;
@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"个人资料"];
    [self SetLeftButton:nil Image:@"u145"];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UIImage *image = [UIImage imageNamed:@"tab－data－gray.png"];
    image = [image resizableImageWithCapInsets:insets];
    
    [self.liftButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.centerButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.liftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    image = [UIImage imageNamed:@"tab－data－yellow.png"];

    [self.liftButton setBackgroundImage:image forState:UIControlStateSelected];
    [self.centerButton setBackgroundImage:image forState:UIControlStateSelected];
    [self.rightButton setBackgroundImage:image forState:UIControlStateSelected];
    [self.liftButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self liftButtonAction:self.liftButton];
    
    image = [UIImage imageNamed:@"icon-data-focus.png"];
    [self.attentionButton setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"icon-data-on.png"];
    [self.attentionButton setBackgroundImage:image forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)liftButtonAction:(UIButton *)sender {
    [self removeAllSubViewsWithView:self.contentListView];
    PersonalInformationCollectionView *collectionView = [[PersonalInformationCollectionView alloc]initWithFrame:self.contentListView.bounds];
    [self.contentListView addSubview:collectionView];
    
    [self.liftButton setSelected:YES];
    [self.centerButton setSelected:NO];
    [self.rightButton setSelected:NO];
}
- (IBAction)centerButtonAction:(UIButton *)sender {
    [self removeAllSubViewsWithView:self.contentListView];
    PersonalInformationContentListTableView *tableView = [[PersonalInformationContentListTableView alloc]initWithFrame:self.contentListView.bounds];
    [self.contentListView addSubview:tableView];
    
    [self.liftButton setSelected:NO];
    [self.centerButton setSelected:YES];
    [self.rightButton setSelected:NO];
}
- (IBAction)rightButtonAction:(UIButton *)sender {
    [self removeAllSubViewsWithView:self.contentListView];
    PersonalInformationContentListTableView *tableView = [[PersonalInformationContentListTableView alloc]initWithFrame:self.contentListView.bounds];
    [self.contentListView addSubview:tableView];
    
    [self.liftButton setSelected:NO];
    [self.centerButton setSelected:NO];
    [self.rightButton setSelected:YES];
}

- (void)removeAllSubViewsWithView:(UIView*)view{
    for (UIView* subView in view.subviews) {
        [subView removeFromSuperview];
    }
}
- (IBAction)attentionButton:(UIButton *)sender {
    BOOL isSelected = !self.attentionButton.selected;
    [self.attentionButton setSelected:isSelected];
}
@end
