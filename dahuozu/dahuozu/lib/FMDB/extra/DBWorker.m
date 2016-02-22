//
//  DBWorker.m
//  数据操作类
//
//  Created by t on 15/5/8.
//  Copyright (c) 2015年 t. All rights reserved.
//

#import "DBWorker.h"

@implementation DBWorker
-(id)initWithDBName:(NSString *)dbname
{
    self = [super init];
    if (self) {
        self.threadLock = [[NSRecursiveLock alloc]init];
        [self setDBName:dbname];
    }
    return self;
}
-(id)initWithDBPath:(NSString *)dbPath
{
    self = [super init];
    if (self)
    {
        self.threadLock = [[NSRecursiveLock alloc]init];
        NSString *fileName = [dbPath lastPathComponent];
        if([self.dbname isEqualToString:fileName] == NO)
        {
            if([fileName hasSuffix:@".db"] == NO)
            {
                self.dbname = [NSString stringWithFormat:@"%@.db",fileName];
            }
            else
            {
                self.dbname = fileName;
            }
            [self.bindingQueue close];
            self.bindingQueue = [[FMDatabaseQueue alloc]initWithPath:dbPath];
        }
    }
    return self;
}
- (id)init
{
    return [self initWithDBName:@"DBWorker"];
}
-(void)setDBName:(NSString *)fileName
{
    if([self.dbname isEqualToString:fileName] == NO)
    {
        if([fileName hasSuffix:@".db"] == NO)
        {
            self.dbname = [NSString stringWithFormat:@"%@.db",fileName];
        }
        else
        {
            self.dbname = fileName;
        }
        [self.bindingQueue close];
        self.bindingQueue = [[FMDatabaseQueue alloc]initWithPath:[DBWorker getDirectoryForDocuments:@"DB" DBName:self.dbname]];
        
        MyDataLog(@"数据库位置：%@",self.bindingQueue.path);
        
#ifdef DEBUG
        //debug 模式下  打印错误日志
        [_bindingQueue inDatabase:^(FMDatabase *db) {
            db.logsErrors = YES;
        }];
#endif
    }
}
+(NSString *)getDirectoryForDocuments:(NSString *)dir DBName:(NSString*)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError* error;
    NSString* path = [documentsDirectory stringByAppendingPathComponent:dir];
    
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        NSLog(@"创建数据库文件夹: %@",error.debugDescription);
    }
    path = [path stringByAppendingPathComponent:filename];
    return path;
}

-(BOOL)executeSQL:(NSString *)sql arguments:(NSArray *)args
{
    __block BOOL execute = NO;
    [self executeDB:^(FMDatabase *db) {
        if(args.count>0)
            execute = [db executeUpdate:sql withArgumentsInArray:args];
        else
            execute = [db executeUpdate:sql];
    }];
    return execute;
}

#pragma mark- core
-(void)executeDB:(void (^)(FMDatabase *db))block
{
    [_threadLock lock];
    if(self.usingdb != nil)
    {
        block(self.usingdb);
    }
    else
    {
        [_bindingQueue inDatabase:^(FMDatabase *db) {
            self.usingdb = db;
            block(db);
            self.usingdb = nil;
        }];
    }
    [_threadLock unlock];
}

