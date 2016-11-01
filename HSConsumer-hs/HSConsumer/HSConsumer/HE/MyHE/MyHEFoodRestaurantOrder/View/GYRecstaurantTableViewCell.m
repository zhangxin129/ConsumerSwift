//
//  GYRecstaurantTableViewCell.m
//  HSConsumer
//
//  Created by appleliss on 15/9/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYRecstaurantTableViewCell.h"

#define imagew 15

@interface GYRecstaurantTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel* lbOrderName; ///餐厅名称
@property (weak, nonatomic) IBOutlet UIButton* cancelBtn2;

@end
@implementation GYRecstaurantTableViewCell

+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    GYRecstaurantTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:KGYRecstaurantTableViewCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYRecstaurantTableViewCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (IBAction)IMChat:(UIButton*)sender
{
    if ([_gydelegate respondsToSelector:@selector(GYRecstaurantTableViewCellDelegateIMChact:)]) {
        [_gydelegate GYRecstaurantTableViewCellDelegateIMChact:self.model];
    }
}

- (IBAction)canclclick:(id)sender
{
    if ([_gydelegate respondsToSelector:@selector(GYRecstaurantTableViewCellcalorder:)]) {
        [_gydelegate GYRecstaurantTableViewCellcalorder:self.model];
    }
}

