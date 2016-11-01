//
//  GYHDCustomerServiceOnLineModel.h
//  HSCompanyPad
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDCustomerServiceOnLineModel : NSObject
@property(nonatomic,copy)NSString*iconUrl;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*operNum;
@property(nonatomic,copy)NSString*roleStr;
@property(nonatomic,copy)NSString*kefuId;
@property(nonatomic,assign)BOOL isSelect;
-(void)initWithDict:(NSDictionary*)dict;
@end
