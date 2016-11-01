//
//  GYHSPointScanView.h
//
//  Created by apple on 16/8/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSCheckScanDelegate <NSObject>

- (void)scanClick;

@end
@interface GYHSPointScanView : UIView
@property (nonatomic,strong) UIImageView * scanImageView;
@property (nonatomic,weak) id<GYHSCheckScanDelegate> delegate;
@end
                                                