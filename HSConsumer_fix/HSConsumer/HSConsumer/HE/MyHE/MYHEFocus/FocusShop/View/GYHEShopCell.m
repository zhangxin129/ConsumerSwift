//
//  CellShopCell.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopCell.h"

@interface GYHEShopCell ()

@end

@implementation GYHEShopCell

- (void)awakeFromNib {

    [self.lbShopName setTextColor:kCellItemTitleColor];
    [self.lbShopScope setTextColor:kCellItemTextColor];
    [self.lbShopConcernTime setTextColor:kCellItemTextColor];
    [GYUtils setFontSizeToFitWidthWithLabel:self.lbShopName labelLines:1];
    self.lbShopScope.numberOfLines = 1;
    self.lbShopScope.minimumScaleFactor = 10;
    self.lbShopScope.adjustsFontSizeToFitWidth = YES;
    [GYUtils setFontSizeToFitWidthWithLabel:self.lbShopConcernTime labelLines:1];

}

- (void)setModel:(GYHEFocusShopModel *)model {
    
    _lbShopConcernTime.text = [NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_AboutTime"), model.createTime];
    _lbShopName.text = model.title;
    _lbShopScope.text = [NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_BusinessScope"), model.scope];
    [_ivShopImage setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"easybuy_placeholder_image"]];
}

@end
