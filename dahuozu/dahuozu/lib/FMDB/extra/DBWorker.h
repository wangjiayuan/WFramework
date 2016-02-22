//
//  DBWorker.h
//  数据操作类
//
//  Created by t on 15/5/8.
//  Copyright (c) 2015年 t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabase+InMemoryOnDiskIO.h"
#import "FMDatabaseQueue.h"
#import <objc/runtime.h>
#define DEFAULT_COLUME_HEAD (@"WJY_")
#define COLUME_NAME(key) ([key isEqualToString:@"rowid"]?key:[DEFAULT_COLUME_HEAD stringByAppendingString:key])
#define INFOR_NAME(key) ([key isEqualToString:@"rowid"]?key:[key substringFromIndex:DEFAULT_COLUME_HEAD.length])
@interface DBWorker : NSObject

@property(unsafe_unretained,nonatomic)FMDatabase* usingdb;
@property(strong,nonatomic)FMDatabaseQueue* bindingQueue;
@property(copy,nonatomic)NSString* dbname;
@property(strong,nonatomic)NSRecursiveLock* threadLock;

-(id)initWithDBName:(NSString*)dbname;

-(id)initWithDBPath:(NSString *)dbPath;

-(void)setDBName:(NSString*)fileName;

-(void)executeDB:(void (^)(FMDatabase *db))block;

-(BOOL)executeSQL:(NSString *)sql arguments:(NSArray *)args;

-(NSString *)executeScalarWithSQL:(NSString *)sql arguments:(NSArray *)args;


-(void)dropAllTable;

-(BOOL)dropTableWithName:(NSString*)tableName;

-(int)rowCountBase:(NSString*)tableName where:(id)where;
-(NSMutableArray *)searchBase:(NSString*)tableName where:(id)where orderBy:(NSString *)orderBy desc:(BOOL)desc offset:(int)offset count:(int)count;
-(void)search:(NSString*)tableName where:(id)where orderBy:(NSString *)orderBy offset:(int)offset count:(int)count callback:(void (^)(NSMutableArray *))block;
-(NSMutableArray *)searchBase:(NSString*)tableName where:(id)where orderBy:(NSString *)orderBy offset:(int)offset count:(int)count;

-(BOOL)insertBase:(NSDictionary*)infoDic DBName:(NSString*)tableName;
-(void)insertBase:(NSDictionary*)infoDic DBName:(NSString*)tableName callback:(void (^)(BOOL))block;
+(DBWorker *)defaultWorker;
+(void)clearTableData:(NSString*)tableName;
-(BOOL)createTableWithTableName:(NSString*)tableName columeNames:(NSArray*)names primaryKey:(NSString*)primaryKey;

-(void)deleteWithName:(NSString*)tableName where:(id)where callback:(void (^)(BOOL result))block;
-(BOOL)deleteWithName:(NSString*)tableName where:(id)where;

-(BOOL)updateToDBBase:(NSString *)tableName rowData:(NSDictionary*)infoDic where:(id)where;
-(void)updateToDBBase:(NSString *)tableName rowData:(NSDictionary*)infoDic where:(id)where callback:(void (^)(BOOL))block;
+ (NSMutableArray*)getPropertys:(Class)aclass;
@end

@interface NSArray (OutOfRange)

-(id)resultAtIndex:(NSUInteger)index;

@end
