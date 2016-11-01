//
//  GYHESCDistributionWayModel.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@protocol GYHESCDistributionTypeModel
@end
@interface GYHESCDistributionTypeModel : JSONModel
@property (nonatomic, copy) NSString* desc; //配送名称
@property (nonatomic, copy) NSString* type; //配送类型，1代表快递，2代表营业点自提，3代表送货上门
@property (nonatomic, assign) CGFloat coinIconWidth;
@property (nonatomic, copy) NSString* moneyString;
@property (nonatomic, assign) BOOL isIconShow;
@property (nonatomic, assign) BOOL isMoneyShow;
@end

@interface GYHESCDistributionWayModel : JSONModel
@property (nonatomic, copy) NSString<Optional>* fee; //配送费
@property (nonatomic, strong) NSArray<GYHESCDistributionTypeModel>* types;
@end
