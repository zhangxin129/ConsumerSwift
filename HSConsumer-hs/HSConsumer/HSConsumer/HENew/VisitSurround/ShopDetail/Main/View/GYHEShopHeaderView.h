//
//  GYHEShopHeaderView.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHEShopDetailModel.h"

@interface GYHEShopHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *contactShoperBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopBusinessImgBtn;
@property (nonatomic, strong) GYHEShopDetailModel *model;

@end
