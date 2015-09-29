//
//  CreateRewardViewController.m
//  Wefafa
//
//  Created by Jiang on 3/17/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "CreateRewardViewController.h"
#import "NavigationTitleView.h"
#import "NoneHeightLightButton.h"
#import "CreateRewardFinishViewController.h"

@interface CreateRewardViewController () <UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate>
//homeProperty
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (strong, nonatomic) IBOutletCollection(NoneHeightLightButton) NSArray *stepButton;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet NoneHeightLightButton *nextButton;
- (IBAction)nextButtonAction:(NoneHeightLightButton *)sender;
- (IBAction)stepButtonAction:(NoneHeightLightButton *)sender;

//firstProperty
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIScrollView *firstContentScrollView;
@property (weak, nonatomic) IBOutlet NoneHeightLightButton *sexManButton;
@property (weak, nonatomic) IBOutlet NoneHeightLightButton *sexWomanButton;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *bodyTypeTextField;

//secondProperty
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIScrollView *secondContentScrollView;
@property (weak, nonatomic) IBOutlet UITextField *simpleDemandTextField;
@property (weak, nonatomic) IBOutlet UITextView *completeDemandTextView;

//finishProperty
@property (strong, nonatomic) IBOutlet UIView *finishView;
@property (strong, nonatomic) IBOutletCollection(NoneHeightLightButton) NSArray *amountButton;
@property (weak, nonatomic) IBOutlet NoneHeightLightButton *rechargeButton;

@end

@implementation CreateRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initContentScrollView];
    [self initSubViewLayout];
}

- (void)initContentScrollView{
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.directionalLockEnabled = YES;
    self.contentScrollView.scrollEnabled = NO;
    self.contentScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * 3, 0);
    
    CGRect rect = self.secondView.frame;
    rect.origin.x = UI_SCREEN_WIDTH;
    self.secondView.frame = rect;
    
    rect.origin.x = UI_SCREEN_WIDTH * 2;
    self.finishView.frame = rect;
    
    [self.contentScrollView addSubview:self.firstView];
    [self.contentScrollView addSubview:self.secondView];
    [self.contentScrollView addSubview:self.finishView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentScrollViewTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)initNavigationBar{
    
    CGRect headrect=CGRectMake(0,0,self.navigationBarView.frame.size.width,self.navigationBarView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:)  selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"创建悬赏";
    [self.navigationBarView addSubview:view];
}

- (void)initSubViewLayout{
    self.nextButton.layer.cornerRadius = 5.0;
    [self.nextButton setTitle:@"提交悬赏" forState:UIControlStateSelected];
    self.completeDemandTextView.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    self.completeDemandTextView.layer.cornerRadius = 5.0;
    self.completeDemandTextView.layer.borderWidth = 1.0;
    self.completeDemandTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.completeDemandTextView.delegate = self;
    
    self.simpleDemandTextField.delegate = self;
    
    self.heightTextField.layer.cornerRadius = 5.0;
    self.heightTextField.layer.borderWidth = 1.0;
    self.heightTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.heightTextField.delegate = self;
    
    self.weightTextField.layer.cornerRadius = 5.0;
    self.weightTextField.layer.borderWidth = 1.0;
    self.weightTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.weightTextField.delegate = self;
    
    self.bodyTypeTextField.layer.cornerRadius = 5.0;
    self.bodyTypeTextField.layer.borderWidth = 1.0;
    self.bodyTypeTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.bodyTypeTextField.delegate = self;
    
    for (int i = 0; i < self.stepButton.count; i++) {
        NoneHeightLightButton *button = self.stepButton[i];
        [button setBackgroundImage:[UIImage imageNamed:@"step_noSelected"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"step_selected"] forState:UIControlStateSelected];
        if (i == 0) {
            [button setSelected:YES];
        }
    }
}

