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
#import "Network.h"
#import "AFNetworking.h"
#import "GYHDMessageCenter.h"
#import "GYHDDataBaseCenter.h"
#import "GYLoginEn.h"
#import "GYGIFHUD.h"
#import "NSObject+HXAddtions.h"
#import <AudioToolbox/AudioToolbox.h>
#define BOUNDARY @"ABC12345678"
@interface GYHDNetWorkTool ()

@property(nonatomic, copy)NSString *bserviceDomain;
@property(nonatomic, copy)NSString *imgCenterDomain;

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
    
//    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
//        
//        _imgCenterDomain = @"http://192.168.41.193:8095";
//        
//    }else{ 
    
        _imgCenterDomain = globalData.loginModel.hdimImgcAddr;
//    }
    NSString * urlString = [NSString stringWithFormat:@"%@/hsim-img-center/upload/imageUpload?type=%@&fileType=%@&custId=%@&id=%@&loginToken=%@&channelType=8",self.imgCenterDomain,@"default",@"image",globalData.loginModel.custId,globalData.loginModel.entResNo,globalData.loginModel.token];
    
    [self postUrlString:urlString Data:data fileName:@"1.jpg" RequetResult:handler];
}

/**上传音频*/
- (void)postAudioWithData:(NSData *)data RequetResult:(RequetResultWithDict)handler
{
//    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
//        
//        _imgCenterDomain = @"http://192.168.41.193:8095";
//        
//    }else{
    
        _imgCenterDomain = globalData.loginModel.hdimImgcAddr;
//    }
    
    NSString * urlString = [NSString stringWithFormat:@"%@/hsim-img-center/upload/audioUpload?type=%@&fileType=%@&custId=%@&id=%@&loginToken=%@&channelType=8",self.imgCenterDomain,@"default",@"audio",globalData.loginModel.custId,globalData.loginModel.entResNo,globalData.loginModel.token];
    
    [self postUrlString:urlString Data:data fileName:@"1.mp3" RequetResult:handler];
}
/**上传视频*/
- (void)postVideoWithData:(NSData *)data RequetResult:(RequetResultWithDict)handler
{
//    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
//        
//        _imgCenterDomain = @"http://192.168.41.193:8095";
//        
//    }else{
    
        _imgCenterDomain = globalData.loginModel.hdimImgcAddr;
//    }
    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-img-center/upload/videoUpload?type=%@&fileType=%@&custId=%@&id=%@&loginToken=%@&channelType=8",self.imgCenterDomain,@"default",@"video",globalData.loginModel.custId,globalData.loginModel.entResNo,globalData.loginModel.token];
    
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
        [[GYHDMessageCenter sharedInstance] checkDict:netwrokDict];
        NSString *string = netwrokDict[@"state"];
        if (![string isEqualToString:@"200"]) {
            handler(nil);
            return ;
        }
        handler(netwrokDict);
    }];
}

- (void)postQueryUserInfoByCustId:(NSString *)custId RequetResult:(RequetResultWithArray)handler {
    
//    NSString *urlString = @"http://192.168.41.193:8098/hsim-bservice/userCenter/queryUserInfoBycustId";
    
//    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
//        
//        _bserviceDomain = @"http://192.168.41.193:8098";
//    }else{
    
        _bserviceDomain = globalData.loginModel.hdbizDomain;
//    }

    
  NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/queryUserInfoBycustId",self.bserviceDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"custId"] = custId;
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = insideDict;
    sendDict[@"channelType"] = @"8";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    
    [Network POST:urlString parameter:sendDict success:^(id returnValue) {
        if ([returnValue[@"retCode"]integerValue]==200) {
            
            if ([returnValue[@"rows"] isKindOfClass:[NSNull class]]) {
                [GYGIFHUD dismiss];
                return ;
                
            }else if ([returnValue[@"rows"] isKindOfClass:[NSArray class]]){
            
                NSArray*arry=returnValue[@"rows"];
                handler(arry);
                [GYGIFHUD dismiss];
            }
            
        }else{
            
            [GYGIFHUD dismiss];
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取网络个人信息列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alterView show];
        
        }
        
    } failure:^(NSError *error) {
        [GYGIFHUD dismiss];
        DDLogCInfo(@"error==%@",error);
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取网络个人信息列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alterView show];
        
     
        
        
    }];
}


