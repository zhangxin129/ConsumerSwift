//
//  GYHEFooterViewFourthView.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEFooterViewFourthView : UIView

//合计互生币
@property (weak, nonatomic) IBOutlet UILabel *cashAmountLabel;
//合计积分累积
@property (weak, nonatomic) IBOutlet UILabel *pvAmountLabel;
//优惠券花费
@property (weak, nonatomic) IBOutlet UILabel *couponAmountLabel;

//共2件商品
@property (weak, nonatomic) IBOutlet UILabel *totalGoodsDescriptionLabel;
//合计 
@property (weak, nonatomic) IBOutlet UILabel *totalCaculationLabel;



@end
