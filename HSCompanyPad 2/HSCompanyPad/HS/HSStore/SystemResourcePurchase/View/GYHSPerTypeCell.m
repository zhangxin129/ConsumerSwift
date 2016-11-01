//
//  GYHSPerTypeCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPerTypeCell.h"
#import "GYHSCardTypeModel.h"
#import <YYKit/UIImageView+YYWebImage.h>

@interface GYHSPerTypeCell()
@property (weak, nonatomic) IBOutlet UIImageView *perTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *staImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeNameLable;

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation GYHSPerTypeCell
/**
 *  给各个控件设置属性
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    self.cardTypeNameLable.textColor = kGray333333;
    self.cardTypeNameLable.font = kFont32;
    self.backView.layer.cornerRadius = 6.0f;
}
/**
 *  给各个控件赋值
 */
-(void)setModel:(GYHSCardTypeModel *)model{
    _model = model;
    NSString *urlStr = GY_PICTUREAPPENDING(model.microPic);
    [self.perTypeImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:nil options:kNilOptions completion:nil];
    
    self.cardTypeNameLable.text = model.cardStyleName;
    self.staImageView.image = [UIImage imageNamed:model.isSelected ? @"gyhs_select" :@"gyhs_normal"];

}

@end