- (void)postListOperByEntCustIdResult:(RequetResultWithArray)handler {
    
//    NSString *urlString = @"http://192.168.41.193:8098/hsim-bservice/userCenter/listOperByEntCustId";
    
//    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
//        
//        _bserviceDomain = @"http://192.168.41.193:8098";
//    }else{
    
        _bserviceDomain = globalData.loginModel.hdbizDomain;
//    }

    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/listOperByEntCustId",self.bserviceDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"entResNo"] = globalData.loginModel.entResNo;
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = insideDict;
    sendDict[@"channelType"] = @"8";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    [Network POST:urlString parameter:sendDict success:^(id returnValue) {
        [GYGIFHUD show];
        if ([returnValue[@"retCode"]integerValue]==200) {
            
//            DDLogCInfo(@"returnValue=%@",returnValue[@"rows"]);
            
            if ([returnValue[@"rows"] isKindOfClass:[NSNull class]]) {
                [GYGIFHUD dismiss];
                return ;
                
            }else if ([returnValue[@"rows"] isKindOfClass:[NSArray class]]){
                
                
                NSArray*arry=returnValue[@"rows"];
                
//                DDLogCInfo(@"arry=%@",arry);
                //                存储操作员到数据库
                [self postListOperByEntCustId:arry];
                
                
                handler(arry);
                [GYGIFHUD dismiss];
            }

        }else{
            
            [GYGIFHUD dismiss];
            
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取网络企业营业点信息列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alterView show];
            
        }
        
    } failure:^(NSError *error) {
        [GYGIFHUD dismiss];
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取网络企业营业点信息列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alterView show];
        
    }];
}

/*
 拉取离线消息
 */

-(void)postGetOffLinePushMessage{
    
//    _bserviceDomain= @"http://192.168.41.189:8998/hsim-web-psi";
        _bserviceDomain = globalData.loginModel.hdimPsiServer;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/login/getOfflinePushMsg",self.bserviceDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"channelType"] = @"8";
    insideDict[@"userId"] =globalData.loginModel.custId;
    insideDict[@"token"] = globalData.loginModel.token;
    insideDict[@"entResNo"] = globalData.loginModel.entResNo;
    insideDict[@"deviceType"] = @"6";

    [Network POST:urlString parameter:insideDict success:^(id returnValue) {
        if ([returnValue[@"retCode"]integerValue]==200) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSNull class]]) {
             
                return;
            }
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *dataArr = returnValue[@"data"];
                if ( dataArr.count== 0) {
                     return;
                }
               
            }
            
            for (NSDictionary*dic in returnValue[@"data"]) {
                
                
                [self saveWithPushMsgDict:dic];
                
            }

            
        }else{
            

        }
        
    } failure:^(NSError *error) {
        
        DDLogCInfo(@"离线消息请求错误==%@",error);
    }];


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
    [[GYHDMessageCenter sharedInstance] checkDict:netwrokDict];
    NSString *string = netwrokDict[@"retCode"];
    
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
        dict[@"data"] = data;
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
        
        insertOperDict[GYHDDataBaseCenterFriendBasic ] = [Utils dictionaryToString:friendDict];
        insertOperDict[GYHDDataBaseCenterFriendDetailed ] = [Utils dictionaryToString:friendDict];
        [[GYHDMessageCenter sharedInstance] insertInfoWithDict:insertOperDict TableName:GYHDDataBaseCenterFriendTableName];
    }
}

