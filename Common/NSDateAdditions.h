//
//  NSDateAdditions.h
//  FaFa
//
//  Created by fafa  on 13-5-14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDateAdditions)

-(NSString*)toDateTimeString;
-(NSString*)toString:(NSString*)format;

+(NSDate*)parse:(NSString*)datestr;
+(NSDate*)parse:(NSString*)datestr defaultvalue:(id)defaultvalue;
+(NSDate*)parse:(NSString*)datestr format:(NSString*)format;
+(NSDate*)parse:(NSString*)datestr format:(NSString*)format defaultvalue:(id)defaultvalue;

@end
