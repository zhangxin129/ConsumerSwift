//
//  GYTicketAccountDetailCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTicketAccountDetailCell.h"
#import "GYHSTools.h"

@interface GYTicketAccountDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *faceValueTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *faceValueTextLab;
@property (weak, nonatomic) IBOutlet UILabel *canUseCountTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *canUseCountTextLab;
@property (weak, nonatomic) IBOutlet UILabel *useTimeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *useTimeTextLab;
@property (weak, nonatomic) IBOutlet UILabel *orderIdTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderIdTextLab;

@property (weak, nonatomic) IBOutlet UIImageView *coinImgView;

@end

@implementation GYTicketAccountDetailCell

- (void)awakeFromNib {
    _coinImgView.image = [UIImage imageNamed:@"gyhs_account_coin"] ;
    
    _faceValueTitleLab.text = kLocalized(@"GYHS_HSAccount_ticketValue");
    _faceValueTitleLab.font = kAlterDetailCellFont;
    _faceValueTitleLab.textColor = kCellTitleBlack;
    _faceValueTextLab.font = kAlterDetailCellFont;
    _faceValueTextLab.textColor = kSelectedRed;
    
    _canUseCountTitleLab.text = kLocalized(@"GYHS_HSAccount_ticketUseCount");
    _canUseCountTitleLab.font = kAlterDetailCellFont;
    _canUseCountTitleLab.textColor = kCellTitleBlack;
    _canUseCountTextLab.font = kAlterDetailCellFont;
    _canUseCountTextLab.textColor = kCellTitleBlack;
    
    _useTimeTitleLab.text = kLocalized(@"GYHS_HSAccount_useTime");
    _useTimeTitleLab.font = kAlterDetailCellFont;
    _useTimeTitleLab.textColor = kCellTitleBlack;
    _useTimeTextLab.font = kAlterDetailCellFont;
    _useTimeTextLab.textColor = kCellTitleBlack;
    
    _orderIdTitleLab.text = kLocalized(@"GYHS_HSAccount_orderId");
    _orderIdTitleLab.font = kAlterDetailCellFont;
    _orderIdTitleLab.textColor = kCellTitleBlack;
    _orderIdTextLab.font = kAlterDetailCellFont;
    _orderIdTextLab.textColor = kCellTitleBlack;
    
    
}
- (void)setModel:(GYTicketAccountDetailModel *)model {
    _model = model;
    
    _faceValueTextLab.text = [GYUtils formatCurrencyStyle:[kSaftToNSString(model.faceValue) doubleValue]];
    _canUseCountTextLab.text = model.number;
    
    NSDate* cdate = [NSDate dateWithTimeIntervalSince1970:[model.couponUseTime longLongValue] / 1000];
    NSString* exEndTime = [GYUtils dateToString:cdate];
    
    _useTimeTextLab.text = exEndTime;
    _orderIdTextLab.text = model.orderNo;
}


@end
