//
//  GYHDAddressView.m
//  HSConsumer
//
//  Created by shiang on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD.
//  All rights reserved.
//

//#import "GYFMDBCityManager.h"
//#import "GYFMDBProvinceManager.h"
#import "GYHDAddressView.h"
#import "GYHDMessageCenter.h"
#import "GYAddressData.h"

@interface GYHDAddressView () <UIPickerViewDataSource, UIPickerViewDelegate>
/**地区View*/
@property (nonatomic, weak) UIPickerView* addressPickView;
/**国家数组*/
@property (nonatomic, strong) NSArray* countryArray;
/**省份数组*/
@property (nonatomic, strong) NSArray* provinceArray;
/**城市数组*/
@property (nonatomic, strong) NSArray* cityArray;

/**选择国家*/
@property (nonatomic, assign) NSInteger selectCountrySection;
/**选择省份*/
@property (nonatomic, assign) NSInteger selectProvinceSection;
/**选择城市*/
@property (nonatomic, assign) NSInteger selectcitySection;
@end
@implementation GYHDAddressView
- (NSArray*)countryArray
{
    if (!_countryArray) {
        NSArray* array = @[ [GYUtils localizedStringWithKey:@"GYHD_china"] ];
        _countryArray = array;
    }
    return _countryArray;
}

- (NSArray*)provinceArray
{

    if (!_provinceArray) {
        //    _provinceArray = [[GYFMDBProvinceManager shareInstance] selectFromDB];
        _provinceArray = [[GYAddressData shareInstance] selectAllProvinces];
    }
    return _provinceArray;
}
- (void)setCityFullName:(NSString*)cityFullName
{
    _cityFullName = cityFullName;
    GYCityAddressModel* model = nil;
    if (cityFullName.length > 2) {
        //       model = [[GYFMDBCityManager shareInstance] selectWithCityFullName:cityFullName];
        model = [[GYAddressData shareInstance] selectWithCityFullName:cityFullName];
    }
    else {
        if (self.provinceArray.count) {
            model = self.provinceArray[0];
        }
    }
    if (!model.provinceNo) {
        return;
    }
    //    self.provinceArray = [[GYFMDBProvinceManager shareInstance] selectFromDB];
    self.provinceArray = [[GYAddressData shareInstance] selectAllProvinces];
    self.cityArray = [[GYAddressData shareInstance] selectCitysByProvinceNo:model.provinceNo];
    //    self.cityArray  = [[GYFMDBCityManager shareInstance] selectFromDB:model.provinceNo];
    NSUInteger pcount = self.provinceArray.count;
    for (int i = 0; i < pcount; i++) {
        GYProvinceModel* proMode = self.provinceArray[i];
        if ([cityFullName rangeOfString:proMode.provinceName].location != NSNotFound) {
            //            NSLog(@"%@",proMode.provinceName);
            [self.addressPickView selectRow:i inComponent:1 animated:YES];
            break;
        }
    }
    NSUInteger ccount = self.cityArray.count;
    for (int i = 0; i < ccount; ++i) {
        GYCityAddressModel* cmodel = self.cityArray[i];
        if ([cityFullName rangeOfString:cmodel.cityFullName].location != NSNotFound) {
            //            NSLog(@"%@",cmodel.cityName);
            [self.addressPickView selectRow:i inComponent:2 animated:YES];
            break;
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    if (self.provinceArray.count >= 1) {
        GYProvinceModel* model = self.provinceArray[0];
        //    self.cityArray =
        //        [[GYFMDBCityManager shareInstance] selectFromDB:mode.provinceNo];
        self.cityArray = [[GYAddressData shareInstance] selectCitysByProvinceNo:model.provinceNo];
    }
    else {
        if (self.block) {
            self.block(nil);
        }
    }

    // 1.提示
    self.backgroundColor = [UIColor whiteColor];
    UILabel* tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = [UIColor redColor];
    tipsLabel.text = [GYUtils localizedStringWithKey:@"GYHD_edit_area"];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipsLabel];

    [tipsLabel mas_makeConstraints:^(MASConstraintMaker* make) {
    make.top.left.right.mas_equalTo(0);
    make.height.mas_equalTo(46);
    }];
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.left.right.mas_equalTo(0);
    make.top.mas_equalTo(tipsLabel.mas_bottom);
    make.height.mas_equalTo(0.5);
    }];

    // 3.确定
    UIButton* defineButton = [[UIButton alloc] init];
    defineButton.backgroundColor = [UIColor redColor];
    [defineButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_define_btn_normal"]
                            forState:UIControlStateNormal];
    [defineButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_define_btn_Highlighted"]
                            forState:UIControlStateHighlighted];
    [defineButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_confirm"]
                  forState:UIControlStateNormal];
    [defineButton addTarget:self
                     action:@selector(defineButtonClick)
           forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:defineButton];
    [defineButton mas_makeConstraints:^(MASConstraintMaker* make) {
    make.bottom.left.right.mas_equalTo(0);
    make.height.mas_equalTo(42);
    }];

    // 2. 选择地址
    UIPickerView* addressPickView = [[UIPickerView alloc] init];
    addressPickView.dataSource = self;
    addressPickView.delegate = self;
    addressPickView.showsSelectionIndicator = YES;
    [self addSubview:addressPickView];
    _addressPickView = addressPickView;
    [addressPickView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.left.right.mas_equalTo(0);
    make.top.equalTo(tipsLabel.mas_bottom).offset(20);
    make.bottom.equalTo(defineButton.mas_top).offset(-20);
    }];
}

