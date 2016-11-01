//
//  GYPasswordTextFieldCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYPasswordTextFieldCell.h"
#import "YYKit.h"

@interface GYPasswordTextFieldCell ()

@end

@implementation GYPasswordTextFieldCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 32, self.bounds.size.height);
        [self setUp];
    }
    return self;
}

- (void)setUp
{

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, self.bounds.size.height)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.tintColor = UIColorFromRGB(0x000000);
    [self addSubview:self.titleLabel];

    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeButton.frame = CGRectMake(self.bounds.size.width - 108, 0, 108, self.bounds.size.height);
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.codeButton.hidden = YES;
    [self.codeButton setTitleColor:UIColorFromRGB(0x1d7dd6) forState:UIControlStateNormal];
    [self addSubview:self.codeButton];

    self.detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.titleLabel.right + 40, 0, self.bounds.size.width - self.titleLabel.right - 40 - 20, self.bounds.size.height)];
    self.detailTextField.font = [UIFont systemFontOfSize:14];
    self.detailTextField.textColor = UIColorFromRGB(0x000000);
    self.detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.detailTextField];

    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(self.bounds.size.width - 108, 0, 0.5, self.bounds.size.height);
    self.lineView.backgroundColor = UIColorFromRGB(0xebebeb);
    [self addSubview:self.lineView];

    self.layer.borderWidth = 0.5;
    self.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
}

- (void)refleshTitle:(NSString*)title placehold:(NSString*)placehold detail:(NSString*)detail codeTitle:(NSString*)codeTitle
{
    self.titleLabel.text = title;
    self.detailTextField.placeholder = placehold;
    self.detailTextField.text = detail;
    [self.codeButton setTitle:codeTitle forState:UIControlStateNormal];
}

@end
