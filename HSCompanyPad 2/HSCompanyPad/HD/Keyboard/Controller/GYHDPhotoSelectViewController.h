//
//  GYHDPhotoSelectViewController.h
//  HSCompanyPad
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"
#import "GYHDInputView.h"
/**
 *    @业务标题 : 图片选择器
 *
 *    @Created :  zhangx
 *    @Modify  : 1.
 *               2.
 *               3.
 */
typedef void (^selectImgBlock)(NSDictionary*dict);
@interface GYHDPhotoSelectViewController : GYBaseViewController
@property(nonatomic,copy)selectImgBlock block;
@end
