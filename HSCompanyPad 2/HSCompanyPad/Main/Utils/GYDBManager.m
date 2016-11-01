//
//  GYDBManager.m
//  HSCompanyPad
//
//  Created by User on 16/8/19.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYDBManager.h"
#import  <FMDB/FMDatabase.h>
#import  <FMDB/FMDatabaseQueue.h>
#import  <FMDB/FMResultSet.h>

#define PATH_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface GYDBManager ()

//暂不使用
@property (strong, nonatomic) FMDatabaseQueue * dbQueue;
@property (strong, nonatomic) FMDatabase *localDB;

@end

@implementation GYDBManager


-(id)init{
    self = [super init];
    if (self) {
        
        //默认在document目录下
        
//        _localDB  =[FMDatabase databaseWithPath:self.dbPath];
//        
//        if (![_localDB open]) {
//            
//            DDLogInfo(@"数据库打开失败");
//        }
        
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static GYDBManager *_singleton = nil;
    
    dispatch_once(&onceToken,^{
        _singleton = [[GYDBManager alloc]init];
        
    });
    return _singleton;
}

-(NSString*)dbPath{
    
    
    NSString * dbPath = [PATH_DOCUMENT stringByAppendingPathComponent:@"gymain.db"];
    
    DDLogInfo(@"dbPath = %@", dbPath);
    return  dbPath;
    
}
//创建浏览历史表

-(void)createHistoryTable{

    NSString *custId=globalData.loginModel.custId;//企业互生号
    
    //根据企业互生号来区分谁创建的数据库
    NSString *dbPath =[PATH_DOCUMENT stringByAppendingString:[NSString stringWithFormat:@"%@_gyhistory.db",custId]];
    
   
        //文件不存在，数据库开始创建
         _localDB  =[FMDatabase databaseWithPath:dbPath];
        
        if (![_localDB open]) {
            DDLogInfo(@"数据库打开失败");
            }
        else{
             DDLogInfo(@"数据库打开成功");
        }
    
   
    //
    NSString *sql =@"create table if not exists history (id integer primary key autoincrement,name text unique,icon text,className text,time text)";
    //name,标题；icon，图片名称；className;控制器类名称,time最新时间
    
  NSError *error;
  BOOL flag =[_localDB executeUpdate:sql values:nil error:&error];
    
    if (flag) {
        DDLogInfo(@"创建历史表成功");
    }
}

-(BOOL)saveHistoryModel:(GYMainHistoryModel*)model{

    //注:replace操作，有则更新，无则插入
    
    NSDate *date = model.time;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    NSString *sql =[NSString stringWithFormat:@"replace into history(name,icon,className,time) values('%@','%@','%@','%@')",model.name,model.iconName,model.className,strDate];
    
    NSError *error;

   BOOL flag = [_localDB executeUpdate:sql values:nil error:&error];
    
    if (flag) {
        DDLogInfo(@"插入浏览历史消息成功");
    }
    else{
        
    }
    
    return YES;
}

-(NSMutableArray*)selectHistoryModels{

    NSString *sql =[NSString stringWithFormat:@"select * from history order by time desc"];
    
    NSError *error;
    FMResultSet * rs= [_localDB executeQuery:sql values:nil error:&error];
    
    NSMutableArray *modelArr =[NSMutableArray new];
    while ([rs next]) {
        
        GYMainHistoryModel *model  =[GYMainHistoryModel new];
        
        model.name = [rs stringForColumn:@"name"];
        model.iconName = [rs stringForColumn:@"icon"];
        model.className =[rs stringForColumn:@"className"];
      //  model.time = [rs stringForColumn:@"time"];
        
        [modelArr addObject:model];
    }
    
    return modelArr;
}
@end
