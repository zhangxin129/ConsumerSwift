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
#import <AudioToolbox/AudioToolbox.h>
#define BOUNDARY @"ABC12345678"
@interface GYHDNetWorkTool ()

@property (nonatomic, copy) NSString* bserviceDomain;
@property (nonatomic, copy) NSString* imgCenterDomain;
@end

@implementation GYHDNetWorkTool
static id instance;
+ (id)allocWithZone:(struct _NSZone*)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];

    });
    return instance;
}

- (NSString*)bserviceDomain
{

    if ([GYHSLoginEn sharedInstance].loginLine == kLoginEn_dev) {
        //        _bserviceDomain = @"http://192.168.41.193:1098";
        if ( [GlobalData shareInstance].loginModel.hdbizDomain.length > 10) {
            _bserviceDomain = [GlobalData shareInstance].loginModel.hdbizDomain;
        }

    }
    else {
//        _bserviceDomain = @"http://192.168.233.138:8080";
        if ( [GlobalData shareInstance].loginModel.hdbizDomain.length > 10) {
            _bserviceDomain = [GlobalData shareInstance].loginModel.hdbizDomain;
        }

    }

    return _bserviceDomain;
}

- (NSString*)imgCenterDomain
{

    if ([GYHSLoginEn sharedInstance].loginLine == kLoginEn_dev) {
        //        _imgCenterDomain = @"http://192.168.41.193:8095";
        //        _imgCenterDomain = [GlobalData shareInstance].loginModel.hdbizDomain;
        if ([GlobalData shareInstance].loginModel.hdimImgcAddr.length > 10) {
            _imgCenterDomain = [GlobalData shareInstance].loginModel.hdimImgcAddr;
        }

    }
    else {
//            _imgCenterDomain = @"http://192.168.233.138:8080";
        if ([GlobalData shareInstance].loginModel.hdimImgcAddr.length > 10) {
            _imgCenterDomain = [GlobalData shareInstance].loginModel.hdimImgcAddr;
        }
    }

    return _imgCenterDomain;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)copyWithZone:(NSZone*)zone
{
    return instance;
}

- (void)getFriendListRequetResult:(RequetResultWithDict)handler
{
    GlobalData* data = [GlobalData shareInstance];
    NSDictionary* mydict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    //    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];
    insideDict[@"accountId"] = [NSString stringWithFormat:@"c_%@",data.loginModel.custId];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"custId"] = data.loginModel.custId;
    dict[@"loginToken"] = data.loginModel.token;
    dict[@"channelType"] = @"4";

    [dict setValue:insideDict forKey:@"data"];

    //    globalData.loginModel.hdbizDomain = @"http://192.168.41.193:8098/hsim-bservice/friend/queryFriendList";
    NSString* ustring = [NSString stringWithFormat:@"%@/hsim-bservice/friend/queryFriendList", self.bserviceDomain];
    
   GYNetRequest *re =  [[GYNetRequest alloc] initWithBlock:ustring  parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
        handler(responseObject);
    }] ;
    re.noShowErrorMsg = YES;
    [re start];
    
}
- (void)postHeaderWithData:(NSData*)data RequetResult:(RequetResultWithDict)handler;
{
    //    NSString *urlStr = [NSString stringWithFormat:@"%@?custId=%@&token=%@&isPub=1", kUrlFileUpload, globalData.loginModel.custId, globalData.loginModel.token];

    //add by zxm 20160106 重构上传图片接口
    NSString* uploadUrlString = [NSString stringWithFormat:@"%@?isPub=%@", kUploadFileUrlString, @"1"]; //公开
    if (globalData.loginModel.custId.length) {

        uploadUrlString = [NSString stringWithFormat:@"%@&custId=%@", uploadUrlString, globalData.loginModel.custId]; //custId
    }
    if (globalData.loginModel.token.length) {

        uploadUrlString = [NSString stringWithFormat:@"%@&token=%@", uploadUrlString, globalData.loginModel.token]; //token
    }
    UIImage* uploadImage = [UIImage imageWithData:data];
    [Network Post:uploadUrlString parameters:nil image:uploadImage completion:^(NSDictionary* responseObject, NSError* error) {
        handler(responseObject);

    }];
}

/**上传图片*/
- (void)postImageWithData:(NSData*)data RequetResult:(RequetResultWithDict)handler
{

    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-imgc/upload/imageUpload?type=%@&fileType=%@&custId=%@&id=%@&loginToken=%@&channelType=4", self.imgCenterDomain, @"default", @"image", globalData.loginModel.custId, globalData.loginModel.resNo, globalData.loginModel.token];

    [self postUrlString:urlString Data:data fileName:@"1.jpg" RequetResult:handler];
}

/**上传音频*/
- (void)postAudioWithData:(NSData*)data RequetResult:(RequetResultWithDict)handler
{

    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-imgc/upload/audioUpload?type=%@&fileType=%@&custId=%@&id=%@&loginToken=%@&channelType=4", self.imgCenterDomain, @"default", @"audio", globalData.loginModel.custId, globalData.loginModel.resNo, globalData.loginModel.token];

    //    NSString *urlString = [NSString stringWithFormat:@""];
    [self postUrlString:urlString Data:data fileName:@"1.mp3" RequetResult:handler];
}

/**上传视频*/
- (void)postVideoWithData:(NSData*)data RequetResult:(RequetResultWithDict)handler
{
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-imgc/upload/videoUpload?type=%@&fileType=%@&custId=%@&id=%@&loginToken=%@&channelType=4", self.imgCenterDomain, @"default", @"video", globalData.loginModel.custId, globalData.loginModel.resNo, globalData.loginModel.token];

    [self postUrlString:urlString Data:data fileName:@"1.mp4" RequetResult:handler];
}

