//
//  GYForgetPasswordView.h
//  HSConsumer
//
//  Created by lizp on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYForgetPasswordViewDelegate<NSObject>

@optional
-(void)dismiss;

@end

@interface GYForgetPasswordView : UIView

@property (nonatomic,weak) id<GYForgetPasswordViewDelegate>delegate;



@end
