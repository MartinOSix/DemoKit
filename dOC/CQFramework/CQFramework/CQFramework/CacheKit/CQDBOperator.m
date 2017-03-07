//
//  CQDBOperator.m
//  CQFramework
//
//  Created by runo on 17/2/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "CQDBOperator.h"
#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "CQConstantDefine.h"

#import <objc/runtime.h>

@interface CQDBOperator ()

@property(nonatomic,strong) FMDatabase *fmDataBase;
@property(nonatomic,strong) NSMutableSet *registerClasss;

@end

@implementation CQDBOperator
static CQDBOperator *instance;//单例的实例对象

/**应该是屏蔽copy方法*/
- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}

+(id)cqShareDMOperation{
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        
        //判断数据库版本
        if (ktCurrentDBVersion != [self LocalDBVersion]) {
            [self deleteDBFile];
            [self setLocalDBVersion];
        }
        instance = [[self alloc]init];
        instance.fmDataBase = [[FMDatabase alloc]initWithPath:[self getDBFilePath]];
        instance.registerClasss = [NSMutableSet set];
    });
    return instance;
}

#pragma mark - 配置方法

-(BOOL)cqRegisterClass:(Class<CQDBOperatorSettingInterface> )modelClass{
    
    NSString *className = NSStringFromClass(modelClass);
    //2.判断表是否存在
    BOOL tableExist = [self isTableExist:className];
    if (tableExist == YES) {
        //如果表的版本也一致，那么直接返回true
        if([CQDBOperator checkTableVersion:modelClass]){
            [self.registerClasss addObject:NSStringFromClass(modelClass)];
            return YES;
        }else{
            //删表
            [self deleteTableWithTableName:className];
        }
    }
    //建表,还要保存表的版本号
    if([self CreateTableWithClass:modelClass]){
        [self.registerClasss addObject:NSStringFromClass(modelClass)];
        return [CQDBOperator setTableVersion:modelClass];
    }
    return NO;
}

#pragma mark - SQL操作

#pragma mark 增
-(void)cqSaveAllModel:(NSArray<CQDBOperatorSettingInterface> *)arr{
    
    for (id model in arr) {
        
        Class modelClass = object_getClass(model);
        NSString *className = NSStringFromClass(modelClass);
        if (![self.registerClasss containsObject:className]) {
            [NSException raise:@"DBOperator" format:@"class %@ not register",className];
            return;
        }
        NSString *replaceSQL = [CQDBOperator getReplaceSQL:model];
        [self.fmDataBase open];
        NSError *error = nil;
        NSMutableArray *values = [[NSMutableArray alloc]init];
        NSDictionary *propertyDic = [CQDBOperator cqGetPropertysBy:modelClass];
        NSArray *propers = propertyDic[@"name"];
        NSArray *types = propertyDic[@"type"];
        
        for (int i = 0; i < propers.count; i++) {
            if ([CQDBOperator cqPropertyIsNull:model property:propers[i]]) {
                continue;
            }
            if (![types[i] isEqualToString:SQLType_blob]) {
                [values addObject:[model valueForKey:propers[i]]];
            }else{
                id value = [model valueForKey:propers[i]];
                NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:value];
                [values addObject:valueData];
            }
        }
        BOOL ret = [self.fmDataBase executeUpdate:replaceSQL values:values error:&error];
        if (!ret) {
            NSLog(@"第 %ld 个模型保存失败",(unsigned long)[arr indexOfObject:model]);
            if (error != nil) {
                NSLog(@"error : %@",error);
            }
        }else{
            //                NSLog(@"成功保存模型 %@",kTableName);
        }
        [self.fmDataBase close];
    }
    return;
}


#pragma mark 删
-(BOOL)cqDeleteAllModel:(Class<CQDBOperatorSettingInterface>)modelClass{
    
    NSString *classNme = NSStringFromClass(modelClass);
    if (![self.registerClasss containsObject:classNme]) {
        [NSException raise:@"DBOperator" format:@"class %@ not register",classNme];
        return NO;
    }
    BOOL ret = false;
    [self.fmDataBase open];
    classNme = [CQDBOperator checkKeyWord:classNme];
    NSString *sql = [NSString stringWithFormat:@"delete from %@",classNme];
    ret = [self.fmDataBase executeUpdate:sql];
    [self.fmDataBase close];
    return ret;
    
}

