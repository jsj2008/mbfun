//
//  MBStoreVisitorViewController.m
//  Wefafa
//
//  Created by Jiang on 5/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBStoreVisitorViewController.h"
#import "MBStoreVisitorTitleView.h"
#import "NavigationTitleView.h"
#import "MBStoreShowDataView.h"
#import "MBStoreVisitorModel.h"
#import "MBStoreShowDataContentView.h"
#import "HttpRequest.h"
#import "WeFaFaGet.h"
#import "Utils.h"
#import "Toast.h"

@interface MBStoreVisitorViewController ()<UIScrollViewDelegate>
{
    NSInteger _selectedDayCount;
    NSInteger _selectedChannelIndex;
    NSInteger _indexStartDate;
    NSInteger _indexEndDate;
}

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet MBStoreVisitorTitleView *titleShowCountView;

//数据显示内容
@property (weak, nonatomic) IBOutlet MBStoreShowDataContentView *contentShowDataView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectedButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *channelButtonArray;

@property (weak, nonatomic) IBOutlet UIScrollView *showDataContentScrollView;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UIView *tabBarSelectedView;


//--------
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) MBStoreShowDataView *showDataContentView;
@property (nonatomic, strong) NSArray *contentModelArray;

@end

@implementation MBStoreVisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initSubViews];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavbar];
    [self requestData];
}

- (void)initNavigationBar{
    self.navigationItem.title = @"今日访客";
}

- (void)setupNavbar{
    [super setupNavbar];
}

- (void)initSubViews{
    CGRect frame = self.contentShowDataView.frame;
    frame.size.height *= MAX(UI_SCREEN_HEIGHT, 320.0)/ 667.0;
    _contentShowDataView.frame = frame;
    for (int i = 0; i < _channelButtonArray.count; i++){
        UIButton *button = _channelButtonArray[i];
        NSLog(@"%@", button);
        CGRect frame = button.frame;
        frame.origin.x = i * (UI_SCREEN_WIDTH/ 4);
        frame.size.width = UI_SCREEN_WIDTH/ 4;
        button.frame = frame;
    }
    UIButton *selectedButton = [self.selectedButton firstObject];
    self.contentScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.contentShowDataView.frame) + 15.0);
    
    self.selectedView = [[UIView alloc]initWithFrame:selectedButton.frame];
    self.selectedView.backgroundColor = [Utils HexColor:0xffde00 Alpha:1];
    self.selectedView.layer.cornerRadius = 4.0;
    
    [self.contentShowDataView insertSubview:self.selectedView atIndex:0];
    self.showDataContentScrollView.delegate = self;
    CGFloat height = self.showDataContentScrollView.frame.size.height;
    CGFloat origin_Y = self.showDataContentScrollView.frame.origin.y;
    [self.contentShowDataView drawRectWithStartPoint_Y:origin_Y height:(height / 10)];
    
    self.showDataContentScrollView.bounces = NO;
    self.showDataContentScrollView.contentSize = CGSizeMake(40 * 31, 0);
    self.showDataContentView = [[MBStoreShowDataView alloc]initWithFrame:CGRectMake(0, 0, 40 * 7, self.showDataContentScrollView.frame.size.height)];
    self.showDataContentView.backgroundColor = [UIColor clearColor];
    _indexStartDate = -1;
    _indexEndDate = -1;
    [self.showDataContentScrollView addSubview:self.showDataContentView];
}

