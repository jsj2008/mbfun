//
//  FileListTableView.m
//  WAVtoAMRtoWAV
//
//  Created by Jeans Huang on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VoiceConverter.h"
#import "wav.h"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"
#import "AppSetting.h"

@implementation VoiceConverter

+ (int)amrToWav:(NSString *)fileNameString{
//    NSString * path = [[NSString alloc] initWithFormat:@"%@/%@",[AppSetting getRecvFilePath], fileNameString];
    
    NSString *savePath = [fileNameString stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
    
    if (! DecodeAMRFileToWAVEFile([fileNameString cStringUsingEncoding:NSASCIIStringEncoding], [savePath cStringUsingEncoding:NSASCIIStringEncoding]))
        return 0;

    return 1;
}

+ (int)wavToAmr:(NSString *)fileNameString{
    

//    NSString * path = [[NSString alloc] initWithFormat:@"%@/%@",[AppSetting getRecvFilePath], fileNameString];
    
    // WAVE音频采样频率是8khz 
    // 音频样本单元数 = 8000*0.02 = 160 (由采样频率决定)
    // 声道数 1 : 160
    //        2 : 160*2 = 320
    // bps决定样本(sample)大小
    // bps = 8 --> 8位 unsigned char
    //       16 --> 16位 unsigned short
    

        NSString *savePath = [fileNameString stringByReplacingOccurrencesOfString:@"wav" withString:@"amr"];
        
        if (EncodeWAVEFileToAMRFile([fileNameString cStringUsingEncoding:NSASCIIStringEncoding], [savePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 8))
            return 0;


    return 1;
}

//+ (int)pcmToWav:(NSString *)fileNameString
//{
//    WavWriter wav([fileNameString cStringUsingEncoding:NSASCIIStringEncoding], 44100, 16, 1);
//    wav.writeData(<#const unsigned char *data#>, <#int length#>);
//    return 1;
//}

@end
