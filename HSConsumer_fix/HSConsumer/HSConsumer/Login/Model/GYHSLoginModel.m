//
//  GYHSLoginModel.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginModel.h"

@implementation GYHSLoginModel

- (NSString*)hdhost
{

    return [[NSURL URLWithString:self.hdDomain] host];
}

- (int)hdPort
{

    return [[[NSURL URLWithString:self.hdDomain] port] intValue];
}

- (NSString*)pushHdhost
{

    return [[NSURL URLWithString:self.pushDomain] host];
}

- (int)pusHdPort
{
    return [[[NSURL URLWithString:self.pushDomain] port] intValue];
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self == [super init]) {
        _userName = [aDecoder decodeObjectForKey:@"_userName"];
        _token = [aDecoder decodeObjectForKey:@"_token"];
        _sex = [aDecoder decodeObjectForKey:@"_sex"];
        _reserveInfo = [aDecoder decodeObjectForKey:@"_reserveInfo"];
        _resNo = [aDecoder decodeObjectForKey:@"_resNo"];
        _nickName = [aDecoder decodeObjectForKey:@"_nickName"];
        _netWorkVer = [aDecoder decodeObjectForKey:@"_netWorkVer"];
        _mobile = [aDecoder decodeObjectForKey:@"_mobile"];
        _mainInfoStatus = [aDecoder decodeObjectForKey:@"_mainInfoStatus"];
        _lastLoginIp = [aDecoder decodeObjectForKey:@"_lastLoginIp"];
        _lastLoginDate = [aDecoder decodeObjectForKey:@"_lastLoginDate"];
        _job = [aDecoder decodeObjectForKey:@"_job"];
        _isRealnameAuth = [aDecoder decodeObjectForKey:@"_isRealnameAuth"];
        _isLocal = [aDecoder decodeObjectForKey:@"_isLocal"];
        _isBindBank = [aDecoder decodeObjectForKey:@"_isBindBank"];
        _isAuthMobile = [aDecoder decodeObjectForKey:@"_isAuthMobile"];
        _isAuthEmail = [aDecoder decodeObjectForKey:@"_isAuthEmail"];
        _homeAddress = [aDecoder decodeObjectForKey:@"_homeAddress"];
        _headPic = [aDecoder decodeObjectForKey:@"_headPic"];
        _entResNo = [aDecoder decodeObjectForKey:@"_entResNo"];
        _email = [aDecoder decodeObjectForKey:@"_email"];
        _custName = [aDecoder decodeObjectForKey:@"_custName"];
        _custId = [aDecoder decodeObjectForKey:@"_custId"];
        _creType = [aDecoder decodeObjectForKey:@"_creType"];
        _creNo = [aDecoder decodeObjectForKey:@"_creNo"];
        _creExpiryDate = [aDecoder decodeObjectForKey:@"_creExpiryDate"];
        _birthAddress = [aDecoder decodeObjectForKey:@"_birthAddress"];
        _entRegAddr = [aDecoder decodeObjectForKey:@"_entRegAddr"];
        _baseStatus = [aDecoder decodeObjectForKey:@"_baseStatus"];
        _webUrl = [aDecoder decodeObjectForKey:@"_webUrl"];
        _picUrl = [aDecoder decodeObjectForKey:@"_picUrl"];
        _phapiUrl = [aDecoder decodeObjectForKey:@"_phapiUrl"];
        _foodUrl = [aDecoder decodeObjectForKey:@"_foodUrl"];
        _tfsDomain = [aDecoder decodeObjectForKey:@"_tfsDomain"];
        _hdbizDomain = [aDecoder decodeObjectForKey:@"_hdbizDomain"];
        _hsUrl = [aDecoder decodeObjectForKey:@"_hsUrl"];
        _hdimVhosts = [aDecoder decodeObjectForKey:@"_hdimVhosts"];
        _pushDomain = [aDecoder decodeObjectForKey:@"_pushDomain"];
        _hdDomain = [aDecoder decodeObjectForKey:@"_hdDomain"];
        _hdhost = [aDecoder decodeObjectForKey:@"_hdhost"];
        _hdPort = [aDecoder decodeIntForKey:@"_hdPort"];
        _pushHdhost = [aDecoder decodeObjectForKey:@"_pushHdhost"];
        _pusHdPort = [aDecoder decodeIntForKey:@"_pusHdPort"];
        _cardHolder = [aDecoder decodeBoolForKey:@"_cardHolder"];
        _ttMsgServer = [aDecoder decodeObjectForKey:@"_ttMsgServer"];
        _hdimPsiServer = [aDecoder decodeObjectForKey:@"_hdimPsiServer"];
        _hdimImgcAddr = [aDecoder decodeObjectForKey:@"_hdimImgcAddr"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_userName forKey:@"_userName"];
    [aCoder encodeObject:_token forKey:@"_token"];
    [aCoder encodeObject:_sex forKey:@"_sex"];
    [aCoder encodeObject:_reserveInfo forKey:@"_reserveInfo"];
    [aCoder encodeObject:_resNo forKey:@"_resNo"];
    [aCoder encodeObject:_nickName forKey:@"_nickName"];
    [aCoder encodeObject:_netWorkVer forKey:@"_netWorkVer"];
    [aCoder encodeObject:_mobile forKey:@"_mobile"];
    [aCoder encodeObject:_mainInfoStatus forKey:@"_mainInfoStatus"];
    [aCoder encodeObject:_lastLoginIp forKey:@"_lastLoginIp"];
    [aCoder encodeObject:_lastLoginDate forKey:@"_lastLoginDate"];
    [aCoder encodeObject:_job forKey:@"_job"];
    [aCoder encodeObject:_isRealnameAuth forKey:@"_isRealnameAuth"];
    [aCoder encodeObject:_isLocal forKey:@"_isLocal"];
    [aCoder encodeObject:_isBindBank forKey:@"_isBindBank"];
    [aCoder encodeObject:_isAuthMobile forKey:@"_isAuthMobile"];
    [aCoder encodeObject:_isAuthEmail forKey:@"_isAuthEmail"];
    [aCoder encodeObject:_homeAddress forKey:@"_homeAddress"];
    [aCoder encodeObject:_headPic forKey:@"_headPic"];
    [aCoder encodeObject:_entResNo forKey:@"_entResNo"];
    [aCoder encodeObject:_email forKey:@"_email"];
    [aCoder encodeObject:_custName forKey:@"_custName"];
    [aCoder encodeObject:_custId forKey:@"_custId"];
    [aCoder encodeObject:_creType forKey:@"_creType"];
    [aCoder encodeObject:_creNo forKey:@"_creNo"];
    [aCoder encodeObject:_creExpiryDate forKey:@"_creExpiryDate"];
    [aCoder encodeObject:_birthAddress forKey:@"_birthAddress"];
    [aCoder encodeObject:_entRegAddr forKey:@"_entRegAddr"];
    [aCoder encodeObject:_baseStatus forKey:@"_baseStatus"];
    [aCoder encodeObject:_webUrl forKey:@"_webUrl"];
    [aCoder encodeObject:_picUrl forKey:@"_picUrl"];
    [aCoder encodeObject:_phapiUrl forKey:@"_phapiUrl"];
    [aCoder encodeObject:_foodUrl forKey:@"_foodUrl"];
    [aCoder encodeObject:_tfsDomain forKey:@"_tfsDomain"];
    [aCoder encodeObject:_hdbizDomain forKey:@"_hdbizDomain"];
    [aCoder encodeObject:_hsUrl forKey:@"_hsUrl"];
    [aCoder encodeObject:_hdimVhosts forKey:@"_hdimVhosts"];
    [aCoder encodeObject:_pushDomain forKey:@"_pushDomain"];
    [aCoder encodeObject:_hdDomain forKey:@"_hdDomain"];
    [aCoder encodeObject:_hdhost forKey:@"_hdhost"];
    [aCoder encodeInt:_hdPort forKey:@"_hdPort"];
    [aCoder encodeObject:_pushHdhost forKey:@"_pushHdhost"];
    [aCoder encodeInt:_pusHdPort forKey:@"_pusHdPort"];
    [aCoder encodeBool:_cardHolder forKey:@"_cardHolder"];
    [aCoder encodeObject:_ttMsgServer forKey:@"_ttMsgServer"];
    [aCoder encodeObject:_hdimPsiServer forKey:@"_hdimPsiServer"];
    [aCoder encodeObject:_hdimImgcAddr forKey:@"_hdimImgcAddr"];
}

@end
