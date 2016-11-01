//
//  GYHSBusinessFillCardView.h
//  HSConsumer
//
//  Created by lizp on 16/8/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "GYHESCDefaultAddressModel.h"

@interface GYHSBusinessFillCardView : UIView

@property (nonatomic,strong) UITextView *reasonTextView;//补办原因
@property (nonatomic,strong) UIButton *nextStepBtn;//下一步
@property (nonatomic,strong) UIButton *modifyAddressBtn;//修改联系地址
@property (nonatomic,strong) GYHESCDefaultAddressModel *model;



-(instancetype)init;

@end
