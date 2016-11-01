//
//  GYHSMyImportantInfoChangeCommitVC.h
//
//  Created by apple on 16/8/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//


#import "GYBaseViewController.h"

@class GYHSMyImportantChageModel;
/**
 *    @业务标题 :提交重要信息变更界面
 *
 *    @Created :王标兵
 *    @Modify  : 1.
 *               2.
 *               3.
 */
@class GYHSMyImportantChageModel;
@interface GYHSMyImportantInfoChangeCommitVC: GYBaseViewController

@property (nonatomic, strong) GYHSMyImportantChageModel *oldModel;
@property (nonatomic, strong) NSMutableDictionary *requestDict;

@end
