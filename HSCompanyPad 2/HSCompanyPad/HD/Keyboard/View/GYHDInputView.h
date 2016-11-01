//
//  GYHDInputView.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDSendModel.h"
typedef NS_ENUM(NSInteger, GYHDInputeViewSendType) {
    GYHDInputeViewSendText,
    GYHDInputeViewSendAudio,
    GYHDInputeViewSendVideo,
    GYHDInputeViewSendPhoto,
    GYHDInputeViewSendLocation,
    GYHDInputeViewSendCamara,
};
@class GYHDInputView;
@protocol GYHDInputViewDelegate <NSObject>
@optional
/**dict key为发送类型，value为发送值*/
- (void)GYHDInputView:(GYHDInputView *)inputView sendDict:(NSDictionary *)dict SendType:(GYHDInputeViewSendType) type;

- (void)GYHDInputView:(GYHDInputView *)inputView sendModel:(GYHDSendModel *)model SendType:(GYHDInputeViewSendType) type;
- (void)GYHDInputViewFrameDidChange:(GYHDInputView *)inputView;

@end


@interface GYHDInputView : UIView
@property(nonatomic, weak)id<GYHDInputViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame isCompany:(BOOL)isCompany;
@property(nonatomic,assign)BOOL isCompany;//是否为企业操作员界面
- (void)disMiss;
@end

