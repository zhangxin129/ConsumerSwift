//
//  GYHDMoreChooseView.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//  更多选择

#import <UIKit/UIKit.h>
#import "GYHDInputView.h"
@protocol  GYHDMoreChooseViewDelegate<NSObject>

-(void)GYHDMoreChooseViewSendMessageWith:(GYHDInputeViewSendType)type;

@end
@interface GYHDMoreChooseView : UIView
@property (nonatomic,weak)id<GYHDMoreChooseViewDelegate> delegage;
@end
