//
//  GYCollectionFooterView.h
//  HSConsumer
//
//  Created by apple on 16/1/6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Postr)(void);
@interface GYCollectionFooterView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton* btnapply; //立即申请
@property (weak, nonatomic) IBOutlet UILabel* lbUploadinstructions; //资料附件上传说明
@property (weak, nonatomic) IBOutlet UILabel* lbStructions;
@property(nonatomic, copy) Postr cb;

@end
