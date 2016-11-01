//
//  GYHEShoppingCartListTableViewCell.h
//  HSConsumer
//
//  Created by admin on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "GYHECartListModel.h"

@protocol GYHEShoppingCartListTableViewCellDelegate <NSObject>

@optional

- (void)updateShowState:(NSIndexPath*)indexPath; //更新控制器显示状态
- (void)pushToItemDetailWithIndexPath:(NSIndexPath*)indexPath; //商品详情

@end

@interface GYHEShoppingCartListTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIButton* chooseButton;
@property (weak, nonatomic) IBOutlet UIImageView* showImageView;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* skuLabel;
@property (weak, nonatomic) IBOutlet UILabel* moneyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel* pvNumLabel;
@property (weak, nonatomic) IBOutlet UIButton* addButton;
@property (weak, nonatomic) IBOutlet UIButton* subtractButton;
@property (weak, nonatomic) IBOutlet UILabel* numberLabel;

@property (nonatomic, weak) id<GYHEShoppingCartListTableViewCellDelegate> cellDelegate;

@property (nonatomic, strong) NSIndexPath* indexPath;
//@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) GYHECartItemModel* itemModel;
@property (nonatomic, assign) NSInteger maxNumber; //最大购买数量

@end
