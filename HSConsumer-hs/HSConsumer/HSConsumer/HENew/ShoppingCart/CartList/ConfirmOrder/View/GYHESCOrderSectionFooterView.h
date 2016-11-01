//
//  GYHESCOrderSectionFooterView.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/28.
//  Copyright © 2016年 zhangqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHESCOrderModel.h"
#import "GYHESCDiscountInfoModel.h"

@protocol GYHESCOrderSectionFooterViewDelegate <NSObject>

@optional

- (void)pushToDistributionWayWithSection:(NSInteger)section; //跳转代理
- (void)pushToChooseAreaWithIndexPath:(NSInteger)section;
- (void)calculateWhenConsumeSwitchDidChange; //当是否使用消费券开关更改时，重新计算金额与积分

@end

@interface GYHESCOrderSectionFooterView : UITableViewHeaderFooterView <UITextViewDelegate>

//含tag是标签
@property (weak, nonatomic) IBOutlet UILabel* goodsNumberLabel; //货物数量
@property (weak, nonatomic) IBOutlet UILabel* totalTagLabel;
@property (weak, nonatomic) IBOutlet UILabel* moneyLabel; //总金额
@property (weak, nonatomic) IBOutlet UILabel* pvLabel; //总积分
@property (weak, nonatomic) IBOutlet UILabel *transFeeTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *transFeeLabel;//运费
@property (weak, nonatomic) IBOutlet UILabel *realMoneyTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNumberLabel;//实付金额
@property (weak, nonatomic) IBOutlet UILabel *couponFeeNumberLabel;//消费券抵扣金额

@property (weak, nonatomic) IBOutlet UILabel* operatingPointTagLabel;
@property (weak, nonatomic) IBOutlet UILabel* operatingPointLabel; //营业点
@property (weak, nonatomic) IBOutlet UIImageView* rightArrowImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* rightArrowImgWidth; //右跳转图标宽度
@property (weak, nonatomic) IBOutlet UILabel* sendWayTagLabel;
@property (weak, nonatomic) IBOutlet UILabel* sendWayLabel; //配送方式
@property (weak, nonatomic) IBOutlet UILabel* expressageLabel; //快递费
@property (weak, nonatomic) IBOutlet UILabel* leaveMessageTagLabel;
@property (weak, nonatomic) IBOutlet UITextView* leaveMessageTextView; //给卖家留言
@property (weak, nonatomic) IBOutlet UILabel* applyCardTagLabe;
@property (weak, nonatomic) IBOutlet UISwitch* applyCardSwitch; //申请互生卡选择开关
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* applyCardViewHeight; //申请互生卡View高度
@property (weak, nonatomic) IBOutlet UILabel* invoiceTagLabel;
@property (weak, nonatomic) IBOutlet UISwitch* invoiceSwitch; //开具发票选择开关
@property (weak, nonatomic) IBOutlet UILabel* invoiceHeadTagLabel;
@property (weak, nonatomic) IBOutlet UITextView* invoiceHeadTextView; //发票抬头编辑
//@property (weak, nonatomic) IBOutlet UILabel *consumeTagLabel;
@property (weak, nonatomic) IBOutlet UILabel* consumeLabel; //消费券
@property (weak, nonatomic) IBOutlet UISwitch* consumeSwitch; //是否选择使用消费券开关

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* coinIconWidth; //消费币图标宽度
@property (weak, nonatomic) IBOutlet UIView* distributionView;
@property (weak, nonatomic) IBOutlet UIView* chooseAreaView;

@property (nonatomic, strong) GYHESCOrderModel* orderModel;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy) NSString* isRightAway; //是否立即购买 0 否 1 是
//抬头发票
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* invoiceHeight;
@property (weak, nonatomic) IBOutlet UIView* invoiceView;

@property (nonatomic, copy) void(^invoiceBlock)();

@property (nonatomic, weak) id<GYHESCOrderSectionFooterViewDelegate> delegate;

- (void)refreshDataWithModel:(GYHESCOrderModel *)model discountInfoModel:(GYHESCDiscountInfoModel *)discountModel;

@end
