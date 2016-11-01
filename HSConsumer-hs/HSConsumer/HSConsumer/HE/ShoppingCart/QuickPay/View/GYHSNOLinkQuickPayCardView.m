//
//  GYHSNOLinkQuickPayCardView.m
//  HSConsumer
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSNOLinkQuickPayCardView.h"
#import "GYHEOrderQuickPayVC.h"

@implementation GYHSNOLinkQuickPayCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.linkButton.layer.borderWidth = 1.0f;
    self.linkButton.layer.borderColor = kCorlorFromRGBA(250, 60, 40, 1).CGColor;
    self.linkButton.layer.cornerRadius = 2.0f;
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
}

//- (IBAction)linkCardButtonClick:(UIButton *)sender {
//    GYHEOrderQuickPayVC *payVC = [[GYHEOrderQuickPayVC alloc] init];
//    UIViewController *vc = [self getCurrentViewController];
//    [vc.navigationController pushViewController:payVC animated:YES];
//}


@end
