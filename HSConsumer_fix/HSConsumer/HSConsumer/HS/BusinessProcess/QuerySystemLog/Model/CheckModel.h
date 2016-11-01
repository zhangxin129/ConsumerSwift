//
//  CheckModel.h
//  HSConsumer
//
//  Created by 00 on 14-12-5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckModel : NSObject

@property (nonatomic, copy) NSString* created; //创建日期
@property (nonatomic, copy) NSString* serialNo; //业务流水号
@property (nonatomic, copy) NSString* status; //业务受理结果 1 成功 2失败   //审核结果
@property (nonatomic, copy) NSString* type; //业务类型 1-实名绑定、2实名注册、3-挂失、4-解挂

/*

   created = "2015-02-28";
   createdBy = 0618601000120141222;
   customId = 0618601000120141222;
   id = "0d9ceae5-1344-4131-ac03-3dc7fe9ae772";
   isActive = Y;
   optDate = "2015-02-28";
   pointNo = 06186010001;
   reason = 44;
   serialNo = GS142511932890706186010001;
   status = 1;
   type = 3;
   updateBy = 0618601000120141222;
   updated = 1425119328000;
 */

//积分福利

@property (nonatomic, copy) NSString* applyDate; //申请时间
@property (nonatomic, copy) NSString* applyNo; //申请单号
@property (nonatomic, copy) NSString* applyType; //申请类别
@property (nonatomic, assign) NSInteger detailType; //申请类别

@property (nonatomic, copy) NSString* amount; //批复金额
@property (nonatomic, copy) NSString* medicalId; //用于查询详情

//意外
@property (nonatomic, copy) NSString* applyId; //申请单号

@end

@interface CheckItem : NSObject

@property (nonatomic, copy) NSString* itemName; //项目名字
@property (nonatomic, copy) NSString* itemValue; //项目值
@property (nonatomic, strong) NSArray *imgUrlArr; //图片数组
@property (nonatomic, copy) NSString *imgTitle; //图片名称

@property (nonatomic, assign)float height;


@end