- (void)postUrlString:(NSString*)urlstring Data:(NSData*)data fileName:(NSString*)fileName RequetResult:(RequetResultWithDict)handler
{

    NSURL* url = [NSURL URLWithString:urlstring];
    DDLogInfo(@"Post上传图片URL：%@", url);

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];

    NSString* s = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
    [request addValue:s
        forHTTPHeaderField:@"Content-Type"];

    NSMutableString* bodyString = [NSMutableString string];
    [bodyString appendFormat:@"--%@\r\n", BOUNDARY];
    [bodyString appendString:@"Content-Disposition: form-data; name=\"Submit\"\r\n"];
    [bodyString appendString:@"\r\n"];
    [bodyString appendString:@"upload"];
    [bodyString appendString:@"\r\n"];
    [bodyString appendFormat:@"--%@\r\n", BOUNDARY];
    [bodyString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName]];
    //    [bodyString appendString:@"Content-Disposition: form-data; name=\"file\"; filename=\"1.mp4\"\r\n"];
    [bodyString appendString:@"Content-Type: image/png\r\n"];
    [bodyString appendString:@"\r\n"];

    NSMutableData* bodyData = [[NSMutableData alloc] init];
    NSData* bodyStringData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];

    [bodyData appendData:bodyStringData];
    [bodyData appendData:data];

    NSString* endString = [NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY];
    NSData* endData = [endString dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:endData];
    NSString* len = [@(bodyData.length) stringValue]; // [NSString stringWithFormat:@"%d", [bodyData length]];
    // 计算bodyData的总长度  根据该长度写Content-Lenngth字段
    [request addValue:len forHTTPHeaderField:@"Content-Length"];
    // 设置请求体
    [request setHTTPBody:bodyData];
    [request setTimeoutInterval:40.0f];

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {

        if (connectionError || !data) {
            handler(nil);
            return;
        }
        NSError *DictError = nil;
        NSMutableDictionary *netwrokDict = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&DictError] mutableCopy];
        if (DictError || !netwrokDict) {
            handler(nil);
            return;
        }
        [[GYHDMessageCenter sharedInstance] checkDict:netwrokDict];
        NSString *string = netwrokDict[@"state"];
        if (![string isEqualToString:@"200"]) {
            handler(nil);
            return;
        }
        handler(netwrokDict);
    }];
}

/**
 * 检查网络穿过来得数据并转换成dict
 */
- (NSMutableDictionary*)checkData:(NSData*)jsonData error:(NSError*)error
{
    if (error || !jsonData) {
        return nil;
    }
    NSError* DictError = nil;
    NSMutableDictionary* netwrokDict = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&DictError] mutableCopy];
    if (DictError || !netwrokDict) {
        return nil;
    }
    [[GYHDMessageCenter sharedInstance] checkDict:netwrokDict];
    NSString* string = netwrokDict[@"retCode"];

    if (![string isEqualToString:@"200"] || !netwrokDict) {
        return nil;
    }
    return netwrokDict;
}
//
//- (void)searchFriendWithString:(NSString *)string Page:(NSString *)page RequetResult:(RequetResultWithDict)handler {
//
//    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/getCustomersByKeyword", self.bserviceDomain];
//    NSMutableDictionary *insideDict = [NSMutableDictionary dictionary];
//    insideDict[@"keyword"] = string;
//    insideDict[@"currentPage"] = page;
//    insideDict[@"pageSize"] = @"10";
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"data"] = insideDict;
//    dict[@"channelType"] = @"4";
//    dict[@"custId"] = globalData.loginModel.custId;
//    dict[@"loginToken"] = globalData.loginModel.token;
//
//    [GYNetwork requestURL:urlString parameters:dict option:POST_JSON_HTTP success:^(NSDictionary *responseObject) {
//
//    } failure:^(NSError *error, NSDictionary *tmpResponseObject) {
//
//    }];
//}

- (void)searchFriendWithDict:(NSDictionary*)dict Page:(NSString*)page RequetResult:(RequetResultWithDict)handler
{
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/getCustomersByKeyword", self.bserviceDomain];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    insideDict[@"keyword"] = dict[@"keyword"];
    insideDict[@"ageScope"] = dict[@"ageScope"];
    insideDict[@"province"] = dict[@"province"];
    insideDict[@"city"] = dict[@"city"];
    insideDict[@"sex"] = dict[@"sex"];
    insideDict[@"currentPage"] = page;
    insideDict[@"pageSize"] = @"10";
    insideDict[@"custId"] = globalData.loginModel.custId;
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = insideDict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;

    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            handler(responseObject);
    }] start];
}

/**
 * 绑定企业账号
 */
- (void)bindCompanyWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    //    NSString *urlString = @"http://192.168.41.44:8084/reconsitution/customerAccount/confirmBindCard";
    NSString* urlString = [NSString stringWithFormat:@"%@/customerAccount/confirmBindCard", globalData.loginModel.hsUrl];
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    //   {"resourceNo":"000"}
    sendDict[@"resourceNo"] = dict[@"resNo"];

    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            handler(responseObject);
    }];
    
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

- (void)downloadDataWithUrlString:(NSString*)urlstring filePath:(NSString*)filePath
{
    NSString* downString = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:downString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {
        //数据接收完保存文件；注意苹果官方要求：下载数据只能保存在缓存目录（/Library/Caches）
        [data writeToFile:filePath atomically:YES]; //
    }];
}

