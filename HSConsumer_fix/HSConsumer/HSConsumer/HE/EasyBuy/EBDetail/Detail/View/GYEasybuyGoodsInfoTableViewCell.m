//
//  GYEasybuyGoodsInfoTableViewCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/11.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import "GYEasybuyGoodsInfoTableViewCell.h"
#import "UIView+CustomBorder.h"

@interface GYEasybuyGoodsInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView* beReachIv;
@property (weak, nonatomic) IBOutlet UILabel* beReachLabel;
@property (weak, nonatomic) IBOutlet UIImageView* beSellIv;
@property (weak, nonatomic) IBOutlet UILabel* beSellLabel;
@property (weak, nonatomic) IBOutlet UIImageView* beCashIv;
@property (weak, nonatomic) IBOutlet UILabel* beCashLabel;
@property (weak, nonatomic) IBOutlet UIImageView* beTakeIv;
@property (weak, nonatomic) IBOutlet UILabel* beTakeLabel;
@property (weak, nonatomic) IBOutlet UIImageView* beTicketIv;
@property (weak, nonatomic) IBOutlet UILabel* beTicketLabel;
@property (weak, nonatomic) IBOutlet UILabel* couponDescLabel; //消费券信息

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView* coinImgView;
@property (weak, nonatomic) IBOutlet UIImageView* pvImgView;

@property (weak, nonatomic) IBOutlet UILabel* priceLabel;
@property (weak, nonatomic) IBOutlet UILabel* pvLabel;
@property (weak, nonatomic) IBOutlet UILabel* postageMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel* salesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel* vShopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* cityLabel;
@property (weak, nonatomic) IBOutlet UIView* verticalSeparateView;
@property (weak, nonatomic) IBOutlet UIView* horizontalSeparateView;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint* beTicketViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView* ticketView;

@property (weak, nonatomic) IBOutlet UIView* couponView;

@end

@implementation GYEasybuyGoodsInfoTableViewCell

- (void)awakeFromNib
{
    _couponView.clipsToBounds = YES;
    // Initialization code
    [self.verticalSeparateView addLeftBorder];
    [self.horizontalSeparateView addTopBorder];
    _couponViewHeight.constant = 0;
    _beTicketViewHeightConstraint.constant = 0;

    self.beTicketLabel.text = kLocalized(@"GYHE_Easybuy_ticket");
    self.beReachLabel.text = kLocalized(@"GYHE_Easybuy_delivery_on_time");
    self.beSellLabel.text = kLocalized(@"GYHE_Easybuy_delivery_home");
    self.beCashLabel.text = kLocalized(@"GYHE_Easybuy_cash_on_delivery");
    self.beTakeLabel.text = kLocalized(@"GYHE_Easybuy_get_by_yourself");

    _ticketView.hidden = YES;
    _couponView.hidden = YES;
    _coinImgView.image = [UIImage imageNamed:@"gyhe_food_coin"];
    _pvImgView.image = [UIImage imageNamed:@"gyhe_about_pv_image"];
}

- (IBAction)couponViewShow:(UIButton*)sender
{

    //    _vc.showCoupon = !_vc.showCoupon;
    if ([self.delegate respondsToSelector:@selector(showCouponView:)]) {
        [self.delegate showCouponView:self];
    }
}

- (void)setModel:(GYEasybuyGoodsInfoModel*)model
{
    if (model) {

        _model = model;
        self.titleLabel.text = model.title;

        if ([model.price doubleValue] == [model.lowPrice doubleValue]) {
            self.priceLabel.text = [NSString stringWithFormat:@"%.2f", [model.price doubleValue]];
        }
        else {
            self.priceLabel.text = [NSString stringWithFormat:@"%.2f~%.2f", [model.lowPrice doubleValue], [model.price doubleValue]];
        }
        if ([model.lowPv doubleValue] == [model.pv doubleValue]) {
            self.pvLabel.text = [NSString stringWithFormat:@"%.2f", [model.pv doubleValue]];
        }
        else {
            self.pvLabel.text = [NSString stringWithFormat:@"%.2f起", [model.lowPv doubleValue]];
        }

        if (model.beFocus) {
            self.beFocusIv.image = [UIImage imageNamed:@"gyhe_collect_yes"];
            self.beFocusLabel.text = kLocalized(@"GYHE_Easybuy_didCollection");
        }
        else {
            self.beFocusIv.image = [UIImage imageNamed:@"gyhe_collect_no"];
            self.beFocusLabel.text = kLocalized(@"GYHE_Easybuy_collection");
        }
        if (!model.postage || [kSaftToNSString(model.postage)  isEqualToString:@"0"]) {
            self.postageMsgLabel.text = model.postageMsg;
            self.postageMsgLabel.text = kLocalized(@"GYHE_Easybuy_freeShipping");
        } else {
            self.postageMsgLabel.text = [NSString stringWithFormat:@"%@:%.2f  %@", kLocalized(@"GYHE_Easybuy_expressFee"), [model.postage doubleValue],model.postageMsg];
        }

        self.salesCountLabel.text = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_Easybuy_totalSales"), model.salesCount.stringValue];
        self.vShopNameLabel.text = model.vShopName;
        self.cityLabel.text = model.city;

        if ([model.couponDesc isKindOfClass:[NSString class]]) {
            if (model.couponDesc.length > 0) {
                self.couponDescLabel.text = model.couponDesc;
                if (_vc.showCoupon) {
                    _ticketView.hidden = NO;
                    _couponView.hidden = NO;
                    self.beTicketViewHeightConstraint.constant = 21;
                    _couponViewHeight.constant = 26;
                }
                else {
                    _ticketView.hidden = NO;
                    _couponView.hidden = YES;
                    self.beTicketViewHeightConstraint.constant = 21;
                    _couponViewHeight.constant = 0;
                }
            }
        }

        _beTicketIv.image = model.beTicket ? [UIImage imageNamed:@"gyhe_good_detail5"] : [UIImage imageNamed:@"gyhe_image_good_detail_unselected_5"];
        _beReachIv.image = model.beReach ? [UIImage imageNamed:@"gyhe_good_detail1"] : [UIImage imageNamed:@"gyhe_image_good_detail_unselected_1"];
        _beSellIv.image = model.beSell ? [UIImage imageNamed:@"gyhe_good_detail2"] : [UIImage imageNamed:@"gyhe_image_good_detail_unselected_2"];
        _beCashIv.image = model.beCash ? [UIImage imageNamed:@"gyhe_good_detail3"] : [UIImage imageNamed:@"gyhe_image_good_detail_unselected_3"];
        _beTakeIv.image = model.beTake ? [UIImage imageNamed:@"gyhe_good_detail4"] : [UIImage imageNamed:@"gyhe_image_good_detail_unselected_4"];
    }
}

@end
