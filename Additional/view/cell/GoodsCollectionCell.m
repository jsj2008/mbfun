//
//  GoodsCollectionCell.m
//  newdesigner
//
//  Created by Miaoz on 14-9-28.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "GoodsCollectionCell.h"
#import "Globle.h"
@implementation GoodsCollectionCell


-(void)setGoodObj:(GoodObj *)goodObj{
    _goodObj = goodObj;
//    if (_goodObj != nil ) {
//        NSString *imageurl =  [self changeStringWithurlString:goodObj.clsPicUrl.filE_PATH];
//        //缓存喜欢
//        [[TMCache sharedCache] objectForKey:[NSString stringWithFormat:@"%@%@",sns.ldap_uid,imageurl] block:^(TMCache *cache, NSString *key, id object) {
//            if ([object isEqualToString:imageurl]) {
//                [_likeButton setImage:[UIImage imageNamed:@"btn_like_pressed"] forState:UIControlStateNormal];
//            }
//            
//        }];
//
//    }
    
}
-(NSString *)changeStringWithurlString:(NSString *)imageurl{
    NSMutableString *mainurlString;
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:imageurl];
    NSRange range = [String1 rangeOfString:@"--"];
    
    int location = (int)range.location;
    int leight = (int)range.length;
    
    if (leight == 2) {////有--400x400
        mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
        [mainurlString appendString:[NSString stringWithFormat:@".png"]];
        
        
    }else{//没有--400x400 //有后缀.png
        NSRange range = [String1 rangeOfString:@".png"];
        
        int leight = (int)range.length;
        if (leight == 4){//有后缀.png
            
            mainurlString = [[NSMutableString alloc] initWithString:String1];
            
        }else{//没有后缀png
            
            //后缀jpg
            NSRange range2 = [String1 rangeOfString:@".jpg"];
            int location2 = (int)range2.location;
            int leight2 = (int)range2.length;
            if (leight2 == 4){//有后缀.jpg
                
                mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location2]];
                [mainurlString appendString:[NSString stringWithFormat:@".jpg"]];
            }else{//没有后缀
                
                mainurlString = [[NSMutableString alloc] initWithString:String1];
                [mainurlString appendString:[NSString stringWithFormat:@".png"]];
                
            }
            
            
        }
        
    }
    
    [mainurlString insertString:[NSString stringWithFormat:@"--%dx%d",(int)200,(int)200] atIndex:mainurlString.length -4];
    NSLog(@"mainurlString--------%@",mainurlString);
    return mainurlString;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GoodsCollectionCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        
        CGFloat borderWidth = 0.5f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
        self.layer.borderWidth = borderWidth;
        
        [_likeButton addTarget:self action:@selector(lickButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    return self;
}


-(void)lickButtonClickEvent:(UIButton *)sender{
   
    NSString *judgetype;//0代表删除喜欢 1代表喜欢
    if ([sender.imageView.image isEqual:[UIImage imageNamed:@"btn_like_pressed"]])
    {
        [sender setImage:[UIImage imageNamed:@"btn_like_normal"] forState:UIControlStateNormal];
         judgetype= [NSString stringWithFormat:@"0"];
//        NSString *imageurl =  [self changeStringWithurlString:_goodObj.clsPicUrl.filE_PATH];
//        [[TMCache sharedCache] removeObjectForKey:[NSString stringWithFormat:@"%@%@",sns.ldap_uid,imageurl]];
    }else
    {
        
    [sender setImage:[UIImage imageNamed:@"btn_like_pressed"] forState:UIControlStateNormal];
        judgetype= [NSString stringWithFormat:@"1"];
    
//        NSString *imageurl =  [self changeStringWithurlString:_goodObj.clsPicUrl.filE_PATH];
//        [[TMCache sharedCache] setObject:imageurl forKey:[NSString stringWithFormat:@"%@%@",sns.ldap_uid,imageurl] block:^(TMCache *cache, NSString *key, id object) {
//            
//        }];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackGoodsCollectionCellWithjudgeType:withGoodobj:)]) {
        [_delegate callBackGoodsCollectionCellWithjudgeType:judgetype withGoodobj:_goodObj];
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)drawRect:(CGRect)rect{
    
    


}
@end
