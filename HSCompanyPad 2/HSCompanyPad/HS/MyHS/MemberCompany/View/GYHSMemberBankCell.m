//
//  GYHSMemberBankCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMemberBankCell.h"

@interface GYHSMemberBankCell ()
@property (weak, nonatomic) IBOutlet UIButton* button;

@end
@implementation GYHSMemberBankCell

- (void)awakeFromNib
{
    self.leftLabel.edgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    self.rightLabel.edgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
}

#pragma mark - setter
- (void)setIsShowBtn:(BOOL)isShowBtn
{
    _isShowBtn = isShowBtn;
    if (_isShowBtn) {
        self.button.hidden = NO;
    } else {
        self.button.hidden = YES;
    }
}
- (IBAction)click:(UIButton*)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectBankClick:cell:)]) {
        [_delegate selectBankClick:sender cell:self];
    }
}



@end
