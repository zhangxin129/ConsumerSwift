//
//  GYHDSearchCompanyListModel.h
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSearchCompanyListModel : NSObject
@property(nonatomic,copy)NSString*operaName;//操作员名称
@property(nonatomic,copy)NSString*icon;//操作员图片
@property(nonatomic,copy)NSString*userName;
@property(nonatomic,copy)NSString*hsCard;
@property(nonatomic,copy)NSString*kerWord;
@property(nonatomic,copy)NSString*custId;
-(void)initWithDict:(NSDictionary*)dict;
@end
