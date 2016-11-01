//
//  GYSystemSettingViewModel.h
//  GYRestaurant
//
//  Created by kuser on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "ViewModel.h"

@interface GYSystemSettingViewModel : ViewModel
/**
 *      @param      vShopId	商城ID
 */
- (void)getShopList;
/**
 *      @param      vShopId	商城ID
 *      @param      shopId	营业点ID
 */
- (void)getSyncShopFoods;
/**
 *      @param      vShopId	商城ID
 *      @param      shopId	营业点ID
 */
- (void)getFoodCategoryList;
/**
 *      @param      vShopId	商城ID
 */

//查询企业送餐员列表
-(void)getQueryDeliverListWthKey:(NSString *)key
                       andParams:(NSDictionary *)params;

//删除送餐员
-(void)deleteDeliverWithKey:(NSString *)key
                      andId:(NSString *)idNum
                 andVShopId:(NSString *)vShopId;

//添加送餐员
-(void)postAddDeliverWithKey:(NSString *)key
                     andName:(NSString *)name
                   andPicUrl:(NSString *)picUrl
                    andPhone:(NSString *)phone
                 andShopName:(NSString *)shopName
                   andRemark:(NSString *)remark
                      andSex:(NSString *)sex
                   andStatus:(NSString *)status
                   andShopId:(NSString *)shopId
                  andVShopId:(NSString *)vShopId
               andCustId:(NSString *)custId;

//修改送餐
-(void)putUpdateDeliverWithKey:(NSString *)key
                         andId:(NSString *)idNum
                       andName:(NSString *)name
                     andPicUrl:(NSString *)picUrl
                      andPhone:(NSString *)phone
                   andShopName:(NSString *)shopName
                     andRemark:(NSString *)remark
                        andSex:(NSString *)sex
                     andStatus:(NSString *)status
                     andShopId:(NSString *)shopId
                    andVShopId:(NSString *)vShopId;

//查询企业用户roleID为空的列表
-(void)getEmployeeRoleIdIsNullWithKey:(NSString *)key
                            andEResNo:(NSString *)eResNo vShopId:(NSString *)vShopId;

@end
