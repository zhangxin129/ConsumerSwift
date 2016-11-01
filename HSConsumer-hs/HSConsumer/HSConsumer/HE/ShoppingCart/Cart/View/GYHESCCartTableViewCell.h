//
//  GYHESCCartTableViewCell.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHESCCartListModel.h"

typedef void (^accountBlock)(void);

@protocol GYHESCCartCellDelegate <NSObject>

@optional

- (void)pushToChooseAreaWithIndexPath:(NSIndexPath*)indexPath; //选择营业点
- (void)pushToItemDetailWithIndexPath:(NSIndexPath*)indexPath; //商品详情
- (void)deleteCartCell:(NSIndexPath*)indexPath; //删除项目
- (void)resetCartCell:(NSIndexPath*)indexPath; //重置项目

@end

@interface GYHESCCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* shopNameLabel; //店名
@property (weak, nonatomic) IBOutlet UIButton* trashButton; //删除按钮
@property (weak, nonatomic) IBOutlet UIButton* selectButton; //选中按钮
@property (weak, nonatomic) IBOutlet UIImageView* pictureImageView; //图片
@property (weak, nonatomic) IBOutlet UILabel* describleLabel; //描述内容
@property (weak, nonatomic) IBOutlet UILabel* skuLabel; //sku
@property (weak, nonatomic) IBOutlet UILabel* moneyNumLabel; //单件价格
@property (weak, nonatomic) IBOutlet UIButton* subButton; //减按钮
@property (weak, nonatomic) IBOutlet UILabel* numberLabel; //购买数量
@property (weak, nonatomic) IBOutlet UIButton* addButton; //加按钮
@property (weak, nonatomic) IBOutlet UILabel* operatingPointLabel; //营业点标签
@property (weak, nonatomic) IBOutlet UILabel* storeLabel; //专卖店名称
@property (weak, nonatomic) IBOutlet UILabel* goodsNumLabel; //购买货物数量
@property (weak, nonatomic) IBOutlet UILabel* totalLabel; //总计标签
@property (weak, nonatomic) IBOutlet UILabel* totalCoinNumLabel; //总共花费的价钱
@property (weak, nonatomic) IBOutlet UILabel* pvNumLabel; //积分值

@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) accountBlock accountBlock;
@property (nonatomic, weak) id<GYHESCCartCellDelegate> delegate;
@property (nonatomic, strong) GYHESCCartListModel* listModel;
@property (nonatomic, assign) NSInteger maxNumber;//最大购买数量

- (void)refreshDataWithModel:(GYHESCCartListModel *)model;

@end
