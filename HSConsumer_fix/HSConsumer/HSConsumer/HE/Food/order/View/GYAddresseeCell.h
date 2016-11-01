//
//  GYAddresseeCell.h
//  HSConsumer
//
//  Created by 00 on 14-12-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYGetGoodViewController.h"
#import "GYGetAddressDelegate.h"

@protocol GYAddresseeCellDelegate <NSObject>

//-(void)pushSelWayViewWithmArray:(NSMutableArray *)mArray;

- (void)pushSelWayVCWithmArray:(NSMutableArray*)mArray WithIndexPath:(NSIndexPath*)IndexPath;

- (void)pushSelAddrVC;

@end

@interface GYAddresseeCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath* indexPath;

@property (weak, nonatomic) IBOutlet UIButton* btnSelWay; //支付方式
@property (weak, nonatomic) IBOutlet UILabel* lbLine; //分隔线

@property (weak, nonatomic) IBOutlet UILabel* lbAddressee; //收件人
@property (weak, nonatomic) IBOutlet UILabel* lbPhone; //电话

@property (weak, nonatomic) IBOutlet UILabel* lbAddress; //地址

@property (weak, nonatomic) IBOutlet UIButton* btnChangeAddress;

@property (weak, nonatomic) IBOutlet UIButton* rightArrow;

@property (assign, nonatomic) id<GYAddresseeCellDelegate> delegate;





@end
