//
//  GYHDEditReplyView.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDReplyModel.h"

@protocol GYHDEditReplyViewDelegate <NSObject>

- (void)GYHDEditReplyViewDidSave:(GYHDReplyModel *)model;//保存
- (void)GYHDEditReplyViewDidUpdate:(GYHDReplyModel *)model;//更新

@end

@interface GYHDEditReplyView : UIView
- (instancetype)initWithModel:(GYHDReplyModel *)model;
@property(nonatomic, weak)id<GYHDEditReplyViewDelegate> delegate;
@end
