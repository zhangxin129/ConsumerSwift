//
//  GYEasybuyShopAddressCell.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyShopAddressCell.h"

@interface GYEasybuyShopAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel* addressLabel;
@property (weak, nonatomic) IBOutlet UILabel* phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton* phoneBtn;
@property (weak, nonatomic) IBOutlet UIImageView* phoneImgView;

@end

@implementation GYEasybuyShopAddressCell

- (void)awakeFromNib
{
    // Initialization code
    _phoneImgView.image = [UIImage imageNamed:@"gycommon_btn_phone"];

    _phoneNumLabel.textColor = kNumGrayColor;
    _phoneNumLabel.font = kGYTitleDescriptionFont;
    _addressLabel.textColor = kTitleBlackColor;
    _addressLabel.font = kGYTitleFont;
}

- (void)setModel:(GYEasybuyShopAddressModel*)model
{
    _model = model;

    _addressLabel.text = model.addr;
    _phoneNumLabel.text = model.tel;
}

- (IBAction)callBtnAction:(id)sender
{

    if (_phoneNumLabel.text) {
        _block(_phoneNumLabel.text);
    }
}

@end
