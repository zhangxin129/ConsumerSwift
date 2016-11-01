//
//  GYHDGPSViewController.h
//  HSConsumer
//
//  Created by shiang on 16/7/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYViewController.h"
typedef void(^sendBlock)(NSDictionary *dict);
@interface GYHDGPSViewController : GYViewController
/**
 *  选择回调
 */
@property (nonatomic, copy) sendBlock block;
@end