- (void)downloadDataWithUrlString:(NSString*)urlstring RequetResult:(RequetResultWithDict)handler
{
    NSString* downString = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:downString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"data"] = data;
        handler(dict);
        //数据接收完保存文件；注意苹果官方要求：下载数据只能保存在缓存目录（/Library/Caches）
        //        [data writeToFile:filePath atomically:YES]; //
    }];
}

- (void)loadTopicFromNetworkRequetResult:(RequetResultWithDict)handler
{
//    NSDictionary* allParas = @{ @"key" : @"" };
//    [GYNetwork requestURL:EasyBuyGetHomePageUrl parameters:allParas option:GET success:^(NSDictionary* responseObject) {
//        handler(responseObject);
//    } failure:^(NSError* error, NSDictionary* tmpResponseObject){
//
//    }];
}

/**查询好友分组*/
- (void)getFriendTeamRequetResult:(RequetResultWithDict)handler
{
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/team/queryTeamInfoByUserId", self.bserviceDomain];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    insideDict[@"teamCreator"] = globalData.loginModel.custId;
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = insideDict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;

    GYNetRequest *re = [[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        handler(responseObject);
//         handler(responseObject[@"rows"]);
    }];
    
    re.noShowErrorMsg = YES;
    [re start];
}

- (void)createFriendTeamWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/team/addTeam", self.bserviceDomain];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    insideDict[@"teamCreator"] = globalData.loginModel.custId;
    insideDict[@"teamName"] = dict[@"teamName"];
    insideDict[@"teamRemark"] = dict[@"teamRemark"];
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = insideDict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;

    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            if (responseObject) {
                if ([responseObject[@"retCode"] integerValue] == 200) {
                    NSArray *array = responseObject[@"rows"];
    
                    for (NSDictionary *dict in array) {
                        handler(dict);
                    }
                } else if ([responseObject[@"retCode"] integerValue] == 701 ||
                           [responseObject[@"retCode"] integerValue] == 702 ) {
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [GYUtils showToast: responseObject[@"message"] duration:1.0f position:CSToastPositionCenter];
                }
            }else {
                handler(nil);
            }
    }] start];
}

/**删除分组*/
- (void)deleteFriendTeamID:(NSString*)teamID RequetResult:(RequetResultWithDict)handler
{
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/team/deleteTeam", self.bserviceDomain];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    insideDict[@"teamId"] = teamID;
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = insideDict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;

    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        handler(responseObject);
    }] start];
}
//1个标签多个好友
- (void)MovieFriendWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/team/addFriendIntoTeam", self.bserviceDomain];
    
//    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
//    insideDict[@"teamId"] = dict[@"teamId"];
//    insideDict[@"userId"] = dict[@"userId"];
//    insideDict[@"friendId"] = dict[@"friendId"];
//    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/team/setTeamToFriend", self.bserviceDomain];
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = dict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;

    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        handler(responseObject);
    }] start];
}

//1个好友多个标签
- (void)MovieFriendtoTagWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    //    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/team/addFriendIntoTeam", self.bserviceDomain];
    
    //    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    //    insideDict[@"teamId"] = dict[@"teamId"];
    //    insideDict[@"userId"] = dict[@"userId"];
    //    insideDict[@"friendId"] = dict[@"friendId"];
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/team/setTeamToFriend", self.bserviceDomain];
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = dict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    
    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        handler(responseObject);
    }] start];
}

- (void)updateFriendTeamWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/team/updateTeamInfo", self.bserviceDomain];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    //    增加传入字段 add zhangx
    insideDict[@"teamCreator"]=globalData.loginModel.custId;
    insideDict[@"teamName"] = dict[@"teamName"];
    insideDict[@"teamRemark"] = dict[@"teamRemark"];
    insideDict[@"teamId"] = dict[@"teamId"];
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = insideDict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;

    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
//        分类修改不成功，暂时在这里加入提示 add zhangx
        if ([responseObject[@"retCode"]integerValue]!=200) {

            UIWindow *windows = [UIApplication sharedApplication].keyWindow;
            [windows makeToast:responseObject[@"message"] duration:1.0f position:CSToastPositionCenter];
        }
    }] start];
}

- (void)searchFriendWithCustId:(NSString*)custID RequetResult:(RequetResultWithDict)handler
{

    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/queryUserInfoBycustId", self.bserviceDomain];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    insideDict[@"custId"] = custID;
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = insideDict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    
    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        //        分类修改不成功，暂时在这里加入提示 add zhangx
        if ([responseObject[@"retCode"] integerValue] == 200) {
            NSArray *rowArray = responseObject[@"rows"];
            NSDictionary *dict = [rowArray lastObject];
            if ([dict[@"searchUserInfo"] isKindOfClass:[NSDictionary class]]) {
                handler(dict[@"searchUserInfo"]);
            } else {
                handler(nil);
            }

        } else {
            handler(nil);
        }
    }] start];
}

- (void)EasyBuyGetMyConcernShopUrlRequetResult:(RequetResultWithArray)handler
{
    //#define EasyBuyGetMyConcernShopUrl [retailDomainBase stringByAppendingString:@"/easybuy/getMyConcernShop"]//获取关注的商铺

    GlobalData* data = globalData;
    if (data.loginModel.token) {
        NSDictionary* allParas = @{ @"key" : data.loginModel.token };
        
      GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:EasyBuyGetMyConcernShopUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"retCode"] integerValue] != 200) {
                handler(nil);
            } else {
                NSMutableArray *array = [NSMutableArray arrayWithArray:responseObject[@"data"]];
                handler(array);
            }
        }] ;
    
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
       [request start];
    }
}

