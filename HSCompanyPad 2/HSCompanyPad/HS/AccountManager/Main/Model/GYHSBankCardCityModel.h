//
//  GYHSBankCardCityModel.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
@interface GYHSBankCardCityModel : JSONModel
@property (nonatomic, copy) NSString *cityNameCn;//城市中文名
@property (nonatomic, copy) NSString *cityNo;//城市代码
@property (nonatomic, copy) NSString *cityFullName;//城市全名
@property (nonatomic, copy) NSString *delFlag;//删除标识
@property (nonatomic, copy) NSString *population;//人口数
@property (nonatomic, copy) NSString *postCode;//邮政编号
@property (nonatomic, copy) NSString *countryNo;//国家代码
@property (nonatomic, copy) NSString *version;//版本号
@property (nonatomic, copy) NSString *phonePrefix;//电话区号
@property (nonatomic, copy) NSString *provinceNo;//省份代码
@property (nonatomic, copy) NSString *cityName;//城市名称


@end
