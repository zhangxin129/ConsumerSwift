//
//  GYHSBankCardNoRealNameView.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/25.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBankCardNoRealNameView.h"
#import "YYKit.h"
#import "GYHSTools.h"
@implementation GYHSBankCardNoRealNameView

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


-(void)setUp {
    
    UIImageView *noDataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-15, self.top + 150, 30, 37)];
    noDataImageView.image = [UIImage imageNamed:@"gycommon_search_norecord"];
    [self addSubview:noDataImageView];
    
    //标示语
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, noDataImageView.bottom + 10, self.bounds.size.width, 20)];
    noDataLabel.text = kLocalized(@"您没有实名注册,请先进行实名注册!");
    noDataLabel.textColor  = UIColorFromRGB(0x999999);
    noDataLabel.font = kBankCardNoDataFont;
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noDataLabel];
    
    //button
    NSString* teamName = @"实名注册";
    NSMutableDictionary* normalDict = [NSMutableDictionary dictionary];
    normalDict[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    normalDict[NSForegroundColorAttributeName] = UIColorFromRGB(0x999999);//[UIColor colorWithRed:51 / 255.0f green:51 / 255.0f blue:51 / 255.0f alpha:1];
    
    NSAttributedString* normalAttString = [[NSMutableAttributedString alloc] initWithString:teamName attributes:normalDict];
    
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-35, noDataLabel.bottom + 15, 70, 22)];
    
    [registBtn setAttributedTitle:normalAttString forState:UIControlStateNormal];
    registBtn.layer.borderWidth = 1;
    registBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;//[UIColor colorWithRed:51 / 255.0f green:51 / 255.0f blue:51 / 255.0f alpha:1].CGColor;
    [registBtn addTarget:self action:@selector(registeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    noDataLabel.text = kLocalized(@"您没有实名注册,请先进行实名注册!");
//    noDataLabel.textColor  = UIColorFromRGB(0x999999);
//    noDataLabel.font = kBankCardNoDataFont;
//    noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:registBtn];
    
    
    
}
//
-(void)registeBtnClick:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToRegistNameVC)]) {
        [self.delegate pushToRegistNameVC];
    }
}

@end
