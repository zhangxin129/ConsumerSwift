//
//  GYHSSetTradePasswordBtnCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSSetTradePasswordBtnCell.h"
#import "GYHSTools.h"

@implementation GYHSSetTradePasswordBtnCell

- (void)awakeFromNib {
    // Initialization code
    self.tradePasswordLb.font = [UIFont systemFontOfSize:15];
    self.setBtn.titleLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)immediately:(id)sender {
    if ([_immediatelyDelegate respondsToSelector:@selector(immediatelySetButton)]) {
        [self.immediatelyDelegate immediatelySetButton];
    }
}

@end
