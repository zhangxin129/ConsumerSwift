//
//  GYSystemSettingViewModel.m
//  GYCompany
//
//  Created by apple on 15/9/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSystemSettingViewModel.h"
#import "GYencryption.h"
#import "GYSystemSettingModel.h"
#import "NSObject+HXAddtions.h"
#import "GYTakeOrderListModel.h"
#import "GYSyncShopFoodsModel.h"
#import "GYDeliverModel.h"
#import "GYFoodSpecModel.h"
#import "UIView+Toast.h"
#import "GYGIFHUD.h"
#import "GYDeliveryStaffManagementViewController.h"
#define APPDELEGATE     ((AppDelegate*)[UIApplication sharedApplication].delegate)
@implementation GYSystemSettingViewModel

#pragma mark －－－－－－－营业点
- (void)getShopList
{
        NSDictionary *paramter = @{@"key":globalData.loginModel.token,@"vShopId": globalData.loginModel.vshopId};
    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodGetShopList) parameter:paramter success:^(id returnValue) {
        
        [self fetchShopListSuccess:returnValue];
        
    }  failure:^(id error){
        [self error:error];
        
       
        
    }];
}

- (void)fetchShopListSuccess:(id)returnValue
{
    
    NSMutableArray *modelArrM = [NSMutableArray array];
    id arr = returnValue[@"data"];
    if ([arr isKindOfClass:[NSNull class]]) {
        return ;
    }else  if ([arr isKindOfClass:[NSArray class]]){
        NSArray *dictArr = returnValue[@"data"];
        for (NSDictionary *d in dictArr) {
            GYSystemSettingModel *model = [GYSystemSettingModel mj_objectWithKeyValues:d];
            [modelArrM addObject:model];
        }
    }
    [self  writeModel:modelArrM toPath:@"pointList"];
    self.returnBlock(modelArrM);
    
}



#pragma mark －－－－－－－同步菜品列表

- (void)getSyncShopFoods
{
//    if (!globalData.loginModel.shopId) {
//        return;
//    }
    if (!kGetNSUser(@"shopId")) {
        kNotice(kLocalized(@"PleaseSelectTheBusiness"));
        [GYGIFHUD dismiss];
        return;
    }
    NSDictionary *paramter = @{@"key":globalData.loginModel.token,
                               @"vShopId":globalData.loginModel.vshopId,
                               @"shopId":kGetNSUser(@"shopId")};
    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodSyncShopFoods) parameter:paramter success:^(id returnValue) {
        
        [self syncShopFoodsFetchSuccess:returnValue];
        
    }failure:^(id error){
        [self error:error];
        
    }];
    
    
}

- (void)syncShopFoodsFetchSuccess:(id)returnValue
{
    
    
    NSMutableArray *modelArrM = [NSMutableArray array];
    id arr = returnValue[@"data"];
    if ([arr isKindOfClass:[NSNull class]]) {
        return ;
    }else  if ([arr isKindOfClass:[NSArray class]]){
        NSArray *dictArr = returnValue[@"data"];
        for (NSDictionary *d in dictArr) {
            DDLogCInfo(@"%@",dictArr);
            GYSyncShopFoodsModel *model = [GYSyncShopFoodsModel mj_objectWithKeyValues:d];
            [modelArrM addObject:model];
        }
    }
    for (GYSyncShopFoodsModel *model in modelArrM) {
        if (model.foodSpec.count > 0) {
            for (GYFoodSpecModel *m in model.foodSpec) {
                m.identify = [[model.foodId stringByAppendingString:m.pId] stringByAppendingString:m.pVId];
            }
        }
    }
    
    
    [self writeModel:modelArrM toPath:@"foodsList"];
    self.returnBlock(modelArrM);
    
}

#pragma mark －－－－－－－自定义菜品分类列表

- (void)getFoodCategoryList
{
//        if (!globalData.loginModel.shopId) {
//        return;
//    }
    if (!kGetNSUser(@"shopId")) {
        return;
    }
    NSDictionary *paramter = @{@"key":globalData.loginModel.token,
                               @"vShopId":globalData.loginModel.vshopId,
                               @"shopId":kGetNSUser(@"shopId")
                               };
    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodGetFoodCategoryList) parameter:paramter success:^(id returnValue) {
        
        [self getFoodCategoryListFetchSuccess:returnValue];
        
        
    }  failure:^(id error){
        [self error:error];
        
       
        
    }];
    
}


/**
 *  获取自定义分类列表数据
 *
 *  @param returnValue <#returnValue description#>
 */
