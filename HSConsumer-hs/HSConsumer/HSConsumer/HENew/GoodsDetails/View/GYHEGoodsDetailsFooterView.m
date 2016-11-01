//
//  GYHEGoodsDetailsFooterView.m
//  HSConsumer
//
//  Created by lizp on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEGoodsDetailsFooterView.h"

@interface GYHEGoodsDetailsFooterView()


@end

@implementation GYHEGoodsDetailsFooterView


-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


-(void)setUp {

    self.backgroundColor = kDefaultVCBackgroundColor;
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(12, 34, 82, 1)];
    leftLineView.backgroundColor = UIColorFromRGB(0xebebeb);
    [self addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 82-12, 34, 82, 1)];
    rightLineView.backgroundColor = UIColorFromRGB(0xebebeb);
    [self addSubview:rightLineView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2 -80, 29, 160, 10)];
    contentLabel.textColor = UIColorFromRGB(0x403000);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:10];
    contentLabel.text = kLocalized(@"GYHE_Good_Continue_Drag_Check_Image_Text_Detail");
    [self addSubview:contentLabel];
    
}

@end
