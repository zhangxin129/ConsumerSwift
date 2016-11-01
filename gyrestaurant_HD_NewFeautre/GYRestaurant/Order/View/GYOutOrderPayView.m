//
//  GYOutOrderPayView.m
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOutOrderPayView.h"
#import "GYOrdDetailModel.h"
#import "NSString+GYJSONObject.h"

@interface GYOutOrderPayView ()

@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *deliverCountLable;

@property (weak, nonatomic) IBOutlet UILabel *orderPayLable;
@property (weak, nonatomic) IBOutlet UILabel *pointLable;
@property (weak, nonatomic) IBOutlet UILabel *postPayLable;
@property (weak, nonatomic) IBOutlet UILabel *payLable;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLB;
@property (weak, nonatomic) IBOutlet UILabel *monegLB;
@property (weak, nonatomic) IBOutlet UILabel *sendPayLB;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLB;
@property (weak, nonatomic) IBOutlet UILabel *pointLB;
@property (weak, nonatomic) IBOutlet UILabel *sendDealsLB;
@property (weak, nonatomic) IBOutlet UILabel *shouldPayLB;
@property (weak, nonatomic) IBOutlet UIImageView *coinView1;
@property (weak, nonatomic) IBOutlet UIImageView *coinView2;
@property (weak, nonatomic) IBOutlet UIImageView *coinView3;
@property (weak, nonatomic) IBOutlet UIImageView *coinView4;

@property (weak, nonatomic) IBOutlet UIImageView *pointView;
@property (weak, nonatomic) IBOutlet UIImageView *xuxianView1;
@property (weak, nonatomic) IBOutlet UIImageView *xuxianView2;
@property (weak, nonatomic) IBOutlet UIView *shixianView;

@end


@implementation GYOutOrderPayView


- (void)updateConstraints
{
    [super updateConstraints];
       
    
    float orderNumLBW = 100;
    float monegLBW = 100;
    float sendPayLBW = 100;
    float phoneNumLBW = 155;
    float pointLBW = 64;
   // float sendDealsLBW = 106;
    float shouldPayLBW = 123;
    float payBtn = 161;
    float orderLableW = 232;
    float phoneLableW = 230;
    float orderPayLableW = 232;
    float pointLableW = 230;
    float postPayLableW = 232;
    float deliverCountLableW = 230;
    float payLableW = 100;
    
    
    float x = (kScreenWidth- orderNumLBW -orderLableW - phoneNumLBW-phoneLableW)/3;
    float y = (kScreenWidth - payBtn)/2;
    
    [self.orderNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(x);
        make.top.equalTo(self.mas_top).offset(50);
        make.height.equalTo(@31);
        make.width.equalTo(@(orderNumLBW));
        
    }];
    self.orderNumLB.adjustsFontSizeToFitWidth = YES;
    [self.orderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(x + orderNumLBW);
        make.top.equalTo(self.mas_top).offset(50);
        make.height.equalTo(@31);
        make.width.equalTo(@(orderLableW));
    }];
    self.orderLable.adjustsFontSizeToFitWidth = YES;
    [self.phoneNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(2 * x + orderNumLBW + orderLableW );
        make.top.equalTo(self.mas_top).offset(50);
        make.height.equalTo(@31);
        make.width.equalTo(@(phoneNumLBW));
        
    }];
    self.phoneNumLB.adjustsFontSizeToFitWidth= YES;
    [self.phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(2 * x + orderNumLBW + orderLableW + phoneNumLBW );
        make.top.equalTo(self.mas_top).offset(50);
        make.height.equalTo(@31);
        make.width.equalTo(@(phoneLableW));
        
    }];
    self.phoneLable.adjustsFontSizeToFitWidth = YES;
    
    [self.xuxianView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( x );
        make.top.equalTo(self.mas_top).offset(50 + 31 + 25);
        make.height.equalTo(@1);
        make.width.equalTo(@(kScreenWidth));
        
    }];

    
    [self.monegLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( x );
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50);
        make.height.equalTo(@31);
        make.width.equalTo(@(monegLBW));
        
    }];
    self.monegLB.adjustsFontSizeToFitWidth = YES;
    [self.coinView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( x + monegLBW);
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 + 5);
        make.height.equalTo(@20);
        make.width.equalTo(@(20));
        
    }];

    
    [self.orderPayLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( x + monegLBW + 20);
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50);
        make.height.equalTo(@31);
        make.width.equalTo(@(orderPayLableW));
        
    }];
    self.orderPayLable.adjustsFontSizeToFitWidth = YES;
    [self.pointLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + monegLBW + orderPayLableW );
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 );
        make.height.equalTo(@31);
        make.width.equalTo(@(pointLBW));
        
    }];
    self.pointLB.adjustsFontSizeToFitWidth = YES;
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + monegLBW + orderPayLableW + pointLBW);
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 + 5);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];

    
    [self.pointLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + monegLBW + orderPayLableW + pointLBW +20);
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50);
        make.height.equalTo(@31);
        make.width.equalTo(@(pointLableW));
        
    }];
    self.pointLable.adjustsFontSizeToFitWidth = YES;
   
    
