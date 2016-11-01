//
//  CellForOrderDetailCell.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kCellForOrderDetailCellIdentifier @"CellForOrderDetailCellIdentifier"

#import <UIKit/UIKit.h>
@class CellForOrderDetailCell;
// add by songjk
@protocol CellForOrderDetailCellDelegate <NSObject>
@optional
- (void)CellForOrderDetailCellDidCliciPictureWithCell:(CellForOrderDetailCell*)cell;

@end

@interface CellForOrderDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView* ivGoodsPicture;
@property (strong, nonatomic) IBOutlet UILabel* lbGoodsName;
@property (strong, nonatomic) IBOutlet UILabel* lbGoodsCnt;
@property (strong, nonatomic) IBOutlet UILabel* lbGoodsProperty;
@property (strong, nonatomic) IBOutlet UIView* vLine;
@property (assign, nonatomic) NSInteger index; // add by sngjk tableview的row
@property (weak, nonatomic) id<CellForOrderDetailCellDelegate> delegate;
@end
