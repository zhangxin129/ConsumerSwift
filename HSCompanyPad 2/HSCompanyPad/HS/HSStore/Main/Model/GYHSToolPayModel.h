//
//  GYHSToolPayModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSToolPayModel : NSObject

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *totalAmount;

#pragma mark - 个性定制卡订单 才会在这里赋值，否则没有值
@property (nonatomic, copy) NSString *hsbAmount;
@property (nonatomic, copy) NSString *cashAmount;

@end
