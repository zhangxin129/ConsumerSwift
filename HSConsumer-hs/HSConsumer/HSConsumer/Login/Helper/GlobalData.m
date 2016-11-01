//
//  GlobalData.m
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData

+ (instancetype)shareInstance
{
    static GlobalData* instaceObj;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instaceObj = [[GlobalData alloc] init];
    });

    return instaceObj;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setInitValues];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (GYHSLocalInfoModel*)localInfoModel
{
    if (_localInfoModel == nil) {
        _localInfoModel = [[GYHSLoginManager shareInstance] localInfoModel];
    }

    return _localInfoModel;
}

- (NSString*)retailDomain
{
    return self.loginModel.phapiUrl ? self.loginModel.phapiUrl : [[GYHSLoginEn sharedInstance] getDefaultRetailDomain];
}

- (NSString*)foodConsmerDomain
{
    return self.loginModel.foodUrl ? self.loginModel.foodUrl : [[GYHSLoginEn sharedInstance] getFoodConsmerDomain];
}

- (void)setSelectedCityName:(NSString*)selectedCityName
{
    if (selectedCityName && selectedCityName.length > 0) {
        _selectedCityName = selectedCityName;
        [[NSNotificationCenter defaultCenter] postNotificationName:KChangeLocationNotice object:selectedCityName];
    }
}

#pragma mark - private methods
- (void)setInitValues
{
    _isLogined = NO;
    _isHdLogined = NO;
    _user = [[GYHSUserData alloc] init];
    _personInfo = [[GYPersonInfo alloc] init];
}

@end
