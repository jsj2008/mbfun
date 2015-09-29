//
//  FittingRoomSecondCell.m
//  Wefafa
//
//  Created by yintengxiang on 15/3/19.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "FittingRoomSecondCell.h"
//#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"
#import "AppSetting.h"

@interface FittingRoomSecondCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;
@end

@implementation FittingRoomSecondCell

- (void)awakeFromNib {
    // Initialization code
    self.lineView.height = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(id)data isFromAPI:(BOOL)isFromAPI
{
//    {
//        "OrgName_FittingName": "A05600S001第一个",
//        "AppointmentID": 148,
//        "AppointmentNo": 84,
//        "ClothesCount": 0,
//        "ProdID": "23541840146",
//        "ImageUrl": "http://m1.ibanggo.com/sources/images/goods/MB/235418/235418_40_10--w_120_h_120.jpg",
//        "Description": "Metersbonwe男合体茄克",
//        "ProdColor": "宝蓝色",
//        "ProdSpec": "165/88A(S)",
//        "Qty": 1,
//        "TotalMoney": 299,
//        "CreateDate": "2015-03-23"
//    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)data;
        if (!isFromAPI) {
            self.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"goodsinfo"][@"productInfo"][@"proD_NAME"]];
            self.goodsIDLabel.text = [NSString stringWithFormat:@"%@",dic[@"goodsinfo"][@"productInfo"][@"proD_NUM"]];
            self.colorLabel.text = [NSString stringWithFormat:@"%@",dic[@"goodsinfo"][@"productInfo"][@"coloR_NAME"]];
            self.priceLabel.text = [NSString stringWithFormat:@"%@",dic[@"goodsinfo"][@"productInfo"][@"salE_PRICE"]];
            self.sizeLabel.text = [NSString stringWithFormat:@"%@",dic[@"goodsinfo"][@"productInfo"][@"speC_NAME"]];
            self.qtyLabel.text = [NSString stringWithFormat:@"x%@",dic[@"qty"]];
//            [self.headImage setImageWithURL:[NSURL URLWithString:dic[@"goodsinfo"][@"productInfo"][@"coloR_FILE_PATH"]] placeholderImage:nil];
            
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"goodsinfo"][@"productInfo"][@"coloR_FILE_PATH"]] placeholderImage:[UIImage imageNamed:@"big_loading@3x.png"]];
            
            
        }else {
            
            
            if (![dic objectForKey:@"ProductCode"] || ![dic objectForKey:@"ProdSpec"]) {
                self.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"description"]];
                self.goodsIDLabel.text = [NSString stringWithFormat:@"%@",dic[@"productCode"]];
                self.colorLabel.text = [NSString stringWithFormat:@"%@",dic[@"prodColor"]];
                self.priceLabel.text = [NSString stringWithFormat:@"%@",dic[@"totalMoney"]];
                self.sizeLabel.text = [NSString stringWithFormat:@"%@",dic[@"prodSpec"]];
                self.qtyLabel.text = [NSString stringWithFormat:@"x%@",dic[@"qty"]];
//                [self.headImage setImageWithURL:[NSURL URLWithString:dic[@"imageUrl"]] placeholderImage:nil];
                [self.headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"big_loading@3x.png"]];
            }else{
                self.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"Description"]];
                self.goodsIDLabel.text = [NSString stringWithFormat:@"%@",dic[@"ProductCode"]];
                self.colorLabel.text = [NSString stringWithFormat:@"%@",dic[@"ProdColor"]];
                self.priceLabel.text = [NSString stringWithFormat:@"%@",dic[@"TotalMoney"]];
                self.sizeLabel.text = [NSString stringWithFormat:@"%@",dic[@"ProdSpec"]];
                self.qtyLabel.text = [NSString stringWithFormat:@"x%@",dic[@"Qty"]];
//                [self.headImage setImageWithURL:[NSURL URLWithString:dic[@"ImageUrl"]] placeholderImage:nil];
                [self.headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"ImageUrl"]] placeholderImage:[UIImage imageNamed:@"big_loading@3x.png"]];
            }
            
            
        }

        

        

    }
}
@end
