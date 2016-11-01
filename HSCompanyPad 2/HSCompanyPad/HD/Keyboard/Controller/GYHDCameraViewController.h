//
//  GYHDCameraViewController.h
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"
/**
 *    @业务标题 : 照相
 *
 *    @Created :  zhangx
 *    @Modify  : 1.
 *               2.
 *               3.
 */
typedef void (^cameraBlock)(NSDictionary*dict);
@interface GYHDCameraViewController : GYBaseViewController
@property (nonatomic,copy) cameraBlock block;
@end
