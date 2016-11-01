//
//  GYHSCreateAddressCell.m
//  HSConsumer
//
//  Created by lizp on 2016/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCreateAddressCell.h"

@implementation GYHSCreateAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {
    
    
    self.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.layer.borderWidth = 1;
    
    UIFont *font = [UIFont systemFontOfSize:16];
    
    self.titleTextField = [[UITextField alloc] init];
    self.titleTextField.textAlignment = NSTextAlignmentLeft;
    self.titleTextField.textColor = UIColorFromRGB(0x666666);
    self.titleTextField.font = font;
    [self addSubview:self.titleTextField];
    
    self.addressTextView = [[UITextView alloc] init];
//    self.addressTextView.textColor = UIColorFromRGB(0x666666);
    self.addressTextView.textColor = [UIColor lightGrayColor];
    self.addressTextView.font = font;
    [self addSubview:self.addressTextView];

    CGFloat leftEdge = 12;
    CGFloat topEdge = 0;
    CGFloat height = 46;
    
    self.titleTextField.frame = CGRectMake(leftEdge, topEdge, kScreenWidth - 2*leftEdge, height);
    self.addressTextView.frame = CGRectMake(7, topEdge ,kScreenWidth - 2*leftEdge, 86);
    
}


-(void)refreshPlaceholder:(NSString *)placeholder detail:(NSString *)detail textField:(NSString *)textField {

    self.titleTextField.placeholder = placeholder;
    self.titleTextField.text = detail;
    self.addressTextView.text = textField;
}

@end
