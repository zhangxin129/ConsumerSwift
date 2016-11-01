//
//  GYGetGoodCell.m
//  HSConsumer
//
//  Created by lizp on 16/3/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYGetGoodCell.h"
#import "GYAddressModel.h"
#import "GYCityAddressModel.h"
#import "GYProvinceModel.h"
#import "GYAddressHeightModel.h"
#import "NSString+YYAdd.h"
#import "GYAddressData.h"

#define kLeftEdge 15.0f
#define kRightEdge 50.0f
#define kTextHeight 20.f
#define kTopEdge 15.0f

@interface GYGetGoodCell ()

@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UILabel* phoneLabel;
@property (nonatomic, weak) UIButton* defaultBtn;
@property (nonatomic, weak) UILabel* addressLabel;
@property (nonatomic, weak) UIImageView* editingImageView;
@property (nonatomic, weak) CALayer* lineLayer;

@property (nonatomic, assign) CGSize size;

@end

@implementation GYGetGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 170);
        [self setUp];
    }
    return self;
}

- (void)setUp
{

    UIFont* font = [UIFont systemFontOfSize:14];

    UILabel* nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    nameLabel.textColor = UIColorFromRGB(0x464646);
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;

    UILabel* phoneLabel = [[UILabel alloc] init];
    [phoneLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [self addSubview:phoneLabel];
    phoneLabel.textColor = UIColorFromRGB(0x464646);
    self.phoneLabel = phoneLabel;

    UIButton* defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    defaultBtn.hidden = YES;
    [defaultBtn setBackgroundImage:[UIImage imageNamed:@"hs_cell_img_default"] forState:UIControlStateNormal];
    [self addSubview:defaultBtn];
    self.defaultBtn = defaultBtn;

    UILabel* addressLabel = [[UILabel alloc] init];
    addressLabel.font = font;
    [self addSubview:addressLabel];
    self.addressLabel = addressLabel;
    self.addressLabel.textColor = UIColorFromRGB(0xA0A0A0);

    self.editingView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - kRightEdge, 0, kRightEdge, self.frame.size.height)];
    [self addSubview:self.editingView];

    UIImageView* editingImageView = [[UIImageView alloc] init];
    editingImageView.image = [UIImage imageNamed:@"hs_cell_img_editing"];
    [self.editingView addSubview:editingImageView];
    self.editingImageView = editingImageView;

    CALayer* lineLayer = [[CALayer alloc] init];
    lineLayer.backgroundColor = UIColorFromRGB(0xCCCCCC).CGColor;
    [self.editingView.layer addSublayer:lineLayer];
    self.lineLayer = lineLayer;
}

- (void)setModel:(GYAddressModel*)model
{

    NSString* attribString;
    if (self.isFood) {
        //直辖市直接显示市
        if ([model.province containsString:kLocalized(@"GYHS_Address_Beijing")] || [model.province containsString:kLocalized(@"GYHS_Address_Tianjing")] || [model.province containsString:kLocalized(@"GYHS_Address_Shanghai")] || [model.province containsString:kLocalized(@"GYHS_Address_Chongqing")]) {
            attribString = [NSString stringWithFormat:@"%@%@%@", model.city, model.area, model.detail];
        }
        else {
            attribString = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.area, model.detail];
        }
    }
    else {

        GYAddressData* address = [GYAddressData shareInstance];
        GYProvinceModel* provinceModel = [address queryProvinceNo:model.provinceNo];
        GYCityAddressModel* cityModel = [address queryCityNo:model.cityNo];

        if ([provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Beijing")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Tianjing")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Shanghai")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Chongqing")]) {
            if (model.postCode.length != 0) {
                attribString = [NSString stringWithFormat:@"%@%@(%@)", cityModel.cityName, model.address, model.postCode];
            }
            else {
                attribString = [NSString stringWithFormat:@"%@%@", cityModel.cityName, model.address];
            }
        }
        else {
            if (model.postCode.length != 0) {
                attribString = [NSString stringWithFormat:@"%@%@%@%@(%@)", provinceModel.provinceName, cityModel.cityName, model.area, model.address, model.postCode];
            }
            else {
                attribString = [NSString stringWithFormat:@"%@%@%@%@", provinceModel.provinceName, cityModel.cityName, model.area, model.address];
            }
        }
    }

    self.nameLabel.text = model.receiver;
    self.phoneLabel.text = model.mobile;
    self.addressLabel.text = attribString;

    GYAddressHeightModel* heightModel = model.heightModel;
    self.phoneLabel.frame = heightModel.phoneLabelFrame;

    self.nameLabel.numberOfLines = 0;
    self.nameLabel.frame = heightModel.nameLabelFrame;

    self.addressLabel.numberOfLines = 0;
    self.phoneLabel.frame = heightModel.phoneLabelFrame;
    self.addressLabel.frame = heightModel.addressLabelFrame;
    self.defaultBtn.frame = heightModel.defaultBtnFrame;
    if (self.isFood) {
        if ([model.beDefault isEqualToString:@"1"]) {
            self.defaultBtn.hidden = NO;
        }
        else {
            self.defaultBtn.hidden = YES;
        }
    }
    else {
        if ([model.isDefault isEqualToString:@"1"]) {
            self.defaultBtn.hidden = NO;
        }
        else {
            self.defaultBtn.hidden = YES;
        }
    }
    self.editingImageView.frame = CGRectMake(10, heightModel.cellHeight / 2 - 15, 30, 30);
    self.lineLayer.frame = CGRectMake(0, kTopEdge, 1, heightModel.cellHeight - 2 * kTopEdge);
}

@end
