//
//  GYHEGoodsWebView.h
//  HSConsumer
//
//  Created by lizp on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHEGoodsDetailsModel.h"

@interface GYHEGoodsWebView : UIView

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIWebView *webView;//加载网页
@property (nonatomic,strong) GYHEGoodsDetailsModel *model;

@end
