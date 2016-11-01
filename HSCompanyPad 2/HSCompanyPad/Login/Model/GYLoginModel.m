//
//  GYLoginModel.m
//  company
//
//  Created by sqm on 15/12/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYLoginModel.h"
#import <MJExtension/MJExtension.h>
#import "GYLoginEn.h"
@implementation GYLoginModel
MJCodingImplementation
+ (NSDictionary*)mj_objectClassInArray
{
    return @{ @"roles" : @"Role" };
}

#pragma mark 互动域名暂时性写死 add zhangx

-(NSString *)hdbizDomain{
    
    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
        
        return @"http://192.168.229.11:9090";
        
    }else if ([GYLoginEn sharedInstance].loginLine==kLoginEn_testB){
        
        return  @"http://192.168.233.138:8080";
        
    }
    return @"";

}

-(NSString *)hdimImgcAddr{

    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
        
          return @"http://192.168.229.11:9090";
        
    }else if ([GYLoginEn sharedInstance].loginLine==kLoginEn_testB){
        
        return  @"http://192.168.233.138:8080";
        
    }
    return @"";
}

@end


@implementation Role
MJCodingImplementation
@end
    
@implementation PlatInfo
    
@end
    
@implementation BankModel

MJCodingImplementation
        
@end
    
@implementation companyStatuModel
    
- (companyStatu)appStatu
{

    return _baseStatus.intValue;
}

@end

@implementation memberQuitStatus

+ (NSDictionary*)mj_replacedKeyFromPropertyName
{
    return @{ @"statusS" : @"status" };
}

- (companyLogoutStatu)status
{
    return [self.statusS intValue];
}

@end

@implementation pointActivityStatus

+ (NSDictionary*)mj_replacedKeyFromPropertyName
{
    return @{ @"statusS" : @"status" };
}

- (companyPointActStatu)status
{

    return [self.statusS intValue];
}
@end
@implementation GYEntGlobalData
MJCodingImplementation
@end
