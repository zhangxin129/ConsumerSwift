//
//  GYHDCustomerViewController.h
//  HSEnterprise
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "ViewController.h"
#import "GYHDCustomerListView.h"
#import "GYHDMainViewController.h"
@interface GYHDCustomerViewController : UIViewController
@property(nonatomic,strong)NSMutableArray*customerMessageDatas;//聊天消息列表
@property(nonatomic,weak)GYHDCustomerListView *customerListView;
@property(nonatomic,strong)GYHDMainViewController*mainView;//对象
@property(nonatomic,assign)BOOL isFromSearch;
@end
