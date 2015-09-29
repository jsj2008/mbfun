//
//  DBInitSql.h
//  FaFa
//
//  Created by fafa  on 13-5-12.
//
//

#import <Foundation/Foundation.h>

@interface DBInitSql : NSObject

//取得各版本数据库初始化脚本[verX, [sqlstr, sqlstr, ...], verX, [sqlstr, sqlstr, ...], ...]
+(NSArray*)getInitSql;

@end
