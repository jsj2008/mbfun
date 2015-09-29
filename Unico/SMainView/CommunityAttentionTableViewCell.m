//
//  CommunityAttentionTableViewCell.m
//  Wefafa
//
//  Created by wave on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityAttentionTableViewCell.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "CommunityAttentionMasterModel.h"
#import "WeFaFaGet.h"
#import "Toast.h"

@interface CommunityAttentionTableViewCell ()
@property (nonatomic, strong) UIImageView   *portraitImg;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UILabel       *fans_count;

@property (nonatomic, strong) UIButton      *attentionBtn;
@property (nonatomic, strong) CALayer       *seperateLayer;
@end

@implementation CommunityAttentionTableViewCell

- (void)setModel:(CommunityAttentionMasterModel *)model {
    _model = model;
    
    [_portraitImg sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    _nameLabel.text = model.nick_name;
    _fans_count.text = [NSString stringWithFormat:@"粉丝 | %@", model.concernCount];
    
    [_nameLabel sizeToFit];
    [_fans_count sizeToFit];
    _attentionBtn.selected = model.isConcerned;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
        
        _portraitImg = [[UIImageView alloc] initWithFrame:CGRectMake(17, 0, 45, 45)];
        _portraitImg.layer.cornerRadius = _portraitImg.width/2;
        _portraitImg.layer.masksToBounds = YES;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_portraitImg.right + 15, 0, 0, 0)];
        [_nameLabel setFont:FONT_T2];
        _fans_count = [[UILabel alloc]initWithFrame:CGRectMake(_portraitImg.right + 15, 0, 0, 0)];
        [_fans_count setFont:FONT_t6];
        [_fans_count setTextColor:COLOR_C6];
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBtn setFrame:CGRectMake(UI_SCREEN_WIDTH - 65, 19, 55, 22)];
        [_attentionBtn setImage:[UIImage imageNamed:@"Unico/ygz.png"] forState:UIControlStateSelected];
        [_attentionBtn setImage:[UIImage imageNamed:@"Unico/main_addtion.png"] forState:UIControlStateNormal];
        _attentionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _attentionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_attentionBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_portraitImg];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_fans_count];
        [self.contentView addSubview:_attentionBtn];
        
        __weak CommunityAttentionTableViewCell *ws = self;
        self.modelDidChangedBlock = ^(BOOL isConcerned){
            ws.attentionBtn.selected = isConcerned;
            ws.model.isConcerned = isConcerned;
            ws.model.concernCount = isConcerned ? [NSString stringWithFormat:@"%d", [ws.model.concernCount intValue] + 1] : [@([ws.model.concernCount intValue] - 1) stringValue];
            ws.fans_count.text = [NSString stringWithFormat:@"粉丝 | %@", ws.model.concernCount];
        };
    }
    
    _seperateLayer = [CALayer new];
    _seperateLayer.backgroundColor = COLOR_C9.CGColor;
    [self.layer addSublayer:_seperateLayer];
    return self;
}

- (void)click {
    __weak __typeof(self)ws = self;
    if (!_attentionBtn.selected) {   //已关注
        NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
        NSDictionary *data=@{@"m":@"Account",
                             @"a":@"UserConcernCreate",
                             @"userId":loginUserID,
                             @"concernId":_model.user_id};
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
            [Toast makeToastSuccess:@"关注成功"];
            ws.attentionBtn.selected = YES;
            //改model
            ws.model.isConcerned = YES;
            ws.model.concernCount = [NSString stringWithFormat:@"%d", [ws.model.concernCount intValue] + 1];
            
            ws.fans_count.text = [NSString stringWithFormat:@"粉丝 | %d",[ws.model.concernCount intValue]];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Toast hideToastActivity];
            ws.attentionBtn.selected = NO;
        }];
    }else { //未关注
        NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
        NSDictionary *data=@{@"m":@"Account",
                             @"a":@"UserConcernDelete",
                             @"userId":loginUserID,
                             @"concernIds":_model.user_id};
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
            [Toast hideToastActivity];
            
            BOOL issuccess=NO;
            if ([[responseObject allKeys] containsObject:@"isSuccess"]) {
                issuccess  = [responseObject[@"isSuccess"] boolValue];
            }
            if(!issuccess)
            {
                [Toast makeToast:@"取消关注失败!" duration:1.5 position:@"center"];
                return ;
            }
            ws.attentionBtn.selected = NO;
            [Toast makeToastSuccess:@"已取消关注!"];
            //改model
            ws.model.isConcerned = NO;
            ws.model.concernCount = [@([ws.model.concernCount intValue] - 1) stringValue];
            
            ws.fans_count.text = [NSString stringWithFormat:@"粉丝 | %@", ws.model.concernCount];
        } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            [Toast makeToast:@"取消关注失败!" duration:1.5 position:@"center"];
        }];
    }
}

- (void)layoutSubviews {
    [_portraitImg setCenterY:self.height / 2];
    
    [_attentionBtn setRight:UI_SCREEN_WIDTH - 10];
    [_attentionBtn setCenterY:self.height / 2];

    [_nameLabel setTop:_portraitImg.top];
    [_fans_count setTop:_nameLabel.bottom + 7];

    [_seperateLayer setFrame:CGRectMake(0, self.height, self.width, 1)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
