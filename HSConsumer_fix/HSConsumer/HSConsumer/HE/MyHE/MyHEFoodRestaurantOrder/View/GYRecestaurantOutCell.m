//
//  GYRecestaurantOutCell.m
//  HSConsumer
//
//  Created by appleliss on 15/9/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
//// view
#import "GYRecestaurantOutCell.h"
#import "Masonry.h"

@implementation GYRecestaurantOutCell

+ (instancetype)cellWithTableView:(UITableView*)tableView andDelegate:(id)delegate
{
    GYRecestaurantOutCell* cell = [tableView dequeueReusableCellWithIdentifier:KGYRecestaurantOutCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GYRecestaurantOutCell" owner:nil options:nil] lastObject];
    }
    cell.gyRecstaurantTableViewCellDelegate = delegate;
    //    cell.model=model;
    return cell;
}

- (IBAction)IMBtn:(id)sender
{

    if ([_gyRecstaurantTableViewCellDelegate respondsToSelector:@selector(GYRecstaurantTableViewCellDelegateIMChact:)]) {
        [_gyRecstaurantTableViewCellDelegate GYRecstaurantTableViewCellDelegateIMChact:self.model];
    }
}

- (IBAction)canclclick:(id)sender
{
    if ([_gyRecstaurantTableViewCellDelegate respondsToSelector:@selector(GYRecstaurantTableViewCellcalorder:)]) {
        [_gyRecstaurantTableViewCellDelegate GYRecstaurantTableViewCellcalorder:self.model];
    }
    DDLogDebug(@"取消按钮");
}

- (IBAction)playclick:(id)sender
{
    DDLogDebug(@"去评价");
    if ([_gyRecstaurantTableViewCellDelegate respondsToSelector:@selector(GYRecstaurantTableViewCellconfirm:)]) {
        [_gyRecstaurantTableViewCellDelegate GYRecstaurantTableViewCellconfirm:self.model];
    }
}

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (self.nav) {

        [self.nav pushViewController:vc animated:ani];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.btnPay setTitle:kLocalized(@"GYHE_MyHE_Pay") forState:UIControlStateNormal];
    [self.btnCancl setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
    self.btnPay.layer.cornerRadius = 3;
    self.btnPay.layer.masksToBounds = YES;
    self.btnPay.layer.borderColor = kNavigationBarColor.CGColor;
    self.btnPay.layer.borderWidth = 0.5f;
    self.btnCancl.layer.cornerRadius = 3;
    self.btnCancl.layer.masksToBounds = YES;
    self.btnCancl.layer.borderColor = [kCorlorFromRGBA(160, 160, 160, 1) CGColor];
    self.btnCancl.layer.borderWidth = 0.5f;
    self.orderNumLabel.text = kLocalized(@"GYHE_MyHE_OrdrNumber");
    self.orderPaymentLabel.text = [kLocalized(@"GYHE_MyHE_OrderAmount") stringByAppendingString:@":"];
    self.lbTitleTime.text = kLocalized(@"GYHE_MyHE_ReachTime");
    self.lbIntegral.text = kLocalized(@"GYHE_MyHE_IntegralTitle");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(GYOrderModel*)model
{
    _model = model;
    _shopName.text = kSaftToNSString(model.restaurantName);
    _lbHSNumber.text = kSaftToNSString(model.hsNumber);
    _lbTime.text = kSaftToNSString(model.useDate);
    _lbJBNumber.text = [NSString stringWithFormat:@"%0.2f", [model.amountActually floatValue]];
    _lbOrderNuber.text = model.orderNumber;
    _lbOrderState.text = model.orderSate;
    _lbPVNumber.text = [NSString stringWithFormat:@"%0.2f", [model.totalPv floatValue]];
    switch ([model.orderSate intValue]) {
    case 2: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
        [_btnCancl setTitle:kLocalized(@"GYHE_MyHE_CancelOrder") forState:UIControlStateNormal];
        _btnPay.tag = 2;
        _btnPay.hidden = YES;
        [_btnCancl mas_makeConstraints:^(MASConstraintMaker* make) {
                make.center.equalTo(_btnPay);
        }];
    } break;
    case 4: {
        if ([model.remarkStatus isEqualToString:@"-1"] || [model.remarkStatus isEqualToString:@"0"]) {
            _lbOrderState.text = kLocalized(@"GYHE_MyHE_OrderFinish");
            [_btnPay setTitle:kLocalized(@"GYHE_MyHE_Evaluate") forState:UIControlStateNormal];
            _btnPay.tag = 4;
            _btnCancl.hidden = YES;
        }
        else {
            _lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyEvaluate");
            _btnCancl.hidden = YES;
            _btnPay.hidden = YES;
        }
    } break;
    case 8: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitConfirm");
        _btnPay.hidden = YES;
        //        _btnCancl.frame = _btnPay.frame;
        [_btnCancl mas_makeConstraints:^(MASConstraintMaker* make) {
                make.center.equalTo(_btnPay);
        }];
    } break;
    case 10: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitShopCancel");
        _btnCancl.hidden = YES;
        _btnPay.hidden = YES;
    } break;
    case 11: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_DeliverMeals");
        _btnPay.hidden = YES;
        _btnCancl.hidden = YES;
    } break;
    case 99: {
        _lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyCanceled");
        _btnCancl.hidden = YES;
        _btnPay.hidden = YES;
    } break;
        default:
            break;
    }
}

@end
