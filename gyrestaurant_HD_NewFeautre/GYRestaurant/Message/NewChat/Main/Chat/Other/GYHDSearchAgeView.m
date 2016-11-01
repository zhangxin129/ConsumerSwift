//
//  GYHDSearchAgeView.m
//  HSConsumer
//
//  Created by shiang on 16/3/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchAgeView.h"
#import "GYHDMessageCenter.h"

@interface GYHDSearchAgeView () <UIPickerViewDataSource, UIPickerViewDelegate>

//@property(nonatomic,strong)NSArray *searchAgeArray;
/**picke*/
@property (nonatomic, weak) UIPickerView* searchAgePickView;
@property (nonatomic, weak) UILabel* tipsLabel;
@end

@implementation GYHDSearchAgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    //1.提示
    UILabel* tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = [UIColor colorWithRed:0/255.0 green:143.0/255.0 blue:215.0/255.0 alpha:1.0];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipsLabel];
    _tipsLabel = tipsLabel;
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

    //3.确定
    UIButton* defineButton = [[UIButton alloc] init];
    defineButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:143.0/255.0 blue:215.0/255.0 alpha:1.0];
    [defineButton setTitle:[Utils localizedStringWithKey:@"确定"] forState:UIControlStateNormal];
    [defineButton addTarget:self action:@selector(defineButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:defineButton];
    [defineButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(42);
    }];

    //2. 选择年龄
    UIPickerView* searchAgePickView = [[UIPickerView alloc] init];
    searchAgePickView.dataSource = self;
    searchAgePickView.delegate = self;
    [self addSubview:searchAgePickView];
    _searchAgePickView = searchAgePickView;
    [searchAgePickView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(tipsLabel.mas_bottom).offset(20);
        make.bottom.equalTo(defineButton.mas_top).offset(-20);
    }];
}

- (void)defineButtonClick
{
    NSInteger row = [self.searchAgePickView selectedRowInComponent:0];
    NSString* string = self.chooseAgeArray[row];
    self.block(string);
}

- (void)setChooseAgeArray:(NSArray*)chooseAgeArray
{
    _chooseAgeArray = chooseAgeArray;
}

- (void)setChooseTips:(NSString*)chooseTips
{
    _chooseTips = chooseTips;
    self.tipsLabel.text = chooseTips;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.chooseAgeArray.count;
}

- (nullable NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.chooseAgeArray[row];
};


@end