//    [self.sendDealsLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset( 2 * x + sendPayLBW + postPayLableW );
//        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31 +50);
//        make.height.equalTo(@31);
//        make.width.equalTo(@(sendDealsLBW));
//        
//    }];
//    self.sendDealsLB.adjustsFontSizeToFitWidth = YES;
    
    [self.deliverCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + sendPayLBW + postPayLableW );
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31 +50);
        make.height.equalTo(@31);
        make.width.equalTo(@(deliverCountLableW));
        
    }];
    self.deliverCountLable.adjustsFontSizeToFitWidth = YES;
    
    [self.sendPayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + sendPayLBW + postPayLableW + deliverCountLableW + 20);
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31 +50);
        make.height.equalTo(@31);
        make.width.equalTo(@(sendPayLBW));
        
    }];
    self.sendPayLB.adjustsFontSizeToFitWidth = YES;
    
    [self.coinView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + sendPayLBW + postPayLableW + deliverCountLableW + 20 + sendPayLBW);
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31 +50 + 5);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];
    
    [self.postPayLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + sendPayLBW + postPayLableW + deliverCountLableW + 20 + sendPayLBW + 20);
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31 +50);
        make.height.equalTo(@31);
        make.width.equalTo(@(postPayLableW));
        
    }];
    self.postPayLable.adjustsFontSizeToFitWidth = YES;
   
    [self.xuxianView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( x );
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31  + 25);
        make.height.equalTo(@1);
        make.width.equalTo(@(kScreenWidth));
        
    }];
    

    
    [self.shouldPayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + monegLBW + orderPayLableW);
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31 +50 +31 +50);
        make.height.equalTo(@31);
        make.width.equalTo(@(shouldPayLBW));
        
    }];
    self.shouldPayLB.adjustsFontSizeToFitWidth = YES;
    [self.coinView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + sendPayLBW + postPayLableW  + shouldPayLBW -10);
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31 +50 +31 +50 +5);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];
    
    [self.payLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + sendPayLBW + postPayLableW  + shouldPayLBW + 20 - 10);
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31 +50 +31 +50 );
        make.height.equalTo(@31);
        make.width.equalTo(@(payLableW));
        
    }];
    self.payLable.adjustsFontSizeToFitWidth = YES;
    
    [self.shixianView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31 +50 +31 +50 + 50);
        make.height.equalTo(@1);
        make.width.equalTo(@(kScreenWidth));
        make.left.equalTo(self.mas_left).offset(0);
        
    }];

    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(50 + 31 + 50 +31 +50 +31 +50 + 100);
        make.height.equalTo(@50);
        make.width.equalTo(@(161));
        make.left.equalTo(self.mas_left).offset(y);
        
    }];
}




//刷新视图详情
- (void)refreshUI:(GYOrdDetailModel*)model
{
    GYOrdDetailModel *detailModel = [GYOrdDetailModel new];
    detailModel = model;
    
    self.orderLable.text = detailModel.orderId;
    self.phoneLable.text=detailModel.resNo;
    self.orderPayLable.text = detailModel.totalAmount;
    self.pointLable.text = detailModel.totalPv;
    self.postPayLable.text = detailModel.deliverFee;
  //  self.deliverCountLable.text = detailModel.deliDiscount;
    self.payLable.text = detailModel.amountActually;
    
    NSDictionary *deliDiscountDict =[detailModel.deliDiscount dictionaryValue];
    if ( [deliDiscountDict[@"manPirce"] length] > 0 && [deliDiscountDict[@"jianPrice"] length] > 0) {
        
        self.deliverCountLable.text = [NSString stringWithFormat:@"订单满%@减%@元配送费",deliDiscountDict[@"manPirce"],deliDiscountDict[@"jianPrice"]];
    }else{
        
        self.deliverCountLable.text = kLocalized(@"NoDistributionDeals");
        
    }

    
    
    self.orderNumLB.text = kLocalized(@"ordernumber1");
    self.monegLB.text = kLocalizedAddParams(kLocalized(@"OrderAmount"), @"：") ;
    self.sendPayLB.text = kLocalized(@"Shipment1");;
    self.phoneNumLB.text = kLocalizedAddParams(kLocalized(@"AlternateNumber/MobilePhoneNumber"), @"：");
    self.pointLB.text = kLocalizedAddParams(kLocalized(@"Integration"), @"：");
//    self.sendDealsLB.text = kLocalizedAddParams(kLocalized(@"DistributionDeals"), @"：");
    self.shouldPayLB.text = kLocalizedAddParams(kLocalized(@"AmountsPayable"), @"：");
    [self.payBtn setTitle:@"现金收款" forState:UIControlStateNormal];
    
    self.payBtn.layer.cornerRadius = 10.0;
}

- (IBAction)btnClick:(id)sender {

    if (self.sendBlock) {
        self.sendBlock(sender);
    }


}


@end
