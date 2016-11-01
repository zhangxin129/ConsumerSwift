//
//  GYEasybuyBasicInfoCell.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyBasicInfoCell.h"
#import "UIView+CustomBorder.h"

@interface GYEasybuyBasicInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* infoLabel;

@end

@implementation GYEasybuyBasicInfoCell

- (void)awakeFromNib
{
    // Initialization code
    [self addBottomBorder];
    [self setBottomBorderInset:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary*)dict
{
    _dict = dict;
    _titleLabel.text = dict[@"key"];
    _infoLabel.text = dict[@"value"];
}

@end
