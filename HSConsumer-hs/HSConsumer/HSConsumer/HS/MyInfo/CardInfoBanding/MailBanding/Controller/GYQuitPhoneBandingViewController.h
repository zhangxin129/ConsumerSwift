//
//  GYQuitPhoneBandingViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface GYQuitPhoneBandingViewController : GYViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
@property (nonatomic, assign) BOOL fromPhonePage;
@property (nonatomic, strong) NSMutableArray* marrDataSoure;

@end
