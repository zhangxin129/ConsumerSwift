//
//  GYHSLoginVConfirmTableCell.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginVConfirmTableCell.h"
#import "GYHSConstant.h"

@interface GYHSLoginVConfirmTableCell ()

@property (weak, nonatomic) IBOutlet UIButton* confirmButton;

@end

@implementation GYHSLoginVConfirmTableCell

- (void)awakeFromNib
{
    self.confirmButton.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellName:(NSString*)name loginType:(GYHSLoginViewControllerEnum)loginType
{
    [self.confirmButton setTitle:name forState:UIControlStateNormal];

    UIColor* color = kNavigationBarColor;
    if (loginType == GYHSLoginViewControllerTypeNohsCard) {
        color = [UIColor orangeColor];
    }

    [self.confirmButton setBackgroundColor:color];
}

- (void)setCellBackground:(UIColor*)color
{
    self.backgroundColor = color;
}

- (IBAction)confirmButtonAction:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(confirmButtonAction)]) {
        [self.cellDelegate confirmButtonAction];
    }
}

@end