- (void)getFoodCategoryListFetchSuccess:(id)returnValue
{
    NSMutableArray *modelArrM = [NSMutableArray array];
    
    id arr = returnValue[@"data"];
    if ([arr isKindOfClass:[NSNull class]]) {
        return ;
    }
    NSArray *dictArr = returnValue[@"data"];
    GYTakeOrderListModel *mode = [[GYTakeOrderListModel alloc]init];
    mode.itemCustomCategoryName = kLocalized(@"All");
    [modelArrM addObject: mode];
    for (NSDictionary *d in dictArr) {
        GYTakeOrderListModel *model = [GYTakeOrderListModel mj_objectWithKeyValues:d];
        [modelArrM addObject:model];
    }
    
    [self  writeModel:modelArrM toPath:@"getFoodCategoryList"];
    self.returnBlock(modelArrM);
}
#pragma mark -  查询企业送餐员列表
-(void)getQueryDeliverListWthKey:(NSString *)key andParams:(NSDictionary *)params{
    
    NSString *str = [NSObject jsonStringWithDictionary:params];
    NSDictionary *paramsDic=@{@"key":key,@"params":str};
    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodQueryDeliverList) parameter:paramsDic success:^(id returnValue) {
        NSMutableArray *orderArr=[[NSMutableArray alloc] init];
        if ([returnValue[@"retCode"] isEqualToNumber:@200]) {
            id arr = returnValue[@"data"];
            if ([arr isKindOfClass:[NSNull class]]) {
                self.returnBlock(orderArr);
            }else if([arr isKindOfClass:[NSArray class]]){
                for(NSDictionary *dataDic in returnValue[@"data"]){
                    GYDeliverModel *deliverModel=[GYDeliverModel mj_objectWithKeyValues:dataDic];
                    
                    [orderArr addObject:deliverModel];
                }
                
            }
            
        }else if ([returnValue[@"retCode"] isEqualToNumber:@204]) {
        
      //  [[UIApplication sharedApplication].delegate.window makeToast:@"查询到送餐员列表为空"];
           // self.returnBlock(returnValue);
        }else {
        
         [[UIApplication sharedApplication].delegate.window makeToast:kLocalized(@"QueryFailed!")];
        
        
        }
       
       self.returnBlock(orderArr);
    } failure:^(id error){
        [self error:error];
       
    }];
}
#pragma mark -  删除送餐员
-(void)deleteDeliverWithKey:(NSString *)key andId:(NSString *)idNum andVShopId:(NSString *)vShopId{
    
    NSDictionary *parameter = @{@"key":key,
                                @"id":idNum,
                                @"vShopId":vShopId};
    
    [Network DELETE:GY_FOODOMAINAPP(GYHEFoodDeleteDeliver) parameter:parameter success:^(id returnValue) {
        
        if ([returnValue[@"retCode"] isEqualToNumber:@200]) {
            NSMutableArray *orderArr=[[NSMutableArray alloc] init];
            
            id arr = returnValue[@"data"];
            if ([arr isKindOfClass:[NSNull class]]) {
                self.returnBlock(orderArr);
            }else if([arr isKindOfClass:[NSArray class]]){
                for(NSDictionary *dataDic in returnValue[@"data"]){
                    GYDeliverModel *deliverModel=[GYDeliverModel mj_objectWithKeyValues:dataDic];
                    
                    [orderArr addObject:deliverModel];
                }
                
            }
        }else{
            [[UIApplication sharedApplication].delegate.window makeToast:kLocalized(@"RemoveDeliveryStaffFailed!")];
            [GYGIFHUD dismiss];
        
        }

        self.returnBlock(returnValue);
    }  failure:^(id error){
        [self error:error];
       
    }];
}
#pragma mark - 添加送餐员
-(void)postAddDeliverWithKey:(NSString *)key andName:(NSString *)name andPicUrl:(NSString *)picUrl andPhone:(NSString *)phone andShopName:(NSString *)shopName andRemark:(NSString *)remark andSex:(NSString *)sex andStatus:(NSString *)status andShopId:(NSString *)shopId andVShopId:(NSString *)vShopId andCustId:(NSString *)custId{
    
    NSDictionary *paramsDic=@{@"key":key,
                              @"name":name,
                              @"picUrl":picUrl,
                              @"phone":phone,
                              @"shopName":shopName,
                              @"remark":remark,
                              @"sex":sex,
                              @"status":status,
                              @"shopId":shopId,
                              @"vShopId":vShopId,
                              @"custId":custId
                              };
    
    [Network POST:GY_FOODOMAINAPP(GYHEFoodAddDeliver) parameter:paramsDic success:^(id returnValue) {
        
        if ([returnValue[@"retCode"] isEqualToNumber:@200]) {
            NSMutableArray *orderArr=[[NSMutableArray alloc] init];
            [[UIApplication sharedApplication].delegate.window makeToast:kLocalized(@"AddDeliveryStaffSuccess!")];
            id arr = returnValue[@"data"];
            if ([arr isKindOfClass:[NSNull class]]) {
                self.returnBlock(orderArr);
            }else if([arr isKindOfClass:[NSArray class]]){
                for(NSDictionary *dataDic in returnValue[@"data"]){
                    GYDeliverModel *deliverModel=[GYDeliverModel mj_objectWithKeyValues:dataDic];
                    
                    [orderArr addObject:deliverModel];
                }
                
            }
            
            self.returnBlock(orderArr);
        }else{
        
            [[UIApplication sharedApplication].delegate.window makeToast:kLocalized(@"AddDeliveryStaffFailed!")];
           [GYGIFHUD dismiss];
        
        }
  
        
    } failure:^(id error){
        [self error:error];
       
    }];
    
    
}