- (void)defineButtonClick
{
    if (self.cityArray.count > self.selectcitySection) {
        GYCityAddressModel* mycityModel = self.cityArray[self.selectcitySection];
        if (self.block) {
            NSString* select = [NSString stringWithFormat:@"%@", mycityModel.cityNo];
            self.block(select);
        }
    }
    else {
        self.block(nil);
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView
    numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
    case 0:
        return self.countryArray.count;
        break;
    case 1:
        return self.provinceArray.count;
        break;
    case 2:
        return self.cityArray.count;
        break;
    }
    return 0;
}

- (nullable NSString*)pickerView:(UIPickerView*)pickerView
                     titleForRow:(NSInteger)row
                    forComponent:(NSInteger)component
{
    switch (component) {
    case 0: {
        self.selectCountrySection = row;
        return self.countryArray[row];

        break;
    }
    case 1: {
        self.selectProvinceSection = row;
        GYProvinceModel* provinceModel = self.provinceArray[row];
        return provinceModel.provinceName;
        break;
    }
    case 2: {
        self.selectcitySection = row;
        GYCityAddressModel* cityModel = self.cityArray[row];
        return cityModel.cityName;
        break;
    }
    default:
        break;
    }
    return nil;
};
- (UIView*)pickerView:(UIPickerView*)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView*)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text =
        [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView*)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    //    NSLog(@"%ld,%ld",row, (long)component);
    switch (component) {
    case 0: {
        break;
    }
    case 1: {
        if (self.provinceArray.count < 1) {
            if (self.block) {
                self.block(nil);
            }
            break;
        }
        GYProvinceModel* model = self.provinceArray[row];
        //      self.cityArray =
        //          [[GYFMDBCityManager shareInstance] selectFromDB:mode.provinceNo];
        self.cityArray = [[GYAddressData shareInstance] selectCitysByProvinceNo:model.provinceNo];
        [self.addressPickView reloadComponent:2];
        [self.addressPickView selectRow:0 inComponent:2 animated:YES];
        self.selectcitySection = 0;

        break;
    }
    case 2: {
        self.selectcitySection = row;
        break;
    }
    default:
        break;
    }
}

- (CGFloat)pickerView:(UIPickerView*)pickerView
    rowHeightForComponent:(NSInteger)component
{
  return 40.0f;
}

@end
