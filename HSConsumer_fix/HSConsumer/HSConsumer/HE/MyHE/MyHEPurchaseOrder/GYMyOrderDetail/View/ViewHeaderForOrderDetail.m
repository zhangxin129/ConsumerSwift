//
//  ViewHeaderForOrderDetail.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewHeaderForOrderDetail.h"

@interface ViewHeaderForOrderDetail ()
// 联系客服
@property (weak, nonatomic) IBOutlet UIButton* btnContact;

@end

@implementation ViewHeaderForOrderDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)btnContactClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(ViewHeaderForOrderDetailContactDidClickedWithView:)]) {
        [self.delegate ViewHeaderForOrderDetailContactDidClickedWithView:self];
    }
}

- (id)init
{
    NSArray* subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    ViewHeaderForOrderDetail* v = [subviewArray objectAtIndex:0];
    v.lbTimeLeft.font = [UIFont systemFontOfSize:13];
    v.lbTimeLeft.textColor = kCorlorFromHexcode(0x5A5A5A);
    [v.lbLabelLogisticInfo setText:kLocalized(@"GYHE_MyHE_LogisticsInformation")];
    [v.lbLabelLogisticInfo setTextColor:kCorlorFromHexcode(0x464646)];
    v.lbLabelLogisticInfo.font = [UIFont systemFontOfSize:16];

    [v.lbLogisticName setText:kLocalized(@"GYHE_MyHE_ExpressCompany")];
    [v.lbLogisticName setTextColor:kCorlorFromHexcode(0x8C8C8C)];
    v.lbLogisticName.font = [UIFont systemFontOfSize:16];

    [v.lbLogisticOrderNo setText:kLocalized(@"GYHE_MyHE_HECourierNumber")];
    [v.lbLogisticOrderNo setTextColor:kCorlorFromHexcode(0x8C8C8C)];
    v.lbLogisticOrderNo.font = [UIFont systemFontOfSize:16];

    [v.btnCheckLogisticDetail setTitle:kLocalized(@"GYHE_MyHE_CheckLogisticsInformation") forState:UIControlStateNormal];
    [v.btnCheckLogisticDetail setTitleColor:kCorlorFromHexcode(0xFA3C28) forState:UIControlStateNormal];
    v.btnCheckLogisticDetail.titleLabel.font = [UIFont systemFontOfSize:14];

    [v.lbConsignee setTextColor:kCorlorFromHexcode(0x464646)];
    v.lbConsignee.font = [UIFont systemFontOfSize:17];
    v.lbTel.font = [UIFont systemFontOfSize:17];
    v.lbTel.textColor = kCorlorFromHexcode(0x464646);

    [v.lbConsigneeAddress setTextColor:kCorlorFromHexcode(0xA0A0A0)];
    v.lbConsigneeAddress.font = [UIFont systemFontOfSize:15];
    [v.btnVshopName setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];

    [GYUtils setFontSizeToFitWidthWithLabel:v.lbLogisticName labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:v.lbLogisticOrderNo labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:v.btnVshopName.titleLabel labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:v.lbConsigneeAddress labelLines:2];
    [GYUtils setFontSizeToFitWidthWithLabel:v.lbConsignee labelLines:2];
    [GYUtils setFontSizeToFitWidthWithLabel:v.lbTel labelLines:1];

    v.labVshopName.textColor = kCorlorFromHexcode(0x464646);

    //    [v setBackgroundColor:kValueRedCorlor];
    [v setBackgroundColor:kDefaultVCBackgroundColor];
    //    [v.viewBkg2 addTopBorderAndBottomBorder];
    //    [v->_viewBkg0 addTopBorderAndBottomBorder];
    //    [v->_viewBkg1 addTopBorder];
    //    [v.viewBkg3 addTopBorderAndBottomBorder];
    [v setFrame:v.bounds];
    v.strCheckLogisticDetailUrl = nil;
    // add by songjk
    [v.btnContact setBackgroundImage:[UIImage imageNamed:@"gyhe_contact_seller"] forState:UIControlStateNormal];
    return v;
}

+ (CGFloat)getHeight
{
    //    return 142.f;
    //return 238.f;
    return 580.f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //  [self addTopBorderAndBottomBorder];
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
    // Drawing code
   }
 */

@end
