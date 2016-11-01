//
//  GYHEVisitTakeOutControl.h
//  HSConsumer
//
//  Created by lizp on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , TakeOutControlType) {

    TakeOutControlTypeSurround = 0,//周边
    TakeOutControlTypeTakeOut = 1,//外卖（送货）
    TakeOutControlTypeVisitService = 2,//上门服务
};

@interface GYHEVisitTakeOutControl : UIControl

@property (nonatomic,strong) UIImageView *takeOutImageView;//图片
@property (nonatomic,strong) UILabel *titleLabel;//标题
@property (nonatomic,assign) TakeOutControlType type;//类型

@end
