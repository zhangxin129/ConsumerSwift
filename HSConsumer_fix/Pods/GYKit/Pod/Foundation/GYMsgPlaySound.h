//
//  GYMsgPlaySound.h
//  company
//
//  Created by sqm on 16/6/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h> 

@interface GYMsgPlaySound : NSObject

@property (nonatomic, assign) SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
- (id)initSystemShake;//系统 震动
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;//初始化系统声音
- (void)play;//播放
+ (void)defaultTip;
@end
