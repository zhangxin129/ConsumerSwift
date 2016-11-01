//
//  GYHDSetingModel.h
//  HSConsumer
//
//  Created by shiang on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSetingModel : NSObject

/**提示文字*/
@property(nonatomic, copy)NSString *title;
/**设置*/
@property(nonatomic, assign)BOOL setting;
@property(nonatomic, assign)NSIndexPath *index;
@end

@interface GYHDSetingGroupModel : NSObject

@property(nonatomic, copy)NSString *headTitle;
@property(nonatomic, strong)NSArray *setingArray;
@end