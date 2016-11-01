//
//  GYHDCountryHeaderView.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCountryHeaderView.h"
#import "GYHSTools.h"

@implementation GYHDCountryHeaderView

- (void)awakeFromNib {
    self.centerView.backgroundColor = kDefaultVCBackgroundColor;
    self.backgroundColor = kDefaultVCBackgroundColor;
    self.countryLb.textColor = kcurrencyBalanceCorlor;
    self.chooseLb.textColor = kcurrencyBalanceCorlor;
    self.allCountryLb.textColor = kcurrencyBalanceCorlor;
    self.selectedLb.textColor = kcurrencyBalanceCorlor;
}


@end
