//
//  UUMessageCell.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageCell.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "UUAVAudioPlayer.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "UUImageAvatarBrowser.h"
#import "SUtilityTool.h"

@interface UUMessageCell ()<UUAVAudioPlayerDelegate>
{
    AVAudioPlayer *player;
    NSString *voiceURL;
    NSData *songData;
    
    UUAVAudioPlayer *audio;
    
    UIView *headImageBackView;
    BOOL contentVoiceIsPlaying;
    UIView *_coverView; //用来遮挡聊天框与三角形中间的线
}
@end

@implementation UUMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        headImageBackView = [[UIView alloc]init];
        headImageBackView.layer.cornerRadius = 22;
        headImageBackView.layer.masksToBounds = YES;
        headImageBackView.backgroundColor = [UIColor clearColor];//[[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 20;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [headImageBackView addSubview:self.btnHeadImage];
        
        // 3、创建头像下标
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = ChatTimeFont;
        [self.contentView addSubview:self.labelNum];
        
        // 4、创建内容
        self.btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
        
        //红外线感应监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
        contentVoiceIsPlaying = NO;

        _coverView = [UIView new];
    }
    return self;
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:self.messageFrame.message.strId];
    }
}


- (void)btnContentClick{
    //play audio
    if (self.messageFrame.message.type == UUMessageTypeVoice || self.messageFrame.message.type == UUMessageTypeVoiceUrl) {
        if(!contentVoiceIsPlaying){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
            contentVoiceIsPlaying = YES;
            audio = [UUAVAudioPlayer sharedInstance];
            audio.delegate = self;
            
            // 支持一下url
            if (voiceURL) {
                [audio playSongWithUrl:voiceURL];
            } else {
                [audio playSongWithData:songData];
            }
            
        }else{
            [self UUAVAudioPlayerDidFinishPlay];
        }
    }
    //show the picture
    else if (self.messageFrame.message.type == UUMessageTypePictureUrl)
    {
        if (self.btnContent.backImageView) {
            [UUImageAvatarBrowser showImage:self.btnContent.backImageView];
        }
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [[(UIViewController *)self.delegate view] endEditing:YES];
        }
    }
    // show text and gonna copy that
    else if (self.messageFrame.message.type == UUMessageTypeText)
    {
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)UUAVAudioPlayerBeiginLoadVoice
{
    [self.btnContent benginLoadVoice];
}
- (void)UUAVAudioPlayerBeiginPlay
{
    //开启红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [self.btnContent didLoadVoice];
}
- (void)UUAVAudioPlayerDidFinishPlay
{
    //关闭红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    contentVoiceIsPlaying = NO;
    [self.btnContent stopPlay];
    [[UUAVAudioPlayer sharedInstance]stopSound];
}

