//
//  GYListHeaderView.m
//  GYRestaurant
//
//  Created by apple on 15/10/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYListHeaderView.h"
#define viewHeight 50.0f

@interface GYListHeaderView()
@property(nonatomic,strong)UILabel *numLable;
@property(nonatomic,strong)UILabel *classLable;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UILabel *sizeLable;
@property(nonatomic,strong)UILabel *priceLable;
@property(nonatomic,strong)UILabel *pointLable;
@property(nonatomic,strong)UILabel *timeLable;
@property(nonatomic,strong)UILabel *stateLable;
@end

@implementation GYListHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        float numLableW = 80;
        float classLableW = 65;
        float nameLableW = 101;
        float sizeLableW = 50;
        float priceLableW = 80;
        float pointLableW = 80;
        float timeLableW = 80;
        float stateLableW = 90;
        
        
        float x = (kScreenWidth - 0.15 * kScreenWidth - numLableW -classLableW - nameLableW-sizeLableW - priceLableW- pointLableW - timeLableW - stateLableW)/8;
        
        
        
        
        
        self.numLable=[[UILabel alloc]initWithFrame:CGRectMake(13, 0, numLableW  , viewHeight)];
        self.numLable.text=kLocalized(@"DishesNumber");
        self.numLable.font=[UIFont systemFontOfSize:17];
        self.numLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.numLable];
        
        self.classLable=[[UILabel alloc] initWithFrame:CGRectMake(x + numLableW, 0, classLableW, viewHeight)];
        self.classLable.text=kLocalized(@"Classification");
        self.classLable.font=[UIFont systemFontOfSize:17];
        self.classLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.classLable];
        
        self.nameLable=[[UILabel alloc] initWithFrame:CGRectMake(2 * x + numLableW + classLableW, 0, nameLableW, viewHeight)];
        self.nameLable.text=kLocalized(@"DishesName");
        self.nameLable.font=[UIFont systemFontOfSize:17];
        self.nameLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.nameLable];
        
        self.sizeLable=[[UILabel alloc] initWithFrame:CGRectMake(3 * x + numLableW + classLableW + nameLableW, 0, sizeLableW, viewHeight)];
        self.sizeLable.text=kLocalized(@"Specification");
        self.sizeLable.font=[UIFont systemFontOfSize:17];
        self.sizeLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.sizeLable];
        
        self.priceLable=[[UILabel alloc] initWithFrame:CGRectMake(4 * x + numLableW + classLableW + nameLableW + sizeLableW, 0, priceLableW, viewHeight)];
        self.priceLable.text=kLocalized(@"Price");
        self.priceLable.font=[UIFont systemFontOfSize:17];
        self.priceLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.priceLable];
        
        self.pointLable=[[UILabel alloc] initWithFrame:CGRectMake(5 * x + numLableW + classLableW + nameLableW + sizeLableW + priceLableW, 0, pointLableW, viewHeight)];
        self.pointLable.text=kLocalized(@"Integration");
        self.pointLable.font=[UIFont systemFontOfSize:17];
        self.pointLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.pointLable];
        
        self.timeLable=[[UILabel alloc] initWithFrame:CGRectMake(6 * x + numLableW + classLableW + nameLableW + sizeLableW + priceLableW + pointLableW, 0, 80, viewHeight)];
        self.timeLable.text=kLocalized(@"AddedTime");
        self.timeLable.font=[UIFont systemFontOfSize:17];
        self.timeLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.timeLable];
        
        self.stateLable=[[UILabel alloc] initWithFrame:CGRectMake(7 * x + numLableW + classLableW + nameLableW + sizeLableW + priceLableW + pointLableW + timeLableW, 0, stateLableW, viewHeight)];
        self.stateLable.text=kLocalized(@"Status");
        self.stateLable.font=[UIFont systemFontOfSize:17];
        self.stateLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.stateLable];
        
    }
    
    return  self;
    
}

@end
