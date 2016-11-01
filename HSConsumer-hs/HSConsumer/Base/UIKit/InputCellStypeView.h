//
//  InputCellStypeView.h
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//公共组件，左边是栏位名，右边输入，如： 输入姓名  xxxxxx

#import <UIKit/UIKit.h>

@interface InputCellStypeView : UIView
@property (strong, nonatomic) IBOutlet UILabel* lbLeftlabel;
@property (strong, nonatomic) IBOutlet UITextField *tfRightTextField;

@end
