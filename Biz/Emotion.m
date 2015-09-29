//
//  Emotion.m
//  Wefafa
//
//  Created by fafa  on 13-8-7.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "Emotion.h"

@implementation Emotion

+(void)initialize
{
    //pre load image
    for (NSString *s in self.emotionImageNames) {
        [UIImage imageNamed:s];
    }
}

static NSArray *g_emotionNames = nil;
+(NSArray*)emotionNames
{
    if (g_emotionNames == nil)
    {
        g_emotionNames = @[@"/hi",@"/bye",@"/wx",@"/hanx",@"/tx",@"/dx",@"/huaix",@"/zk",@"/yun",@"/lh",
                           @"/xu",@"/yw",@"/wq",@"/tp",@"/she",@"/qdl",@"/qq",@"/ng",@"/ll",@"/kun",
                           @"/keai",@"/kl",@"/jy",@"/jk",@"/hq",@"/fd",@"/haix",@"/gg",@"/dk",@"/chuh",
                           @"/deyi",@"/shanchu",@"/sa",@"/fn",@"/bs",@"/bz",@"/cool",@"/am",@"/by",@"/cah",@"/shui",
                           @"/ok",@"/no",@"/qiang",@"/ruo",@"/cj",@"/gz",@"/sl",@"/ws",@"/qt",@"/gy",
                           @"/yb",@"/bq",@"/bt",@"/jl",@"/qiaod",@"/zt",@"/tu",@"/lw",@"/fan",@"/je",@"/shanchu"];
    }
    
    return g_emotionNames;
}

static NSArray *g_emotionNameCNs = nil;
+(NSArray*)emotionNameCNs
{
    if (g_emotionNameCNs == nil)
    {
        g_emotionNameCNs = @[@"你好",@"再见",@"微笑",@"憨笑",@"偷笑",@"大笑",@"坏笑",@"抓狂",@"晕",@"冷汗",
                             @"嘘",@"疑问",@"委屈",@"调皮",@"色",@"糗大了",@"亲亲",@"难过",@"流泪",@"困",
                             @"可爱",@"可怜",@"惊讶",@"惊恐",@"呵欠",@"发呆",@"害羞",@"尴尬",@"大哭",@"出汗",
                             @"得意",@"删除",@"示爱",@"发怒",@"鄙视",@"闭嘴",@"酷",@"傲慢",@"白眼",@"擦汗",@"睡",
                             @"OK",@"NO",@"强",@"弱",@"差劲",@"鼓掌",@"胜利",@"握手",@"拳头",@"勾引",
                             @"拥抱",@"抱拳",@"拜托",@"敬礼",@"敲打",@"猪头",@"吐",@"礼物",@"饭",@"饥饿",@"删除"];
    }
    
    return g_emotionNameCNs;
}

static NSArray *g_emotionImageNames = nil;
+(NSArray*)emotionImageNames
{
    if (g_emotionImageNames == nil)
    {
        g_emotionImageNames = @[@"hi.png",@"bye.png",@"wx.png",@"hanx.png",@"tx.png",@"dx.png",@"huaix.png",@"zk.png",@"yun.png",@"lh.png",
                                @"xu.png",@"yw.png",@"wq.png",@"tp.png",@"she.png",@"qdl.png",@"qq.png",@"ng.png",@"ll.png",@"kun.png",
                                @"keai.png",@"kl.png",@"jy.png",@"jk.png",@"hq.png",@"fd.png",@"haix.png",@"gg.png",@"dk.png",@"chuh.png",
                                @"deyi.png",@"deleteEmotion.png",@"sa.png",@"fn.png",@"bs.png",@"bz.png",@"cool.png",@"am.png",@"by.png",@"cah.png",@"shui.png",
                                @"ok.png",@"no.png",@"qiang.png",@"ruo.png",@"cj.png",@"gz.png",@"sl.png",@"ws.png",@"qt.png",@"gy.png",
                                @"yb.png",@"bq.png",@"bt.png",@"jl.png",@"qiaod.png",@"zt.png",@"tu.png",@"lw.png",@"fan.png",@"je.png",@"deleteEmotion.png"];
    }
    
    return g_emotionImageNames;
}

+(UIImage*)imageWithName:(NSString*)name
{
    NSUInteger index = [[self emotionNames] indexOfObject:name];
    
    if (index == NSNotFound)return nil;
    
    return [UIImage imageNamed:[self emotionImageNames][index]];
}

+(NSString *)getRegularEmotionAndMediaString
{
    NSMutableString *regularstr=[[NSMutableString alloc] initWithFormat:@"("];
    NSArray *emotionstr = [self emotionNames];
    int i;
    for(i=0;i<[emotionstr count];i++)
    {
        [regularstr appendString:[emotionstr objectAtIndex:i]];
        [regularstr appendString:@"|"];
    }
    //filetransfer
    [regularstr appendString:@"(\\{[\\[\\(]([a-zA-Z0-9]{32}\\.[a-zA-Z0-9]{3,5})[\\]\\)]\\})"];

    [regularstr appendString:@")"];

    return regularstr;
}

