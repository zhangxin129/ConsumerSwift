//
//  GYHSAddressPickView.m
//  HSConsumer
//
//  Created by lizp on 2016/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAddressPickView.h"

@interface GYHSAddressPickView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIPickerView *pick;

@end

@implementation GYHSAddressPickView


-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

    [self addSubview:self.pick];
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    
}

#pragma mark  - set or get 
-(UIPickerView *)pick {

    if (!_pick) {
        _pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, self.bounds.size.height -20)];
        _pick.dataSource = self;
        _pick.delegate = self;
    }
    return _pick;
}

@end