-(BOOL)cqDeleteModelWhere:(NSDictionary *)dic AtClass:(Class<CQDBOperatorSettingInterface>)modelClass{
    
    BOOL ret = false;
    [self.fmDataBase open];
    NSString *className = NSStringFromClass(modelClass);
    if (![self.registerClasss containsObject:className]) {
        [NSException raise:@"DBOperator" format:@"class %@ not register",className];
        return NO;
    }
    className = [CQDBOperator checkKeyWord:className];
    NSMutableString *mstr = [NSMutableString stringWithFormat:@"delete from %@ ",className];
    NSArray *keys = [dic allKeys];
    NSMutableArray *values = [[NSMutableArray alloc]init];
    for (int i = 0; i < keys.count; i++) {
        
        NSString *key = keys[i];
        key = [CQDBOperator checkKeyWord:key];
        if (i == 0) {
            [mstr appendString:@"where "];
        }
        
        if (i != keys.count-1) {
            [mstr appendFormat:@"%@ = ? and",key];
        }else{
            [mstr appendFormat:@"%@ = ?",key];
        }
        [values addObject:[dic valueForKey:keys[i]]];
    }
    NSError *error = nil;
    ret = [self.fmDataBase executeUpdate:mstr values:values error:&error];
    if (!ret && error != nil) {
        kDebugLog(ktDBDebugFlag, @"delete error :%@",error);
    }
    // NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = ",kTableName,key];
    // ret = [self.fmdatabase executeUpdate:sql,[dic valueForKey:key]];
    [self.fmDataBase close];
    return ret;
}

#pragma mark - 查
/** 查  获取数据库中所有模型*/
-(NSArray *)cqGetAllModel:(Class<CQDBOperatorSettingInterface>)modelClass{
    
    NSString *className = NSStringFromClass(modelClass);
    if (![self.registerClasss containsObject:className]) {
        [NSException raise:@"DBOperator" format:@"class %@ not register",className];
        return nil;
    }
    className = [CQDBOperator checkKeyWord:className];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",className];
    [self.fmDataBase open];
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    
    FMResultSet *resultSet = [self.fmDataBase executeQuery:sql];
    while ([resultSet next]) {
        
        id model = [[(Class)modelClass alloc]init];
        NSDictionary *propertyDic = [CQDBOperator cqGetPropertysBy:modelClass];
        NSArray *propers = propertyDic[@"name"];
        NSArray *types = propertyDic[@"type"];
        for (int i = 0; i < propers.count; i++) {
            
            NSString *tmpType = types[i];
            NSString *tmpProper = propers[i];
            
            if ([tmpType isEqualToString:SQLType_text]) {
                
                NSString *value = [resultSet stringForColumn:tmpProper];
                [model setValue:value forKey:tmpProper];
            }else if ([tmpType isEqualToString:SQLType_blob]){
                
                NSData *data = [resultSet dataForColumn:tmpProper];
                if (data != nil){
                    id value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [model setValue:value forKey:tmpProper];
                }
                
            }else if ([tmpType isEqualToString:SQLType_double]
                      ||[tmpType isEqualToString:SQLType_float]){
                
                double dou = [resultSet doubleForColumn:tmpProper];
                [model setValue:@(dou) forKey:tmpProper];
            }else if ([tmpType isEqualToString:SQLType_int]){
                
                NSInteger intData = [resultSet longForColumn:tmpProper];
                [model setValue:@(intData) forKey:tmpProper];
            }else{
                NSLog(@"error type %@",tmpType);
            }
        }
        [marr addObject:model];
    }
    [self.fmDataBase close];
    return marr;
}
/** 查  获取某一组指定模型*/
-(NSArray *)cqGetModelWhere:(NSDictionary *)dic AtClass:(Class<CQDBOperatorSettingInterface>)modelClass{
    //select * from TableName where  key = value
    NSString *className = NSStringFromClass(modelClass);
    if (![self.registerClasss containsObject:className]) {
        [NSException raise:@"DBOperator" format:@"class %@ not register",className];
        return nil;
    }
    className = [CQDBOperator checkKeyWord:className];
    
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    NSMutableString *msql = [NSMutableString stringWithFormat:@"select * from %@ ",modelClass];
    NSArray *keys = [dic allKeys];
    NSMutableArray *values = [[NSMutableArray alloc]init];
    for (int i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        key = [CQDBOperator checkKeyWord:key];
        if (i == 0) {
            [msql appendString:@"where "];
        }
        
        if (i != keys.count-1) {
            [msql appendFormat:@"%@ = ? and",key];
        }else{
            [msql appendFormat:@"%@ = ?",key];
        }
        [values addObject:[dic valueForKey:keys[i]]];
    }
    [self.fmDataBase open];
    NSError *error = nil;
    FMResultSet *resultSet = [self.fmDataBase executeQuery:msql values:values error:&error];
    if (error != nil) {
        kDebugLog(ktDBDebugFlag, @"condition query error :%@",error);
        [self.fmDataBase close];
        return marr;
    }
    
    while ([resultSet next]) {
        
        id model = [[(Class)modelClass alloc]init];
        NSDictionary *propertyDic = [CQDBOperator cqGetPropertysBy:modelClass];
        NSArray *propers = propertyDic[@"name"];
        NSArray *types = propertyDic[@"type"];
        for (int i = 0; i < propers.count; i++) {
            
            NSString *tmpType = types[i];
            NSString *tmpProper = propers[i];
            
            if ([tmpType isEqualToString:SQLType_text]) {
                
                NSString *value = [resultSet stringForColumn:tmpProper];
                [model setValue:value forKey:tmpProper];
            }else if ([tmpType isEqualToString:SQLType_blob]){
                
                NSData *data = [resultSet dataForColumn:tmpProper];
                if (data != nil){
                    id value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [model setValue:value forKey:tmpProper];
                }
                
            }else if ([tmpType isEqualToString:SQLType_double]
                      ||[tmpType isEqualToString:SQLType_float]){
                
                double dou = [resultSet doubleForColumn:tmpProper];
                [model setValue:@(dou) forKey:tmpProper];
            }else if ([tmpType isEqualToString:SQLType_int]){
                
                NSInteger intData = [resultSet longForColumn:tmpProper];
                [model setValue:@(intData) forKey:tmpProper];
            }else{
                kDebugLog(ktDBDebugFlag, @"error type %@",tmpType);
            }
        }
        [marr addObject:model];
    }
    [self.fmDataBase close];
    return marr;
    
}

