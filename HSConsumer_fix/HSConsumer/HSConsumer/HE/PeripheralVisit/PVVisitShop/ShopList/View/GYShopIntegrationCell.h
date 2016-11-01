//
//  GYShopIntegrationCell.h
//  HSConsumer
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackBlock)(NSInteger tag, NSString* idStr);
@interface GYShopIntegrationCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray* picArr; //图片数组
@property (weak, nonatomic) IBOutlet UIImageView* leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView* rightImageView;
@property(nonatomic, strong) BackBlock block;

@end
