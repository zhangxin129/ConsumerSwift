//
//  GYHDChooseMarkCell.m
//  HSConsumer
//
//  Created by wangbiao on 16/9/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDChooseMarkCell.h"

@interface GYHDChooseMarkCell ()

@end

@implementation GYHDChooseMarkCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = self.contentView.frame;
        backView.backgroundColor = [UIColor redColor];
        self.backgroundView = backView;
        
        UIView *selectBackView = [[UIView alloc] init];
        selectBackView.frame = self.contentView.frame;
        selectBackView.backgroundColor = [UIColor blueColor];
        self.backgroundView = selectBackView;
    }
    return self;
}
@end