/**上传自己信息*/
- (void)updateNetworkInfoWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{

    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/updateNetworkInfo", self.bserviceDomain];

    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    NSMutableDictionary* insertDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    insertDict[@"perCustId"] = globalData.loginModel.custId;
    sendDict[@"data"] = insertDict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;

    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
//            分类修改不成功，暂时在这里加入提示 add zhangx
            handler(responseObject);
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            [GYUtils showToast:@"保存资料成功！" duration:1.0f position:CSToastPositionCenter];
    }] start];
    //    [GYNetwork requestURL:urlString parameters:sendDict option:POST_JSON_HTTP success:^(NSDictionary *responseObject) {
    //        handler(responseObject);
    //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //        [GYUtils showToast:@"保存资料成功！" duration:1.0f position:CSToastPositionCenter];
    //    } failure:^(NSError *error, NSDictionary *tmpResponseObject) {
    //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //        [GYUtils showToast:@"保存资料失败！" duration:1.0f position:CSToastPositionCenter];
    //    }];
}

/**好友*/
- (void)deleteFriendWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{

    NSMutableDictionary* deleteDict = [NSMutableDictionary dictionary];
    [deleteDict setValue:@"2" forKey:@"channel_type"];
    [deleteDict setValue:@"1.0" forKey:@"version"];
    [deleteDict setValue:globalData.loginModel.token forKey:@"key"];
    deleteDict[@"channelType"] = @"4";
    deleteDict[@"custId"] = globalData.loginModel.custId;
    deleteDict[@"loginToken"] = globalData.loginModel.token;
    deleteDict[@"data"] = dict;

    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/addFriend", self.bserviceDomain];

    [[[GYNetRequest alloc] initWithBlock:urlString parameters:deleteDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        //            分类修改不成功，暂时在这里加入提示 add zhangx
        handler(responseObject);
    }] start];
    
    //    [GYNetwork requestURL:urlString parameters:deleteDict option:POST_JSON_HTTP success:^(NSDictionary *responseObject) {
    //        handler(responseObject);
    //    } failure:^(NSError *error, NSDictionary *tmpResponseObject) {
    //        handler(nil);
    //    }];
}

- (void)queryWhoAddMeListRequetResult:(RequetResultWithDict)handler
{

    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    [insideDict setValue:myDict[@"myDict"] forKey:@"accountId"];
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = insideDict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/queryWhoAddMeList", self.bserviceDomain];

    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        //            分类修改不成功，暂时在这里加入提示 add zhangx
        handler(responseObject);
    }] start];
    //    [GYNetwork requestURL:urlString parameters:sendDict option:POST_JSON_HTTP success:^(NSDictionary *responseObject) {
    ////        NSLog(@"%@", responseObject);
    //        handler(responseObject);
    //    } failure:^(NSError *error, NSDictionary *tmpResponseObject) {
    //        handler(nil);
    //    }];
}

- (void)searchCompanyWithString:(NSString*)string currentPage:(NSString*)currentPage RequetResult:(RequetResultWithDict)handler
{
    NSString* hasCoupon = @"0";
    NSString* SortType = @"7";
    NSString* strSpecialServiceType = @"";

    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:string forKey:@"keyword"];
    [dict setValue:SortType forKey:@"sortType"];
    [dict setValue:strSpecialServiceType forKey:@"specialService"];
    [dict setValue:@"10" forKey:@"count"];

    [dict setValue:hasCoupon forKey:@"hasCoupon"];
    [dict setValue:currentPage forKey:@"currentPage"];
    [[[GYNetRequest alloc] initWithBlock:EasyBuySearchShopUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
        handler(responseObject);
    }] start];
}

- (void)searchCompanyWithcity:(NSString*)city currentPage:(NSString*)currentPage RequetResult:(RequetResultWithDict)handler
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:city forKey:@"city"];
    [dict setValue:@"" forKey:@"area"];
    [dict setValue:@"" forKey:@"section"];
    [dict setValue:@"10" forKey:@"count"];
    [dict setValue:currentPage forKey:@"currentPage"];
    [dict setValue:@"" forKey:@"categoryId"];
    [dict setValue:@"1" forKey:@"sortType"];
    [dict setValue:@"" forKey:@"location"];
    [dict setValue:@"" forKey:@"supportService"];
    [dict setValue:@"" forKey:@"distance"];
    [dict setValue:@"" forKey:@"hasCoupon"];

    [[[GYNetRequest alloc] initWithBlock:GetTopicListUrl  parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
        handler(responseObject);
    }] start];
}

- (void)CancelConcernShopUrlWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    [[[GYNetRequest alloc] initWithBlock:CancelConcernShopUrl  parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
        handler(responseObject);
    }] start];
}

- (void)ConcernShopUrlWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{

    
//    NSMutableDictionary* sendDict  = [[NSMutableDictionary alloc] init];
//    
//    if(![GYUtils checkStringInvalid:shopInfo.strVshopId]) {
//        [sendDict setValue:[NSString stringWithFormat:@"%@", shopInfo.strVshopId] forKey:@"vShopId"];
//        [dict setValue:globalData.loginModel.token forKey:@"key"];
//        [dict setValue:shopInfo.strShopId forKey:@"shopId"];
//        [dict setValue:shopInfo.strVshopId forKey:@"vShopId"];
//        //add by zhangqy 店名最长显示30字
//        [dict setValue:shopInfo.strShopName forKey:@"shopName"];
//    }
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:ConcernShopUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        handler(responseObject);
    }];
    [request start];
}

