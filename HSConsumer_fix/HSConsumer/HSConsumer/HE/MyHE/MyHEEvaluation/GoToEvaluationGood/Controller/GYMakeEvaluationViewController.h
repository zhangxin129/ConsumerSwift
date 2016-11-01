//
//  GYMakeEvaluationViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEvaluateGoodModel.h"
typedef void (^refreshListBlock)(GYEvaluateGoodModel*);
@interface GYMakeEvaluationViewController : GYViewController <UITextViewDelegate>

@property (nonatomic, strong) GYEvaluateGoodModel* model;

@property (nonatomic, copy) NSString* strComment;
@property (nonatomic, copy) NSString* tag;  //标签
//add by zhangqy 9295 iOS消费者--我的评价--待评价列表中商品评价提交跳转回列表后，此条评价还保留在待评价列表，需刷新才消失
@property (nonatomic, copy) refreshListBlock refreshListBlock;
@end
