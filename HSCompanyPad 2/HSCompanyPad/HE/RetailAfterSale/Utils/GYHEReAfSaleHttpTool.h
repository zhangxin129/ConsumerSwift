//
//  GYHEReAfSaleHttpTool.h
//  HSCompanyPad
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHEReAfSaleHttpTool : NSObject

//获取交易流水号
+ (void)getSourceTransNoWithsuccess:(HTTPSuccess)success failure:(HTTPFailure)failure;
//退货
+ (void)returnGoodsWithOldTransNo:(NSString*)oldTransNo sourceTransNo:(NSString*)sourceTransNo sourceTransAmount:(NSString*)sourceTransAmount transAmount:(NSString*)transAmount termRunCode:(NSString*)termRunCode equipmentNo:(NSString*)equipmentNo secretCode:(NSString*)secretCode transPwd:(NSString*)pwd transType:(NSString*)transType perResNo:(NSString*)perResNo strBatchNo:(NSString*)strBatchNo success:(HTTPSuccess)success failure:(HTTPFailure)err;


@end
