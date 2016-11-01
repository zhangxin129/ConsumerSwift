//
//  GYHSMyAccountMainViewController.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSMyAccountMainViewController : GYViewController

//对外接口（用来刷新切换 持卡、非持卡人 时的主界面）
- (void)refreshIsHaveCard;
- (void) showMainView;

@end
