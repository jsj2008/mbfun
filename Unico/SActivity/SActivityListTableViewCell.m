//
//  SActivityListTableViewCell.m
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityListTableViewCell.h"
#import "SActivityListModel.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "SMBNewActivityListModel.h"

@interface SActivityListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageViewLabel;

@end

@implementation SActivityListTableViewCell

- (void)awakeFromNib {
    _contentImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}
//NSString *UrlEncodedString(NSString *sourceText) {
//    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)sourceText ,NULL ,CFSTR("!*'();:@&=+$,/?%#[]") ,kCFStringEncodingUTF8));
//         return result;
//}
- (void)setContentModel:(SMBNewActivityListModel *)contentModel{
    _contentModel = contentModel;
    if (!contentModel.img){
        self.contentImageView.image = [UIImage imageNamed:@"pic_loading@3x.png"];
    }else{
       
        NSString *imgSt =[contentModel.img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
//       NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)imgSt ,NULL ,CFSTR("，,") ,kCFStringEncodingUTF8));//CFSTR("!*'();:@&=+$,/?%#[]
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:imgSt] placeholderImage:[UIImage imageNamed:@"pic_loading@3x.png"]];
//        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:imgSt]  isLoadThumbnail:NO placeholderImage:[UIImage imageNamed:@"pic_loading@3x.png"]];
        
    }
     self.contentDateLabel.text = [NSString stringWithFormat:@"结束时间：%@",contentModel.end_time];
//    self.contentDateLabel.text = [NSString stringWithFormat:@"结束时间：%@", [Utils getdate:contentModel.enD_TIME]];
//    self.pageViewLabel.text = [NSString stringWithFormat:@"%@人浏览", contentModel.dis_Amount];
}

@end
