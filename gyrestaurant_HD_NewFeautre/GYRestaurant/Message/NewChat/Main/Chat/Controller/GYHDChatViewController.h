//
//  GYHDChatViewController.h
//  HSConsumer
//
//  Created by shiang on 15/12/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDBasicViewController.h"


@interface GYHDChatViewController : GYHDBasicViewController
/**昵称，互生号，*/
@property(nonatomic, strong) NSDictionary *companyInformationDict;
@property (nonatomic)BOOL isFromSearch;//是否来自搜索界面
@property (nonatomic, copy) NSString *primaryId;
@property (nonatomic, copy) NSString *userName;
/**
 * 记录聊天内容的数组
 */
@property(nonatomic, strong)NSMutableArray *chatArrayM;
- (void)loadChat;
@end