#pragma mark - 修改送餐员
-(void)putUpdateDeliverWithKey:(NSString *)key andId:(NSString *)idNum andName:(NSString *)name andPicUrl:(NSString *)picUrl andPhone:(NSString *)phone andShopName:(NSString *)shopName andRemark:(NSString *)remark andSex:(NSString *)sex andStatus:(NSString *)status andShopId:(NSString *)shopId andVShopId:(NSString *)vShopId{
    
    NSDictionary *paramsDic=@{@"key":key,
                              @"id":idNum,
                              @"name":name,
                              @"picUrl":picUrl,
                              @"phone":phone,
                              @"shopName":shopName,
                              @"remark":remark,
                              @"sex":sex,
                              @"status":status,
                              @"shopId":shopId,
                              @"vShopId":vShopId
                              };
    
    [Network PUT:GY_FOODOMAINAPP(GYHEFoodUpdateDeliver) parameter:paramsDic success:^(id returnValue) {
        if ([returnValue[@"retCode"] isEqualToNumber:@200]) {
            NSMutableArray *orderArr=[[NSMutableArray alloc] init];
            
            id arr = returnValue[@"data"];
            if ([arr isKindOfClass:[NSNull class]]) {
              self.returnBlock(orderArr);
            }else if([arr isKindOfClass:[NSArray class]]){
                for(NSDictionary *dataDic in returnValue[@"data"]){
                    GYDeliverModel *deliverModel=[GYDeliverModel mj_objectWithKeyValues:dataDic];
                    
                    [orderArr addObject:deliverModel];
                }
                
            }
            self.returnBlock(orderArr);
          [[UIApplication sharedApplication].delegate.window makeToast:kLocalized(@"ModifyDeliveryStaffSuccessfully")];
            
        }else {
         [[UIApplication sharedApplication].delegate.window makeToast:kLocalized(@"ModifyDeliveryStaffFailed!")];
        [GYGIFHUD dismiss];
        }
       
        
    }failure:^(id error){
        [self error:error];
       
    }];
    
    
}

#pragma mark - 查询企业用户roleID为空的列表
-(void)getEmployeeRoleIdIsNullWithKey:(NSString *)key andEResNo:(NSString *)eResNo vShopId:(NSString *)vShopId{
    
    
    NSDictionary *paramsDic=@{@"key":key,
                              @"entCustId":eResNo,
                              @"vShopId":vShopId
                              };
    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodEmployeeRoleIdIsNull) parameter:paramsDic success:^(id returnValue) {
        
        if ([returnValue[@"retCode"] isEqualToNumber:@200]) {
            NSMutableArray *orderArr=[[NSMutableArray alloc] init];
            
            id arr = returnValue[@"data"];
            if ([arr isKindOfClass:[NSNull class]]) {
                self.returnBlock(orderArr);
            }else if([arr isKindOfClass:[NSArray class]]){
                for(NSDictionary *dataDic in returnValue[@"data"]){
                    GYDeliverModel *deliverModel=[GYDeliverModel mj_objectWithKeyValues:dataDic];
                    
                    [orderArr addObject:deliverModel];
                }
                
            }
            self.returnBlock(orderArr);
        }else if ([returnValue[@"retCode"] isEqualToNumber:@204]){
            
            [[UIApplication sharedApplication].delegate.window makeToast:kLocalized(@"TheCompanyHasNoAlternativeBusinessUsers,BusinessUsersPleaseAdd!")];
           
             [GYGIFHUD dismiss];
            
        }else if ([returnValue[@"retCode"] isEqualToNumber:@205]){
           
            [[UIApplication sharedApplication].delegate.window makeToast:returnValue[@"msg"]];
            [GYGIFHUD dismiss];
        
        }
        else{
            [[UIApplication sharedApplication].delegate.window makeToast:kLocalized(@"QueryFailed!")];
            [GYGIFHUD dismiss];
            
            
        }
        
        
    } failure:^(id error){
        [self error:error];
       
    }];
    
    
}


@end