- (IBAction)playclick:(id)sender
{
    if ([_gydelegate respondsToSelector:@selector(GYRecstaurantTableViewCellconfirm:)]) {
        [_gydelegate GYRecstaurantTableViewCellconfirm:self.model];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.btnCancl setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
    [self.cancelBtn2 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
    self.cancelBtn2.hidden = YES;
    [self.btnPay setTitle:kLocalized(@"GYHE_MyHE_Pay") forState:UIControlStateNormal];
    self.btnPay.layer.cornerRadius = 3;
    self.btnPay.layer.masksToBounds = YES;
    self.btnPay.layer.borderColor = kNavigationBarColor.CGColor;
    self.btnPay.layer.borderWidth = 0.5f;
    self.btnCancl.layer.cornerRadius = 3;
    self.btnCancl.layer.masksToBounds = YES;
    self.btnCancl.layer.borderColor = [kCorlorFromRGBA(160, 160, 160, 1) CGColor];
    self.btnCancl.layer.borderWidth = 0.5f;
    self.cancelBtn2.layer.cornerRadius = 3;
    self.cancelBtn2.layer.masksToBounds = YES;
    self.cancelBtn2.layer.borderColor = [kCorlorFromRGBA(160, 160, 160, 1) CGColor];
    self.cancelBtn2.layer.borderWidth = 0.5f;
    self.orderNumLabel.text = kLocalized(@"GYHE_MyHE_OrdrNumber");
    self.lbTitleTime.text = kLocalized(@"GYHE_MyHE_AppointMakeTime");
    self.lbPersonNumberTitle.text = [kLocalized(@"GYHE_MyHE_EatingPeopleNmuber") stringByAppendingString:@":"];
    self.lbOrderTitle.text = kLocalized(@"GYHE_MyHE_PrepaidAmount");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setModel:(GYOrderModel*)model
{
    _model = model;
    _lbOrderName.text = kSaftToNSString(model.restaurantName);
    _lbHSNumber.text = kSaftToNSString(model.hsNumber);
    _lbTime.text = kSaftToNSString(model.useDate);
    _lbPersonNumber.text = kSaftToNSString(model.personNum);
    if ([model.amountActually floatValue] > 0) {
        _lbOrderTitle.text = [kLocalized(@"GYHE_MyHE_ShouldPayMoney") stringByAppendingString:@":"];
        _lbJBNumber.text = [NSString stringWithFormat:@"%0.2f", [model.amountActually floatValue]];
    }
    else {
        if ([model.orderSate intValue] == 7) {
            _lbJBNumber.text = [NSString stringWithFormat:@"%0.2f", [model.amountActually floatValue]];
        }
        else {
            _lbJBNumber.text = [NSString stringWithFormat:@"%0.2f", [kSaftToNSString(model.preAmount) floatValue]];
        }
    }
    _lbOrderNuber.text = model.orderNumber;
    switch ([model.orderSate intValue]) {
    case -2: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitConfirm");
        _btnCancl.hidden = YES;
        _btnPay.hidden = YES;
    } break;
    case -3: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitConfirm");
        _btnCancl.frame = _btnPay.frame;
        _btnPay.hidden = YES;
        _btnCancl.hidden = YES;
        _cancelBtn2.hidden = NO;
        _btnCancl.tag = -3;
    } break;
    case 0: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitPay");
        _lbOrderTitle.text = kLocalized(@"GYHE_MyHE_PrepaidAmount");
    } break;
    case 1: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitConfirm");
        _lbOrderTitle.text = kLocalized(@"GYHE_MyHE_PrepaidAmount");
        [_btnCancl setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
        _btnCancl.frame = _btnPay.frame;
        _btnCancl.hidden = YES;
        _cancelBtn2.hidden = NO;
        _btnPay.hidden = YES;
    } break;
    case 2: {
        _btnCancl.hidden = YES;
        if ([model.type isEqualToString:@"1"]) {
            _lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
            _btnPay.hidden = YES;
            _lbOrderTitle.text = kLocalized(@"GYHE_MyHE_PrepaidAmount");
        }
        else {
            _lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
            [self.cancelBtn2 setTitle:kLocalized(@"GYHE_MyHE_CancelOrder") forState:UIControlStateNormal];
            self.cancelBtn2.tag = 2;
            self.cancelBtn2.hidden = NO;
            _btnPay.hidden = YES;
            //            _btnCancl.frame = _btnPay.frame;//_lbJBNumber
            _lbOrderTitle.text = kLocalized(@"GYHE_MyHE_OrderAmount");
            _lbTitleTime.text = kLocalized(@"GYHE_MyHE_TakeTime");
            _lbPersonNumberTitle.hidden = YES;
            _lbPersonNumber.hidden = YES;
        }
    } break;
    case 4: {
        //            修改交易完成订单金额显示
        _lbJBNumber.text = [NSString stringWithFormat:@"%0.2f", [model.totalAmount floatValue]]; //+[model.amountOther floatValue]
        //            _lbJBNumber.text = model.totalAmount;
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_OrderFinish");
        _lbOrderTitle.text = [kLocalized(@"GYHE_MyHE_OrderAmount") stringByAppendingString:@":"];
        if ([model.remarkStatus integerValue] == -1 || [model.remarkStatus integerValue] == 0) {
            [_btnPay setTitle:kLocalized(@"GYHE_MyHE_Evaluate") forState:UIControlStateNormal];
            _btnPay.tag = 4;
        }
        else {
            _lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyEvaluate");
            _btnPay.hidden = YES;
        }
        _btnCancl.hidden = YES;
    } break;
    case 6: {
        _lbOrderTitle.text = kLocalized(@"GYHE_MyHE_PrepaidAmount");
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_Eating");
        _btnPay.hidden = YES;
        _btnCancl.hidden = YES;
    } break;
    case 7: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitPay");
        _btnCancl.hidden = YES;
        if ([_lbJBNumber.text isEqualToString:@"0.00"]) {
            _btnPay.hidden = YES;
        }
        else {
            [_btnPay setTitle:kLocalized(@"GYHE_MyHE_Pay") forState:UIControlStateNormal];
        }
        //2016年05月13日--- bill------------------------
        if ([model.amountActually floatValue] == 0) {
            _lbOrderTitle.text = [kLocalized(@"GYHE_MyHE_ShouldPayMoney") stringByAppendingString:@":"];
            _btnPay.hidden = YES;
        }
        //2016年05月13日---------------------------
    } break;
    case 8: {
        if ([model.type isEqualToString:@"1"]) {
            _lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitConfirm");
            [_btnCancl setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
        }
        else { /////自提
            _lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitConfirm");
            _lbTitleTime.text = kLocalized(@"GYHE_MyHE_TakeTime");
            [_cancelBtn2 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
        }
        _btnPay.hidden = YES;
        _btnCancl.hidden = YES;
        _cancelBtn2.hidden = NO;
        //      _btnCancl.frame = _btnPay.frame;
    } break;
    case 9: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
        if ([model.type isEqualToString:@"3"]) {
            _lbTitleTime.text = kLocalized(@"GYHE_MyHE_TakeTime");
        }
        _btnCancl.hidden = YES;
        _btnPay.hidden = YES;
    } break;
    case 10: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitShopCancel");
        _btnCancl.hidden = YES;
        _btnPay.hidden = YES;
    } break;
    case 99: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyCanceled");
        _lbOrderTitle.text = kLocalized(@"GYHE_MyHE_PrepaidAmount");
        _btnCancl.hidden = YES;
        _btnPay.hidden = YES;
    } break;
    default:
        break;
    }
    if ([model.type isEqualToString:@"3"]) {
        _lbTitleTime.text = kLocalized(@"GYHE_MyHE_TakeTime");
        _lbOrderTitle.text = [NSString stringWithFormat:@"%@:", kLocalized(@"GYHE_MyHE_OrderAmount")];
        self.distanceTopConstraint.constant = -23;
        _lbPersonNumberTitle.hidden = YES;
        _lbPersonNumber.hidden = YES;
    }
    
}

@end
