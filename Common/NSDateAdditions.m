//
//  NSDateAdditions.m
//  FaFa
//
//  Created by fafa  on 13-5-14.
//
//

#import "NSDateAdditions.h"

@implementation NSDate (NSDateAdditions)

-(NSString*)toDateTimeString
{
    return [self toString:@"yyyy-MM-dd HH:mm:ss"];
}

-(NSString*)toString:(NSString*)format
{
    NSString *re;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:format];
    re = [dateFormatter stringFromDate:self];
    OBJC_RELEASE(dateFormatter);
    
    return re;
}

+(NSDate*)parse:(NSString*)datestr
{
    return [self parse:datestr defaultvalue:nil];
}

+(NSDate*)parse:(NSString*)datestr defaultvalue:(id)defaultvalue
{
    return [self parse:datestr format:@"yyyy-MM-dd HH:mm:ss" defaultvalue:defaultvalue];
}

+(NSDate*)parse:(NSString*)datestr format:(NSString*)format
{
    return [self parse:datestr format:format defaultvalue:nil];
}

+(NSDate*)parse:(NSString*)datestr format:(NSString*)format defaultvalue:(id)defaultvalue
{
    NSDate *re=nil;
    
    if (datestr!=nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
        [dateFormatter setDateFormat:format];
        re = [dateFormatter dateFromString:datestr];
        OBJC_RELEASE(dateFormatter);
    }
    return re == nil ? defaultvalue : re;
}

@end
