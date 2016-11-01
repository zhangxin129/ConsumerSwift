//
//  GYOrderStoreInvoicingView.h
//  GYRestaurant
//
//  Created by apple on 15/10/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  结账的view  

#import <UIKit/UIKit.h>
@class GYOrdDetailModel;
@interface GYOrderStoreInvoicingView : UIView

@property (weak, nonatomic) IBOutlet UITextField *serviceContentTextFild;//服务内容
@property (weak, nonatomic) IBOutlet UITextField *servicePayTextFild;//服务费用
@property (weak, nonatomic) IBOutlet UITextField *discountedAmountTextFild;//折后金额
@property (weak, nonatomic) IBOutlet UILabel *receivedDepositLabel;//已收定金
@property (weak, nonatomic) IBOutlet UIButton *useDepositBtn;//使用定金按钮
@property (weak, nonatomic) IBOutlet UIButton *returnDepositBtn;//返还定金按钮
/**添加页面数据*/
- (void)loadViewData:(GYOrdDetailModel*)model;

/**获取打印结单字典*/
- (NSMutableDictionary *)getViewSendOrderMessageDic;
@property (nonatomic, copy)NSString* orderPayCount;

@end
