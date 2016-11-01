//
//  GYHEFooterViewFirstView.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEFooterViewFirstView : UIView

//合计 两个字
@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;
//折算互生币支付 额
@property (weak, nonatomic) IBOutlet UILabel *cashCostLabel;

//积分积累
@property (weak, nonatomic) IBOutlet UILabel *pvAmountLabel;
//实付 两个字
@property (weak, nonatomic) IBOutlet UILabel *actualyCostLabel;


//实付数额
@property (weak, nonatomic) IBOutlet UILabel *actualyPayLabel;
//消耗抵用券
@property (weak, nonatomic) IBOutlet UILabel *voucherLeftLabel;
//共多少件商品的描述
@property (weak, nonatomic) IBOutlet UILabel *allGoodsLabel;







@end
