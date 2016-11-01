//
//  GYHECartSectionHeaderView.h
//  HSConsumer
//
//  Created by admin on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHECartListModel.h"

@protocol GYHECartSectionHeaderViewDelegate <NSObject>

@optional

- (void)updateStateWithAction:(NSInteger)section;
- (void)pushToShopHomePage:(NSInteger)section;//跳转至店铺首页

@end

@interface GYHECartSectionHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIView *couponInfoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *voucherInfoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponInfoViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *couponButton;

@property (nonatomic, weak) id<GYHECartSectionHeaderViewDelegate> delegate;
@property (nonatomic, strong) GYHECartListModel* listModel;
@property (nonatomic, assign) NSInteger section;

@end
