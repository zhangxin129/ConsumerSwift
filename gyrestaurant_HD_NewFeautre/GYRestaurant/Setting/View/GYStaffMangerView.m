//
//  GYStaffMangerView.m
//  GYRestaurant
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYStaffMangerView.h"

#define btnHeight 60.0f
#define navItemHight 64.0f

@interface  GYStaffMangerView ()

@end

@implementation GYStaffMangerView

//代码控制视图，会自动调用这个方法
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self =[super initWithFrame:frame]) {
        // 初始化代码
        
        [self createView];
    }
    
    return self;
    
}

//初始化视图
-(void)createView{
    
        
    _staffTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 2, self.width, kScreenHeight-64-2-52) style:UITableViewStylePlain];
    
    _staffTabView.backgroundColor=[UIColor clearColor];
    
    [self addSubview:_staffTabView ];
   
}

@end