- (void)updateFriendNickNameWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    //    GlobalData * data =globalData;
    //    NSMutableDictionary * sendDict =[NSMutableDictionary dictionary];
    //    [sendDict setValue:globalData.loginModel.token forKey:@"key"];
    //    [sendDict setValue:globalData.loginModel.custId forKey:@"mid"];
    //    [sendDict setValue:@"1.0" forKey:@"version"];
    //    [sendDict setValue:@"4" forKey:@"channel_type"];
    //    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    //
    //    [insideDict setValue:globalData.loginModel.custId forKey:@"accountId"];
    //    [insideDict setValue:self.friendId   forKey:@"friendId"];
    //    [insideDict setValue:tfInputNickName.text forKey:@"friendNickname"];
    //    [sendDict setValue:insideDict forKey:@"data"];

    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    [sendDict setValue:@"2" forKey:@"channel_type"];
    [sendDict setValue:@"1.0" forKey:@"version"];
    [sendDict setValue:globalData.loginModel.token forKey:@"key"];
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"data"] = dict;

    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/updateFriendNickName", self.bserviceDomain];

    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        //            分类修改不成功，暂时在这里加入提示 add zhangx
        handler(responseObject);
    }] start];
}
//- (void)getOfflinePushMsgRequetResult:(RequetResultWithDict)handler {
//
//    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
//    sendDict[@"userId"] = globalData.loginModel.custId;
//    sendDict[@"token"] = globalData.loginModel.token;
//    sendDict[@"entResNo"] = @"";
//    sendDict[@"channelType"] = @"4";
//    sendDict[@"deviceType"] = @"5";
//
//    NSString *urlString = [NSString stringWithFormat:@"%@/login/getOfflinePushMsg",globalData.loginModel.hdimPsiServer];