- (NSString *)getdate:(NSString *)datestr {
    NSString *dateString=nil;
    NSDate *date ;
    if (datestr.length>1 && [[datestr substringToIndex:1] isEqualToString:@"/"])
    {
        NSArray *arr=[datestr componentsSeparatedByString:@"/Date("];
        NSString *s=[arr lastObject];
        arr=[s componentsSeparatedByString:@")/"];
        
        s=arr[0];
        arr=[s componentsSeparatedByString:@"-"];
        s=arr[0];
        date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateString=[NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }
    return dateString;
}

//内容及Frame设置
- (void)setMessageFrame:(UUMessageFrame *)messageFrame{

    _messageFrame = messageFrame;
    UUMessage *message = messageFrame.message;
    
    // 1、设置时间
    self.labelTime.text = message.strTime;
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    headImageBackView.frame = messageFrame.iconF;
    self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
    [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal
                                          withURL:[NSURL URLWithString:message.strIcon]
                                 placeholderImage:[UIImage imageNamed:@"headImage.jpeg"]];
    
    // 3、设置下标
//    self.labelNum.text = message.strName;
    CGSize labelSize = [SUTIL getStrLenByFontStyle:message.strName fontStyle:ChatTimeFont];
    
    if (messageFrame.nameF.origin.x > 160) {
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - labelSize.width/2, messageFrame.nameF.origin.y + 3, labelSize.width, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 3, labelSize.width, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }

    // 4、设置内容
    
    //prepare for reuse
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;

    self.btnContent.frame = messageFrame.contentF;

    if (message.from == UUMessageFromMe) {
        self.btnContent.isMyMessage = YES;
        [self.btnContent setTitleColor:COLOR_C2 forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = FONT_t3;
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
    }else{
        self.btnContent.isMyMessage = NO;
        [self.btnContent setTitleColor:COLOR_C2 forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = FONT_t3;
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
    }
    
    self.btnContent.layer.cornerRadius = 4;
    [self.btnContent setNeedsDisplay];
    
    //背景气泡图
    UIImage *normal;
    if (message.from == UUMessageFromMe) {
        normal = [UIImage imageNamed:@"Unico/im_yellow"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
        self.btnContent.layer.borderWidth = .5;
        self.btnContent.layer.borderColor = [Utils HexColor:0xffc002 Alpha:1].CGColor;
        _coverView.frame = CGRectMake(self.btnContent.right - .5, headImageBackView.top + (headImageBackView.height - 12)/2, .5, 12);
        _coverView.backgroundColor = [Utils HexColor:0xfedc32 Alpha:1];
        [self.contentView addSubview:_coverView];
    }
    else{
        normal = [UIImage imageNamed:@"Unico/im_gray"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
        self.btnContent.layer.borderColor = [Utils HexColor:0xe2e2e2 Alpha:1].CGColor;
        _coverView.frame = CGRectMake(self.btnContent.left, headImageBackView.top + (headImageBackView.height - 12)/2, .5, 12);
        _coverView.backgroundColor = COLOR_C4;
        [self.contentView addSubview:_coverView];
    }
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];

    switch (message.type) {
        case UUMessageTypeText:
            [self.btnContent setTitle:message.strContent forState:UIControlStateNormal];
            
            if (message.from == UUMessageFromMe) {
                self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 15, 10);
            }else if (message.from == UUMessageFromOther) {
                self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 15, 10);
            }
            
            break;
        case UUMessageTypePicture:
        case UUMessageTypePictureUrl:
        {
            if (message.type == UUMessageTypePictureUrl) {
                [self.btnContent.backImageView sd_setImageWithURL:[NSURL URLWithString:message.pictureUrl] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            } else {
//                self.btnContent.backImageView.image = message.picture;
                
            }
            self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
            self.btnContent.backImageView.hidden = NO;
            
            [self makeMaskView:self.btnContent.backImageView withImage:normal];
        }
            break;
        case UUMessageTypeVoice:
        case UUMessageTypeVoiceUrl:
        {
            if (message.type == UUMessageTypeVoiceUrl) {
                songData = nil;
                voiceURL = message.voiceUrl;
            } else {
                voiceURL = nil;
                songData = message.voice;
            }
            self.btnContent.second.text = [NSString stringWithFormat:@"%@'语音",message.strVoiceTime];
            self.btnContent.voiceBackView.hidden = NO;
            
            
//            voiceURL = [NSString stringWithFormat:@"%@%@",RESOURCE_URL_HOST,message.strVoice];
        }
            break;
            
        default:
            break;
    }
    [self setNeedsDisplay];
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();

    if (self.messageFrame.message.from == UUMessageFromMe) {
        CGContextMoveToPoint(contextRef, self.btnContent.right - .5, headImageBackView.top + (headImageBackView.height - 12)/2);
        CGContextAddLineToPoint(contextRef, self.btnContent.right + 6, headImageBackView.top + headImageBackView.height/2);
        CGContextAddLineToPoint(contextRef, self.btnContent.right - .5, headImageBackView.top + (headImageBackView.height + 12)/2);

        [[Utils HexColor:0xffc002 Alpha:1] setStroke];
        [[Utils HexColor:0xfedc32 Alpha:1] setFill];
    }else {
        CGContextMoveToPoint(contextRef, self.btnContent.left + .5, headImageBackView.top + (headImageBackView.height - 12)/2);
        CGContextAddLineToPoint(contextRef, self.btnContent.left - 6, headImageBackView.top + headImageBackView.height/2);
        CGContextAddLineToPoint(contextRef, self.btnContent.left + .5, headImageBackView.top + (headImageBackView.height + 12)/2);

        [[Utils HexColor:0xe2e2e2 Alpha:1] setStroke];
        [COLOR_C4 setFill];
    }
    CGContextSetLineWidth(contextRef, .5);
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    CGContextAddLineToPoint(contextRef, self.btnContent.right + .5, headImageBackView.top + (headImageBackView.height - 12)/2);
    CGContextAddLineToPoint(contextRef, self.btnContent.right + .5, headImageBackView.top + (headImageBackView.height + 12)/2);
    if (self.messageFrame.message.from == UUMessageFromMe) {
        [[Utils HexColor:0xfedc32 Alpha:1] setStroke];
    }else {
        [COLOR_C4 setStroke];
    }
    
    CGContextSetLineWidth(contextRef, 1);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end



