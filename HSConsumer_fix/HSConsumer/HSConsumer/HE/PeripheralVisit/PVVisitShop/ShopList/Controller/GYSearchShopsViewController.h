//
//  GYSearchShopsViewController.h
//  HSConsumer
//
//  Created by apple on 15/11/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "DropDownWithChildChooseProtocol.h"
#import <UIKit/UIKit.h>
#import "DropDownWithChildListView.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface GYSearchShopsViewController : GYViewController <UITableViewDataSource, UITableViewDelegate, DropDownWithChildChooseDataSource, DropDownWithChildChooseDelegate, deleteTableviewInSectionOne, BMKLocationServiceDelegate>

@property (nonatomic, weak) id<sendTitleText> delegate;

@property (nonatomic, strong) NSMutableDictionary* mdictArea; // 保存位置信息
@property (nonatomic, copy) NSString* modelTitle;
@property (nonatomic, copy) NSString* modelID;

//下面好评 综合 人气的传值
@property (nonatomic, copy) NSString* strSortType;
@property (nonatomic, assign) BOOL FromBottomType; //之前业务需求中，周边逛findshopviewcontroller上面的topSelectView 中BTN显示title和来自下面的分类不一样。在此添加此变量作为标示。

@end
