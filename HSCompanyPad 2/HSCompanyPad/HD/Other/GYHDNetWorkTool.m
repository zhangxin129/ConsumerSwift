//
//  GYHDNetWorkTool.m
//  HSConsumer
//
//  Created by shiang on 16/1/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDNetWorkTool.h"
#import "GYNetwork.h"
#import "GYHDUtils.h"
#import "GYGIFHUD.h"
#import <AFNetworking/AFNetworking.h>
#import "GYHDMessageCenter.h"
#import "GYHDDataBaseCenter.h"
#import "GYLoginEn.h"
#import <GYKit/NSObject+HXAddtions.h>
#import <AudioToolbox/AudioToolbox.h>
#define BOUNDARY @"ABC12345678"
@interface GYHDNetWorkTool ()

//@property(nonatomic, copy)NSString *bserviceDomain;
//@property(nonatomic, copy)NSString *imgCenterDomain;
@end

@implementation GYHDNetWorkTool
static id instance;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        
    });
    return instance;
}


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}

//************************//
/**上传图片*/
- (void)postImageWithData:(NSData *)data RequetResult:(RequetResultWithDict)handler
{
    
////    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
////        
////        _imgCenterDomain = @"http://192.168.41.193:8095";
////        
////    }else{
//    
//        _imgCenterDomain = globalData.loginModel.hdimImgcAddr;
////    }
    NSString * urlString = [NSString stringWithFormat:@"%@/hsim-imgc/upload/imageUpload?type=%@&fileType=%@&custId=%@&id=%@&loginToken=%@&channelType=5",globalData.loginModel.hdimImgcAddr,@"default",@"image",globalData.loginModel.custId,globalData.loginModel.entResNo,globalData.loginModel.token];
    
    [self postUrlString:urlString Data:data fileName:@"1.jpg" RequetResult:handler];
}

/**上传音频*/
- (void)postAudioWithData:(NSData *)data RequetResult:(RequetResultWithDict)handler
{
////    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
////        
////        _imgCenterDomain = @"http://192.168.41.193:8095";
////        
////    }else{
//    
//        _imgCenterDomain = globalData.loginModel.hdimImgcAddr;
////    }
    
    NSString * urlString = [NSString stringWithFormat:@"%@/hsim-imgc/upload/audioUpload?type=%@&fileType=%@&custId=%@&id=%@&loginToken=%@&channelType=5",globalData.loginModel.hdimImgcAddr,@"default",@"audio",globalData.loginModel.custId,globalData.loginModel.entResNo,globalData.loginModel.token];
    
    [self postUrlString:urlString Data:data fileName:@"1.mp3" RequetResult:handler];
}
/**上传视频*/
- (void)postVideoWithData:(NSData *)data RequetResult:(RequetResultWithDict)handler
{
////    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
////        
////        _imgCenterDomain = @"http://192.168.41.193:8095";
////        
////    }else{
//    
//        _imgCenterDomain = globalData.loginModel.hdimImgcAddr;
////    }
    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-imgc/upload/videoUpload?type=%@&fileType=%@&custId=%@&id=%@&loginToken=%@&channelType=5",globalData.loginModel.hdimImgcAddr,@"default",@"video",globalData.loginModel.custId,globalData.loginModel.entResNo,globalData.loginModel.token];
    
    [self postUrlString:urlString Data:data fileName:@"1.mp4" RequetResult:handler];
    
}
- (void)postUrlString:(NSString *)urlstring Data:(NSData *)data fileName:(NSString *)fileName RequetResult:(RequetResultWithDict)handler
{

    NSURL *url = [NSURL URLWithString:urlstring];
    DDLogCInfo(@"Post上传图片URL：%@", url);
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *s = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
    [request addValue:s
   forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *bodyString = [NSMutableString string];
    [bodyString appendFormat:@"--%@\r\n", BOUNDARY];
    [bodyString appendString:@"Content-Disposition: form-data; name=\"Submit\"\r\n"];
    [bodyString appendString:@"\r\n"];
    [bodyString appendString:@"upload"];
    [bodyString appendString:@"\r\n"];
    [bodyString appendFormat:@"--%@\r\n", BOUNDARY];
    [bodyString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fileName]];
    //    [bodyString appendString:@"Content-Disposition: form-data; name=\"file\"; filename=\"1.mp4\"\r\n"];
    [bodyString appendString:@"Content-Type: image/png\r\n"];
    [bodyString appendString:@"\r\n"];
    
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    NSData *bodyStringData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    [bodyData appendData:bodyStringData];
    [bodyData appendData:data];
    
    
    NSString *endString = [NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY];
    NSData *endData = [endString dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:endData];
    NSString *len = [@(bodyData.length) stringValue];// [NSString stringWithFormat:@"%d", [bodyData length]];
    // 计算bodyData的总长度  根据该长度写Content-Lenngth字段
    [request addValue:len forHTTPHeaderField:@"Content-Length"];
    // 设置请求体
    [request setHTTPBody:bodyData];
    [request setTimeoutInterval:40.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError || !data) {
            handler(nil);
            return ;
        }
        NSError *DictError = nil;
        NSMutableDictionary *netwrokDict = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&DictError] mutableCopy];
        if (DictError || !netwrokDict) {
            handler(nil);
            return ;
        }
        [GYHDUtils checkDict:netwrokDict];
        NSString *string = netwrokDict[@"state"];
        if (![string isEqualToString:@"200"]) {
            handler(nil);
            return ;
        }
        handler(netwrokDict);
    }];
}

