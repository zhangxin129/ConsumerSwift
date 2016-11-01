//
//  GYHSGetGoodsCell.m
//  HSConsumer
//
//  Created by lizp on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSGetGoodsCell.h"
#import "YYKit.h"
#import "GYAddressModel.h"
#import "GYAddressData.h"
//#import "GYAddressHeightModel.h"
#import "GYHSTools.h"
#import "GYAddressListModel.h"
#import "GYAddressListHeightModel.h"

@interface GYHSGetGoodsCell()

@property (nonatomic,strong) UILabel *nameLabel;//姓名
@property (nonatomic,strong) UILabel *phoneLabel;//手机
@property (nonatomic,strong) UILabel *addressLabel;//地址
@property (nonatomic,strong) UIImageView *arrowImageView;//箭头
@property (nonatomic,strong) UIView *footerView;//底部视图
@property (nonatomic,strong) UIView *lineView;//线
@property (nonatomic,strong) UILabel *defaultLabel;//设置默认地址 label


@end

@implementation GYHSGetGoodsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    //姓名
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = kGetGoodsCellFont;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = UIColorFromRGB(0x1A1A1A);
    self.nameLabel.numberOfLines = 0;
    [self addSubview:self.nameLabel];
    
    //手机
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.font = kGetGoodsCellFont;
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    self.phoneLabel.textColor = UIColorFromRGB(0x1A1A1A);
    [self addSubview:self.phoneLabel];
    
    //地址
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.font = kGetGoodsCellAddressFont;
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    self.addressLabel.textColor = UIColorFromRGB(0x666666);
    [self addSubview:self.addressLabel];
    
    //箭头
    self.arrowImageView = [[UIImageView alloc] init];
    self.arrowImageView.image = [UIImage imageNamed:@"gyhs_address_arrow"];
    [self addSubview:self.arrowImageView];
    
    
    
    
    //底部视图
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    self.footerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.footerView];
    
    //线
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth - 12, 1)];
    self.lineView.backgroundColor = UIColorFromRGB(0xebebeb);
    [self.footerView addSubview:self.lineView];
    
    //默认选中按钮
    self.defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.defaultBtn.frame = CGRectMake(12, 13, 20, 20);
    [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"gy_he_unselected_icon"] forState:UIControlStateNormal];
    [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_select_circle_blue"] forState:UIControlStateSelected];
    [self.footerView addSubview:self.defaultBtn];
    
    //设置默认地址文字
    self.defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.defaultBtn.right + 10, 13, 120, 16)];
    self.defaultLabel.text = kLocalized(@"GYHS_Address_SettingDefault");
    self.defaultLabel.font = kGetGoodsCellFont;
    self.defaultLabel.textAlignment = NSTextAlignmentLeft;
    self.defaultLabel.textColor = UIColorFromRGB(0x1A1A1A);
    [self.footerView addSubview:self.defaultLabel];
    
    //编辑
    self.editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editorBtn.frame = CGRectMake(kScreenWidth - 137, 7, 61, 31);
    self.editorBtn.titleLabel.font = kGetGoodsCellFont;
    [self.editorBtn setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    self.editorBtn.layer.cornerRadius = 2;
    self.editorBtn.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.editorBtn.layer.borderWidth = 1;
    [self.editorBtn setTitle:kLocalized(@"GYHS_Address_Edit") forState:UIControlStateNormal];
    [self.footerView addSubview:self.editorBtn];
    
    //删除
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(kScreenWidth - 71, 7, 61, 31);
    self.deleteBtn.titleLabel.font = kGetGoodsCellFont;
    [self.deleteBtn setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    self.deleteBtn.layer.cornerRadius  = 2;
    self.deleteBtn.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.deleteBtn.layer.borderWidth = 1;
    [self.deleteBtn setTitle:kLocalized(@"GYHS_Address_Delete") forState:UIControlStateNormal];
    [self.footerView addSubview:self.deleteBtn];
    
}

- (void)setModel:(GYAddressListModel*)model
{
    self.nameLabel.text = model.receiverName;
    self.phoneLabel.text = model.phone;
    
    NSString* attribString;
    
    //直辖市直接显示市
    if ([model.province containsString:kLocalized(@"GYHS_Address_Beijing")] || [model.province containsString:kLocalized(@"GYHS_Address_Tianjing")] || [model.province containsString:kLocalized(@"GYHS_Address_Shanghai")] || [model.province containsString:kLocalized(@"GYHS_Address_Chongqing")]) {
        attribString = [NSString stringWithFormat:@"%@%@%@", model.city, model.area, model.address];
    }
    else {
        attribString = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.area, model.address];
    }
    
//    if (self.isFood) {
//        //直辖市直接显示市
//        if ([model.province containsString:kLocalized(@"GYHS_Address_Beijing")] || [model.province containsString:kLocalized(@"GYHS_Address_Tianjing")] || [model.province containsString:kLocalized(@"GYHS_Address_Shanghai")] || [model.province containsString:kLocalized(@"GYHS_Address_Chongqing")]) {
//            attribString = [NSString stringWithFormat:@"%@%@%@", model.city, model.area, model.address];
//        }
//        else {
//            attribString = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.area, model.address];
//        }
//    }
//    else {
//        
//        GYAddressData* address = [GYAddressData shareInstance];
//        GYProvinceModel* provinceModel = [address queryProvinceNo:model.provinceNo];
//        GYCityAddressModel* cityModel = [address queryCityNo:model.cityNo];
//        
//        if ([provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Beijing")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Tianjing")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Shanghai")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Chongqing")]) {
//            if (model.postcode.length != 0) {
//                attribString = [NSString stringWithFormat:@"%@%@(%@)", cityModel.cityName, model.address, model.postcode];
//            }
//            else {
//                attribString = [NSString stringWithFormat:@"%@%@", cityModel.cityName, model.address];
//            }
//        }
//        else {
//            if (model.postCode.length != 0) {
//                attribString = [NSString stringWithFormat:@"%@%@%@%@(%@)", provinceModel.provinceName, cityModel.cityName, model.area, model.address, model.postCode];
//            }
//            else {
//                attribString = [NSString stringWithFormat:@"%@%@%@%@", provinceModel.provinceName, cityModel.cityName, model.area, model.address];
//            }
//        }
//    }
    self.addressLabel.text = attribString;
    
    GYAddressListHeightModel* heightModel = model.heightModel;
//    self.phoneLabel.frame = heightModel.phoneLabelFrame;
    
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.frame = heightModel.nameLabelFrame;
    
    self.addressLabel.numberOfLines = 0;
    self.phoneLabel.frame = heightModel.phoneLabelFrame;
    self.addressLabel.frame = heightModel.addressLabelFrame;
    self.footerView.frame = CGRectMake(0, self.addressLabel.frame.origin.y + self.addressLabel.frame.size.height, kScreenWidth, 46);
    if (self.isFood) {
//        if ([model.beDefault isEqualToString:@"1"]) {
//            self.defaultBtn.selected = YES;
//        }
//        else {
//            self.defaultBtn.selected = NO;
//        }
    }
    else {
        if ([model.isDefault isEqualToString:@"1"]) {
            self.defaultBtn.selected = YES;
        }
        else {
            self.defaultBtn.selected = NO;
        }
    }
    
}

@end
