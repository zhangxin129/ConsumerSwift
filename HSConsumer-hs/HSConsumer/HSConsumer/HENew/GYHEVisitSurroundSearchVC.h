//
//  GYHEVisitSurroundSearchVC.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

/**
 *    @业务标题 : 搜索功能界面
 *
 *    @Created : 吴文超
 *    @Modify  : 1.从周边逛主界面上部进入的搜索功能 / 或从商铺详情页面上部进入的搜索功能
 *               2.
 *               3.
 */

#import "GYViewController.h"

typedef NS_ENUM (NSUInteger, SearchShowType)
{
    kGYHESearchShowCollection = 1, //显示搜索记录
    kGYHESearchShowTable      = 2, //显示联想词
    kGYHESearchShowContent    = 3, //显示商铺或商品列表
};
typedef NS_ENUM (NSUInteger, ShowGoodsOrShopsType)
{
    kGoodsType = 1, //显示商品
    kShopsType = 2, //显示商铺
   
};
@interface GYHEVisitSurroundSearchVC : GYViewController
@property (nonatomic, assign) SearchShowType searchShowType;
@property (nonatomic, assign) ShowGoodsOrShopsType contentTabelType;
//开始的数据库 为了展示联想词功能
@property(nonatomic, retain) NSMutableArray *items;
@end