-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonAction:(NoneHeightLightButton *)sender {
    self.view.userInteractionEnabled = NO;
    if ([self.nextButton isSelected]) {
        NSLog(@"提交悬赏");
        CreateRewardFinishViewController *controller = [[CreateRewardFinishViewController alloc]initWithNibName:@"CreateRewardFinishViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    CGPoint point = self.contentScrollView.contentOffset;
    point.x += UI_SCREEN_WIDTH;
    __weak typeof(self) p = self;
    [UIView animateWithDuration:0.5 animations:^{
        p.contentScrollView.contentOffset = point;
    } completion:^(BOOL finished) {
        [p scrollViewDidEndDecelerating:p.contentScrollView];
    }];
}

- (IBAction)stepButtonAction:(NoneHeightLightButton *)sender {
    self.view.userInteractionEnabled = NO;
    NoneHeightLightButton *button = nil;
    for (NoneHeightLightButton *currentButton in self.stepButton) {
        if ([currentButton isSelected]) {
            button = currentButton;
        }
    }
    if ([sender.titleLabel.text intValue] < [button.titleLabel.text intValue]) {
        CGPoint point = self.contentScrollView.contentOffset;
        point.x = UI_SCREEN_WIDTH * ([sender.titleLabel.text intValue] - 1);
        __weak typeof(self) p = self;
        [UIView animateWithDuration:0.5 animations:^{
            p.contentScrollView.contentOffset = point;
        } completion:^(BOOL finished) {
            [p scrollViewDidEndDecelerating:p.contentScrollView];
        }];
    }
}

#pragma mark - scrollView delelgate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.view.userInteractionEnabled = YES;
    if (self.contentScrollView.contentOffset.x == UI_SCREEN_WIDTH * 2) {
        [self.nextButton setSelected:YES];
    }else{
        [self.nextButton setSelected:NO];
    }
    int index = scrollView.contentOffset.x/ UI_SCREEN_WIDTH;
    for (int i = 0; i < self.stepButton.count; i++) {
        NoneHeightLightButton *button = self.stepButton[i];
        button.selected = index == i;
    }
}

- (void)contentScrollViewTap:(UITapGestureRecognizer*)tap{
    [self.bodyTypeTextField resignFirstResponder];
    [self.heightTextField resignFirstResponder];
    [self.weightTextField resignFirstResponder];
    [self.completeDemandTextView resignFirstResponder];
    [self.simpleDemandTextField resignFirstResponder];
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.heightTextField || textField == self.weightTextField || textField == self.bodyTypeTextField) {
        CGFloat keyPosiotn = UI_SCREEN_HEIGHT - 230.0;
        CGFloat movePosition = keyPosiotn - self.contentScrollView.frame.origin.y;
        CGSize size = self.firstContentScrollView.bounds.size;
        size.height += CGRectGetMaxY(self.bodyTypeTextField.frame) - movePosition + 60;
        self.firstContentScrollView.contentSize = size;
        CGPoint point = CGPointMake(0, CGRectGetMaxY(textField.frame) - movePosition + 40);
        [self.firstContentScrollView setContentOffset:point animated:YES];
    }
    if (textField == self.simpleDemandTextField) {
        CGFloat keyPosiotn = UI_SCREEN_HEIGHT - 230.0;
        CGFloat movePosition = keyPosiotn - self.contentScrollView.frame.origin.y;
        CGSize size = self.secondContentScrollView.bounds.size;
        size.height += CGRectGetMaxY(self.completeDemandTextView.frame) - movePosition + 60;
        self.secondContentScrollView.contentSize = size;
        [self.secondContentScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == self.heightTextField || textField == self.weightTextField || textField == self.bodyTypeTextField){
        self.firstContentScrollView.contentSize = CGSizeZero;
    }
    if (textField == self.simpleDemandTextField){
        self.secondContentScrollView.contentSize = CGSizeZero;
    }
    return YES;
}

#pragma mark - textView delegate
static NSString *textViewDefaultText = @"描述的越具体，热心的网友为你提供的搭配越容易符合你得心意哦";
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == self.completeDemandTextView) {
        if ([textView.text isEqualToString:textViewDefaultText]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
        CGFloat keyPosiotn = UI_SCREEN_HEIGHT - 230.0;
        CGFloat movePosition = keyPosiotn - self.contentScrollView.frame.origin.y;
        CGSize size = self.secondContentScrollView.bounds.size;
        size.height += CGRectGetMaxY(self.completeDemandTextView.frame) - movePosition + 60;
        self.secondContentScrollView.contentSize = size;
        [self.secondContentScrollView setContentOffset:CGPointMake(0, textView.frame.origin.y) animated:YES];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView == self.completeDemandTextView) {
        if (textView.text.length == 0) {
            textView.text = textViewDefaultText;
            textView.textColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        }
        self.secondContentScrollView.contentSize = CGSizeZero;
    }
    return YES;
}

@end
