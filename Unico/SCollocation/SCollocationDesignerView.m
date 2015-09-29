//
//  SCollocationDesignerView.m
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationDesignerView.h"
#import "SCollocationDetailModel.h"
#import "SMineViewController.h"
#import "HttpRequest.h"
#import "WeFaFaGet.h"
#import "Toast.h"

@interface SCollocationDesignerView ()

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userSignatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightSymbol;

@end

@implementation SCollocationDesignerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"SCollocationDesignerView" owner:nil options:nil][0];
        self.width = frame.size.width;
        self.layer.masksToBounds = YES;
        self.userHeaderImageView.layer.masksToBounds = YES;
        self.userHeaderImageView.layer.cornerRadius = _userHeaderImageView.width/ 2.0;
        self.userHeaderImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchHeaderImageView:)];
        [self.userHeaderImageView addGestureRecognizer:tap];
    }
    return self;
}

- (void)touchHeaderImageView:(UITapGestureRecognizer *)tap{
    if (!_contentModel.designer.user_id) return;
    SMineViewController *controller = [SMineViewController new];
    controller.person_id = _contentModel.designer.user_id;
    [_target.navigationController pushViewController:controller animated:YES];
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    _attentionButton.hidden = [contentModel.designer.user_id isEqualToString:sns.ldap_uid];
    
    SDiscoveryUserModel *designerModel = contentModel.designer;
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:designerModel.head_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    self.nickNameLabel.text = designerModel.nick_name;
    self.fansCountLabel.text = [NSString stringWithFormat:@"粉丝 %d", designerModel.concernedCount.intValue];
    self.userSignatureLabel.text = designerModel.userSignature;
    self.attentionButton.selected = designerModel.isConcerned.boolValue;
    
     CGSize size = [designerModel.userSignature boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 58, 0) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
    _rightSymbol.hidden = size.height > 20;
    
    CGRect rect = self.frame;
    if (self.contentModel.isNoneShopping) {
        rect.size.height = 64.0;
    }else{
        rect.size.height = 90.0 + size.height - (size.height > 0? 23: 0);
    }
    self.frame = rect;
    [self setNeedsDisplay];
}

#pragma mark - attention action
- (IBAction)attentionButtonAction:(UIButton *)sender {
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    SDiscoveryUserModel *designerModel = _contentModel.designer;
    if ([sender isSelected]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认取消关注" message:@"您将取消对此用户的关注！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.delegate = self;
        [alertView show];
    }else{
        NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
        NSDictionary *data=@{@"m":@"Account",
                             @"a":@"UserConcernCreate",
                             @"userId":loginUserID,
                             @"concernId":designerModel.user_id};
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id dict) {
            [Toast hideToastActivity];
            
            if ([[dict allKeys]containsObject:@"isSuccess"]) {
                BOOL  isSuccess = [dict[@"isSuccess"] boolValue];
                if(!isSuccess)
                {
                    NSString *message =nil;
                    message = dict[@"message"];
                    [Toast makeToast:message duration:1.5 position:@"center"];
                    return ;
                }
            }
            designerModel.isConcerned = @YES;
            sender.selected = YES;
            [Toast makeToastSuccess:@"关注成功!"];
        } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            [Toast makeToast:@"关注失败!" duration:1.5 position:@"center"];
        }];

    }

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    SDiscoveryUserModel *designerModel = _contentModel.designer;
    if (buttonIndex == 1)
    {
        
        NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
        NSDictionary *data=@{@"m":@"Account",
                             @"a":@"UserConcernDelete",
                             @"userId":loginUserID,
                             @"concernIds":designerModel.user_id};
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id dict) {
            [Toast hideToastActivity];
            if ([[dict allKeys]containsObject:@"isSuccess"]) {
                BOOL  isSuccess = [dict[@"isSuccess"] boolValue];
                if(!isSuccess)
                {
                    NSString *message =nil;
                    message = dict[@"message"];
                    [Toast makeToast:message duration:1.5 position:@"center"];
                    return ;
                }
            }
            designerModel.isConcerned = @NO;
            _attentionButton.selected = NO;
            [Toast makeToastSuccess:@"已取消关注!"];
        } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            _attentionButton.userInteractionEnabled = YES;
            [Toast makeToast:@"取消关注失败!" duration:1.5 position:@"center"];
        }];
    }
}

- (void)drawRect:(CGRect)rect{
    if (_contentModel.isNoneShopping && _contentModel.content_info.length > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        //指定直线样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //直线宽度
        CGContextSetLineWidth(context, 0.5);
        //设置颜色
        CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xd9d9d9).CGColor);
        //    cgcontextset
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
        CGContextMoveToPoint(context, 0, self.height);
        //下一点
        CGContextAddLineToPoint(context, 30, self.height);
        //下一点
        CGContextAddLineToPoint(context, 34, self.height - 4);
        //下一点
        CGContextAddLineToPoint(context, 38, self.height);
        //下一点
        CGContextAddLineToPoint(context, self.width, self.height);
        //绘制完成
        CGContextStrokePath(context);
    }
}

@end
