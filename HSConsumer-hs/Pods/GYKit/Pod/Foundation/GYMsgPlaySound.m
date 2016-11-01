//
//  GYMsgPlaySound.m
//  company
//
//  Created by sqm on 16/6/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMsgPlaySound.h"

@implementation GYMsgPlaySound
{
    SystemSoundID _sound;
}
- (id)initSystemShake
{
    self = [super init];
    if (self) {
        _sound = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
        //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&_sound);
            
          
        }
    }
    return self;
}

- (void)play
{
    if (_sound) {
          AudioServicesPlaySystemSound(_sound);
    }
  
}
+ (void)defaultTip {

    GYMsgPlaySound *tool = [[GYMsgPlaySound alloc]initSystemSoundWithName:@"jbl_no_match" SoundType:@"caf"];
    [tool play];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

}
@end
