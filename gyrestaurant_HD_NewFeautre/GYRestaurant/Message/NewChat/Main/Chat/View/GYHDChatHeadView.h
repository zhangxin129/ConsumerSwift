//
//  GYHDChatHeadView.h
//  GYRestaurant
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDNewChatModel.h"
@interface GYHDChatHeadView : UIView
@property(nonatomic,strong)UIImageView*iconImg;//商品图片
@property(nonatomic,strong)UILabel*nameLabel;//商品名
@property(nonatomic,strong)UILabel*descripLabel;//商品描述
@property(nonatomic,strong)UIImageView*hsiconImg;//互生币图标
@property(nonatomic,strong)UILabel*hsCoinLabel;//互生币
@property(nonatomic,strong)UIImageView*integrateImg;//积分图标
@property(nonatomic,strong)UILabel*integrateLabel;//积分
@property(nonatomic,strong)GYHDNewChatModel*chatShopModel;
@end
