//
//  GYHDSwitch.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/17.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHDSwitch;
@protocol GYHDSwitchDelegate <NSObject>
- (void)GYHDSwitch:(GYHDSwitch *)hdswitch select:(BOOL)select;
@end


@interface GYHDSwitch : UIButton
@property(nonatomic, strong)UILabel *oneTitle;
@property(nonatomic, strong)UILabel *twoTitle;
@property(nonatomic, weak)id<GYHDSwitchDelegate> delegate;
@end
