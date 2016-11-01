//
//  GYHEGoodsImageTextDetailsCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEGoodsDetailsProductionCell.h"

@implementation GYHEGoodsDetailsProductionCell

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

    UIFont *font = [UIFont systemFontOfSize:12];
    
    self.titleLabel =  [[UILabel alloc ]init];
    self.titleLabel.font = font;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = UIColorFromRGB(0x999999);
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = font;
    self.detailLabel.textAlignment =  NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.textColor = UIColorFromRGB(0x000000);
    [self addSubview:self.detailLabel];
}


-(void)refreshTitle:(NSString *)title  detail:(NSString *)detail titleHeight:(CGFloat)titleHeight detailHeight:(CGFloat)detailHeight {

    CGFloat leftEdge = 22;
    CGFloat rightEdge = 22;
    CGFloat topEdge = 15;
    CGFloat leftWidth = 121;
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
    self.titleLabel.frame = CGRectMake(leftEdge, topEdge, leftWidth -leftEdge - 10, titleHeight );
    self.detailLabel.frame = CGRectMake(leftWidth, topEdge, kScreenWidth - rightEdge - leftWidth, detailHeight );
}




@end
