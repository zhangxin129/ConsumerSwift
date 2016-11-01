//
//  GYHDNavView.h
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDNavViewDelegate <NSObject>
@optional
- (void)GYHDNavViewButtonClick:(UIButton *)button;
- (void)GYHDNavViewSearchAll;
- (void)GYHDNavViewGoBackAction;
- (void)GYHDNavViewSearch:(UITextField *)textField;
@end

@interface GYHDNavView : UIView
@property (nonatomic, copy) NSString *backTitle;
@property (nonatomic, weak) id<GYHDNavViewDelegate> delegate;
@property (nonatomic,strong) UILabel *tipLabel;//企业消息提示
@property (nonatomic,strong) UILabel *showLabel;//客户咨询消息提示
@property (nonatomic,strong) UILabel *msgLabel;//消息列表消息提示

/**
 *3个btn的View
 */
- (NSArray *)segmentViewMsgBtn:(UIButton *)msgBtn :(UIButton *)customerBtn :(UIButton *)companyBtn;
/**
 *只有文字的View
 */
- (void)segmentViewLable:(NSString *)title;
/**
 *搜索按钮
 */
- (void)searchBtn;
/**
 *搜索框
 */
- (void)searchTextFiled:(NSString *)imageName :(NSString *)placeholder;
@end
