//
//  ViewController.h
//  HSCompanyPad
//
//  Created by - on 16/6/3.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYBaseViewController.h"
@class GYCardInfoModel;

/**
 *    @业务标题 :代兑互生币
 *
 *    @Created :王标兵
 *    @Modify  : 1.删除界面内的支付
 *               2.
 *               3.
 */
@interface GYHSGenerationsExchangeHSBVC : GYBaseViewController
/**本币交易数据*/
@property (nonatomic, strong) GYCardInfoModel* localModel;

@end
