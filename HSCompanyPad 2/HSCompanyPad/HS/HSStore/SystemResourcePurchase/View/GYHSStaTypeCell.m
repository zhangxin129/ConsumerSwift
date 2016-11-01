//
//  GYHSStaTypeCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSStaTypeCell.h"
#import "GYHSCardTypeModel.h"
#import <YYKit/UIImageView+YYWebImage.h>

@interface GYHSStaTypeCell()

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *staImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;


@end

@implementation GYHSStaTypeCell
/**
 *  给各个控件设置属性
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    self.typeLable.textColor = kGray333333;
    self.typeLable.font = kFont32;
}
/**
 *  给各个控件赋值
 */
-(void)setModel:(GYHSCardTypeModel *)model{
    _model = model;
    NSString *urlStr = GY_PICTUREAPPENDING(model.microPic);
    [self.typeImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:nil options:kNilOptions completion:nil];
    
    self.typeLable.text = model.cardStyleName;
    self.staImageView.image = [UIImage imageNamed:model.isSelected ? @"gyhs_select" :@"gyhs_normal"];
}

@end
