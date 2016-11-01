//
//  GYMyInfoNoCardViewController.h
//  HSConsumer
//
//  Created by zhangqy on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYViewControllerDelegate.h"
#import "GYHSBasicInformationModel.h"

@interface GYMyInfoNoCardViewController : GYViewController <UITableViewDataSource, UITableViewDelegate, GYViewControllerDelegate>
@property (nonatomic, strong) GYHSBasicInformationModel* infoModel;
@property (strong, nonatomic) UITableView* tableView;
@property (weak, nonatomic) id<GYViewControllerDelegate> delegate;
@end