#pragma mark - 建表
-(BOOL)CreateTableWithClass:(Class<CQDBOperatorSettingInterface>)modelClass{
    
    //建表
    NSDictionary *ditc = [CQDBOperator cqGetPropertysBy:modelClass];
    NSString *createSQL = [CQDBOperator cqCreateTableSQL:ditc TableName:modelClass];
    kDebugLog(ktDBDebugFlag, @"create sql :%@",createSQL);
    [self.fmDataBase open];
    BOOL ret = [self.fmDataBase executeUpdate:createSQL];
    if (!ret) {
        kDebugLog(ktDBDebugFlag, @"创建数据库失败");
    }
    [self.fmDataBase close];
    return ret;
}

#pragma mark - SQL语句
/**获得建表语句*/
+(NSString *)cqCreateTableSQL:(NSDictionary *)dic TableName:(Class<CQDBOperatorSettingInterface>)modelClass{
    
    NSString *className = [CQDBOperator checkKeyWord:NSStringFromClass(modelClass)];
    NSMutableString *msql = [[NSMutableString alloc]init];
    [msql appendString:[NSString stringWithFormat:@"create table if not exists %@ (",className]];
    NSArray *propers = dic[@"name"];
    NSArray *types = dic[@"type"];
    NSMutableArray *primaryKeys = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < propers.count; i++) {
        NSString *proper = propers[i];
        proper = [CQDBOperator checkKeyWord:proper];
        
        //添加列名和属性
        [msql appendFormat:@"%@ %@",proper,types[i]];
        
        //判断是否是主键
        BOOL primaryIMP = class_respondsToSelector(object_getClass(modelClass), @selector(cqIsPrimaryKey:));
        if ( primaryIMP && [modelClass cqIsPrimaryKey:propers[i]]) {
            [primaryKeys addObject:propers[i]];
        }
        //判断是否允许为空
        BOOL notNumllIMP = class_respondsToSelector(object_getClass(modelClass), @selector(cqIsAllowNull:));
        if ( notNumllIMP && ![modelClass cqIsAllowNull:propers[i]]) {
            [msql appendFormat:@" %@",SQLNot_Null];
        }
        if (i<propers.count-1) {
            [msql appendString:@","];
        }
        
    }//end for
    
    //拼接primarykey
    if (primaryKeys.count>0) {
        [msql appendFormat:@", %@ (",SQLPrimaryKey];
        for (NSString *primarykey in primaryKeys) {
            
            [msql appendString:primarykey];
            if (primarykey != [primaryKeys lastObject]) {
                [msql appendFormat:@","];
            }
        }
        [msql appendString:@")"];
    }
    
    [msql appendString:@")"];
    return msql;
}

