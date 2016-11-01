//
//  GYHDUserSetingFooterCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDUserSetingFooterCell.h"

@implementation GYHDUserSetingFooterCell

- (void)awakeFromNib {
    [_exitLoginBtn setTitle:kLocalized(@"退出登录") forState:UIControlStateNormal];
    _exitLoginBtn.titleLabel.textColor = [UIColor whiteColor];
    _exitLoginBtn.titleLabel.font = kfont(12);
    _exitLoginBtn.layer.cornerRadius = 17;
}


@end
