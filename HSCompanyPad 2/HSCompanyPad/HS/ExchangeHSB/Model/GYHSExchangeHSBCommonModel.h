//
//  GYHSExchangeHSBModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>





@interface GYHSExchangeHSBMaxModel : JSONModel

@property (nonatomic, copy) NSString* t_buyHsbMax;
@property (nonatomic, copy) NSString* t_buyHsbMin;
@property (nonatomic, copy) NSString* t_buyHsbDay;

@property (nonatomic, copy) NSString* b_buyHsbMax;
@property (nonatomic, copy) NSString* b_buyHsbMin;
@property (nonatomic, copy) NSString* b_buyHsbDay;


@end