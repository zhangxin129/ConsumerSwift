//
//  GYHSTradingPasswordViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/8/2.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  NS_ENUM(NSInteger,GYHSTradingPasswordType){
    GYHSTradingPasswordTypeSet = 0,  //设置交易密码
    GYHSTradingPasswordTypeModify = 1  //修改交易密码
};
@interface GYHSTradingPasswordViewController : GYViewController
@property (nonatomic,assign)GYHSTradingPasswordType tradingPasswordType;
@end
