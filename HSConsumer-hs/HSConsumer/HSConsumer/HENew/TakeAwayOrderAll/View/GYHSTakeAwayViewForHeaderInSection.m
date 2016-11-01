//
//  GYHSTakeAwayViewForHeaderInSection.m
//  HSConsumer
//
//  Created by kuser on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSTakeAwayViewForHeaderInSection.h"
#import "GYHSTakeAwayOrderAllModel.h"
#import "GYHSTakeAwayOrderAllModels.h"

@implementation GYHSTakeAwayViewForHeaderInSection

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.backColorView.backgroundColor = kCorlorFromHexcode(0xf6f6f6);
    self.shopNameLabel.textColor = kCorlorFromHexcode(0x333333);
    self.shopNameLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.textColor = kCorlorFromHexcode(0xff5000);
    self.statusLabel.font = [UIFont systemFontOfSize:12];
}

- (IBAction)titleClick:(id)sender
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDetailsBtn:)]) {

        [self.delegate didSelectedDetailsBtn:self];
    }
}

- (void)setModel:(GYHSTakeAwayModels*)model
{
    _model = model;
    
        [self.shopUrlIcon setImageWithURL:[NSURL URLWithString:model.mobile_pic] placeholder:[UIImage imageNamed:@"gy_he_example_foodicon"]];
        self.shopNameLabel.text = model.shopName;
    
        if (model.status == -1) { //返回状态，判断按钮显示文字
    
            self.statusLabel.text = @"未付款";
        }
        else if (model.status == 8) {
    
            self.statusLabel.text = @"交易完成";
        }
        else if (model.status == 4) {
    
            self.statusLabel.text = @"已付款";
        }
        else if (model.status == 9) {
    
            self.statusLabel.text = @"已接单";
        }
    
    

//    [self.shopUrlIcon setImageWithURL:[NSURL URLWithString:model.shopUrl] placeholder:[UIImage imageNamed:@"gy_he_example_foodicon"]];
//    self.shopNameLabel.text = model.shopName;
//
//    if ([model.status isEqualToString:@"0"]) { //返回状态，判断按钮显示文字
//
//        self.statusLabel.text = @"未付款";
//    }
//    else if ([model.status isEqualToString:@"1"]) {
//
//        self.statusLabel.text = @"交易完成";
//    }
//    else if ([model.status isEqualToString:@"2"]) {
//
//        self.statusLabel.text = @"已付款";
//    }
//    else if ([model.status isEqualToString:@"3"]) {
//
//        self.statusLabel.text = @"已接单";
//    }
    
}



@end
