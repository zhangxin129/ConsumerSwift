//
//  GYHESCCartAlertView.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHESCCartAlertViewDelegate <NSObject>

- (void)cancleButtonClicked;
- (void)confirmButtonClicked;

@end

@interface GYHESCCartAlertView : UIView
@property (weak, nonatomic) IBOutlet UITextField* numberTextField;
@property (nonatomic, weak) id<GYHESCCartAlertViewDelegate> delegate;
@property (nonatomic, assign) NSInteger maxNumber; //最大购买数量
@end
