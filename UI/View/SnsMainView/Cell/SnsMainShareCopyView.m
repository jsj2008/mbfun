//
//  SnsMainShareCopyView.m
//  Wefafa
//
//  Created by mw on 15-1-12.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SnsMainShareCopyView.h"
#import "AppDelegate.h"
#import "XMPPRosterSqliteStorage.h"
#import "Utils.h"
#import "WeFaFaGet.h"
#import "AppSetting.h"
#import "ImageDisplayViewController.h"
#import "QuartzCore/QuartzCore.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "Toast.h"
#import "JSONKit.h"
#import "SnsMessageCell.h"
#import "SnsMainMessageCell.h"
#import "RichTextHtml.h"
#import "SNSDataClass.h"
#import "utils.h"
#import "SnsMessage.h"
#import "SNSDataClass.h"
@implementation SnsMainShareCopyView

- (void)configView:(SnsMainMessage*)message
{
    self.message=message;
    CALayer *sublayer = [self layer];
    sublayer.masksToBounds = YES;
    //    sublayer.backgroundColor = [UIColor blueColor].CGColor;
    //    sublayer.shadowOffset = CGSizeMake(0, 2);
    //    sublayer.shadowRadius =6.0;
    //    sublayer.shadowOpacity = 0.7;
    sublayer.cornerRadius = 4;
    
    [self createHeadImage];
    
    if (richTextLabel==nil)
    {
        richTextLabel = [[RichTextLabelHtml alloc] init];
        richTextLabel.textColor=SNS_CONTENT_TEXTCOLOR;
        [richTextLabel.onClick addListener:[CommonEventListener listenerWithTarget:self withSEL:@selector(richTextLabel_OnClick:eventData:)]];
        [self addSubview:richTextLabel];
    }
    
    [self createNameAndTime];
    
    [self createBottomView];
    
    SnsMainMessage *msg = message;
    SNSConvCopy *conv=msg.conv.conv_copy;
    lbName.text=[NSString stringWithFormat:@"%@", conv.create_staff_obj.nick_name];
    lbTime.text=[NSString stringWithFormat:@"%@", [SnsMessage FormatDateTime:conv.post_date FormatType:FORMAT_DATE_TYPE_MDHN_CHN]];
    
    XMPPRosterSqliteStorage *xmppRosterSqliteStorageX = [[AppDelegate xmppConnectDelegate] xmppRosterStorage];
    XMPPUserSqliteStorageObject *userx = [xmppRosterSqliteStorageX userForEmailStr:conv.create_staff_obj.login_account];
    [imgHead setImage:userx.photo];
    
    richTextLabel.richtext = msg.richTextCopy;
    [self setRichTextFrame];
    
    int attachHeight=[SnsMainCopyView attachHeight:msg];
    int bottom_y=richTextLabel.frame.origin.y+richTextLabel.frame.size.height+SNSMAINCELL_MARGIN_WIDTH;
    ParentViewName=@"SnsMainCopyView";
    LeftMargin=SNSMAINCELL_MARGIN_WIDTH+imgHead.frame.size.width+SNSMAINCELL_MARGIN_WIDTH+SNSMAINCELL_MARGIN_WIDTH;
    [self drawBottomViews:bottom_y AttachHeight:attachHeight+_showImageView.frame.size.height AttachLeftMargin:0];
    
    if([[[((SNSConv *)msg.snsData).conv_copy.conv_content objectFromJSONString] allKeys]containsObject:@"shareContent"])
    {
        NSDictionary * dict=[((SNSConv *)msg.snsData).conv_copy.conv_content objectFromJSONString];
        if(!_showImageView)
        {
            _showImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            _showImageView.frame=CGRectMake(lbName.frame.origin.x,bottom_y, SNS_IMAGE_MAX_SIZE, SNS_IMAGE_MAX_SIZE);
            _showImageView.backgroundColor=[UIColor whiteColor];//SNS_BACKGROUND_SILVERCOLOR;
            [_showImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            _showImageView.contentMode =  UIViewContentModeScaleAspectFill;
            _showImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            _showImageView.clipsToBounds  = YES;
            _showImageView.userInteractionEnabled = YES;  //必须为YES才能响应事件
            [self addSubview:_showImageView];
            
        }
        NSString *filepath = [NSString stringWithFormat:@"%@/%@", [AppSetting getSNSAttachFilePath],[[[[dict[@"image"] componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."] firstObject]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]==YES)
        {
            _showImageView.image = [[UIImage alloc] initWithContentsOfFile:filepath];
        }
        else
        {
            //缓存图片数据
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data=[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"image"]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _showImageView.image=[UIImage imageWithData:data];
                    if (data!=nil)
                    {
                        [data writeToFile: filepath atomically: NO];
                    }
                });
            });
        }

    }
    
}
-(void)setRichTextFrame
{
    [richTextLabel sizeToFit:SNSMAINCELL_COPY_TEXT_WIDTH withMinSize:CGSizeMake(SNSMAINCELL_COPY_TEXT_WIDTH, contentFontSize)];
    richTextLabel.frame = CGRectMake(lbName.frame.origin.x,
                                     lbName.frame.origin.y+lbName.frame.size.height+SNSMAINCELL_MARGIN_WIDTH,
                                     richTextLabel.bounds.size.width,
                                     richTextLabel.bounds.size.height);
}
@end
