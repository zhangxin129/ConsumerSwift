//
//  GYHDVideoViewController.h
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"
/**
 *    @业务标题 : 录像
 *
 *    @Created :  zhangx
 *    @Modify  : 1.
 *               2.
 *               3.
 */
typedef void (^videoBlock)(NSDictionary*dict);
@interface GYHDVideoViewController : GYBaseViewController
@property (nonatomic,copy)videoBlock bloclk;
@end
