//
//  GYHSQueryToolListCell.m
//  HSCompanyPad
//
//  Created by User on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSQueryToolListCell.h"
#import "GYHSStoreQueryListModel.h"
#import "GYHSStoreKVUtils.h"

@interface GYHSQueryToolListCell()
@property (weak, nonatomic) IBOutlet UILabel *headNameLabel;//标题

@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;//付款状态

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//订单号

@property (weak, nonatomic) IBOutlet UILabel *orderNoTitleLable;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;//下单时间
@property (weak, nonatomic) IBOutlet UILabel *orderTimeTitleLable;

@property (weak, nonatomic) IBOutlet UILabel *amountLable;
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLable;

@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *payTypeTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation GYHSQueryToolListCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.headNameLabel.textColor = kGray333333;
    self.orderNoTitleLable.textColor = kGray999999;
    self.orderTimeTitleLable.textColor = kGray999999;
    self.amountTitleLable.textColor = kGray999999;
    self.payTypeTitleLable.textColor = kGray999999;
    self.orderLabel.textColor = kGray333333;
    self.orderTimeLabel.textColor = kGray333333;
    self.amountLable.textColor = kGray333333;
    self.payTypeLabel.textColor = kGray333333;
    

}

- (void)setModel:(GYHSStoreQueryListModel *)model
{
    _model = model;
    self.headNameLabel.text = [GYHSStoreKVUtils getOrderType:model.orderType];
    self.payStatusLabel.text = [GYHSStoreKVUtils getOrderStatusWithStatus:model.orderStatus];
    
    self.orderLabel.text = model.orderNo;
    self.orderTimeLabel.text = model.orderTime;
    self.payTypeLabel.text = [GYHSStoreKVUtils getOrderPayWay:[NSString stringWithFormat:@"%ld",(long)model.payChannel]];
    self.amountLable.text = [GYUtils formatCurrencyStyle: model.orderOriginalAmount.doubleValue];
    if ([model.orderStatus isEqualToString:@"1"]) {
        self.payStatusLabel.textColor = kRedE50012;
    }else{
        self.payStatusLabel.textColor = kGray999999;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        
        self.arrowImageView.image =[UIImage imageNamed:@"gyhs_greenArrow"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F9FF"];
    }
    else{
         self.arrowImageView.image =[UIImage imageNamed:@"gyhs_grayArrow"];
        self.contentView.backgroundColor = kWhiteFFFFFF;
    }
  
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeTop | UIViewCustomBorderTypeBottom;
    
}


@end
