//
//  GYHDCompanyDetailsCell.h
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDSaleListModel.h"
#import "GYHDOpereotrListModel.h"
@interface GYHDCompanyDetailsCell : UICollectionViewCell
@property(nonatomic,strong)GYHDSaleListModel*model;//营业点列表模型
@property(nonatomic,strong)UILabel*unreadMessageCountLabel;//未读消息数量显示
-(void)initUIWithModel:(GYHDSaleListModel*)model;
-(void)initUIWithOperatorModel:(GYHDOpereotrListModel *)model;
@end
