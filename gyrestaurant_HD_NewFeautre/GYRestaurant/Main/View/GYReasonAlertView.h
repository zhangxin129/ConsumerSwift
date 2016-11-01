//
//  GYReasonAlertView.h
//  GYRestaurant
//
//  Created by apple on 15/11/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GYBlock)(NSString *);

@interface GYReasonAlertView : UIView

/**待用餐弹出框*/
- (id)initWithTitle:(NSString *)title resonTextFieldName:(NSString *)reason
leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle;
- (void)show;
@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) GYBlock rightBlock;

@end
