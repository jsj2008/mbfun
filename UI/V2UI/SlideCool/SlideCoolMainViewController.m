//
//  SlideCoolMainViewController.m
//  Designer
//
//  Created by Samuel on 1/14/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "SlideCoolMainViewController.h"
@interface SlideCoolMainViewController ()

@end

@implementation SlideCoolMainViewController
{
    int sCount;
}

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
    self.title =@"滑酷";
//    self.navigationController.title ;
    [self SetLeftButton:nil Image:@"icon_backarrow_big.png"];

    sCount = 0;
    self.swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectMake(30, 86, 260, 260)];
    [self.view addSubview:self.swipeableView];
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
}
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {

    if (sCount<5) {
        UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, swipeableView.frame.size.width, swipeableView.frame.size.height)];
        NSString *aaa = [NSString stringWithFormat:@"miao%d.jpg",sCount];
        UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:aaa]];
        [imV setFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height)];
        [mainView addSubview:imV];
        sCount++;
        mainView.tag = 1000+sCount;
        return mainView;
    }
   
    
    return nil;
    
    
    
}

#pragma mark - ZLSwipeableViewDelegate
- (void)swipeableView: (ZLSwipeableView *)swipeableView didSwipeLeft:(UIView *)view {
    NSLog(@"did swipe left");
}
- (void)swipeableView: (ZLSwipeableView *)swipeableView didSwipeRight:(UIView *)view {
    NSLog(@"did swipe right");
}
- (void)swipeableView: (ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"swiping at location: x %f, y%f", location.x, location.y);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view;
{
    NSLog(@"%d",view.tag);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location;
{
    NSLog(@"%f~~~%f",location.x,location.y);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation;
{
    NSLog(@"%f~~~~~~~~~~~~~~~~~~~~~%f",location.x,location.y);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location;
{
    NSLog(@"%f~~~~~~~~%f",location.x,location.y);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)leftDel:(id)sender {
    [self.swipeableView swipeTopViewToLeft];

}

- (IBAction)rightSav:(id)sender {
        [self.swipeableView swipeTopViewToRight];
}

- (IBAction)Okay:(id)sender {
}

- (IBAction)unOkay:(id)sender {
}

- (IBAction)finish:(id)sender {
}
@end
