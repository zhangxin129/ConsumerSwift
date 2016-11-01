//
//  GYHSLoginVCButtonActionTableCellTableViewCell.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginVCBtnActionTableCell.h"
#import "GYHSConstant.h"

@interface GYHSLoginVCBtnActionTableCell ()

@property (weak, nonatomic) IBOutlet UIButton* changeHSBtn;

@property (weak, nonatomic) IBOutlet UIButton* forgetPwdBtn;

@end

@implementation GYHSLoginVCBtnActionTableCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellName:(NSString*)changeBtnName
          loginType:(GYHSLoginViewControllerEnum)loginType
         forgetName:(NSString*)forgetName
{

    [self.changeHSBtn setTitle:changeBtnName forState:UIControlStateNormal];
    [self.forgetPwdBtn setTitle:forgetName forState:UIControlStateNormal];

    UIColor* color = kNavigationBarColor;
    if (loginType == GYHSLoginViewControllerTypeNohsCard) {
        color = [UIColor orangeColor];
    }

    [self.changeHSBtn setTitleColor:color forState:UIControlStateNormal];
}

- (IBAction)chageHSButtonAction:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(changeHSView)]) {
        [self.cellDelegate changeHSView];
    }
}

- (IBAction)forgetPwdBtnAction:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(forgetPwdActon)]) {
        [self.cellDelegate forgetPwdActon];
    }
}

@end