- (void)postQueryUserInfoByCustId:(NSString *)custId RequetResult:(RequetResultWithArray)handler {
    
////    NSString *urlString = @"http://192.168.41.193:8098/hsim-bservice/userCenter/queryUserInfoBycustId";
//    
////    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
////        
////        _bserviceDomain = @"http://192.168.41.193:8098";
////    }else{
//    
//        _bserviceDomain = globalData.loginModel.hdbizDomain;
////    }

    
  NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/queryUserInfoBycustId",globalData.loginModel.hdbizDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"custId"] = custId;
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = insideDict;
    sendDict[@"channelType"] =GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    
    [GYNetwork POST:urlString parameter:sendDict success:^(id returnValue) {
        if ([returnValue[GYNetWorkCodeKey]integerValue]==200) {
            
            if ([returnValue[@"rows"] isKindOfClass:[NSNull class]]) {
                [GYGIFHUD dismiss];
                return ;
                
            }else if ([returnValue[@"rows"] isKindOfClass:[NSArray class]]){
            
                NSArray*arry=returnValue[@"rows"];
                handler(arry);
                [GYGIFHUD dismiss];
            }
            
        }else{
             handler(nil);
            [GYGIFHUD dismiss];
        }
        
    } failure:^(NSError *error) {
        [GYGIFHUD dismiss];
        DDLogCInfo(@"error==%@",error);
        handler(nil);
    }isIndicator:YES];
}


- (void)postListOperByEntCustIdResult:(RequetResultWithArray)handler {
    
////    NSString *urlString = @"http://192.168.41.193:8098/hsim-bservice/userCenter/listOperByEntCustId";
//    
////    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
////        
////        _bserviceDomain = @"http://192.168.41.193:8098";
////    }else{
//    
//        _bserviceDomain = globalData.loginModel.hdbizDomain;
////    }

    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/listOperByEntCustId",globalData.loginModel.hdbizDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"entResNo"] = globalData.loginModel.entResNo;
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = insideDict;
    sendDict[@"channelType"] = GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    [GYNetwork POST:urlString parameter:sendDict success:^(id returnValue) {
        [GYGIFHUD show];
        if ([returnValue[GYNetWorkCodeKey]integerValue]==200) {
        
            if ([returnValue[@"rows"] isKindOfClass:[NSNull class]]) {
                [GYGIFHUD dismiss];
                return ;
                
            }else if ([returnValue[@"rows"] isKindOfClass:[NSArray class]]){
                
                
                NSArray*arry=returnValue[@"rows"];
                
                //                存储操作员到数据库
                [self postListOperByEntCustId:arry];
                
                handler(arry);
                [GYGIFHUD dismiss];
            }

        }else{
            handler(nil);
            [GYGIFHUD dismiss];
            
        }
        
    } failure:^(NSError *error) {
        [GYGIFHUD dismiss];
        handler(nil);
    }isIndicator:YES];
}

/**
 * 检查网络穿过来得数据并转换成dict
 */
- (NSMutableDictionary *)checkData:(NSData *)jsonData error:(NSError *)error
{
    if (error || !jsonData ) {
        return nil;
    }
    NSError *DictError = nil;
    NSMutableDictionary *netwrokDict = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&DictError] mutableCopy];
    if (DictError || !netwrokDict) {
        return nil;
    }
    [GYHDUtils checkDict:netwrokDict];
    NSString *string = netwrokDict[GYNetWorkCodeKey];
    
    if (![string isEqualToString:@"200"] || !netwrokDict) {
        return nil;
    }
    return netwrokDict;
}

