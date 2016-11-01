//
//  GYPasswordSelectButton.h
//  HSConsumer
//
//  Created by lizp on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,GYPasswordSelectButtonType) {
    GYPasswordSelectButtonTypeBack,//密码找回
    GYPasswordSelectButtonTypeRegisted,//注册
};

@interface GYPasswordSelectButton : UIButton

@property (nonatomic,assign) GYPasswordSelectButtonType type;

@end
