//
//  GYTicketAccountCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTicketAccountCell.h"
#import "GYHSTools.h"

@interface GYTicketAccountCell ()
@property (weak, nonatomic) IBOutlet UILabel *ticketTypeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *ticketValueTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *canUseTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *didUseTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLab;

@property (weak, nonatomic) IBOutlet UIImageView *coinImgView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation GYTicketAccountCell

- (void)awakeFromNib {
    [_searchBtn setImage:[UIImage imageNamed:@"gyhs_account_search"] forState:UIControlStateNormal];
    _coinImgView.image = [UIImage imageNamed:@"gyhs_account_coin"] ;
    
    _ticketTypeTitleLab.text = kLocalized(@"GYHS_HSAccount_ticket");
    _ticketTypeTitleLab.font = kCellImportTextFont;
    _ticketTypeTitleLab.textColor = kCellTitleBlack;
    _ticketTypeTextLab.font = kCellImportTextFont;
    _ticketTypeTextLab.textColor = kSelectedRed;
    
    _ticketValueTitleLab.text = kLocalized(@"GYHS_HSAccount_ticketValue");
    _ticketValueTitleLab.font = kCellOtherTextFont;
    _ticketValueTitleLab.textColor = kCellTitleBlack;
    _ticketValueTextLab.font = kCellOtherTextFont;
    _ticketValueTextLab.textColor = kSelectedRed;
    
    _canUseTitleLab.text = kLocalized(@"GYHS_HSAccount_ticketCanUseCount");
    _canUseTitleLab.font = kCellOtherTextFont;
    _canUseTitleLab.textColor = kCellTitleBlack;
    _canUseTextLab.font = kCellOtherTextFont;
    _canUseTextLab.textColor = kCellTitleBlack;
    
    _didUseTitleLab.text = kLocalized(@"GYHS_HSAccount_ticketDidUseCount");
    _didUseTitleLab.font = kCellOtherTextFont;
    _didUseTitleLab.textColor = kCellTitleBlack;
    _didUseTextLab.font = kCellOtherTextFont;
    _didUseTextLab.textColor = kCellTitleBlack;
    
    _timeTitleLab.text = kLocalized(@"GYHS_HSAccount_ticketTime");
    _timeTitleLab.font = kCellOtherTextFont;
    _timeTitleLab.textColor = kCellTitleBlack;
    _timeTextLab.font = kCellOtherTextFont;
    _timeTextLab.textColor = kCellTitleBlack;
}

- (IBAction)showTicket:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(showDidUseTicket:)]) {
        [self.delegate showDidUseTicket:self];
    }
}


@end
