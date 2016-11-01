//
//  GYHSVConfirmTableCell.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSVConfirmTableCell.h"
#import "GYHSTools.h"

@interface GYHSVConfirmTableCell ()

@property (weak, nonatomic) IBOutlet UIButton* confirmButton;

@end

@implementation GYHSVConfirmTableCell

- (void)awakeFromNib
{
    
    self.confirmButton.layer.cornerRadius = 20.0f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.confirmButton.backgroundColor  = kButtonCellBtnCorlor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellName:(NSString*)name
{
    [self.confirmButton setTitle:name forState:UIControlStateNormal];
   
}

- (void)setCellBackground:(UIColor*)color
{
    self.backgroundColor = color;
}

- (IBAction)confirmButtonAction:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(confirmButtonAction:)]) {
        [self.cellDelegate confirmButtonAction:sender];
    }
}

@end