////    [GYNetwork requestURL:urlString parameters:sendDict option:POST success:^(NSDictionary *responseObject) {
////        NSLog(@"%@", responseObject);
////        handler(responseObject);
////    } failure:^(NSError *error, NSDictionary *tmpResponseObject) {
////        handler(nil);
////    }];
//}
- (void)postOffLinePushMessageRequetResult:(RequetResultWithArray)handler
{
    if (globalData.loginModel.hdimPsiServer.length < 10 || [GYHDMessageCenter sharedInstance].state != GYHDMessageLoginStateAuthenticateSucced) {
        return ;
    }

    NSString* urlString = [NSString stringWithFormat:@"%@/login/getOfflinePushMsg", globalData.loginModel.hdimPsiServer];
    //    NSString *urlString = @"http://192.168.41.189:8998/hsim-web-psi/login/getOfflinePushMsg";
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"userId"] = globalData.loginModel.custId;
    sendDict[@"token"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = @"";
    sendDict[@"channelType"] = @"4";
    sendDict[@"deviceType"] = @"5";

    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *resDic = (NSDictionary*)responseObject;
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            [GYUtils showToast: [NSString stringWithFormat:@"%@",resDic[@"retCode"]] duration:0.25f position:CSToastPositionCenter];
            if ([resDic[@"retCode"]integerValue]==200) {
                NSMutableDictionary *insertMessageDict = [NSMutableDictionary dictionary];
                
                NSArray *dataArray = resDic[@"data"];
                
                if (dataArray.count>0) {
                    
                    for (int i=0; i<dataArray.count; i++) {
                        
                        NSDictionary *dic = dataArray[i];
                        
                        NSDictionary*contentDict=[GYUtils stringToDictionary:dic[@"content"]]
                        ;
                        NSMutableDictionary *pushMessageDict = [NSMutableDictionary dictionary];
                        
                        NSString *sendTime = contentDict[@"time"];
                        NSString *sendDateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",
                                                    [sendTime substringWithRange:NSMakeRange(0, 4)],
                                                    [sendTime substringWithRange:NSMakeRange(4, 2)],
                                                    [sendTime substringWithRange:NSMakeRange(6, 2)],
                                                    [sendTime substringWithRange:NSMakeRange(8, 2)],
                                                    [sendTime substringWithRange:NSMakeRange(10, 2)],
                                                    [sendTime substringWithRange:NSMakeRange(12, 2)]];
                        NSDate *nowdata = [NSDate date];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *recvDateString = [formatter stringFromDate:nowdata];
                        NSDictionary *bodyDict = contentDict[@"content"];
                        pushMessageDict[GYHDDataBaseCenterPushMessageCode]          = dic[@"msgType"];
                        pushMessageDict[GYHDDataBaseCenterPushMessageID]            = [NSString stringWithFormat:@"%@",dic[@"msgId"]];
                        
                        pushMessageDict[GYHDDataBaseCenterPushMessagePlantFromID]   = [NSString stringWithFormat:@"%@",dic[@"plantformId"]];
                        
                        pushMessageDict[GYHDDataBaseCenterPushMessageFromID]        = [NSString stringWithFormat:@"%@",dic[@"fromId"]];
                        
                        pushMessageDict[GYHDDataBaseCenterPushMessageToID]          = [NSString stringWithFormat:@"%@",dic[@"toId"]];
              
                        pushMessageDict[GYHDDataBaseCenterPushMessageContent]       = bodyDict[@"msg_content"];
                        if ([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] == GYHDProtobufMessage01001 || [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] == GYHDProtobufMessage01002) {
                            NSDictionary* dict = [GYUtils stringToDictionary: bodyDict[@"msg_content"]];
                            pushMessageDict[GYHDDataBaseCenterPushMessageContent]   = dict[@"summary"];
                        }
                        pushMessageDict[GYHDDataBaseCenterPushMessageBody]       = [GYUtils dictionaryToString:bodyDict];
                        pushMessageDict[GYHDDataBaseCenterPushMessageSendTime]      = sendDateString;
                        pushMessageDict[GYHDDataBaseCenterPushMessageRevieTime]     = recvDateString;
                        pushMessageDict[GYHDDataBaseCenterPushMessageIsRead]        =@(1);

                        if ([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage01001||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage01002||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage01006||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02001||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage01007||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage01008||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage01009||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage01010||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02002||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02003||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02004||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02005||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02006||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02007||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02008||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02021||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02022||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02023||
                            
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02024||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02025||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02026||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02027||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02028||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage02029||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage04101||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage04102||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage04104||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage04105||
                            [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage04106
                            ) {
                                if ([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] == GYHDProtobufMessage04102) {
//                                    NSLog([GYUtils localizedStringWithKey:@"GYHD_Friend_add_Friend"]);
                                    NSString *sendTime = contentDict[@"time"];
                                    NSString *sendDateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",
                                                                [sendTime substringWithRange:NSMakeRange(0, 4)],
                                                                [sendTime substringWithRange:NSMakeRange(4, 2)],
                                                                [sendTime substringWithRange:NSMakeRange(6, 2)],
                                                                [sendTime substringWithRange:NSMakeRange(8, 2)],
                                                                [sendTime substringWithRange:NSMakeRange(10, 2)],
                                                                [sendTime substringWithRange:NSMakeRange(12, 2)]];
                                    NSDate *nowdata = [NSDate date];
                                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                    NSString *recvDateString = [formatter stringFromDate:nowdata];

                                    
                                    insertMessageDict[GYHDDataBaseCenterMessageFromID] = [NSString stringWithFormat:@"m_%@@im.gy.com", contentDict[@"content"][@"fromId"] ];
                                    insertMessageDict[GYHDDataBaseCenterMessageToID] = [NSString stringWithFormat:@"m_%@@im.gy.com", contentDict[@"content"][@"toId"] ];
                                    insertMessageDict[GYHDDataBaseCenterMessageContent] = [NSString stringWithFormat:@"您和%@已经成为好友，现在可以聊天了噢", contentDict[@"content"][@"msg_note"]];
                                    insertMessageDict[GYHDDataBaseCenterMessageFriendType] = @"c";;
                                    insertMessageDict[GYHDDataBaseCenterMessageBody] = @"-1";
                                    insertMessageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);;
                                    insertMessageDict[GYHDDataBaseCenterMessageSendTime] = sendDateString;
                                    insertMessageDict[GYHDDataBaseCenterMessageRevieTime] = recvDateString;
                                    insertMessageDict[GYHDDataBaseCenterMessageIsSelf] = @(0);
                                    insertMessageDict[GYHDDataBaseCenterMessageIsRead] = @(1);
                                    insertMessageDict[GYHDDataBaseCenterMessageSendState] = @(GYHDDataBaseCenterMessageSendStateSuccess);;
                                    NSString *fromJID = insertMessageDict[GYHDDataBaseCenterMessageFromID];
                                    NSString *pattern = @"\\d+";
                                    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                                    // 2.测试字符串
                                    NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0, fromJID.length)];
                                    // 3.遍历结果
                                    NSTextCheckingResult *result = [results firstObject];
                                    insertMessageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
                                    pushMessageDict[GYHDDataBaseCenterPushMessageFromID] = insertMessageDict[GYHDDataBaseCenterMessageCard];
                                    pushMessageDict[GYHDDataBaseCenterPushMessageIsRead]        =@(0);
                                    insertMessageDict[GYHDDataBaseCenterMessageData] = @"-1";
                                    insertMessageDict[GYHDDataBaseCenterMessageData] = @"-1";
                                    
                                    NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
                                    friendDict[GYHDDataBaseCenterFriendFriendID] = [insertMessageDict[GYHDDataBaseCenterMessageFromID] substringWithRange:NSMakeRange(2, 13)];
                                    friendDict[GYHDDataBaseCenterFriendCustID] = insertMessageDict[GYHDDataBaseCenterMessageCard];
                                    friendDict[GYHDDataBaseCenterFriendName] = contentDict[@"content"][@"msg_note"];
                                    friendDict[GYHDDataBaseCenterFriendIcon] = contentDict[@"content"][@"msg_icon"];
                                    friendDict[GYHDDataBaseCenterFriendUsetType] = [insertMessageDict[GYHDDataBaseCenterMessageFromID] substringWithRange:NSMakeRange(2, 1)];
                                    friendDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterFriends;
                                    friendDict[GYHDDataBaseCenterFriendMessageTop] = @"-1";
                                    friendDict[GYHDDataBaseCenterFriendInfoTeamID] = @"unteamed";
                                    friendDict[GYHDDataBaseCenterFriendBasic] = @"-1";
                                    friendDict[GYHDDataBaseCenterFriendDetailed] = @"-1";
                                    [[GYHDMessageCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];
                                    
                                    
//                                    [[GYHDMessageCenter sharedInstance] saveMessageWithDict:insertMessageDict];
                                    [[GYHDMessageCenter sharedInstance] insertInfoWithDict:insertMessageDict TableName:GYHDDataBaseCenterMessageTableName];
                                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                    dict[GYHDDataBaseCenterPushMessageIsRead] = @0;
                                    NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                                    condDict[GYHDDataBaseCenterPushMessageCode] = @([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue]);
                                    [[GYHDMessageCenter sharedInstance] updateInfoWithDict:dict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
                                    //                                    [self getFriendListRequetResult:^(NSArray *resultArry) {
                                    NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
                                    frienddeletedict[@"friendChange"] = @(GYHDProtobufMessage04102);
                                    frienddeletedict[@"toID"] =  pushMessageDict[GYHDDataBaseCenterPushMessagePlantFromID] ;
                                    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
                                    //                                    }];
                                    
                                }else if ([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] == GYHDProtobufMessage04104 ||
                                          [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] == GYHDProtobufMessage04105 ||
                                          [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] == GYHDProtobufMessage04106) {
                                    //                                    [self getFriendListRequetResult:^(NSArray *resultArry) {
                                    NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
                                    frienddeletedict[@"friendChange"] = @([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue]);
                                    frienddeletedict[@"toID"] =  bodyDict[@"fromId"];
                                    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
                                    //                                    }];
                                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                    dict[GYHDDataBaseCenterPushMessageIsRead] = @0;
                                    NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                                    condDict[GYHDDataBaseCenterPushMessageCode] = @([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue]);
                                    
                                    [[GYHDMessageCenter sharedInstance] updateInfoWithDict:dict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
                                    
                                  
                                        
                                        NSString *fromJID = bodyDict[@"fromId"];
                                        NSString *pattern = @"\\d+";
                                        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                                        // 2.测试字符串
                                        NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0, fromJID.length)];
                                        // 3.遍历结果
                                        NSTextCheckingResult *result = [results firstObject];
                                        pushMessageDict[GYHDDataBaseCenterPushMessageFromID] = [fromJID substringWithRange:result.range];
                                        pushMessageDict[GYHDDataBaseCenterPushMessageIsRead]        =@(0);
                                     
                                    
                                      
                                        NSMutableDictionary *delectDict = [NSMutableDictionary dictionary];
                                        delectDict[GYHDDataBaseCenterPushMessageFromID] = pushMessageDict[GYHDDataBaseCenterPushMessageFromID];
                                    if ([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] == GYHDProtobufMessage04104 ) {
                        
                                        [[GYHDMessageCenter sharedInstance] deleteMessageWithMessageCard:pushMessageDict[GYHDDataBaseCenterPushMessageFromID]];
                                        [[GYHDMessageCenter sharedInstance]deleteInfoWithDict:delectDict TableName:GYHDDataBaseCenterPushMessageTableName];
                                        
                                    }
                                    
                                    
                                }else if ([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] == GYHDProtobufMessage04101) {
                                    NSString *fromJID = bodyDict[@"fromId"];
                                    NSString *pattern = @"\\d+";
                                    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                                    // 2.测试字符串
                                    NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0, fromJID.length)];
                                    // 3.遍历结果
                                    NSTextCheckingResult *result = [results firstObject];
                                    pushMessageDict[GYHDDataBaseCenterPushMessageFromID] = [fromJID substringWithRange:result.range];

                                    NSMutableDictionary *delectDict = [NSMutableDictionary dictionary];
                                    delectDict[GYHDDataBaseCenterPushMessageFromID] = pushMessageDict[GYHDDataBaseCenterPushMessageFromID];
                                    delectDict[GYHDDataBaseCenterPushMessageCode] = pushMessageDict[GYHDDataBaseCenterPushMessageCode];

                                    NSArray *updataCount =   [[GYHDMessageCenter sharedInstance] selectInfoEqualDict:delectDict TableName:GYHDDataBaseCenterPushMessageTableName];
                                    NSDictionary *lastDict = updataCount.lastObject;
                                    if (lastDict[GYHDDataBaseCenterPushMessageIsRead]) {
                                        NSInteger count =  [lastDict[GYHDDataBaseCenterPushMessageIsRead] integerValue]+1;
                                        pushMessageDict[GYHDDataBaseCenterPushMessageIsRead]        =@(count);
                                    }
                                   [[GYHDMessageCenter sharedInstance]deleteInfoWithDict:delectDict TableName:GYHDDataBaseCenterPushMessageTableName];
                                    
                                }
                            if ([[GYHDMessageCenter sharedInstance] insertInfoWithDict:pushMessageDict TableName:GYHDDataBaseCenterPushMessageTableName]) {

                                if ([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage04104 ||
                                    [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage04105 ||
                                    [pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue] ==  GYHDProtobufMessage04106  ) {
                                    
                                    
                                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                    dict[GYHDDataBaseCenterPushMessageIsRead] = @0;
                                    NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                                    condDict[GYHDDataBaseCenterPushMessageCode] = @([pushMessageDict[GYHDDataBaseCenterPushMessageCode] integerValue]);
                                    [[GYHDMessageCenter sharedInstance] updateInfoWithDict:dict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
                                    
                                } else {
                                    
                                    
                                    [[GYHDMessageCenter sharedInstance] clearMessageHidenWithCustID:[pushMessageDict[GYHDDataBaseCenterPushMessageCode] stringValue]];
                                    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:nil];
                                    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
                                    NSArray *accountArray =  [accountDefaults objectForKey:KUserDefaultAccount];
                                    if (!accountArray) {
                                        AudioServicesPlaySystemSound(1016);
                                    }else {
                                        NSDate *date = [NSDate date];
                                        NSDateFormatter *matter = [[NSDateFormatter alloc] init];
                                        [matter setDateFormat:@"HH"];
                                        NSString *timeString =  [matter stringFromDate:date];
                                        NSLog(@"%d",timeString.intValue);
                                        if ((![(NSNumber *)accountArray[0][0] boolValue] && ![(NSNumber *)accountArray[0][1] boolValue] )||([(NSNumber *)accountArray[0][1] boolValue] &&  timeString.integerValue < 22 && timeString.integerValue  > 8)) {
                                            if ([(NSNumber *)accountArray[0][2] boolValue]) {
                                                NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"tweet_sent",@"caf"];
                                                //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
                                                //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
                                                SystemSoundID sound;
                                                if (path) {
                                                    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
                                                    
                                                    if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
                                                        sound = nil;
                                                    }
                                                    
                                                    AudioServicesPlaySystemSound(sound);
                                                }
                                            }
                                            if ([(NSNumber *)accountArray[0][3] boolValue]) {
                                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                            }
                                        }
                                    }
//                                    if (![[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
//                                        
//                                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//                                        
//                                        localNotification.alertAction = @"Ok";
//                                        localNotification.fireDate = [NSDate new];
//                                        localNotification.timeZone=[NSTimeZone defaultTimeZone];
//                                        
//                                        localNotification.alertBody = insertMessageDict[GYHDDataBaseCenterMessageContent];
//                                        
//                                        localNotification.soundName = UILocalNotificationDefaultSoundName;//通知声音
//                                        
//                                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//                                    }

                                    
                                }

         
                            }
                        }
                        
                        else{
                            DDLogInfo(@"插入推送消息失败");
                        }
                    }

                    
                }
                
                
            }
            
        }
    }];
    
    request.noShowErrorMsg = YES;
