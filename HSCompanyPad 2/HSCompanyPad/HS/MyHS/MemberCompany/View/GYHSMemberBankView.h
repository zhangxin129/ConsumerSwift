//
//  GYHSMemBerBankView.h
//
//  Created by apple on 16/8/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSBankListModel;
@interface GYHSMemberBankView : UIView
@property (nonatomic,strong) GYHSBankListModel * model;
- (void)reloadDeleteBank;
@end
                                                