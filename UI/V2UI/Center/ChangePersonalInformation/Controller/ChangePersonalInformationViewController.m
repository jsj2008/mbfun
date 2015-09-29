//
//  ChangePersonalInformationViewController.m
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ChangePersonalInformationViewController.h"
#import "ChangePersonalInformationTableView.h"
#import "ChangePersonalInformationModel.h"

//subClassController

#import "ChangeSexViewController.h"
#import "ChangePasswardViewController.h"
#import "ChangeNicknameViewController.h"
#import "ChangeMySignatureViewController.h"

@interface ChangePersonalInformationViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *modelArray;

@property (weak, nonatomic) IBOutlet ChangePersonalInformationTableView *contentTableView;

@end

@implementation ChangePersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"个人资料"];
    [self SetLeftButton:nil Image:@"u145"];
    self.contentTableView.modelArray = self.modelArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d", buttonIndex);
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet{
    NSLog(@"%d",actionSheet.subviews.count);
}
//
//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
//    for (UIView *view in actionSheet.subviews) {
//        int count =0;
//        if ([view isKindOfClass:[UIButton class]]) {
//            UIButton *btn = (UIButton*)view;
//            UIColor *color = nil;
//            if (count == 2) {
//                color = [UIColor grayColor];
//            }else{
//                color = [UIColor blackColor];
//            }
//            [btn setTitleColor:color forState:UIControlStateNormal];
//            count++;
//        }
//    }
//}

- (NSArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSArray array];
        typeof(self) p = self;
        NSArray *array01 = @[
                             [[ChangePersonalInformationModel alloc]initWithTitle:@"头像" imageName:@"u12.png" contentText:@"" showArrows:YES operation:^{
                                 UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:p cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机获取", nil];
                                 [actionSheet showInView:p.view];
                             }],
                             [[ChangePersonalInformationModel alloc]initWithTitle:@"性别" imageName:@"" contentText:@"女" showArrows:YES operation:^{
                                 ChangeSexViewController *controller = [[ChangeSexViewController alloc]initWithNibName:@"ChangeSexViewController" bundle:nil];
                                 controller.sexWoman = YES;
                                 [p.navigationController pushViewController:controller animated:YES];
                             }]
                             ];
        NSArray *array02 = @[
                             [[ChangePersonalInformationModel alloc]initWithTitle:@"昵称" imageName:@"" contentText:@"野崎君" showArrows:YES operation:^{
                                 ChangeNicknameViewController *controller = [[ChangeNicknameViewController alloc]initWithNibName:@"ChangeNicknameViewController" bundle:nil];
                                 controller.nickName = @"野崎君";
                                 [p.navigationController pushViewController:controller animated:YES];
                             }],
                             [[ChangePersonalInformationModel alloc]initWithTitle:@"手机" imageName:@"" contentText:@"12345645764" showArrows:NO operation:^{
                                 
                             }],
                             [[ChangePersonalInformationModel alloc]initWithTitle:@"个性签名" imageName:@"" contentText:@"" showArrows:YES operation:^{
                                 ChangeMySignatureViewController *controller = [[ChangeMySignatureViewController alloc]initWithNibName:@"ChangeMySignatureViewController" bundle:nil];
                                 controller.mySignatureText = @"时尚是一种生活态度!";
                                 [p.navigationController pushViewController:controller animated:YES];
                             }],
                             [[ChangePersonalInformationModel alloc]initWithTitle:@"收货管理" imageName:@"" contentText:@"" showArrows:YES operation:^{
                                 
                             }]
                             ];
        NSArray *array03 = @[
                             [[ChangePersonalInformationModel alloc]initWithTitle:@"修改密码" imageName:@"" contentText:@"" showArrows:YES operation:^{
                                 ChangePasswardViewController *controller = [[ChangePasswardViewController alloc]initWithNibName:@"ChangePasswardViewController" bundle:nil];
                                 [p.navigationController pushViewController:controller animated:YES];
                             }]
                             ];
        _modelArray = @[array01, array02, array03];
    }
    return _modelArray;
}

@end
