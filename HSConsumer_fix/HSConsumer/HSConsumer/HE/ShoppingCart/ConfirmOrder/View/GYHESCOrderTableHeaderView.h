//
//  GYHESCOrderTableHeaderView.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/28.
//  Copyright © 2016年 zhangqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHESCOrderTableHeaderViewDelegate <NSObject>

@optional

- (void)pushToChooseReceiveAddress; //当是否使用消费券开关更改时，重新计算金额与积分

@end

@interface GYHESCOrderTableHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel* nameLabel; //收货人
@property (weak, nonatomic) IBOutlet UILabel* telephoneNumberLabel; //电话
@property (weak, nonatomic) IBOutlet UILabel* addressLabel; //地址
@property (weak, nonatomic) IBOutlet UILabel* chooseAddressLabel; //选择收货地址
@property (nonatomic, weak) id<GYHESCOrderTableHeaderViewDelegate> delegate;

@end
