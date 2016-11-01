//
//  GYHDSelectMarkModel.h
//  HSConsumer
//
//  Created by wangbiao on 16/9/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSelectMarkModel : NSObject

/**mark 名字*/
@property(nonatomic, copy)NSString *markNameString;
/**选中状态*/
@property(nonatomic, assign)BOOL selectState;
@end