- (void)downloadDataWithUrlString:(NSString *)urlstring filePath:(NSString *)filePath
{
    NSString *downString = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:downString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue ] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //数据接收完保存文件；注意苹果官方要求：下载数据只能保存在缓存目录（/Library/Caches）
        [data writeToFile:filePath atomically:YES]; //
    }];
}

- (void)downloadDataWithUrlString:(NSString *)urlstring RequetResult:(RequetResultWithDict)handler {
    NSString *downString = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:downString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue ] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[GYNetWorkDataKey] = data;
        handler(dict);
        //数据接收完保存文件；注意苹果官方要求：下载数据只能保存在缓存目录（/Library/Caches）
//        [data writeToFile:filePath atomically:YES]; //
    }];
}
/**
 *查询企业下的所有操作员,此发送有两返回值
 *1. 直接返回的是通过数据库得到的，
 *2.block返回的是从服务器获取的
 */
- (void)postListOperByEntCustId:(NSArray*)array {

    [[GYHDDataBaseCenter sharedInstance] deleteInfoWithMessage:@"e" fieldName:GYHDDataBaseCenterFriendUsetType tableName:GYHDDataBaseCenterFriendTableName];
    
    for (NSDictionary *friendDict in array){

        NSMutableDictionary *insertOperDict = [NSMutableDictionary dictionary];
        NSDictionary *searchUserInfoDict = friendDict[@"searchUserInfo"];
        NSString*str=@"m_e_";
        insertOperDict[GYHDDataBaseCenterFriendFriendID ] = [NSString stringWithFormat:@"%@%@",str,searchUserInfoDict[@"custId"]];
        insertOperDict[GYHDDataBaseCenterFriendCustID]    = searchUserInfoDict[@"custId"];
        insertOperDict[GYHDDataBaseCenterFriendName]      = searchUserInfoDict[@"operName"];
        insertOperDict[GYHDDataBaseCenterFriendIcon]      = searchUserInfoDict[@"headImage"];
        insertOperDict[GYHDDataBaseCenterFriendUsetType]  = @"e";
        insertOperDict[ GYHDDataBaseCenterFriendMessageTop]= @"-1";
        
        insertOperDict[GYHDDataBaseCenterFriendBasic ] = [GYHDUtils dictionaryToString:friendDict];
        insertOperDict[GYHDDataBaseCenterFriendDetailed ] = [GYHDUtils dictionaryToString:friendDict];
        [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:insertOperDict TableName:GYHDDataBaseCenterFriendTableName];
    }
}
/**
 * 查询企业下的在线客服信息
 */
- (void)queryOnlineCustomerServiceListWithEntResNo:(NSString *)entResNo RequetResult:(RequetResultWithArray)handler{

//    //    NSString *urlString = @"http://192.168.41.193:8098/hsim-bservice/userCenter/queryUserInfoBycustId";
//    
//    //    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
//    //
//    //        _bserviceDomain = @"http://192.168.41.193:8098";
//    //    }else{
//    
//    _bserviceDomain = globalData.loginModel.hdbizDomain;
//    //    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/getCusOperOnlineInfoList",globalData.loginModel.hdbizDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"entResNo"] = entResNo;
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = insideDict;
    sendDict[@"channelType"] =GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    [GYNetwork POST:urlString parameter:sendDict success:^(id returnValue) {
        if ([returnValue[GYNetWorkCodeKey]integerValue]==200) {
            
            if ([returnValue[@"rows"] isKindOfClass:[NSNull class]]) {
              
                return ;
                
            }else if ([returnValue[@"rows"] isKindOfClass:[NSArray class]]){
                
                NSArray*arry=returnValue[@"rows"];
                handler(arry);
            }
            
        }else{
            
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:kLocalized(@"GYHD_Tips") message:kLocalized(@"GYHD_GetOnline_CustomerServiceList_Failed") delegate:nil cancelButtonTitle:kLocalized(@"GYHD_Comfirm") otherButtonTitles:nil];
            
            [alterView show];
            
        }
        
    } failure:^(NSError *error) {
        
        DDLogCInfo(@"error==%@",error);
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:kLocalized(@"GYHD_Tips") message:kLocalized(@"GYHD_GetOnline_CustomerServiceList_Failed") delegate:nil cancelButtonTitle:kLocalized(@"GYHD_Comfirm") otherButtonTitles:nil];
        
        [alterView show];

    }];

}

