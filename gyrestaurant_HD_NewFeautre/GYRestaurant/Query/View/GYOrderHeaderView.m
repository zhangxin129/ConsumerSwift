//
//  GYOrderHeaderView.m
//  GYRestaurant
//
//  Created by apple on 15/10/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderHeaderView.h"
#define viewHeight 50.0f

@interface GYOrderHeaderView()
@property(nonatomic,strong)UILabel *orderNumLable;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UILabel *strTimeLable;
@property(nonatomic,strong)UILabel *stateLable;
@property(nonatomic,strong)UILabel *totalLable;
@property(nonatomic,strong)UILabel *endTimeLable;
@property(nonatomic,strong)UILabel *payStateLable;
@property(nonatomic,strong)UILabel *classLable;
@end

@implementation GYOrderHeaderView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        float orderNumLableW = 146;
        float nameLableW = 120;
        float strTimeLableW = 120;
        float stateLableW = 99;
        float totalLableW = 88;
        float endTimeLableW = 120;
        float payStateLableW = 77;
        float classLableW = 80;
        
        
        float x = (kScreenWidth - 0.15 * kScreenWidth - orderNumLableW -nameLableW - strTimeLableW-stateLableW - totalLableW- endTimeLableW - payStateLableW - classLableW)/9;

        
        
       self.orderNumLable=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, orderNumLableW, viewHeight)];
      

        self.orderNumLable.text=kLocalized(@"OrderNumber");
        self.orderNumLable.font=[UIFont systemFontOfSize:17];
        self.orderNumLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.orderNumLable];
        
        self.nameLable=[[UILabel alloc] initWithFrame:CGRectMake(x + orderNumLableW, 0, nameLableW, viewHeight)];
        self.nameLable.text=kLocalized(@"AlternateNumber/MobilePhoneNumber");
        self.nameLable.font=[UIFont systemFontOfSize:17];
        self.nameLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.nameLable];
        
        self.strTimeLable=[[UILabel alloc] initWithFrame:CGRectMake( 2 * x + orderNumLableW + nameLableW, 0, strTimeLableW, viewHeight)];
        self.strTimeLable.text=kLocalized(@"OrderTime");
        self.strTimeLable.font=[UIFont systemFontOfSize:17];
        self.strTimeLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.strTimeLable];
        
        self.stateLable=[[UILabel alloc]initWithFrame:CGRectMake( 3 * x + orderNumLableW + nameLableW + strTimeLableW, 0, stateLableW, viewHeight)];
        self.stateLable.text=kLocalized(@"OrderStatus");
        self.stateLable.font=[UIFont systemFontOfSize:17];
        self.stateLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.stateLable];
        
        self.totalLable=[[UILabel alloc] initWithFrame:CGRectMake( 4 * x + orderNumLableW + nameLableW + strTimeLableW + stateLableW, 0, totalLableW, viewHeight)];
        self.totalLable.text=kLocalized(@"OrderAmount");
        self.totalLable.font=[UIFont systemFontOfSize:17];
        self.totalLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.totalLable];
        
        self.endTimeLable=[[UILabel alloc] initWithFrame:CGRectMake(5 * x + orderNumLableW + nameLableW + strTimeLableW + stateLableW + totalLableW, 0, endTimeLableW, viewHeight)];
        self.endTimeLable.text=kLocalized(@"CheckoutTime");
        self.endTimeLable.font=[UIFont systemFontOfSize:17];
        self.endTimeLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.endTimeLable];
        
        self.payStateLable=[[UILabel alloc] initWithFrame:CGRectMake( 6 * x +orderNumLableW + nameLableW + strTimeLableW + stateLableW + totalLableW + endTimeLableW, 0, payStateLableW, viewHeight)];
        self.payStateLable.text=kLocalized(@"PaymentStatus");
        self.payStateLable.font=[UIFont systemFontOfSize:17];
        self.payStateLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.payStateLable];
        
        self.classLable=[[UILabel alloc] initWithFrame:CGRectMake(7 * x + orderNumLableW + nameLableW + strTimeLableW + stateLableW + totalLableW + endTimeLableW + payStateLableW , 0, classLableW, viewHeight)];
        self.classLable.text=kLocalized(@"DiningWay");
        self.classLable.font=[UIFont systemFontOfSize:17];
        self.classLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.classLable ];
    }
    
    
    return  self;
    
}

@end
