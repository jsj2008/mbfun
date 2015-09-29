//
//  EnterpriseLicenceUploadViewController.h
//  Wefafa
//
//  Created by mac on 13-10-25.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationTitleView.h"

@interface EnterpriseLicenceUploadViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *sections;
}

@property (strong, nonatomic) NavigationTitleView *titleView;
@property (strong, nonatomic) IBOutlet UIView *viewHead;



@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnUpload;

- (IBAction)btnUploadClick:(id)sender;

@end
