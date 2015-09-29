//
//  WideGuideCollectionViewCell.m
//  Wefafa
//
//  Created by HuTailong on 15/2/9.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "WideGuideCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppSetting.h"
#import "Utils.h"
@implementation WideGuideCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.levelLabel.layer.cornerRadius = 5;
    self.levelLabel.clipsToBounds = YES;
    self.selectBtn.layer.cornerRadius = 5;
    self.selectBtn.clipsToBounds = YES;
    self.headerImg.layer.cornerRadius = 30;
    self.headerImg.clipsToBounds = YES;
}
-(void)makeCell:(NSDictionary *)dic{
//    [self.headerImg setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"headPortrait"]]];
    
    NSString *filepath = [NSString stringWithFormat:@"%@/%@",[AppSetting getSNSHeadImgFilePath],[Utils fileNameHash:[dic objectForKey:@"headPortrait"]]];
    NSLog(@"%@",[dic objectForKey:@"headPortrait"]);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]==YES)
    {
        self.headerImg.image = [UIImage imageWithContentsOfFile:filepath];
    }
    else
    {
       
        if (download_lock == nil) {
            download_lock=[[NSCondition alloc] init];
        }
        
        UIImage *img1= [Utils getImageAsyn:[dic objectForKey:@"headPortrait"] path:[AppSetting getSNSHeadImgFilePath] downloadLock:download_lock ImageCallback:^(UIImage * image,NSObject *recv_img_id){
            NSString *r_id=(NSString *)recv_img_id;
            if ([r_id isEqualToString:[Utils fileNameHash:[dic objectForKey:@"headPortrait"]]])
            {
                //                _headImgView.contentMode=UIViewContentModeScaleAspectFit;
                self.headerImg.image=image;
                
            }
        } ErrorCallback:^{
            
            self.headerImg.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
        }];
         if (img1!=nil) self.headerImg.image=img1;
    }
    
 
    self.nameLabel.text = [dic objectForKey:@"nickName"];
    
    if ([dic objectForKey:@"concernedCount"] && [[dic objectForKey:@"concernedCount"] integerValue] > 0 && ![[dic objectForKey:@"concernedCount"] isKindOfClass:[NSNull class]]) {
        self.concernedLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"concernedCount"]];
    }else {
        self.concernedLabel.text = @"0";
    }
    

    if ([dic objectForKey:@"collocationCount"] && [[dic objectForKey:@"collocationCount"] integerValue] > 0 && ![[dic objectForKey:@"collocationCount"] isKindOfClass:[NSNull class]]) {
        self.collocationLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"collocationCount"]];
    }else {
        self.collocationLabel.text = @"0";
    }
    
    self.levelLabel.text = [NSString stringWithFormat:@"V%@",[dic objectForKey:@"userLevel"]];
}
@end
