//
//  GYHDAddressView.h
//  HSConsumer
//
//  Created by shiang on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^defineChildBlock)(NSString* message);
@interface GYHDAddressView : UIView
/**返回Block*/
@property (nonatomic, copy) defineChildBlock block;

@property (nonatomic, copy) NSString* cityFullName;

/**省份数组*/
@property (nonatomic, strong) NSArray* provinceArray;
/**城市数组*/
@property (nonatomic, strong) NSArray* cityArray;

@end
