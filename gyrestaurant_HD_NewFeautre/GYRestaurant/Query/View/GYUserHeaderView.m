//
//  GYUserHeaderView.m
//  GYRestaurant
//
//  Created by apple on 15/10/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYUserHeaderView.h"
#define viewHeight 50.0f

@interface GYUserHeaderView()
@property (strong, nonatomic) UILabel *numLable;
@property (strong, nonatomic) UILabel *nameLable;
@property (strong, nonatomic) UILabel *nicknameLable;
@property (strong, nonatomic) UILabel *menberLable;
@property (strong, nonatomic) UILabel *phoneLable;
@property (strong, nonatomic) UILabel *actorLable;
@property (strong, nonatomic) UILabel *stateLable;
@end

@implementation GYUserHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        
        float numLableW = 100;
        float nameLableW = 80;
        float phoneLableW = 130;
        float actorLableW = 80;
        float stateLableW = 80;
        
        
        
        float x = (kScreenWidth - 0.15 * kScreenWidth - numLableW -nameLableW - phoneLableW - actorLableW - stateLableW)/5;
        
        
        
        self.numLable=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, numLableW, viewHeight)];
        self.numLable.text=kLocalized(@"Numbering");
        self.numLable.textAlignment=NSTextAlignmentCenter;
        self.numLable.font=[UIFont systemFontOfSize:17];
        [self addSubview:self.numLable];
        
        self.nameLable=[[UILabel alloc] initWithFrame:CGRectMake(60 + x + numLableW, 0, nameLableW, viewHeight)];
        self.nameLable.text=kLocalized(@"Name");
        self.nameLable.textAlignment=NSTextAlignmentCenter;
        self.nameLable.font=[UIFont systemFontOfSize:17];
        [self addSubview:self.nameLable];
        
//        self.nicknameLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLable.frame)+36, 0, 60, viewHeight)];
//        self.nicknameLable.text=kLocalized(@"Nickname");
//        self.nicknameLable.textAlignment=NSTextAlignmentCenter;
//        self.nicknameLable.font=[UIFont systemFontOfSize:17];
//        [self addSubview:self.nicknameLable];
//        
//        self.menberLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nicknameLable.frame)-20, 0, 208, viewHeight)];
//        self.menberLable.text=kLocalized(@"IDNumber");
//        self.menberLable.textAlignment=NSTextAlignmentCenter;
//        self.menberLable.font=[UIFont systemFontOfSize:17];
//        [self addSubview:self.menberLable];
        
        self.phoneLable=[[UILabel alloc] initWithFrame:CGRectMake(60 + 2 * x + numLableW + nameLableW, 0, phoneLableW, viewHeight)];
        self.phoneLable.text=kLocalized(@"CellphoneNumber");
        self.phoneLable.textAlignment=NSTextAlignmentCenter;
        self.phoneLable.font=[UIFont systemFontOfSize:17];
        [self addSubview:self.phoneLable];
        
        self.actorLable=[[UILabel alloc] initWithFrame:CGRectMake(60 + 3 * x + numLableW + nameLableW + phoneLableW, 0, actorLableW, viewHeight)];
        self.actorLable.text=kLocalized(@"Character");
        self.actorLable.textAlignment=NSTextAlignmentCenter;
        self.actorLable.font=[UIFont systemFontOfSize:17];
        [self addSubview:self.actorLable];
        
        self.stateLable=[[UILabel alloc] initWithFrame:CGRectMake(60 + 4 * x + numLableW + nameLableW + phoneLableW + actorLableW, 0, stateLableW, viewHeight)];
        self.stateLable.text=kLocalized(@"Status");
        self.stateLable.textAlignment=NSTextAlignmentCenter;
        self.stateLable.font=[UIFont systemFontOfSize:17];
        [self addSubview:self.stateLable];
        
    }
    
    
    return  self;
    
}


@end
