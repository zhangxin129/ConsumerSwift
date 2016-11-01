//
//  GYHDSearchListViewController.h
//  GYRestaurant
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHDSearchListViewController : UIViewController
@property(nonatomic,copy)NSString*custId;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*iconUrl;
@property(nonatomic,copy)NSString*keyWord;
@property(nonatomic,copy)NSString*msgType;//区分聊天消息和推送消息
@property(nonatomic,copy)NSString*pushType;//推送消息类型
@end
