//
//  GYHDSearchCustomerListModel.h
//  GYRestaurant
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSearchCustomerListModel : NSObject
@property(nonatomic,copy)NSString*iconUrl;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*custId;
@property(nonatomic,copy)NSString*hsCardNum;
@property(nonatomic,copy)NSString*keyWord;
@property(nonatomic,copy)NSString*friendUserType;
-(void)initWithDict:(NSDictionary*)dict;
@end
