//
//  GYAlertWithFieldView.h
//  GYRestaurant
//
//  Created by apple on 15/10/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GYBlock)(NSString *, NSString *);
typedef void(^GYBlock3)(NSString *,NSString *, NSString *);

@interface GYAlertWithFieldView : UIView

/**待用餐弹出框*/
- (id)initWithTitle:(NSString *)title
        ramadhinTextFieldName:(NSString *)amadhin
    numberTextFieldName:(NSString*)numberr
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;
/**消费者取消弹出框*/
- (id)initCancelView:(NSString*)deposit;
- (void)show;
@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) GYBlock rightBlock;
@property (nonatomic, copy) GYBlock3 returnBlock;
@property (nonatomic, strong) UITextField *ramadhinTextField;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UITextField *cancelTF;
@end
