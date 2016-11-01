//
//  GYHSAddAddressCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAddAddressCell.h"
#import "YYKit.h"
#import "GYHSTools.h"


@interface GYHSAddAddressCell()



@end

@implementation GYHSAddAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

    UIFont *font = kAddAddressCellFont;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = font;
    self.titleLabel.textColor = UIColorFromRGB(0x000000);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.detailTextField = [[UITextField alloc] init];
    self.detailTextField.textAlignment = NSTextAlignmentLeft;
    self.detailTextField.textColor = UIColorFromRGB(0x666666);
    self.detailTextField.font =  font;
    [self addSubview:self.detailTextField];
    
    
    self.addressTextView = [[UITextView alloc] init];
    self.addressTextView.font = kAddAddressCellAddressFont;
    self.addressTextView.textAlignment = NSTextAlignmentLeft;
    self.addressTextView.textColor = UIColorFromRGB(0x666666);
    [self addSubview:self.addressTextView];
    
    self.arrowImageView = [[UIImageView alloc] init];
    self.arrowImageView.image = [UIImage imageNamed:@"hs_cell_btn_right_arrow"];
    [self addSubview:self.arrowImageView];
    
    CGFloat kLeftEdge = 12;
    CGFloat kLeftWidth = 111;
    CGFloat kRightEdge = 20;
    CGFloat KTopEdge = 0;//16
    CGFloat kTextHeight = 46;//16
    
    self.titleLabel.frame = CGRectMake(kLeftEdge, KTopEdge, kLeftWidth -kLeftEdge, kTextHeight);
    self.arrowImageView.frame = CGRectMake(kScreenWidth -kRightEdge , 46/2-5,10, 16);
    self.detailTextField.frame = CGRectMake(kLeftWidth, KTopEdge, kScreenWidth-kLeftWidth -kRightEdge, kTextHeight);
    self.addressTextView.frame = CGRectMake(kLeftWidth, KTopEdge/2, kScreenWidth-kLeftWidth -kRightEdge, 86);
    
    
}

-(void)refreshTitle:(NSString *)title detail:(NSString *)detail address:(NSString *)address {

    self.titleLabel.text  = title;
    self.detailTextField.text = detail;
    self.addressTextView.text = address;
}

@end
