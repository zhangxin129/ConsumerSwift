//
//  GYHESearchShopVC.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

/**
 *    @业务标题 : 周边逛主界面搜索商铺的显示页面
 *
 *    @Created : 吴文超
 *    @Modify  : 1.商铺搜索返回页面 上面菜单有 附近 分类 智能排序 卖家服务 控制器仅提供视图层使用
 *               2.
 *               3.
 */

#import <UIKit/UIKit.h>

@interface GYHESearchShopVC : UIViewController
@property (nonatomic, strong)NSMutableArray *dataArry; //数据源
@property (nonatomic, copy) NSString* searchWord;
@end
