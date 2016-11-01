//
//  GYSurroundShopSecondCell.h
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYSurroundShopVisitSecondCell;
@protocol GYSurroundShopVisitSecondCellDelegate <NSObject>

- (void)surroundShopVisitSecondCell:(GYSurroundShopVisitSecondCell*)cell didSelectItemAtIndexPath:(NSIndexPath*)indexPath categoryName:(NSString*)categoryName categoryId:(NSString*)categoryId;

@end

@interface GYSurroundShopVisitSecondCell : UITableViewCell
@property (nonatomic, weak) NSArray* secondCategories;
@property (nonatomic, weak) UIViewController<GYSurroundShopVisitSecondCellDelegate>* delegate;
+ (CGFloat)height;
@end
