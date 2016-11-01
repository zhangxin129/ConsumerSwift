//
//  GYInstructionViewController.h
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYInstructionViewController : GYViewController

@property (weak, nonatomic) NSString* strTitle; //说明标题
@property (weak, nonatomic) NSString* strContent; //说明内容
@property (weak, nonatomic) IBOutlet UITextView* tvInstruction; //文本框

@end