//    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
//    }];
}

- (void)deleteRedundantFriendVerifyDataWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler {
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = dict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/deleteRedundantFriendVerifyData", self.bserviceDomain];
    
    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        //            分类修改不成功，暂时在这里加入提示 add zhangx
        handler(responseObject);
    }] start];
}

-(void)updatePrivacyWithString:(NSString *)string RequetResult:(RequetResultWithDict)handler{
    return ;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"searchMe"] = string;
    dict[@"perCustId"] = globalData.loginModel.custId;
    
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = dict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/updatePrivacy", self.bserviceDomain];
    
      GYNetRequest *re = [[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        //            分类修改不成功，暂时在这里加入提示 add zhangx
        handler(responseObject);
      }];
    re.noShowErrorMsg = YES;
    [re start];
}
/**查询个人设置*/
- (void)searchPrivacyRequetResult:(RequetResultWithDict)handler {

    return ;
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = @{@"perCustId":globalData.loginModel.custId};
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/searchPrivacy", self.bserviceDomain];
    
    GYNetRequest *re =  [[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        //            分类修改不成功，暂时在这里加入提示 add zhangx
        handler(responseObject);
    }];
    re.noShowErrorMsg = YES;
    [re start];
}
- (void)searchCompanyTypeRequetResult:(RequetResultWithDict)handler {
    [[[GYNetRequest alloc] initWithBlock:GetShopsMainInterfaceUrl  parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
        handler(responseObject);
    }] start];
}
/**获取周边企业*/
- (void)getTopicListWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler {
    
    [[[GYNetRequest alloc] initWithBlock:GetTopicListUrl  parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
        handler(responseObject);
    }] start];
}
- (void)GetFoodMainPageUrlWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler  {
    [[[GYNetRequest alloc] initWithBlock:GetFoodMainPageUrl  parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
        handler(responseObject);
    }] start];
}

- (void)EasyBuySearchShopUrlWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler {
    [[[GYNetRequest alloc] initWithBlock:EasyBuySearchShopUrl  parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
        handler(responseObject);
    }] start];
}

- (void)getConsumerOrCompanyInfoWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler {
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = dict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/getConsumerOrCompanyInfo", self.bserviceDomain];
    
    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        //            分类修改不成功，暂时在这里加入提示 add zhangx
        handler(responseObject);
    }] start];
}
- (void)GetVShopShortlyInfoUrlWithResourcesNo:(NSString *)string RequetResult:(RequetResultWithDict)handler {

    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetVShopShortlyInfoUrl parameters:@{ @"key" : globalData.loginModel.token,
                                                                                                     @"resourceNo" : string } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
                                                                                                         handler(responseObject);
                                                                                                     }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)getUserByPhoneContactsWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler {
    
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = dict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;


//
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/getUserByPhoneContacts", self.bserviceDomain];
//    NSString *urlString = @"http://192.168.41.193:8089/hsim-bservice/userCenter/getUserByPhoneContacts";
    [[[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict  requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        //            分类修改不成功，暂时在这里加入提示 add zhangx
        handler(responseObject);
    }] start];
}
@end

//- (void)getFriendDetailWithAccountID:(NSString *)accountID RequetResult:(RequetResultWithDict)handler {
//
//    GlobalData *data = globalData;
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:globalData.loginModel.token forKey:@"key"];
//    [dict setValue:data.midKey forKey:@"mid"];
//    NSMutableDictionary *insideDict = [NSMutableDictionary dictionary];
//
//    [insideDict setValue:accountID forKey:@"accountId"];
//    [insideDict setValue:globalData.loginModel.custId forKey:@"friendId"];
//    [dict setValue:insideDict forKey:@"data"];
//
//
//    [GYNetwork requestURL:QueryPersonInfoUrl parameters:dict option:POST_JSON_HTTP success:^(NSDictionary *responseObject) {
//        handler(responseObject);
//    } failure:^(NSError *error, NSDictionary *tmpResponseObject) {
//
//    }];
//
//
//}
