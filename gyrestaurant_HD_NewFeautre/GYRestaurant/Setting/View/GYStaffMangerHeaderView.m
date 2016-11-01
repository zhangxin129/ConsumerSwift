//
//  GYStaffMangerHeaderView.m
//  GYRestaurant
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYStaffMangerHeaderView.h"


#define viewHeight 50.0f
@interface GYStaffMangerHeaderView ()

@property(nonatomic,strong)UILabel *headImageNameLable;
@property(nonatomic,strong)UILabel *phoneNumLable;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UILabel *sexLable;
@property(nonatomic,strong)UILabel *stateLable;
@property(nonatomic,strong)UILabel *shopLable;
@property(nonatomic,strong)UILabel *remarkLable;
@property(nonatomic,strong)UILabel *oparateLable;



@end

@implementation GYStaffMangerHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        
        float headImageNameLableW = 80;
        float nameLableW = 90;
        float sexLableW = 43;
        float phoneNumLableW = 159;
        float stateLableW = 68;
        float shopLableW = 139;
        float remarkLableW = 152;
        float oparateLableW = 65;
        
        
        float x = (kScreenWidth  - headImageNameLableW -nameLableW - sexLableW-phoneNumLableW - stateLableW- shopLableW - remarkLableW - oparateLableW)/8;

        
        
        self.headImageNameLable = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, headImageNameLableW, viewHeight)];
        self.headImageNameLable.text=kLocalized(@"Photo");
        self.headImageNameLable.font=[UIFont systemFontOfSize:17];
        self.headImageNameLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.headImageNameLable];
        
    
        self.nameLable=[[UILabel alloc] initWithFrame:CGRectMake(8 + x + headImageNameLableW, 0, nameLableW, viewHeight)];
        self.nameLable.text=kLocalized(@"Name");
        self.nameLable.font=[UIFont systemFontOfSize:17];
        self.nameLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.nameLable];
        
        self.sexLable=[[UILabel alloc] initWithFrame:CGRectMake(8 + 2 * x + headImageNameLableW + nameLableW, 0, sexLableW, viewHeight)];
        self.sexLable.text=kLocalized(@"Person_sec");
        self.sexLable.font=[UIFont systemFontOfSize:17];
        self.sexLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.sexLable];
        
        self.phoneNumLable=[[UILabel alloc]initWithFrame:CGRectMake(8 + 3 * x + headImageNameLableW + nameLableW + sexLableW, 0, phoneNumLableW, viewHeight)];
        self.phoneNumLable.text=kLocalized(@"contactNumber");
        self.phoneNumLable.font=[UIFont systemFontOfSize:17];
        self.phoneNumLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.phoneNumLable];
        
        self.stateLable=[[UILabel alloc] initWithFrame:CGRectMake(8 + 4 * x + headImageNameLableW + nameLableW + sexLableW + phoneNumLableW, 0, stateLableW, viewHeight)];
        self.stateLable.text=kLocalized(@"Status");
        self.stateLable.font=[UIFont systemFontOfSize:17];
        self.stateLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.stateLable];
        
        self.shopLable=[[UILabel alloc] initWithFrame:CGRectMake(8 + 5 * x + headImageNameLableW + nameLableW + sexLableW + phoneNumLableW + stateLableW, 0, shopLableW, viewHeight)];
        self.shopLable.text=kLocalized(@"IncludeOfBusiness");
        self.shopLable.font=[UIFont systemFontOfSize:17];
        self.shopLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.shopLable];
        
        self.remarkLable=[[UILabel alloc] initWithFrame:CGRectMake(8 + 6 * x + headImageNameLableW + nameLableW + sexLableW + phoneNumLableW + stateLableW + shopLableW, 0, remarkLableW, viewHeight)];
        self.remarkLable.text=kLocalized(@"Remark");
        self.remarkLable.font=[UIFont systemFontOfSize:17];
        self.remarkLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.remarkLable];
        
        self.oparateLable=[[UILabel alloc] initWithFrame:CGRectMake(8 + 7 * x + headImageNameLableW + nameLableW + sexLableW + phoneNumLableW + stateLableW + shopLableW + remarkLableW ,  0, oparateLableW, viewHeight)];
        self.oparateLable.text=kLocalized(@"Operating");
        self.oparateLable.font=[UIFont systemFontOfSize:17];
        self.oparateLable.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.oparateLable ];
    }
    
    
    return  self;
    
}



@end
