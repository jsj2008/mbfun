//
//  NetManager.h

#import <Foundation/Foundation.h>
#define DomainUrl @"http://10.100.20.51:8086//handler/billappointment_handler.ashx"  //试衣间测试用

@interface NetManager : NSObject

@property(nonatomic,assign)BOOL progress;

+ (NetManager *)sharedManager;
- (void)postRequestWithUrlString:(NSString*)urlString
                    postParamDic:(NSDictionary*)postParamDic
                         success:(void (^)(id responseDic))success
                         failure:(void(^)(id errorString))failure;
- (void)sendRequestWithUrlString :(NSString*)urlString
                          success:(void (^)(id responseDic))success
                          failure:(void(^)(id errorString))failure;
@end
