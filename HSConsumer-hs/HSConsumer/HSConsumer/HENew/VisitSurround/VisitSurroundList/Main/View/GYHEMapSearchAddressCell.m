//
//  GYHEMapSearchAddressCell.m
//  HSConsumer
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEMapSearchAddressCell.h"
#import "GYHEMapSearchAddressModel.h"

@interface GYHEMapSearchAddressCell()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
@implementation GYHEMapSearchAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GYHEMapSearchAddressModel *)model
{
    _model = model;
    NSString * string = [NSString stringWithFormat:@"%@\n%@",model.cityName,model.detailAddressName];
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributeString setAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName : [UIColor blackColor] } range:NSMakeRange(0, model.cityName.length)];
    [attributeString setAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : [UIColor grayColor] } range:NSMakeRange(model.cityName.length + 1,model.detailAddressName.length)];
    self.addressLabel.attributedText = attributeString;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
