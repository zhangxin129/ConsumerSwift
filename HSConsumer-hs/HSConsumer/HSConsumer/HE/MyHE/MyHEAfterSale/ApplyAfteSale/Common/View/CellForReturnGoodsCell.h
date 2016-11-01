//
//  CellForReturnGoodsCell.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kCellForReturnGoodsCellIdentifier @"CellForReturnGoodsCellIdentifier"

#import <UIKit/UIKit.h>

@protocol CellForReturnGoodsCellDelegate <NSObject>
@optional
- (void)selectChange:(id)sender;

@end

@interface CellForReturnGoodsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView* ivGoodsPicture;
@property (strong, nonatomic) IBOutlet UILabel* lbGoodsName;
@property (strong, nonatomic) IBOutlet UILabel* lbGoodsPrice;
@property (strong, nonatomic) IBOutlet UIButton* btnSelect;
@property (nonatomic, weak) id<CellForReturnGoodsCellDelegate> delegate;
+ (CGFloat)getHeight;
- (BOOL)isSelected;

@end
