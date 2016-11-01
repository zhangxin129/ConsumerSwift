//
//  GYHDEmojiModel.m
//  HSConsumer
//
//  Created by shiang on 16/2/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDEmojiModel.h"

@implementation GYHDEmojiModel

- (instancetype)initWithEmojiName:(NSString*)emojiName
{
    if (self = [super init]) {
        self.image = [UIImage imageNamed:emojiName];
        self.imageName = [NSString stringWithFormat:@"[%@]", emojiName];
    }
    return self;
}

@end