+(NSString *)getReplaceSQL:(id<CQDBOperatorSettingInterface>)model{
    
    Class modelClass = object_getClass(model);
    NSString *className = NSStringFromClass(modelClass);
    className = [CQDBOperator checkKeyWord:className];
    NSMutableString *msql = [NSMutableString stringWithFormat:@"replace into %@ (",className];
    NSDictionary *propertyDic = [CQDBOperator cqGetPropertysBy:modelClass];
    NSArray *propers = propertyDic[@"name"];
    NSArray *types = propertyDic[@"type"];
    
    for (int i = 0; i < propers.count ; i++) {
        NSString *properName = propers[i];
        properName = [CQDBOperator checkKeyWord:properName];
        if (i != propers.count-1) {
            if ([CQDBOperator cqPropertyIsNull:model property:propers[i]]) {
                continue;
            }
            [msql appendFormat:@"%@,",properName];
        }else{
            if ([CQDBOperator cqPropertyIsNull:model property:propers[i]]) {
                [msql appendString:@") values("];
            }else{
                [msql appendFormat:@"%@) values(",properName];
            }
        }
    }
    
    for (int i = 0; i < propers.count; i++) {
        
        if (i != propers.count-1) {
            if ([CQDBOperator cqPropertyIsNull:model property:propers[i]]) {
                continue;
            }
            [msql appendString:@"?,"];
        }else{
            if ([CQDBOperator cqPropertyIsNull:model property:propers[i]]) {
                [msql appendString:@")"];
            }else{
                [msql appendString:@"?)"];
            }
        }
    }
    //NSLog(@"%@",msql);
    //NSString *sql = @"replace into Simpal(warningID,warningClass,carType,carFramID,carNumber,carImg,carData) values (?,?,?,?,?,?,?)";
    return msql;
}

/**删除该表*/
-(BOOL)deleteTableWithTableName:(NSString *)tableName{
    
    tableName = [CQDBOperator checkKeyWord:tableName];
    [self.fmDataBase open];
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
    BOOL result = [self.fmDataBase executeUpdate:sql];
    [self.fmDataBase close];
    return result;
}

#pragma mark - runtime
/**
 *  获取该类的所有属性名，属性类型
 */
+ (NSDictionary *)cqGetPropertysBy:(Class<CQDBOperatorSettingInterface> )modelClass
{
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(modelClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        //是否忽略不保存
        if(class_respondsToSelector(object_getClass(modelClass), @selector(cqIsIgnoreProperty:))){
            if ([modelClass cqIsIgnoreProperty:propertyName]) {
                continue;
            }
        }
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是T@"NSString"
         T@"NSDate"
         
         64位下long 和long long 都是Tq
         SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL
         */
        //NSLog(@"%@",propertyType);
        
        //跳过只读属性 判断是否有只读属性
        NSArray *typeArr = [propertyType componentsSeparatedByString:@","];
        if ([typeArr containsObject:@"R"]) {
            continue;
        }
        
        //添加属性名
        [proNames addObject:propertyName];
        
        //添加属性类型
        if ([propertyType hasPrefix:@"T@\"NSString"]) {
            [proTypes addObject:SQLType_text];
        } else if ([propertyType hasPrefix:@"Ti"]||[propertyType hasPrefix:@"TI"]
                   ||[propertyType hasPrefix:@"Ts"]||[propertyType hasPrefix:@"TS"]
                   ||[propertyType hasPrefix:@"TB"]
                   ||[propertyType hasPrefix:@"Tq"] || [propertyType hasPrefix:@"TQ"]) {
            [proTypes addObject:SQLType_int];
        }else if ([propertyType hasPrefix:@"Td"]){
            [proTypes addObject:SQLType_double];
        }else if ([propertyType hasPrefix:@"Tf"]){
            [proTypes addObject:SQLType_float];
        }else {
            [proTypes addObject:SQLType_blob];
        }
        
    }
    free(properties);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}


