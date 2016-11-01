//
//  GYHSResSegCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSResSegCell.h"
#import "GYHSResSegmentModel.h"

@interface GYHSResSegCell()

@property (weak, nonatomic) IBOutlet UILabel *resSegNameLable;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;


@end

@implementation GYHSResSegCell
/**
 *  给各个控件设置属性
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    self.resSegNameLable.textColor = kGray333333;
    self.resSegNameLable.font = kFont48;
    
    self.priceTitleLable.textColor = kGray999999;
    self.priceTitleLable.font = kFont42;
    
    self.priceLable.textColor = kRedE50012;
    self.priceLable.font = kFont42;
}
/**
 *  给各个控件赋值
 */
-(void)setModel:(GYSegmentModel *)model{
    _model = model;
    self.resSegNameLable.text = model.segmentDesc;
    self.priceLable.text = model.segmentPrice;
}

@end
