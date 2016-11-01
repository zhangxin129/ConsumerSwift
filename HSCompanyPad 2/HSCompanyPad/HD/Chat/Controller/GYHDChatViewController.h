//
//  GYHDChatViewController.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"
#import "GYHDInputView.h"
@interface GYHDChatViewController : GYBaseViewController
@property(nonatomic,copy)NSString*custId;//用户ID;
@property(nonatomic,assign)BOOL isCompany;//是否为企业通讯录进入
- (instancetype)initWithIsCompany:(BOOL)isCompany;
@property(nonatomic, strong)GYHDInputView       *hdInputView;
@property(nonatomic, strong)UITableView         *chatTableView;
@end
