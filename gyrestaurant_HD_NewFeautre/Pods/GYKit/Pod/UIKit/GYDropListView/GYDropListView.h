//
//  GYDropListView.h
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYDropListView;
typedef NS_ENUM (NSUInteger, GYDropListViewCellType) {
    GYDropListViewCellTypeDefault = 0,
    GYDropListViewCellTypeSelectedRed,
    GYDropListViewCellTypeSlider,
    GYDropListViewCellTypeCheckmark,
    GYDropListViewCellTypeMutableCheckmark
};
@protocol GYDropListViewDelegate <NSObject>
@optional
- (NSInteger)dropListView:(GYDropListView *)dropListView numberOfGroupsInTitleIndex:(NSInteger)titleIndex;

- (GYDropListViewCellType)dropListView:(GYDropListView *)dropListView cellTypeForRowAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex;

- (void)dropListView:(GYDropListView *)dropListView didSelectRowAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex indexPath:(NSIndexPath *)indexPath rowText:(NSString *)rowText;

- (void)dropListView:(GYDropListView *)dropListView didClickConfirmButtonAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex choosedIndexPaths:(NSArray *)choosedIndexPaths;

- (UIColor *)dropListView:(GYDropListView *)dropListView backgroundColorForCellAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex;
@end




@interface GYDropListView : UIView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(UIViewController<GYDropListViewDelegate> *)delegate;

- (void)setDataSource:(NSArray *)dataSource atTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex;

- (void)showTableViewAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex;

- (void)hiddenTableViewAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex;

- (void)hiddenAllTableView;

- (void)setTitle:(NSString *)title color:(UIColor *)color atTitleIndex:(NSInteger)titleIndex;

@end
