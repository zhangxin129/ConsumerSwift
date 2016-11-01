//
//  GYHEHeadViewSeventhCell.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//右边有滑块 两种支付方式的选择
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, PaymentType)
{
    kPaymentTypeArriveGoods = 1, //货到付款
    kPaymentTypeOnInternet  = 2, //在线支付
};

@class GYHEHeadViewSeventhCell;
//代理方法
@protocol GYHEHeadViewSeventhCellDelegate <NSObject>
//刷新表
- (void)transmitPayType:(PaymentType)payType;


@end


@interface GYHEHeadViewSeventhCell : UITableViewCell
@property (nonatomic, weak) id<GYHEHeadViewSeventhCellDelegate> delegate;
//显示支付方式 四个字
@property (weak, nonatomic) IBOutlet UILabel *chargeTypeLabel;


@end
