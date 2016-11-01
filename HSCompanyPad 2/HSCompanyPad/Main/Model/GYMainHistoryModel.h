//
//  GYMainBodyModel.h
//  HSCompanyPad
//
//  Created by User on 16/8/19.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYMainHistoryModel : NSObject

@property (nonatomic ,copy)NSString * name;
@property (nonatomic ,copy)NSString * iconName;
@property (nonatomic ,copy)NSString * className;
@property (nonatomic ,strong)NSDate * time;

@property (nonatomic,copy)NSString *colorHexString;

@end
