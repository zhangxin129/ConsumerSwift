//
//  GYHSBankCradModel.h
//  HSCompanyPad
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSBankCradModel : NSObject
@property (nonatomic, copy) NSString *accId;
@property (nonatomic, copy) NSString *amountSingleLimit;
@property (nonatomic, copy) NSString *amountTotalLimit;
@property (nonatomic, copy) NSString *bankCardNo;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *custId;
@property (nonatomic, copy) NSString *resNo;
@property (nonatomic, copy) NSString *signNo;
@property (nonatomic, copy) NSString *smallPayExpireDate;
@property (nonatomic, copy) NSString *bankCardType;

@property (nonatomic) BOOL select;

@end