- (void)requestData{
    [Toast makeToastActivity];
    self.tabBarSelectedView.userInteractionEnabled = NO;
    self.contentShowDataView.userInteractionEnabled = NO;
    NSDictionary *params = @{@"Shared_id": _user_ID,
                             @"DayTotal": @90};
    [HttpRequest getRequestPath:kMBServerNameTypeStatistics methodName:@"DayClickSharedCountSumGroupListFilter" params:params success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        self.contentModelArray = [MBStoreVisitorModel modelArrayForDataArray:dict[@"results"]];
    } failed:^(NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    UIButton *button = [self.channelButtonArray firstObject];
    [UIView animateWithDuration:0.25 animations:^{
        button.backgroundColor = [Utils HexColor:0xffde00 Alpha:1];
    }completion:^(BOOL finished) {
        self.tabBarSelectedView.userInteractionEnabled = YES;
        self.contentShowDataView.userInteractionEnabled = YES;
    }];
    [self selectedButtonAction:self.selectedButton[0]];
    [self channelButtonAction:button];
    
}

- (void)settingContentViewDataWithIndex:(NSInteger)index{
    NSArray *array = _contentModelArray[index];
    NSArray *dayCountArray = [array subarrayWithRange:NSMakeRange(0, _selectedDayCount)];
    int maxCount = 1;
    int sumShareCount = 0;
    int sumVisitorCount = 0;
    for (MBStoreVisitorModel *model in dayCountArray) {
        sumShareCount += model.sharedCount.intValue;
        sumVisitorCount += model.clickCount.intValue;
        int currentCount = model.clickCount.intValue + model.sharedCount.intValue;
        if(currentCount > maxCount){
            maxCount = currentCount;
        }
    }
    self.showDataContentScrollView.contentSize = CGSizeMake(kShowPointLocation_X * (dayCountArray.count - 1) + 30, 0);
    self.titleShowCountView.shareCount = [NSString stringWithFormat:@"%d", sumShareCount];
    self.titleShowCountView.visitorCount = [NSString stringWithFormat:@"%d", sumVisitorCount];
    _showDataContentView.maxVisitorCount = maxCount;
    _showDataContentView.contentModelArray = dayCountArray;
    [self scrollViewDidScroll:_showDataContentScrollView];
}

-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int indexStart = (scrollView.contentOffset.x - 15)/ kShowPointLocation_X;
    if (_indexStartDate != indexStart && indexStart > 0) {
        _indexStartDate = indexStart;
        [self setBottomShowDate:self.startDateLabel index:indexStart];
    }
    int indexEnd = (scrollView.contentOffset.x - 15 + scrollView.frame.size.width)/ kShowPointLocation_X;
    if (indexEnd != _indexEndDate && indexEnd < 90) {
        _indexEndDate = indexEnd;
        [self setBottomShowDate:self.endDateLabel index:indexEnd];
    }
}

- (void)setBottomShowDate:(UILabel*)label index:(NSInteger)index{
    NSArray *array = _contentModelArray[_selectedChannelIndex];
    MBStoreVisitorModel *model = array[index];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM.dd"];
    
    UILabel *animationLabel = [[UILabel alloc]initWithFrame:label.frame];
    [self.contentShowDataView addSubview:animationLabel];
    animationLabel.text = label.text;
    animationLabel.font = label.font;
    animationLabel.textAlignment = label.textAlignment;
    animationLabel.textColor = label.textColor;
    animationLabel.alpha = 0.6;
    label.text = [formatter stringFromDate:model.create_date];
    [UIView animateWithDuration:0.15 animations:^{
        animationLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        animationLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [animationLabel removeFromSuperview];
    }];
}

- (IBAction)selectedButtonAction:(UIButton *)sender {
    //button状态处理
    if ([sender isSelected]) {
        return;
    }else{
        for (UIButton *button in self.selectedButton) {
            if (button == sender) {
                button.selected = YES;
                [UIView animateWithDuration:0.25 animations:^{
                    self.selectedView.center = button.center;
                }];
            }else{
                button.selected = NO;
            }
        }
    }
    
    //button 事件处理
    _selectedDayCount = [sender.titleLabel.text intValue];
    [self settingContentViewDataWithIndex:_selectedChannelIndex];
}

- (IBAction)channelButtonAction:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }else{
        for (UIButton *button in self.channelButtonArray) {
            if (button == sender) {
                button.selected = YES;
                button.backgroundColor = [Utils HexColor:0xffde00 Alpha:1];
            }else{
                button.selected = NO;
                button.backgroundColor = [Utils HexColor:0x333333 Alpha:1];
            }
        }
    }
    _selectedChannelIndex = sender.tag - 30;
    [self settingContentViewDataWithIndex:_selectedChannelIndex];
}
@end
