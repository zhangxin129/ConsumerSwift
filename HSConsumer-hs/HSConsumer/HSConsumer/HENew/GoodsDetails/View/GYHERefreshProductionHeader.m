//
//  GYHERefreshProductionHeader.m
//  HSConsumer
//
//  Created by lizp on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHERefreshProductionHeader.h"

@interface GYHERefreshProductionHeader()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation GYHERefreshProductionHeader

#pragma mark 基本设置
- (void)prepare
{
    [super prepare];


    [self addSubview:self.imageView];
    
    
}



- (void)setState:(MJRefreshState)state {

    [super setState:state];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.text = kLocalized(@"GYHE_Good_Drop_Down_Back_To_Good_Introduction");
    self.stateLabel.font = [UIFont systemFontOfSize:10];
    self.stateLabel.textColor = UIColorFromRGB(0x403000);
}

#pragma mark  - get or set 
-(UIImageView *)imageView {

    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2 -10, 0, 20, 20)];
        _imageView.image = [UIImage imageNamed:@"gyhe_goods_Production_down"];
    }
    return _imageView;
}

@end
