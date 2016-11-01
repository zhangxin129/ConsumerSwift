//
//  GYEeayBuyTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"
@interface GYEeayBuyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* imgLeftImage; //左边图片imgview
@property (weak, nonatomic) IBOutlet UIImageView* imgRightImage; //右边图片imgview
@property (weak, nonatomic) IBOutlet UILabel* lbLeftGoodName; //左边商品名称
@property (weak, nonatomic) IBOutlet UILabel* lbLeftGoodPrice; //左边商品价格
@property (weak, nonatomic) IBOutlet UILabel* lbLeftGoodPv; //左边商品积分
@property (weak, nonatomic) IBOutlet UILabel* lbRightGoodName; //右边商品名称
@property (weak, nonatomic) IBOutlet UILabel* lbRightGoodPrice; //右边商品价格
@property (weak, nonatomic) IBOutlet UILabel* lbRightGoodPv; //右边商品积分
@property (weak, nonatomic) IBOutlet UIView* vLine;

@property (weak, nonatomic) IBOutlet UIImageView* imgvCoinIcon;
@property (weak, nonatomic) IBOutlet UIImageView* imgvPointIcon;

@property (weak, nonatomic) IBOutlet UIImageView* imgvRightCoinIcon;
@property (weak, nonatomic) IBOutlet UIImageView* imgvRightPointIcon;
//@property (weak, nonatomic) IBOutlet UIImageView *imgvRightTicket;
//@property (weak, nonatomic) IBOutlet UIImageView *imgvRightReach;
//@property (weak, nonatomic) IBOutlet UIImageView *imgvRightSell;
//@property (weak, nonatomic) IBOutlet UIImageView *imgvRightCash;
//@property (weak, nonatomic) IBOutlet UIImageView *imgvRightTake;
@property (weak, nonatomic) IBOutlet UILabel* lbRightSellCount;
@property (weak, nonatomic) IBOutlet UILabel* lbRightHscompany;
@property (weak, nonatomic) IBOutlet UILabel* lbRightCity;
/***左边改UI 添加的控件**/
@property (weak, nonatomic) IBOutlet UILabel* lbLeftSellCount;
//@property (weak, nonatomic) IBOutlet UIImageView *imgvLeftReach;
//@property (weak, nonatomic) IBOutlet UIImageView *imgvLeftSell;
//@property (weak, nonatomic) IBOutlet UIImageView *imgvLeftCash;
//@property (weak, nonatomic) IBOutlet UIImageView *imgvLeftTake;
@property (weak, nonatomic) IBOutlet UILabel* lbLeftCity;

//@property (weak, nonatomic) IBOutlet UIImageView *imgvTicket;
@property (weak, nonatomic) IBOutlet UILabel* lbLeftHScompany;

/*控制5个特殊服务*/
@property (nonatomic, copy) NSString* beCash;
@property (nonatomic, copy) NSString* beReach;
@property (nonatomic, copy) NSString* beSell;
@property (nonatomic, copy) NSString* beTake;
@property (nonatomic, copy) NSString* beTicket;
@property (nonatomic, copy) NSString* beCashRight;
@property (nonatomic, copy) NSString* beReachRight;
@property (nonatomic, copy) NSString* beSellRight;
@property (nonatomic, copy) NSString* beTakeRight;
@property (nonatomic, copy) NSString* beTicketRight;
@property (weak, nonatomic) IBOutlet UIButton* btnLeftCover; //左边覆盖BTN
@property (weak, nonatomic) IBOutlet UIButton* btnRightCover; //右边覆盖BTN

@property (weak, nonatomic) IBOutlet UIView* vRight;

@property (weak, nonatomic) IBOutlet UIView *vLeft;


- (void)refreshUIWithModel:(GYEasyBuyModel *)model WithSecondModel:(GYEasyBuyModel *)rightModel;
@end
