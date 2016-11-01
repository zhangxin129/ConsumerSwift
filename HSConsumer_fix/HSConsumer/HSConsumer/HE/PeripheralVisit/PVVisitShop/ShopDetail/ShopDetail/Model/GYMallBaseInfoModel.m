//
//  GYMallBaseInfoModel.m
//  HSConsumer
//
//  Created by Apple03 on 15/9/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMallBaseInfoModel.h"

@implementation GYMallBaseInfoModel

#pragma mark 加载商城详情
+ (void)loadBigShopDataWithVshopid:(NSString*)vShopID landMark:(NSString*)landMark result:(dictResult)result
{
    if ([vShopID isKindOfClass:[NSNull class]] || !vShopID || vShopID.length == 0) {
        result(nil, nil, nil);
    }
    else {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        if (globalData.loginModel.token == nil) {

            [dict setValue:@"" forKey:@"key"];
        }
        else {

            [dict setValue:globalData.loginModel.token forKey:@"key"];
        }

        [dict setValue:vShopID forKey:@"vShopId"];
        [dict setValue:landMark forKey:@"landmark"];
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetVShopIntroductionUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
            
            NSString *strRetCode = [NSString stringWithFormat:@"%@",responseObject[@"retCode"]];
            if (error) {
                result(nil, error,nil);
                [GYUtils parseNetWork:error resultBlock:nil];
            } else {
                NSDictionary *dictALL = responseObject;
                NSInteger code = kSaftToNSInteger([dictALL objectForKey:@"retCode"]);
                if (code == 200) {

                    NSDictionary *dictData = [dictALL objectForKey:@"data"];
                    if (dictData.count > 0) {
                        result(dictData, nil,nil);
                    } else {
                        result(nil, nil,nil);
                    }
                } else if([strRetCode isEqualToString:@"855"]){
                    result(nil, nil,strRetCode);
                }else {
                    result(nil, nil,nil);
                }
            }
        }];
        [request start];
    }
}

+ (NSDictionary*)objectClassInArray
{

    return @{ @"picList" : @"GYMallBaseInfoPicListModel",
        @"shops" : @"GYMallBaseInfoShopsModel" };
}

@end

@implementation GYMallBaseInfoPicListModel

@end


@implementation GYMallBaseInfoShopsModel

@end
