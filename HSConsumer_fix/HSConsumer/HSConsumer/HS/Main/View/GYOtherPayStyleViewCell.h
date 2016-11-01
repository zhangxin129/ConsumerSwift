//
//  GYOtherPayStyleViewCell.h
//  HSConsumer
//
//  Created by Apple03 on 15/12/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYOtherPayStyleViewCell : UITableViewCell
//选中与未选中显示图片
@property (weak, nonatomic) IBOutlet UIImageView* selectImageView;
//支付方式Label
@property (weak, nonatomic) IBOutlet UILabel* titleLabel; //银联支付
//货币转换比率
@property (weak, nonatomic) IBOutlet UILabel* accountTransRateLabel;
//转换的金额
@property (weak, nonatomic) IBOutlet UILabel* accounTransMoney;

@property (weak, nonatomic) IBOutlet UILabel* localSettlementCurrencyLabel; //本地结算币种:
@property (weak, nonatomic) IBOutlet UILabel* currencyConversionRatioLabel; //货币转换比率:
@property (weak, nonatomic) IBOutlet UILabel* convertCurrencyAmountLabel; //折算货币金额:
@property (weak, nonatomic) IBOutlet UILabel *theYuanLabel;//人民币

@end
