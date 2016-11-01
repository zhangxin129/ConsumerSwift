//
//  GYHSHealthPlanViewCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSHealthPlanViewCell.h"
#import "GYHSTools.h"

@implementation GYHSHealthPlanViewCell

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

    UIFont *font = kHealthPlanViewCellFont;
    UIColor *color = UIColorFromRGB(0x000000);
    
    self.titleLael = [[UILabel alloc] init];
    self.titleLael.font = font;
    self.titleLael.textColor = color;
    self.titleLael.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLael];
    
    self.detailTextField = [[UITextField alloc] init];
    self.detailTextField.font  = font;
    self.detailTextField.textColor = color;
    self.detailTextField.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.detailTextField];
    
    self.arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.arrowBtn setImage:[UIImage imageNamed:@"gyhe_down_arrow"] forState:UIControlStateNormal];
    [self addSubview:self.arrowBtn];
    
    CGFloat leftEdge = 15;
    CGFloat rightEdge = 15;
    CGFloat topEdge = 0;//13
    CGFloat leftWidth = 140;
    CGFloat textHeight = 39;//13
    
    self.titleLael.frame = CGRectMake(leftEdge, topEdge, leftWidth, textHeight);
    self.detailTextField.frame = CGRectMake(leftWidth, topEdge, kScreenWidth -leftWidth -rightEdge, textHeight);
    self.arrowBtn.frame = CGRectMake(kScreenWidth -rightEdge -25, 5, 25, 29);
}

-(void)refreshTitle:(NSString *)title placeholder:(NSString *)placeholder {

    self.titleLael.text = title;
    self.detailTextField.placeholder = placeholder;
}

@end
