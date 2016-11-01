//
//  GYHDSetingInfoPickerView.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYIndexPath : NSObject
@property (nonatomic ,assign) NSUInteger row;
@property (nonatomic ,assign)NSUInteger component;

@end
@class GYHDSetingInfoPickerView;
@protocol GYHDSetingInfoPickerViewDelegate <NSObject>

- (NSArray<NSArray *> *)dataArrayForSetingInfoPickerView:(GYHDSetingInfoPickerView *)setingInfoPickerView;
- (void)setingInfoPickerView:(GYHDSetingInfoPickerView *)setingInfoPickerView didSelectedForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)finishBtnDidSelect:(GYHDSetingInfoPickerView *)setingInfoPickerView;


@end



@interface GYHDSetingInfoPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong)UIPickerView *pickView;
@property (nonatomic, strong)UIButton * finishBtn;

@property (nonatomic, weak)id<GYHDSetingInfoPickerViewDelegate> delegate;

- (void)reloadData;

@end
