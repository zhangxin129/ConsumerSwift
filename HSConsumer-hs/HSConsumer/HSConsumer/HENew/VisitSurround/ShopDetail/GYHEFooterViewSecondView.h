//
//  GYHEFooterViewSecondView.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEFooterViewSecondView : UIView
// 实付款 三个字
@property (weak, nonatomic) IBOutlet UILabel *realPayCharacterLabel;
// 提交订单按钮
@property (weak, nonatomic) IBOutlet UIButton *commiteOrderBtn;


//实付款数量
@property (weak, nonatomic) IBOutlet UILabel *realToPayLabel;



@end
