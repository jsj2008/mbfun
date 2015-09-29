//
//  NSMutableQueue.h
//  FaFa
//
//  Created by fafa  on 13-5-25.
//
//

#import <Foundation/Foundation.h>

/**
 *  队列，线程安全类
 */
@interface NSMutableQueue : NSObject
{
    NSLock *_ReadWriteLock;
}

//存储队列数据的数组，一般情况下不要直接使用，非线程安全
@property(strong, nonatomic, readonly) NSMutableArray *data;

-(NSUInteger)count;
-(void)Enqueue:(id)item;
-(id)Dequeue;

@end
