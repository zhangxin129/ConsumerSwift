//
//  GYSettingSaftSetLastApplyBeanModel.h
//  HSCompanyPad
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYSettingSaftSetLastApplyBeanModel : JSONModel

@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSString *applyDate;
@property (nonatomic, copy) NSString *apprRemark;

@end
