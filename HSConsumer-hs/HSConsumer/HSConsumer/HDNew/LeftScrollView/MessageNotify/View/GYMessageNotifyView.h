//
//  GYMessageNotifyView.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYMessageNotifyView : UIView

@property (nonatomic, strong)UIView *showView;

- (void)showWithVc:(UIViewController *)vc;

@end
