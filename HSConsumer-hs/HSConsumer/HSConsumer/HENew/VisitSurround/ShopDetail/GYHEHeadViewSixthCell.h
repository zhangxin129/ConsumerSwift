//
//  GYHEHeadViewSixthCell.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//纯文本 两个label
#import <UIKit/UIKit.h>

@interface GYHEHeadViewSixthCell : UITableViewCell
//显示 支付方式 四个字
@property (weak, nonatomic) IBOutlet UILabel *chargeTypeLabel;
//显示 在线支付 四个字
@property (weak, nonatomic) IBOutlet UILabel *paymentOnlineLabel;


@end
