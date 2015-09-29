//
//  MBSettingViewController.h
//  Wefafa
//
//  Created by fafatime on 14-11-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSettingViewController : SBaseViewController//UIViewController
{
    NSArray *sections; //title, cells, title, cells,...

}

@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *helpCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *checkUpdataCel;
@property (strong, nonatomic) IBOutlet UITableViewCell *clearDataCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *clearChattingRecordsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *suggestionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *aboutWeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *mdtgCell;


@property (strong, nonatomic) IBOutlet UIView *quitView;
@property (strong, nonatomic) IBOutlet UITableViewCell *modifyPassWord;
- (IBAction)quitBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbVersion;

@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;


@property (strong, nonatomic) IBOutlet UITableViewCell *tipViberTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *tipVoiceTableViewCell;


@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *switchTipVoice;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *switchTipViber;


- (IBAction)switchTipVoice_OnValueChanged:(id)sender;
- (IBAction)switchTipViber_OnValueChanged:(id)sender;

@end
