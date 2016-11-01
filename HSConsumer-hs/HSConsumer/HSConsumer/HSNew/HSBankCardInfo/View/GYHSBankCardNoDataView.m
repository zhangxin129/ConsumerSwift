//
//  GYHSBankCardNoDataView.m
//  HSConsumer
//
//  Created by lizp on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBankCardNoDataView.h"
#import "YYKit.h"
#import "GYHSTools.h"

@implementation GYHSBankCardNoDataView



-(instancetype)init {
    if(self = [super init]) {
        [self setUp];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


-(void)setUp {

    UIImageView *noDataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-15, self.top + 59, 30, 37)];
    noDataImageView.image = [UIImage imageNamed:@"gycommon_search_norecord"];
    [self addSubview:noDataImageView];
    
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, noDataImageView.bottom + 10, self.bounds.size.width, 20)];
    noDataLabel.text = kLocalized(@"GYHS_Address_NoAnyBankCard");
    noDataLabel.textColor  = UIColorFromRGB(0x999999);
    noDataLabel.font = kBankCardNoDataFont;
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noDataLabel];
}

@end
