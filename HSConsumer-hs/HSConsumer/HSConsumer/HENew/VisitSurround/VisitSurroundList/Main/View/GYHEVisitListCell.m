//
//  GYHEVisitListCell.m
//  HSConsumer
//
//  Created by kuser on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEVisitListCell.h"
#import "GYHEVisitListModel.h"

@interface GYHEVisitListCell()

@property (strong, nonatomic) IBOutlet UIView *typeView;

@end

@implementation GYHEVisitListCell

- (void)awakeFromNib {
    // Initialization code
    
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = kCorlorFromHexcode(0x403000);
    self.subTitleLabel.font = [UIFont systemFontOfSize:13];
    self.subTitleLabel.textColor = kCorlorFromHexcode(0x999999);
    self.detailAddressLabel.font = [UIFont systemFontOfSize:13];
    self.detailAddressLabel.textColor = kCorlorFromHexcode(0x666666);
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = kCorlorFromHexcode(0x999999);
    self.distanceLabel.font = [UIFont systemFontOfSize:12];
    self.distanceLabel.textColor = kCorlorFromHexcode(0xdddddd);
}

-(void)setModel:(GYHEVisitListModel *)model
{
    _model = model;
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.logo.sourceSize] placeholder:[UIImage imageNamed:@"gy_he_example_icon"]];
    if(model.vshopName.length > 15){//截取最大显示的个数
        self.titleLabel.text = [model.vshopName substringToIndex:15];
    }else{
        self.titleLabel.text = model.vshopName;
    }
    if(model.mpNames.length > 18){
        self.subTitleLabel.text = [model.mpNames substringToIndex:18];
    }else{
        self.subTitleLabel.text = model.mpNames;
    }
    if(model.addr.length > 18){
        self.detailAddressLabel.text = [model.addr substringToIndex:18];
    }else{
        self.detailAddressLabel.text = model.addr;
    }
    self.addressLabel.text = model.locationName;
    self.distanceLabel.text = model.dist;
    NSString *serCoupon;
    NSString *serDeposit;
    NSString *serTakeout;
    if (model.servicesInfo.hasSerCoupon) { //抵扣券
        serCoupon = @"1";
    }else{
        serCoupon = @"0";
    }
    if (model.servicesInfo.hasSerDeposit) { //预约服务
        serDeposit = @"1";
    }else{
        serDeposit = @"0";
    }
    if (model.servicesInfo.hasSerTakeout) { //支持外卖服务
        serTakeout = @"1";
    }else{
        serTakeout = @"0";
    }
    NSArray* arrData = [NSArray arrayWithObjects:
                        serCoupon,
                        serDeposit,
                        serTakeout,
                        nil];
    NSArray* imageNames = @[@"gy_he_juan_icon", @"gy_he_ding_icon", @"gy_he_mai_icon"];
    CGFloat width = 16;
    for (UIView* view in self.typeView.subviews) {
        [view removeFromSuperview];
    }
    NSInteger index = arrData.count;
    CGFloat border = 2;
    for (NSInteger i = 0, j = 0; i < index; i++) {
        UIImageView* imageView = [[UIImageView alloc] init];
        if (arrData.count > i) {
            if ([arrData[i] isEqualToString:@"1"]) {
                CGFloat imgX = (i - j) * (width + border);
                imageView.frame = CGRectMake(self.typeView.frame.size.width - imgX - 15, 0, width, width);
                if (imageNames.count > i)
                    imageView.image = [UIImage imageNamed:imageNames[i]];
                [self.typeView addSubview:imageView];
            }
            else {
                j++;
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
