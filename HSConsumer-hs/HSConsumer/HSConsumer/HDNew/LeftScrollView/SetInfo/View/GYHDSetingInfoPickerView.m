//
//  GYHDSetingInfoPickerView.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSetingInfoPickerView.h"
#import "Masonry.h"

@implementation GYIndexPath 

@end

@interface GYHDSetingInfoPickerView ()

@property (nonatomic, strong)NSArray<NSArray *> *dataArr;


@end

@implementation GYHDSetingInfoPickerView

- (instancetype)init {
    self = [super init];
    if(self) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:205/255.0f green:205/255.0f blue:205/255.0f alpha:1];
        [self addSubview:lineView];
        
        _finishBtn = [[UIButton alloc] init];
        [_finishBtn setTitle:kLocalized(@"完成") forState:UIControlStateNormal];
        _finishBtn.backgroundColor = [UIColor whiteColor];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth/2.0 -30 , 0, - kScreenWidth/2.0 +30);
        [_finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_finishBtn];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {\
            make.top.mas_equalTo(2);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
        [self addSubview:self.pickView];
        [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}

#pragma mark -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    if([self.delegate respondsToSelector:@selector(dataArrayForSetingInfoPickerView:)]) {
        self.dataArr = [self.delegate dataArrayForSetingInfoPickerView:self];
        return self.dataArr.count;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if([self.delegate respondsToSelector:@selector(dataArrayForSetingInfoPickerView:)]) {
        self.dataArr = [self.delegate dataArrayForSetingInfoPickerView:self];
        if(self.dataArr.count > component) {
            NSArray *arr = self.dataArr[component];
            return arr.count;
        }
        return 0;
    }
    return 0;
}

- (nullable NSString*)pickerView:(UIPickerView*)pickerView
                     titleForRow:(NSInteger)row
                    forComponent:(NSInteger)component
{
    if(self.dataArr.count > component) {
        
        NSArray *arr = self.dataArr[component];
        if(arr.count > row) {
            return arr[row];
        }
        
        
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
        pickerLabel.minimumScaleFactor = 8;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text =
    [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView*)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if([self.delegate respondsToSelector:@selector(setingInfoPickerView:didSelectedForRow:forComponent:)]) {
        [self.delegate setingInfoPickerView:self didSelectedForRow:row forComponent:component];
    }
    
}

- (CGFloat)pickerView:(UIPickerView*)pickerView
rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}
#pragma mark - 懒加载
- (UIPickerView *)pickView {
    if(!_pickView) {
        UIPickerView* addressPickView = [[UIPickerView alloc] init];
        addressPickView.dataSource = self;
        addressPickView.delegate = self;
        addressPickView.showsSelectionIndicator = YES;
        _pickView = addressPickView;
    }
    return _pickView;
}
- (NSArray *)dataArr {
    if(!_dataArr) {
        _dataArr = [[NSArray alloc] init];
    }
    return _dataArr;
}

- (void)reloadData {
    [self.pickView reloadAllComponents];
}
- (void)finishAction {
    if([self.delegate respondsToSelector:@selector(finishBtnDidSelect:)]) {
        
        [self.delegate finishBtnDidSelect:self];
    }
    
}


@end
