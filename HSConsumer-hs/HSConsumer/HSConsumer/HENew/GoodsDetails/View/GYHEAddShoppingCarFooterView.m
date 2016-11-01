//
//  GYHEAddShoppingCarFooterView.m
//  HSConsumer
//
//  Created by lizp on 16/9/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEAddShoppingCarFooterView.h"
#import "YYKit.h"

@interface GYHEAddShoppingCarFooterView()

@property (nonatomic,strong) UILabel *titleLabel;//标题


@end

@implementation GYHEAddShoppingCarFooterView


-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


-(void)setUp {

    //购买数量
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 60)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = UIColorFromRGB(0x00101e);
    [self addSubview:self.titleLabel];
    self.titleLabel.text = kLocalized(@"GYHE_Good_Number_Of_Buy");
    
    //减少
    self.reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reduceBtn.frame  = CGRectMake(kScreenWidth - 10 - 64 - 36, 15, 32, 29);
    [self.reduceBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_goods_reduce_shop_car"] forState:UIControlStateNormal];
    [self.reduceBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_goods_reduce_shop_car_select"] forState:UIControlStateSelected];
    [self addSubview:self.reduceBtn];
    self.reduceBtn.selected = NO;
    
    
    
    //数量
    self.numberextField = [[UITextField alloc] init];
    self.numberextField.frame  = CGRectMake(self.reduceBtn.right + 1, 15, 32, 29);
    self.numberextField.background = [UIImage imageNamed:@"gyhe_goods_shop_number"];
    self.numberextField.font = [UIFont systemFontOfSize:14];
    self.numberextField.textColor = UIColorFromRGB(0x00101e);
    self.numberextField.textAlignment = NSTextAlignmentCenter;
    self.numberextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.numberextField];
    self.numberextField.text = @"1";
    
    //增加
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame  = CGRectMake(self.numberextField.right + 1, 15, 32, 29);
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_goods_add_shop_car"] forState:UIControlStateNormal];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_goods_add_shop_car_select"] forState:UIControlStateSelected];
    [self addSubview:self.addBtn];
    self.addBtn.selected  = YES;
}


@end
