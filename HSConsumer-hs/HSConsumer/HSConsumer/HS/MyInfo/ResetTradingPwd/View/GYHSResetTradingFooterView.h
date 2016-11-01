//
//  GYHSResetTradingFooterView.h
//  HSConsumer
//
//  Created by lizp on 16/8/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSResetTradingFooterViewDelegate<NSObject>

@optional

-(void)footerConfirmClick;

@end

@interface GYHSResetTradingFooterView : UIView

@property (nonatomic,weak) id<GYHSResetTradingFooterViewDelegate>delegate;
@property (nonatomic,copy) NSString *tipStr;//提示信息

-(instancetype)initWithFrame:(CGRect)frame;

@end
