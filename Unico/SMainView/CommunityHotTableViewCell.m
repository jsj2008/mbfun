//
//  CommunityHotTableViewCell.m
//  Wefafa
//  时尚达人
//  Created by wave on 15/8/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityHotTableViewCell.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SStarStoreCellModel.h"
#import "SCollocationDetailViewController.h"
#import "SMineViewController.h"
#import "CommunityHotTableView.h"

@interface CommunityHotTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img4_3;
@property (weak, nonatomic) IBOutlet UIImageView *img16_9;
@property (weak, nonatomic) IBOutlet UIImageView *img1_1;

@property (weak, nonatomic) IBOutlet UIImageView *protrait;
@property (weak, nonatomic) IBOutlet UIImageView *head_v;

@property (weak, nonatomic) IBOutlet UIImageView *mask; //排名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabelLeft;   //作品
@property (weak, nonatomic) IBOutlet UILabel *countLabelRight;  //粉丝
@property (weak, nonatomic) IBOutlet UIView *bottomGrayView;

@property (weak, nonatomic) UIViewController *target;
@end

@implementation CommunityHotTableViewCell

- (void)model:(SStarStoreCellModel*)model parentVC:(UIViewController*)target indexPath:(NSIndexPath*)indexPath {
    self.target = target;
    
    self.model = model;
    
    self.img16_9.userInteractionEnabled = NO;
    self.img1_1.userInteractionEnabled = NO;
    self.img4_3.userInteractionEnabled = NO;
    
    NSMutableArray *tempAry = model.collocationList;
    NSArray *ary_img = @[self.img16_9, self.img1_1, self.img4_3];
    for (NSDictionary *dictionary in tempAry) {
        UIImageView *imgView = ary_img[[tempAry indexOfObject:dictionary]];
        [imgView sd_setImageWithURL:[NSURL URLWithString:dictionary[@"img"]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        imgView.userInteractionEnabled = YES;
    }
    /*
     if (tempAry.count == 3) {
     [self.img16_9 sd_setImageWithURL:[NSURL URLWithString:[tempAry[0] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
     [self.img1_1 sd_setImageWithURL:[NSURL URLWithString:[tempAry[1] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
     [self.img4_3 sd_setImageWithURL:[NSURL URLWithString:[tempAry[2] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
     self.img16_9.userInteractionEnabled = YES;
     self.img1_1.userInteractionEnabled = YES;
     self.img4_3.userInteractionEnabled = YES;
     }else {
     self.img16_9.userInteractionEnabled = NO;
     self.img1_1.userInteractionEnabled = NO;
     self.img4_3.userInteractionEnabled = NO;
     }
     */
    [self.protrait sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    [self.nameLabel setText:model.userName];

    [self.countLabelLeft setText:[NSString stringWithFormat:@"作品%@", model.collocationCount]];
    [self.countLabelRight setText:[NSString stringWithFormat:@"粉丝%@", model.concernCount]];
    
    NSString *head_v_type=[NSString stringWithFormat:@"%@",model.head_v_type];
    switch ([head_v_type integerValue]) {
        case 0:
        {
            self.head_v.hidden=YES;
        }
            break;
        case 1:
        {
            self.head_v.hidden=NO;
            [self.head_v setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [self.head_v setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            self.head_v.hidden=NO;
        }
            break;
        default:
            break;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            self.mask.hidden = NO;
            self.mask.image = [UIImage imageNamed:@"Unico/ico_no1"];
            break;
        }
        case 1:
        {
            self.mask.hidden = NO;
            self.mask.image = [UIImage imageNamed:@"Unico/ico_no2"];
            break;
        }
        case 2:
        {
            self.mask.hidden = NO;
            self.mask.image = [UIImage imageNamed:@"Unico/ico_no3"];
            break;
        }
        default:
        {
            self.mask.hidden = YES;
            break;
        }
    }
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        //_nameLabel
//        [_nameLabel setFont:FONT_t6];
//        [_nameLabel setTextColor:COLOR_C2];
//        //_countLabel
//        [_countLabelLeft setFont:FONT_t7];
//        [_countLabelLeft setTextColor:COLOR_C6];
//        [_countLabelRight setFont:FONT_t7];
//        [_countLabelRight setTextColor:COLOR_C6];
//        _bottomGrayView.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
//        //img
//        self.img16_9.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit;
//        self.img1_1.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit;
//        self.img4_3.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit;
//        
//        self.img16_9.layer.masksToBounds = YES;
//        self.img4_3.layer.masksToBounds = YES;
//        self.img1_1.layer.masksToBounds = YES;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click16_9)];
//        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click1_1)];
//        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click4_3)];
//        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProtrait)];
//        NSArray *array = @[self.img16_9, self.img1_1, self.img4_3, self.protrait];
//        NSArray *array2 = @[tap, tap2, tap3, tap4];
//        for (UIImageView *imgView in array) {
//            imgView.userInteractionEnabled = YES;
//            [imgView addGestureRecognizer:array2[[array indexOfObject:imgView]]];
//        }
//        
//        _protrait.layer.cornerRadius = _protrait.width/2;
//        _protrait.layer.masksToBounds = YES;
//        _protrait.layer.borderColor = [UIColor whiteColor].CGColor;
//        _protrait.layer.borderWidth = 2;
//
//    }
//    return self;
//}

- (void)awakeFromNib {
    // Initialization code
    //_nameLabel
    [_nameLabel setFont:FONT_t6];
    [_nameLabel setTextColor:COLOR_C2];
    //_countLabel
    [_countLabelLeft setFont:FONT_t7];
    [_countLabelLeft setTextColor:COLOR_C6];
    [_countLabelRight setFont:FONT_t7];
    [_countLabelRight setTextColor:COLOR_C6];
    _bottomGrayView.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
    //img
    self.img16_9.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit;
    self.img1_1.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit;
    self.img4_3.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit;
    
    self.img16_9.layer.masksToBounds = YES;
    self.img4_3.layer.masksToBounds = YES;
    self.img1_1.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click16_9)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click1_1)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click4_3)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProtrait)];
    NSArray *array = @[self.img16_9, self.img1_1, self.img4_3, self.protrait];
    NSArray *array2 = @[tap, tap2, tap3, tap4];
    for (UIImageView *imgView in array) {
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:array2[[array indexOfObject:imgView]]];
    }
    
    _protrait.layer.cornerRadius = _protrait.width/2;
    _protrait.layer.masksToBounds = YES;
    _protrait.layer.borderColor = [UIColor whiteColor].CGColor;
    _protrait.layer.borderWidth = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)click16_9 {
    //        CommunityHotTableView *view = (CommunityHotTableView*)self.parentView;
    SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
    NSString * collocationId = _model.collocationList[0][@"id"];
    collocationDetailVC.collocationId = collocationId  ;
    [self.parentVC.navigationController pushViewController:collocationDetailVC animated:YES];
}

- (void)click1_1 {
    SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
    NSString * collocationId = _model.collocationList[1][@"id"];
    collocationDetailVC.collocationId = collocationId  ;
    [self.parentVC.navigationController pushViewController:collocationDetailVC animated:YES];
}

- (void)click4_3 {
    SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
    NSString * collocationId = _model.collocationList[2][@"id"];
    collocationDetailVC.collocationId = collocationId  ;
    [self.parentVC.navigationController pushViewController:collocationDetailVC animated:YES];
}


- (void)clickProtrait {
//    CommunityHotTableView *view = (CommunityHotTableView*)self.parentView;
    NSString *userIdStr = _model.designId;
    SMineViewController *vc = [[SMineViewController alloc]init];
    vc.person_id = userIdStr;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
}

@end
