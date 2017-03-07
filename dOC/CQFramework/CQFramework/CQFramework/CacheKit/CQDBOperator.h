//
//  CQDBOperator.h
//  CQFramework
//
//  Created by runo on 17/2/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQDBOperatorSettingInterface.h"

/**保存数据库的类型*/
#define SQLType_int @"integer"
#define SQLType_float @"float"
#define SQLType_double @"double"
#define SQLType_text @"text"
#define SQLType_blob @"blob"
/**数据库关键字*/
#define SQLPrimaryKey @"PRIMARY KEY"
#define SQLNot_Null @"NOT NULL"
#define SQL_UNIQUE @"UNIQUE"

/*
    当前数据库版本号,版本号与app本地数据库版本号不一致则会删除数据重建数据库
 */
#define ktCurrentDBVersion 1.0
#define ktDBVersionKey @"ktDBVersionKey"

#define ktDBDebugFlag 1



@interface CQDBOperator : NSObject

@property(nonatomic,readonly,copy) NSString *cacheDBPath;

/**单例入口*/
+ (id)cqShareDMOperation;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (BOOL)cqRegisterClass:(Class<CQDBOperatorSettingInterface> )modelClass;

/** 增  保存所有模型,同样适用于更新,自己注意主键设置*/
-(void)cqSaveAllModel:(NSArray<CQDBOperatorSettingInterface> *)arr;
/** 删  除所有模型*/
-(BOOL)cqDeleteAllModel:(Class<CQDBOperatorSettingInterface>)modelClass;
/** 删  除特定条件下的模型，如果是字符串以外的对象请转成data去比较*/
-(BOOL)cqDeleteModelWhere:(NSDictionary *)dic AtClass:(Class<CQDBOperatorSettingInterface>)modelClass;//delet from TableName where key1 = value1 and key2 = value2
/** 查  获取数据库中所有模型*/
-(NSArray *)cqGetAllModel:(Class<CQDBOperatorSettingInterface>)modelClass;
/** 查  获取某一组指定模型*/
-(NSArray *)cqGetModelWhere:(NSDictionary *)dic AtClass:(Class<CQDBOperatorSettingInterface>)modelClass;//select * from TableName where  key = value



@end