//1.添加快捷回复消息请求URL
- (void)addQuickReplyMsgWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler {
    
//    NSString *urlString = @"http://192.168.41.193:8088/hsim-bservice/message/addQuickReplyMsg";
    
    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/message/addQuickReplyMsg",globalData.loginModel.hdbizDomain];
    
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = dict;
    sendDict[@"channelType"] = GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    GYNetRequest *re = [[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        handler(responseObject);
    }];
    re.noShowErrorMsg = YES;
    [re start];
}
//2.更新快捷回复消息请求URL
- (void)updateQuickReplyMsgWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler {
//    NSString *urlString = @"http://192.168.41.193:8088/hsim-bservice/message/updateQuickReplyMsg";
     NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/message/updateQuickReplyMsg",globalData.loginModel.hdbizDomain];
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = dict;
    sendDict[@"channelType"] = GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    GYNetRequest *re = [[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {

        handler(responseObject);
    }];
    re.noShowErrorMsg = YES;
    [re start];
}
//3.删除快捷回复消息请求URL
- (void)deleteQuickReplyMsgByMsgIdWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler {
    
//    NSString *urlString = @"http://192.168.41.193:8088/hsim-bservice/message/deleteQuickReplyMsgByMsgId";
    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/message/deleteQuickReplyMsgByMsgId",globalData.loginModel.hdbizDomain];
    
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = dict;
    sendDict[@"channelType"] = GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    GYNetRequest *re = [[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        DDLogInfo(@"%@",responseObject);
        handler(responseObject);
    }];
    re.noShowErrorMsg = YES;
    [re start];
}
//4.根据客户号查询快捷回复消息请求URL
- (void)queryQuickReplyMsgByCustIdWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithArray)handler {
    
 NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/message/queryQuickReplyMsgByCustId",globalData.loginModel.hdbizDomain];
//    NSString *urlString = @"http://192.168.41.193:8088/hsim-bservice/message/queryQuickReplyMsgByCustId";
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"custId"] = globalData.loginModel.entCustId;
    
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = insideDict;
    sendDict[@"channelType"] = GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    GYNetRequest *re = [[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        DDLogInfo(@"%@",responseObject);
        if ([responseObject[GYNetWorkCodeKey] integerValue] == 200) {
            NSMutableArray *array = [NSMutableArray array];
            [[GYHDDataBaseCenter sharedInstance] deleteInfoWithDict:nil TableName:GYHDDataBaseCenterQuickReplyTableName];
            for (NSDictionary *dict in responseObject[@"rows"]) {
                NSMutableDictionary *replyDict = [NSMutableDictionary dictionary];
                replyDict[GYHDDataBaseCenterQuickReplyTitle] = dict[@"title"];
                replyDict[GYHDDataBaseCenterQuickReplyCreateTimeStr] = dict[@"createTimeStr"];
                replyDict[GYHDDataBaseCenterQuickReplyUpdateTimeStr] = dict[@"updateTimeStr"];
                replyDict[GYHDDataBaseCenterQuickReplyContent] = dict[@"content"];
                replyDict[GYHDDataBaseCenterQuickReplyMsgId] = dict[@"msgId"];
                replyDict[GYHDDataBaseCenterQuickReplyIsDefault] = dict[@"isDefault"];
                replyDict[GYHDDataBaseCenterQuickReplyCustId] = dict[@"custId"];
                [array addObject:replyDict];
                [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:replyDict TableName:GYHDDataBaseCenterQuickReplyTableName];
            }
            handler(array);
        }

    }];
    re.noShowErrorMsg = YES;
    [re start];
}

/**
 * 查询企业客服记录列表
 */
- (void)queryCustomerServiceRecordListPage:(NSInteger)page RequetResult:(RequetResultWithArray)handler{


    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/message/queryAllCsSessionRecord",globalData.loginModel.hdbizDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"entCustId"] = globalData.loginModel.entCustId;
    insideDict[@"currentPage"] = [NSString stringWithFormat:@"%ld",page];
    insideDict[@"pageSize"] = @"20";
    insideDict[@"csOperId"] = @"";
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = insideDict;
    sendDict[@"channelType"] =GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    [GYNetwork POST:urlString parameter:sendDict success:^(id returnValue) {
        if ([returnValue[GYNetWorkCodeKey]integerValue]==200) {
            
            if ([returnValue[@"rows"] isKindOfClass:[NSNull class]]) {
                
                return ;
                
            }else if ([returnValue[@"rows"] isKindOfClass:[NSArray class]]){
                
                NSArray*arry=returnValue[@"rows"];
                handler(arry);
            }
            
        }else{
            
            handler(nil);
        }
        
    } failure:^(NSError *error) {
       
        DDLogCInfo(@"error==%@",error);
        
         handler(nil);
    }];
    
}