#pragma mark - 各种判断
/**判断属性是否为空，主键为空就会蹦*/
+(BOOL)cqPropertyIsNull:(id)model property:(NSString *)proper{
    
    id value = [model valueForKey:proper];
    Class modelClass = object_getClass(model);
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        
        if ( class_respondsToSelector(object_getClass(modelClass), @selector(cqIsPrimaryKey:)) &&
            [modelClass cqIsPrimaryKey:proper]) {
            [NSException raise:@"FMDBHelper" format:@"%@ is PrimaryKey cannot be nil",proper];
        }
        return YES;
    }
    return NO;
}

+(BOOL)checkTableVersion:(Class<CQDBOperatorSettingInterface>)modelClass{
    
    BOOL result = class_respondsToSelector(object_getClass(modelClass), @selector(cqTableVersion));
//    if (!result) {
//        [NSException raise:@"DBOperator" format:@"the %@ muste implement method cqTableVersion CQDBOperatorSettingInterface",NSStringFromClass(modelClass)];
//        return NO;
//    }
    float currentVersion = [modelClass cqTableVersion];
    float localVersion = [[NSUserDefaults standardUserDefaults] floatForKey:NSStringFromClass(modelClass)];

    return currentVersion == localVersion;
}

+(BOOL)setTableVersion:(Class<CQDBOperatorSettingInterface>)modelClass{
    BOOL result = class_respondsToSelector(object_getClass(modelClass), @selector(cqTableVersion));
//    if (!result) {
//        [NSException raise:@"DBOperator" format:@"the %@ muste implement method cqTableVersion CQDBOperatorSettingInterface",NSStringFromClass(modelClass)];
//        return NO;
//    }
    [[NSUserDefaults standardUserDefaults] setFloat:[modelClass cqTableVersion] forKey:NSStringFromClass(modelClass)];
    return [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
 判断是否是关键字，如果是则特殊化，如果不是小写化返回
 只在拼接sql语句的时候判断，防止混乱
 */
+(NSString *)checkKeyWord:(NSString *)checkWord{
    
    //关键字必须是小写，便于比较
    NSArray *keyWords = @[@"order"];
    BOOL exist = NO;
    checkWord = [checkWord lowercaseString];
    for (NSString *tmpkey in keyWords) {
        if ([[tmpkey lowercaseString] isEqualToString:checkWord]) {
            exist = YES;
        }
    }
    if (exist) {
        return [NSString stringWithFormat:@"\"%@\"",checkWord];
    }else{
        return checkWord;
    }
}

//判断表是否存在
- (BOOL)isTableExist:(NSString *)tableName
{
    [self.fmDataBase open];
    tableName = [CQDBOperator checkKeyWord:tableName];
    FMResultSet *rs = [self.fmDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    BOOL exist = NO;
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        if (0 == count)
        {
            kDebugLog(ktDBDebugFlag, @"%@ 表不存在",tableName);
            exist = NO;
            break;
        }
        else
        {
            exist = YES;
            break;
        }
    }
    [self.fmDataBase close];
    return exist;
}

#pragma mark - 数据库文件操作

+(CGFloat)LocalDBVersion{
    float version = [[NSUserDefaults standardUserDefaults] floatForKey:ktDBVersionKey];
    return version;
}

+(void)setLocalDBVersion{
    [[NSUserDefaults standardUserDefaults] setFloat:ktCurrentDBVersion forKey:ktDBVersionKey];
}

+(NSString *)getDBFilePath{
    
    NSString *dbName = [NSString stringWithFormat:@"%@.sqlite",@"CQDBOperator"];
    NSString * dbPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:dbName];
    kDebugLog(ktDBDebugFlag, @" %@",dbPath);
    BOOL isDirectory;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath isDirectory:&isDirectory];
    //不存在则创建文件
    if (isExist == NO || isDirectory) {
        
        kDebugLog(ktDBDebugFlag, @"创建数据库文件不存在 %@",dbPath);
        BOOL result = [[NSFileManager defaultManager]createFileAtPath:dbPath contents:nil attributes:nil];
        if (!result) {
            kDebugLog(ktDBDebugFlag, @"创建数据库文件失败");
        }
    }
    return dbPath;
}

-(NSString *)cacheDBPath{
    return [CQDBOperator getDBFilePath];
}

+(void)deleteDBFile{
    
    NSString *filePath = [self getDBFilePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    NSError *error;
    if (isExist) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            kDebugLog(ktDBDebugFlag, @"DeleteDBFileError -- %@",error);
        }
    }else{
        kDebugLog(ktDBDebugFlag, @"DeleteDBFile -- file already not exist");
    }
}

@end
