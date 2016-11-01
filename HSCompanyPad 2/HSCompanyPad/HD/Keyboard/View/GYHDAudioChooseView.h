//
//  GYHDAudioView.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//  录音选择

#import <UIKit/UIKit.h>
#import "GYHDSendModel.h"

//typedef void (^audioBlock)(NSDictionary*dict);
@class GYHDAudioChooseView;
@protocol GYHDAudioChooseViewDelegate <NSObject>

- (void)GYHDAudioChooseView:(GYHDAudioChooseView *)audioChooseView sendModel:(GYHDSendModel *)model;

@end

@interface GYHDAudioChooseView : UIView
//@property (nonatomic,copy)audioBlock bloclk;
@property(nonatomic, weak)id<GYHDAudioChooseViewDelegate> delegate;
@end