+(NSString *)getEmotionNameCNByStr:(NSString *)emotionstr
{
    NSString *rst=nil;
    NSArray *emotionString = [self emotionNames];
    int i=0;
    for(i=0;i<[emotionString count];i++)
    {
        NSString *str=[emotionString objectAtIndex:i];
        if ([str isEqualToString:emotionstr])
        {
            rst=[[NSString alloc] initWithFormat:@"%@",[[self emotionNameCNs] objectAtIndex:i]];
            break;
        }
    }
    if (rst==nil)
        rst=[[NSString alloc] initWithFormat:@""];
    return rst;
}

+(NSString *)replaceFaceImage:(NSString *)content ImageWidth:(int)faceImageWidth
{
    NSRegularExpression *psupperlink = [NSRegularExpression regularExpressionWithPattern:
                                        @"<img\\s.*?alt\\s*=\\s*\'?\"?([^(\\s\")]+)\\s*\'?\"?"
                                        "\\s.*?style\\s*=\\s*\'?\"?\\s*height:\\s.*?([0-9]{1,3})px;\\s*width:\\s.*?([0-9]{1,3})px;\\s*'\\s.*?"
                                        "src='/bundles/fafatimewebase/images/face/([^(\\s\")]+).(gif|png)'>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *message=[NSString stringWithFormat:@"%@",content];
    
    
    NSString *temp=[NSString stringWithFormat:@"<img alt='' style='height: %dpx; width: %dpx;' src='$4.png'>",faceImageWidth,faceImageWidth];
    
    NSString *replaceStr = [psupperlink stringByReplacingMatchesInString:message
                                                                 options:0
                                                                   range:NSMakeRange(0, [message length])
                                                            withTemplate:temp];
    
    //    NSLog(@">>>>>replaceFaceImage psupperlink result=[%@]",replaceStr);
    
    return replaceStr;
}

+(NSString *)getRegularEmotionString:(NSArray *)emotionstr
{
    NSMutableString *regularstr=[[NSMutableString alloc] initWithFormat:@"("];
    int i;
    for(i=0;i<[emotionstr count];i++)
    {
        if (i>0)
            [regularstr appendString:@"|"];
        [regularstr appendFormat:@"\\[%@\\]",[emotionstr objectAtIndex:i]];
    }
    
    [regularstr appendString:@")"];
    
    return regularstr;
}

+(NSString *)getEmotionImageNameByNameCN:(NSString *)namecn
{
    NSString *rst=nil;
    int i=0;
    for(i=0;i<[g_emotionNameCNs count];i++)
    {
        NSString *str=[g_emotionNameCNs objectAtIndex:i];
        if ([str isEqualToString:namecn])
        {
            rst=[[NSString alloc] initWithFormat:@"%@",[g_emotionImageNames objectAtIndex:i]];
            break;
        }
    }
    if (rst==nil)
        rst=[[NSString alloc] initWithFormat:@""];
    return rst;
}

+(NSString *)replaceFaceString:(NSString *)message ImageWidth:(int)faceImageWidth
{
    NSString *resultString=[[NSString alloc] initWithFormat:@""];
    NSString * reg=[Emotion getRegularEmotionString:g_emotionNameCNs];
    
    NSRange r= [message rangeOfString:reg options:NSRegularExpressionSearch];
    //是否有表情
    if (r.length != NSNotFound &&r.length != 0)
    {
        int lastlocation=0;
        
        do {
            //            NSString* substr = [message substringWithRange:r];
            
            ///////////////////////////////////////////
            //type:(image,image_ft_pic,text)
            if (lastlocation!=r.location)
            {
                //文字
                NSString *firstText=[message substringWithRange:NSMakeRange(lastlocation, r.location-lastlocation)];
                resultString=[resultString stringByAppendingString:firstText];
            }
            
            if (r.length>0)
            {
                //图片,（去掉中括号）
                NSString *expressText=[message substringWithRange:NSMakeRange(r.location+1, r.length-2)];
                
                resultString=[resultString stringByAppendingFormat:@"<img alt='' style='height: %dpx; width: %dpx;' src='%@'>",faceImageWidth,faceImageWidth, [Emotion getEmotionImageNameByNameCN:expressText]];
            }
            
            ///////////////////////////////////////
            //剩余部分
            lastlocation=(int)r.location+(int)r.length;
            NSRange startr=NSMakeRange(r.location+r.length, [message length]-r.location-r.length);
            //检查剩余部分是否为空
            NSString *nextstr=[message substringWithRange:startr];
            if ([nextstr isEqualToString:@""]) {
                break;
            }
            
            //匹配
            r=[message rangeOfString:reg options:NSRegularExpressionSearch range:startr];
            
            //是否最后一行文本
            if (r.length == 0 )
            {
                //文字
                NSString *firstText=[message substringWithRange:startr];
                resultString=[resultString stringByAppendingString:firstText];
            }
        }while (r.length != NSNotFound &&r.length != 0);
    } else if (message != nil) {
        //文字
        resultString=[[NSString alloc] initWithFormat:@"%@",message];
    }
    return resultString;
}

@end
