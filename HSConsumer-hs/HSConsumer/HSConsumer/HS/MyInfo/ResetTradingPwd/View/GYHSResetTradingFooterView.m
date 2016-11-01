//
//  GYHSResetTradingFooterView.m
//  HSConsumer
//
//  Created by lizp on 16/8/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSResetTradingFooterView.h"
#import "YYKit.h"

@interface GYHSResetTradingFooterView()

@property (nonatomic,weak) YYLabel *tipLabel;

@end

@implementation GYHSResetTradingFooterView


-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

////    NSString *tipStr = @"温馨提示:此业务办理需通过实名认证!";
//    NSMutableAttributedString *tipAttributedString = [[NSMutableAttributedString alloc] initWithString:self.tipStr];
//    CGFloat height = [GYUtils heightForString:self.tipStr fontSize:14 andWidth:kScreenWidth-20];
//    YYLabel *tipLabel = [[YYLabel alloc] initWithFrame:CGRectMake(10, self.top +10, kScreenWidth-20, height)];
//    tipLabel.numberOfLines = 0;
//    tipLabel.font = [UIFont systemFontOfSize:14];
//    tipLabel.attributedText = tipAttributedString;
//    [self addSubview:tipLabel];
//    
//    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    confirmBtn.frame = CGRectMake(tipLabel.left, tipLabel.bottom+20, tipLabel.width, 50);
//    confirmBtn.backgroundColor = [UIColor orangeColor];
//    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:confirmBtn];
    
    
    
    YYLabel *tipLabel = [[YYLabel alloc] initWithFrame:CGRectMake(10, self.top +10, kScreenWidth-20, 20)];
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(tipLabel.left, tipLabel.bottom+20, tipLabel.width, 50);
    confirmBtn.backgroundColor = [UIColor orangeColor];
    [confirmBtn setTitle:kLocalized(@"GYHS_Pwd_Confirm") forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];

    

}

-(void)setTipStr:(NSString *)tipStr {
    //    NSString *tipStr = @"温馨提示:此业务办理需通过实名认证!";
    NSMutableAttributedString *tipAttributedString = [[NSMutableAttributedString alloc] initWithString:self.tipStr];
    CGFloat height = [GYUtils heightForString:self.tipStr fontSize:14 andWidth:kScreenWidth-20];
//    self.tipLabel.frame = 
}

-(void)confirmBtnClick {

    if(self.delegate && [self.delegate respondsToSelector:@selector(footerConfirmClick)]) {
        [self.delegate footerConfirmClick];
    }
}

@end