/**
 * 查询消费者客服记录列表
 */
- (void)queryCustomerServiceRecordListByCustomerId:(NSString*)customerid RequetResult:(RequetResultWithArray)handler{

    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/message/queryAllConsumerCsSessionRecord",globalData.loginModel.hdbizDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"consumerId"] = customerid;
    insideDict[@"currentPage"] = @"1";
    insideDict[@"entCustId"] = globalData.loginModel.entCustId;
    insideDict[@"pageSize"] = @"50";
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = insideDict;
    sendDict[@"channelType"] =GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    [GYNetwork POST:urlString parameter:sendDict success:^(id returnValue) {
        if ([returnValue[GYNetWorkCodeKey]integerValue]==200) {
            
            if ([returnValue[@"rows"] isKindOfClass:[NSNull class]]) {
                
                return ;
                
            }else if ([returnValue[@"rows"] isKindOfClass:[NSArray class]]){
                
                NSArray*arry=returnValue[@"rows"];
                handler(arry);
            }
            
        }else{
        
            handler(nil);
        }
        
    } failure:^(NSError *error) {
       
        DDLogCInfo(@"error==%@",error);
        
        handler(nil);
        
    }];

}

/**
 * 查询企业提示语
 */
- (void)queryCompanyGreetingRequetResult:(RequetResultWithArray)handler{


    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/message/queryGreetingsMsg",globalData.loginModel.hdbizDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"entCustId"] = globalData.loginModel.entCustId;
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = insideDict;
    sendDict[@"channelType"] =GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    [GYNetwork POST:urlString parameter:sendDict success:^(id returnValue) {
        if ([returnValue[GYNetWorkCodeKey]integerValue]==200) {
            
            if ([returnValue[@"rows"] isKindOfClass:[NSNull class]]) {
                
                return ;
                
            }else if ([returnValue[@"rows"] isKindOfClass:[NSArray class]]){
                
                NSArray*arry=returnValue[@"rows"];
                handler(arry);
            }
            
        }else{
            
            handler(nil);
        }
        
    } failure:^(NSError *error) {
        
        DDLogCInfo(@"error==%@",error);
        
        handler(nil);
        
    }];

}

/**
 * 根据会话ID查询会话记录
 */
- (void)querySessionRecordWithSession:(NSString *)sessionId page:(NSInteger)page RequetResult:(RequetResultWithArray)handler{

    
    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/message/queryMsgRecordBySessionId",globalData.loginModel.hdbizDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"sessionId"] = sessionId;
    insideDict[@"currentPage"] = [NSString stringWithFormat:@"%ld",page];
    insideDict[@"pageSize"] = @"10";
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = insideDict;
    sendDict[@"channelType"] =GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    [GYGIFHUD show];
    [GYNetwork POST:urlString parameter:sendDict success:^(id returnValue) {
        if ([returnValue[GYNetWorkCodeKey]integerValue]==200) {
            
            if ([returnValue[@"rows"] isKindOfClass:[NSNull class]]) {
                [GYGIFHUD dismiss];
                return ;
                
            }else if ([returnValue[@"rows"] isKindOfClass:[NSArray class]]){
                [GYGIFHUD dismiss];
                NSArray*arry=returnValue[@"rows"];
                handler(arry);
            }
            
        }else{
            
            [GYGIFHUD dismiss];
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:kLocalized(@"GYHD_Tips") message:kLocalized(@"GYHD_GetCustomerServiceRecord_Failed") delegate:nil cancelButtonTitle:kLocalized(@"GYHD_Comfirm") otherButtonTitles:nil];
            
            [alterView show];
            handler(nil);
        }
        
    } failure:^(NSError *error) {
        
        DDLogCInfo(@"error==%@",error);
        [GYGIFHUD dismiss];
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:kLocalized(@"GYHD_Tips") message:kLocalized(@"GYHD_GetCustomerServiceRecord_Failed") delegate:nil cancelButtonTitle:kLocalized(@"GYHD_Comfirm") otherButtonTitles:nil];
        
        [alterView show];
        handler(nil);
        
    }];
    
}

@end
