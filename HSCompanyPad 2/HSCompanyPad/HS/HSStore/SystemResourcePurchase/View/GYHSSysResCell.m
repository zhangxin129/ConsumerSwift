//
//  GYHSSysResCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSSysResCell.h"
#import "GYHSResSegmentModel.h"

@interface GYHSSysResCell()
@property (weak, nonatomic) IBOutlet UIImageView *staImageView;
@property (weak, nonatomic) IBOutlet UILabel *resourceLable;
@property (weak, nonatomic) IBOutlet UILabel *staLable;

@end

@implementation GYHSSysResCell
/**
 *  给各个控件设置属性
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    self.resourceLable.textAlignment = NSTextAlignmentLeft;
    self.resourceLable.textColor = kGray333333;
    self.resourceLable.font = kFont32;
    
    self.staLable.textAlignment = NSTextAlignmentLeft;
    self.staLable.textColor = kRedE50012;
    self.staLable.font = kFont32;
    self.staLable.hidden = YES;
}
/**
 *  给各个控件赋值
 */
-(void)setModel:(GYSegmentModel *)model{
    _model = model;
    
    if (model.buyStatus.boolValue) {//如果已购买 直接打勾 否则判断是否被选中
        self.staImageView.image = [UIImage imageNamed:@"gyhs_gray_select_icon"];
        self.staLable.hidden = NO;
    }else {
        if (model.isSelected) {
            self.staImageView.image = [UIImage imageNamed:@"gyhs_red_select_icon"];
        }else {
            self.staImageView.image = [UIImage imageNamed:@"gyhs_normal_icon"];
        }
    }

    
    self.resourceLable.text = model.segmentDesc;
}
@end
