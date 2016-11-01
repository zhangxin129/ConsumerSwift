//
//  GYAddressModel.m
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddressModel.h"
#import "GYCityAddressModel.h"
#import "GYProvinceModel.h"
#import "GYAddressHeightModel.h"
#import "GYAddressData.h"

#define kLeftEdge 15.0f
#define kRightEdge 50.0f
#define kTextHeight 20.f
#define kTopEdge 15.0f

@interface GYAddressModel ()

@property (nonatomic, assign) CGSize size;

@end

@implementation GYAddressModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"id" : @"idString" }];
}

- (GYAddressModel*)dataWithDic:(NSDictionary*)dic isFood:(BOOL)isFood
{
    GYAddressModel* model = [[GYAddressModel alloc] initWithDictionary:dic error:nil];

    self.heightModel = [[GYAddressHeightModel alloc] init];

    NSString* attribString;
    if (isFood) {
        attribString = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.area, model.detail];
    }
    else {

        GYCityAddressModel* cityModel = [[GYAddressData shareInstance] queryCityNo:model.cityNo];
        GYProvinceModel* provinceModel = [[GYAddressData shareInstance] queryProvinceNo:model.provinceNo];

        attribString = [NSString stringWithFormat:@"%@%@%@%@(%@)", provinceModel.provinceName, cityModel.cityName, model.area, model.address, model.postCode];
    }

    UILabel* label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;

    label.text = model.mobile;
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    self.size = [self adaptiveWithWidth:kScreenWidth - kRightEdge - 35 - kLeftEdge label:label];
    self.heightModel.phoneLabelFrame = CGRectMake(kScreenWidth - kRightEdge - self.size.width - kLeftEdge - 35-10, kTopEdge, self.size.width, self.size.height);
    self.heightModel.defaultBtnFrame = CGRectMake(kScreenWidth - kRightEdge - 35-10, kTopEdge, 35, 15);

    label.text = model.receiver;
    self.size = [self adaptiveWithWidth:kScreenWidth - kRightEdge - 35 - self.heightModel.phoneLabelFrame.size.width - 3 * kLeftEdge -10 label:label];

    self.heightModel.nameLabelFrame = CGRectMake(kLeftEdge, kTopEdge, self.size.width, self.size.height);

    label.text = attribString;
    label.font = [UIFont systemFontOfSize:14];
    self.size = [self adaptiveWithWidth:(kScreenWidth - 2 * kLeftEdge - kRightEdge)label:label];
    if (isFood) {
        self.heightModel.phoneLabelFrame = CGRectMake(kLeftEdge, kTopEdge, self.heightModel.phoneLabelFrame.size.width, self.heightModel.phoneLabelFrame.size.height);
        self.heightModel.addressLabelFrame = CGRectMake(kLeftEdge, CGRectGetMaxY(self.heightModel.phoneLabelFrame) + 10, self.size.width, self.size.height);
    }
    else {
        self.heightModel.addressLabelFrame = CGRectMake(kLeftEdge, CGRectGetMaxY(self.heightModel.nameLabelFrame) + 10, self.size.width, self.size.height);
    }

    self.heightModel.cellHeight = self.heightModel.addressLabelFrame.origin.y + self.heightModel.addressLabelFrame.size.height + 15;
    if (self.heightModel.cellHeight < 80) {
        self.heightModel.cellHeight = 80;
    }

    model.heightModel = self.heightModel;

    return model;
}

- (CGSize)adaptiveWithWidth:(CGFloat)width label:(UILabel*)label
{
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return size;
}

@end