//离线消息存储数据库
- (void)saveWithPushMsgDict:(NSDictionary *)dic{
    
    NSDictionary*contentDict=[Utils stringToDictionary:dic[@"content"]]
    ;
    NSMutableDictionary *pushMessageDict = [NSMutableDictionary dictionary];
    
    NSString *sendTime = contentDict[@"time"];
    
    NSString*sendDateString=nil;
    if (sendTime==nil || [sendTime isEqualToString:@""]){
        
        sendDateString=@"";
        
    }else{
    
        sendDateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",
                          [sendTime substringWithRange:NSMakeRange(0, 4)],
                          [sendTime substringWithRange:NSMakeRange(4, 2)],
                          [sendTime substringWithRange:NSMakeRange(6, 2)],
                          [sendTime substringWithRange:NSMakeRange(8, 2)],
                          [sendTime substringWithRange:NSMakeRange(10, 2)],
                          [sendTime substringWithRange:NSMakeRange(12, 2)]];
    }

    NSDate *nowdata = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *recvDateString = [formatter stringFromDate:nowdata];
    NSDictionary *bodyDict = contentDict[@"content"];
    pushMessageDict[GYHDDataBaseCenterPushMessageCode]          = dic[@"msgType"];
    pushMessageDict[GYHDDataBaseCenterPushMessageID]            = [NSString stringWithFormat:@"%@",dic[@"msgId"]];
    
    pushMessageDict[GYHDDataBaseCenterPushMessagePlantFromID]   = [NSString stringWithFormat:@"%@",dic[@"plantformId"]];
    
    pushMessageDict[GYHDDataBaseCenterPushMessageFromID]        = [NSString stringWithFormat:@"%@",dic[@"fromId"]];
    
    pushMessageDict[GYHDDataBaseCenterPushMessageToID]          = [NSString stringWithFormat:@"%lld",globalData.loginModel.custId.longLongValue];
    pushMessageDict[GYHDDataBaseCenterPushMessageContent]       = bodyDict[@"msg_content"];
    pushMessageDict[GYHDDataBaseCenterPushMessageBody]       = [Utils dictionaryToString:bodyDict];
    pushMessageDict[GYHDDataBaseCenterPushMessageSendTime]      = sendDateString;
    pushMessageDict[GYHDDataBaseCenterPushMessageRevieTime]     = recvDateString;
    pushMessageDict[GYHDDataBaseCenterPushMessageIsRead]        =@(1);
  
