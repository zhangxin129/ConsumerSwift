//
//  GYQueryView.h
//  GYRestaurant
//
//  Created by apple on 15/10/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义一个传递视图的block类型
typedef void (^SendViewBlock)(id sender);
typedef void (^SelectBlock)(id select);
typedef void (^SearchBlock)(NSString *orderTypeStr,NSString *searchStr ,NSString *dateStr);
typedef void (^SearchFoodListBlock)(NSString *searchStr, NSString *categoryName);
typedef void (^SearchUserBlock)(NSString *actorStr, NSString *nameStr, NSString *numStr);

@interface GYQueryView : UIView
@property (nonatomic, assign)NSInteger  selectedIndex;
@property (nonatomic, strong)UITableView *meunuTableView;//菜单表格

//回调block
@property (nonatomic,copy)SendViewBlock sendBlock;
@property(nonatomic,copy)SelectBlock selectBlock;
@property(nonatomic,copy)SearchBlock searchBlock;
@property(nonatomic,copy)SearchFoodListBlock foodsearchBlock;
@property(nonatomic,copy)SearchUserBlock userSearchBlock;
@property(nonatomic,strong)NSMutableArray *nameArr;
@property(nonatomic,strong)NSMutableArray *actorArr;


@end