-(NSString *)executeScalarWithSQL:(NSString *)sql arguments:(NSArray *)args
{
    __block NSString* scalar = nil;
    [self executeDB:^(FMDatabase *db) {
        FMResultSet* set = nil;
        if(args.count>0)
            set = [db executeQuery:sql withArgumentsInArray:args];
        else
            set = [db executeQuery:sql];
        
        if([set columnCount]>0 && [set next])
        {
            scalar = [set stringForColumnIndex:0];
        }
        [set close];
    }];
    return scalar;
}
+(BOOL)checkStringIsEmpty:(NSString *)string
{
    if(string == nil)
    {
        return YES;
    }

    return [[[string description] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
}
//splice 'where' 拼接where语句
- (NSMutableArray *)extractQuery:(NSMutableString *)query where:(id)where
{
    NSMutableArray* values = nil;
    if([where isKindOfClass:[NSString class]] && [DBWorker checkStringIsEmpty:where]==NO)
    {
        [query appendFormat:@" where %@",where];
    }
    else if ([where isKindOfClass:[NSDictionary class]] && [where count] > 0)
    {
        NSString* wherekey = [self dictionaryToSqlWhere:where];
        [query appendFormat:@" where %@",wherekey];
    }
    return values;
}

//dic where parse
-(NSString*)dictionaryToSqlWhere:(NSDictionary*)dic
{
    NSMutableString* wherekey = [NSMutableString stringWithCapacity:0];
    if(dic != nil && dic.count >0 )
    {
        NSArray* keys = dic.allKeys;
        for (NSInteger i=0; i< keys.count;i++) {
        
            NSString* key = [keys objectAtIndex:i];
            
            id va = [dic objectForKey:key];
            if([va isKindOfClass:[NSArray class]])
            {
                NSArray* vlist = va;
                if(vlist.count==0)
                    continue;
                
                if(wherekey.length > 0)
                    [wherekey appendString:@" and"];
                
                [wherekey appendFormat:@" %@ in(",COLUME_NAME(key)];
                
                for (NSInteger j=0; j<vlist.count; j++) {
                    
                    [wherekey appendString:[NSString stringWithFormat:@"'%@'",[vlist objectAtIndex:j]]];
                    if(j== vlist.count-1)
                    {
                        [wherekey appendString:@")"];
                    }
                    else
                    {
                        [wherekey appendString:@","];
                    }
                    
                }
            }
            else
            {
                if(wherekey.length > 0)
                {
                    [wherekey appendFormat:@" and %@='%@'",COLUME_NAME(key),va];
                }
                else
                {
                    [wherekey appendFormat:@" %@='%@'",COLUME_NAME(key),va];
                }
                
            }
            
        }
    }
    return wherekey;
}
-(void)dropAllTable
{
    [self executeDB:^(FMDatabase *db) {
        FMResultSet* set = [db executeQuery:@"select name from sqlite_master where type='table'"];
        NSMutableArray* dropTables = [NSMutableArray arrayWithCapacity:0];
        while ([set next]) {
            [dropTables addObject:[set stringForColumnIndex:0]];
        }
        [set close];
        
        for (NSString* tableName in dropTables) {
            NSString* dropTable = [NSString stringWithFormat:@"drop table %@",tableName];
            [db executeUpdate:dropTable];
        }
    }];
}

-(BOOL)dropTableWithName:(NSString*)tableName
{
    NSString* dropTable = [NSString stringWithFormat:@"drop table %@",tableName];
    
    BOOL isDrop = [self executeSQL:dropTable arguments:nil];
    
    return isDrop;
}
-(int)rowCountBase:(NSString*)tableName where:(id)where
{
    NSMutableString* rowCountSql = [NSMutableString stringWithFormat:@"select count(rowid) from %@",tableName];
    
    NSMutableArray* valuesarray = [self extractQuery:rowCountSql where:where];
    int result = [[self executeScalarWithSQL:rowCountSql arguments:valuesarray] intValue];
    
    return result;
}
-(NSMutableArray *)searchBase:(NSString*)tableName where:(id)where orderBy:(NSString *)orderBy desc:(BOOL)desc offset:(int)offset count:(int)count
{
    NSMutableString* query = [NSMutableString stringWithFormat:@"select * from %@",tableName];
    NSMutableArray * values = [self extractQuery:query where:where];
    
    [self sqlString:query AddOder:orderBy desc:desc offset:offset count:count];

    __block NSMutableArray* results = nil;
    [self executeDB:^(FMDatabase *db) {
        FMResultSet* set = nil;
        if(values == nil)
            set = [db executeQuery:query];
        else
            set = [db executeQuery:query withArgumentsInArray:values];
        
        results = [self executeResult:set];
        
        [set close];
    }];
    return results;
}
-(void)sqlString:(NSMutableString*)sql AddOder:(NSString*)orderby desc:(BOOL)desc offset:(int)offset count:(int)count
{
    if([DBWorker checkStringIsEmpty:orderby] == NO)
    {
        if (desc)
        {
            [sql appendFormat:@" order by %@ desc",COLUME_NAME(orderby)];
        }
        else
        {
            [sql appendFormat:@" order by %@",COLUME_NAME(orderby)];
        }
    }
    [sql appendFormat:@" limit %d offset %d",count,offset];
}
-(void)search:(NSString*)tableName where:(id)where orderBy:(NSString *)orderBy offset:(int)offset count:(int)count callback:(void (^)(NSMutableArray *))block
{
    [self asyncBlock:^{
        NSMutableArray* array = [self searchBase:tableName where:where orderBy:orderBy offset:offset count:count];
        
        if(block != nil)
            block(array);
    }];
}
-(BOOL)deleteWithName:(NSString*)tableName where:(id)where
{
    NSMutableString* deleteSQL = [NSMutableString stringWithFormat:@"delete from %@",tableName];
    NSMutableArray* values = [self extractQuery:deleteSQL where:where];
    BOOL result = [self executeSQL:deleteSQL arguments:values];
    return result;
}
-(void)deleteWithName:(NSString*)tableName where:(id)where callback:(void (^)(BOOL result))block
{
    [self asyncBlock:^{
        BOOL isDeleted = [self deleteWithName:tableName where:where];
        if (block != nil) {
            block(isDeleted);
        }
    }];
}
-(NSMutableArray *)searchBase:(NSString*)tableName where:(id)where orderBy:(NSString *)orderBy offset:(int)offset count:(int)count
{
    NSMutableString* query = [NSMutableString stringWithFormat:@"select * from %@",tableName];
    NSMutableArray * values = [self extractQuery:query where:where];
    
    [self sqlString:query AddOder:orderBy offset:offset count:count];

    __block NSMutableArray* results = nil;
    [self executeDB:^(FMDatabase *db) {
        FMResultSet* set = nil;
        if(values == nil)
            set = [db executeQuery:query];
        else
            set = [db executeQuery:query withArgumentsInArray:values];
        
        results = [self executeResult:set];
        
        [set close];
    }];
    return results;
}
- (NSMutableArray *)executeResult:(FMResultSet *)set
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    int columeCount = [set columnCount];
    while ([set next])
    {
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        for (int i=0; i<columeCount; i++)
        {
            NSString* sqlName = INFOR_NAME([set columnNameForIndex:i]);
            NSString* sqlValue = [set stringForColumnIndex:i];
            [infoDic setValue:sqlValue forKey:sqlName];
        }
        [array addObject:infoDic];
    }
    return array;
}
-(void)sqlString:(NSMutableString*)sql AddOder:(NSString*)orderby offset:(int)offset count:(int)count
{
    if([DBWorker checkStringIsEmpty:orderby] == NO)
    {
        [sql appendFormat:@" order by %@",COLUME_NAME(orderby)];
    }
    [sql appendFormat:@" limit %d offset %d",count,offset];
}
-(void)asyncBlock:(void(^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block);
}
+(DBWorker *)defaultWorker
{
    static DBWorker* worker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        worker = [[DBWorker alloc]init];
    });
    return worker;
}
-(BOOL)createTableWithTableName:(NSString*)tableName columeNames:(NSArray*)names primaryKey:(NSString*)primaryKey
{
    
    NSMutableString* table_pars = [NSMutableString string];
    for (NSInteger i=0; i<names.count; i++)
    {
        if(i > 0)
        {
            [table_pars appendString:@","];
        }
        NSString *name = [names objectAtIndex:i];
        [table_pars appendFormat:@"'%@' %@",COLUME_NAME(name),@"text"];
        
        if(primaryKey && [[name description] isEqualToString:primaryKey])
        {
            [table_pars appendFormat:@" %@",@"PRIMARY KEY"];
        }
    }
    NSString* createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS [%@](%@)",tableName,table_pars];
    
    
    BOOL isCreated = [self executeSQL:createTableSQL arguments:nil];
    
    return isCreated;
}
+(void)clearTableData:(NSString*)tableName
{
    [[DBWorker defaultWorker] executeDB:^(FMDatabase *db)
    {
        NSString* delete = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        [db executeUpdate:delete];
    }];
}
-(NSMutableArray*)arrayColumeName:(NSString*)tableName
{
    NSMutableString* query = [NSMutableString stringWithFormat:@"select * from %@",tableName];
    
    [self sqlString:query AddOder:nil offset:0 count:1];
    
    __block NSMutableArray* results = nil;
    [self executeDB:^(FMDatabase *db)
     {
        FMResultSet* set = nil;
        set = [db executeQuery:query];
         results = [NSMutableArray arrayWithCapacity:0];
         int columeCount = [set columnCount];
         for (int i=0; i<columeCount; i++)
         {
             [results addObject:INFOR_NAME([set columnNameForIndex:i])];
         }
        [set close];
    }];
    return results;
}
-(void)insertBase:(NSDictionary*)infoDic DBName:(NSString*)tableName callback:(void (^)(BOOL))block
{
    [self asyncBlock:^{
        BOOL result = [self insertBase:infoDic DBName:tableName];
        if(block != nil)
        {
            block(result);
        }
    }];
}
-(BOOL)insertBase:(NSDictionary*)infoDic DBName:(NSString*)tableName
{
    //--
    NSMutableArray * dbPs = [self arrayColumeName:tableName];
    
    NSMutableString* insertKey = [NSMutableString stringWithCapacity:0];
    NSMutableString* insertValuesString = [NSMutableString stringWithCapacity:0];
    
    NSMutableArray* insertValues = [NSMutableArray arrayWithCapacity:dbPs.count];
    for (NSInteger i=0; i<dbPs.count; i++)
    {
        NSString *key = [dbPs objectAtIndex:i];
        if(i>0)
        {
            [insertKey appendString:@","];
            [insertValuesString appendString:@","];
        }
        
        [insertKey appendString:[NSString stringWithFormat:@"'%@'",COLUME_NAME(key)]];
        [insertValuesString appendString:@"?"];
        
        id value = [infoDic valueForKey:key];
        if ([DBWorker checkStringIsEmpty:value])
        {
            value = @"";
        }
        else if (![value isKindOfClass:[NSString class]])
        {
            if ([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSDictionary class]])
            {
                value = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:value options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
            }
            else
            {
                value = [value description];
            }
        }
        [insertValues addObject:value];
    }
    
    //拼接insertSQL 语句  采用 replace 插入
    NSString* insertSQL = [NSString stringWithFormat:@"replace into %@(%@) values(%@)",tableName,insertKey,insertValuesString];
    
    __block BOOL execute = NO;
    
    [self executeDB:^(FMDatabase *db)
    {
        execute = [db executeUpdate:insertSQL withArgumentsInArray:insertValues];
    }];

    return execute;
}
-(BOOL)updateToDBBase:(NSString *)tableName rowData:(NSDictionary*)infoDic where:(id)where
{
    NSMutableArray * dbPs = [self arrayColumeName:tableName];
    NSMutableString* updateKey = [NSMutableString string];
    for (NSInteger i=0; i<dbPs.count; i++)
    {
        
        NSString *key = [dbPs objectAtIndex:i];
        id value = [infoDic valueForKey:key];
        if ([DBWorker checkStringIsEmpty:value])
        {
            value = @"";
        }
        else if (![value isKindOfClass:[NSString class]])
        {
            if ([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSDictionary class]])
            {
                value = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:value options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
            }
            else
            {
                value = [value description];
            }
        }
        if(i>0)
        {
            [updateKey appendString:@","];
        }
        [updateKey appendFormat:@"%@='%@'",COLUME_NAME(key),value];
    }
    NSMutableString* updateSQL = [NSMutableString stringWithFormat:@"update %@ set %@ where",tableName,updateKey];
    
    //添加where 语句
    if([where isKindOfClass:[NSString class]] && [DBWorker checkStringIsEmpty:where]== NO)
    {
        [updateSQL appendString:where];
    }
    else if([where isKindOfClass:[NSDictionary class]] && [where count]>0)
    {
        NSString* sqlwhere = [self dictionaryToSqlWhere:where];
        [updateSQL appendString:sqlwhere];
    }
    
    BOOL execute = [self executeSQL:updateSQL arguments:nil];
    
    return execute;
}
-(void)updateToDBBase:(NSString *)tableName rowData:(NSDictionary*)infoDic where:(id)where callback:(void (^)(BOOL))block
{
    [self asyncBlock:^{
        BOOL result = [self updateToDBBase:tableName rowData:infoDic where:where];
        if(block != nil)
            block(result);
    }];
}
+ (NSMutableArray*)getPropertys:(Class)aclass
{
    NSMutableArray *pronames = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(aclass, &outCount);
    
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if([propertyName isEqualToString:@"rowid"])
        {
            continue;
        }
        [pronames addObject:propertyName];
    }
    free(properties);
    return pronames;
}
@end

@implementation NSArray (OutOfRange)

-(id)resultAtIndex:(NSUInteger)index
{
    if (index<[self count])
    {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end