//    屏蔽不该收到的消息类型
    /*
     互生消息： '1001','1002','1003','1004','1005','2531','2532','1011','1012','1013','1014','1015','1016'
     
     订单消息： '2501','2502','2503','2504','2505','2506','2507','2508','2509','2510','2511','2512','2513','2514','2514','2541','2542','2543','2544','2545','2546','2547'
     
     服务消息： '2801','2802','2803'定制／通用平板接受，当前餐饮平板不接受服务消息
     */
    NSArray *msgTypeArr=@[@"1001",@"1002",@"1003",@"1004",@"1005",@"2531",@"2532",@"1011",@"1012",@"1013",@"1014",@"1015",@"1016",@"2501",@"2502",@"2503",@"2504",@"2505",@"2506",@"2507",@"2508",@"2509",@"2510",@"2511",@"2512",@"2513",@"2514",@"2541",@"2542",@"2543",@"2544",@"2545",@"2546",@"2547"];
    
    NSArray*hsMsgTypeArr=@[@"1001",@"1002",@"1003",@"1004",@"1005",@"2531",@"2532",@"1011",@"1012",@"1013",@"1014",@"1015",@"1016"];
    NSArray*ddMsgTypeArr=@[@"2501",@"2502",@"2503",@"2504",@"2505",@"2506",@"2507",@"2508",@"2509",@"2510",@"2511",@"2512",@"2513",@"2514",@"2541",@"2542",@"2543",@"2544",@"2545",@"2546",@"2547"];
    
    NSArray*fuMsgTypeArr=@[@"2801",@"2802",@"2803"];
    
    for (NSString*msgType in hsMsgTypeArr) {
        
        if ([[dic[@"msgType"]stringValue] isEqualToString:msgType]) {
            
            pushMessageDict[GYHDDataBaseCenterPushMessageMainType] =@"1";//系统消息
            
            if ([msgType isEqualToString:@"1001"]||[msgType isEqualToString:@"1002"]||[msgType isEqualToString:@"1003"]||[msgType isEqualToString:@"1004"]||[msgType isEqualToString:@"1005"]) {
                
                NSString *msg_contentDic =bodyDict[@"msg_content"];
                
                if (msg_contentDic) {
                    
                    NSDictionary *dic = [Utils stringToDictionary:msg_contentDic];
                    
                    if ([dic isKindOfClass:[NSNull class]]||!dic) {
                        return;
                    }
                    
                    NSString *summary =dic[@"summary"];
                    
                    pushMessageDict[GYHDDataBaseCenterPushMessageSummary] =
                    summary;
                }
                
            }

            
        }
        
    }
    
    for (NSString*msgType in ddMsgTypeArr) {
        
        
        if ([[dic[@"msgType"]stringValue] isEqualToString:msgType]) {
            
            pushMessageDict[GYHDDataBaseCenterPushMessageMainType] =@"2";//订单消息
            
        }
        
    }
    
    for (NSString*msgType in fuMsgTypeArr) {
        
        
        if ([[dic[@"msgType"]stringValue] isEqualToString:msgType]) {
            
            pushMessageDict[GYHDDataBaseCenterPushMessageMainType] =@"3";//服务消息
            
        }
        
    }
    
    
    for (NSString*msgType in msgTypeArr) {
        
        if ([[dic[@"msgType"]stringValue] isEqualToString:msgType]) {
            
            //    屏蔽非0000用户零售推送消息
            //    '2501','2502','2503','2504','2505','2506','2507','2508','2509','2510','2511','2512','2513',
            if (([dic[@"msgType"] integerValue]==2501 || [dic[@"msgType"] integerValue]==2502 || [dic[@"msgType"] integerValue]==2503 || [dic[@"msgType"] integerValue]==2504 || [dic[@"msgType"] integerValue]==2505 || [dic[@"msgType"] integerValue]==2506 || [dic[@"msgType"] integerValue]==2507 || [dic[@"msgType"] integerValue]==2508 || [dic[@"msgType"] integerValue]==2509 || [dic[@"msgType"] integerValue]==2510 || [dic[@"msgType"] integerValue]==2511 || [dic[@"msgType"] integerValue]==2512 || [dic[@"msgType"] integerValue]==2513 || [dic[@"msgType"] integerValue]==2514) && ![globalData.loginModel.userName isEqualToString:@"0000"]) {
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushMessage" object:nil];
                });
                
                [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:pushMessageDict TableName:GYHDDataBaseCenterPushMessageTableName];
                
//                 AudioServicesPlaySystemSound(1002);
                
                NSArray *pushArray = [[NSUserDefaults standardUserDefaults]objectForKey:globalData.loginModel.custId];
                
                
                if (pushArray.count==4) {
                    
                    if ([pushArray[0]isEqualToNumber:@1]) {
                        
                        //全天不提示消息
                    }
                    
                    else if ([pushArray[1]isEqualToNumber:@1]) {
                        //夜间不提示消息,白天提示消息
                        
                        if ([Utils isBetweenFromHour:8 toHour:22]) {
                            
                            if ([pushArray[3]isEqualToNumber:@1]) {
                                
                                //震动提示
                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                
                            }
                            if ([pushArray[2]isEqualToNumber:@1]){
                                //声音提示
                                AudioServicesPlaySystemSound(1007);
                            }
                        }
                    }
                    
                    else if ([pushArray[0]isEqualToNumber:@0]) {
                        //默认全天提示消息
                        
                        if ([pushArray[3]isEqualToNumber:@1]) {
                            
                            //震动提示
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                            
                        }
                        if ([pushArray[2]isEqualToNumber:@1]){
                            //声音提示
                            AudioServicesPlaySystemSound(1007);
                        }
                    }
                    
                    else if ([pushArray[1]isEqualToNumber:@0]) {
                        //默认夜间提示消息
                        
                        if ([pushArray[3]isEqualToNumber:@1]) {
                            
                            //震动提示
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                            
                        }
                        if ([pushArray[2]isEqualToNumber:@1]){
                            //声音提示
                            AudioServicesPlaySystemSound(1007);
                        }
                    }

                }

                
            }
            
        }
        
        
    }
    
}
@end
