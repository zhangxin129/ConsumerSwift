//
//  GYHDReplyChooseView.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//  快捷回复

#import <UIKit/UIKit.h>
@class GYHDReplyChooseView;
@protocol GYHDReplyChooseViewDelegate <NSObject>

- (void)GYHDReplyChooseView:(GYHDReplyChooseView *)view DidSelectWithString:(NSString *)string;

@end

@interface GYHDReplyChooseView : UIView
@property(nonatomic, weak)id<GYHDReplyChooseViewDelegate> delegate;
@property(nonatomic, strong)NSArray     *dataArray;
@end
