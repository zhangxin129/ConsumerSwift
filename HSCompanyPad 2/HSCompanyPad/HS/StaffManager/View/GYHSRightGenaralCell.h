//
//  GYHSRightGenaralCell.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>



@class GYHSRightGenaralCell;
@protocol GYHSRightGenaralCellDelegate <NSObject>
@optional
-(void)rightGenaralCell:(GYHSRightGenaralCell*)specialcell didClickCellButtonWithTag:(NSInteger)tag;
-(void)rightGenaralCell:(GYHSRightGenaralCell*)specialcell didClickLabelWithTag:(NSInteger)tag;
@end
@interface GYHSRightGenaralCell : UITableViewCell
@property(nonatomic,weak) id <GYHSRightGenaralCellDelegate> delegate;
//第一种单元 蓝色和红色的 显示明细查询
-(instancetype)createNeedCustomShowDetailWith:(UIColor*)color;

//第二种单元格 中间两个label
- (instancetype)createNeedCustomWithLeftLabelString:(NSString*)stringLeft leftColor:(UIColor*)leftColor leftFont:(UIFont*)leftFont rightLabelString:(NSString*)stringRight rightColor:(UIColor*)rightColor rightFont:(UIFont*)rightFont;

//第三种单元格 中间两个按钮
- (void)initWithLeftImageName:(NSString*)leftImagName leftTitle:(NSString*)leftTitleStr  rightImageName:(NSString*)rightImagName rightTitle:(NSString*)rightTitleStr;

//第四种自定义的cell 用于静态描述
-(instancetype)createNeedCustomWithDscripritionWords;

//第五种单元格 中间一个按钮
-(instancetype)createNeedCustomWithMidOneButtonImageName:(NSString*)imageStr Title:(NSString*)titleStr Tag:(NSInteger)tag leftTitleColor:(UIColor*)color;

//第六种单元格 左边显示投资收益的数据 右边显示明细查询的按钮
-(instancetype)createNeedCustomDividendYear:(NSString*)dividendYear LeftShowDetailPercentage:(NSString*)numStr numberColor:(UIColor*)numberColor rightShowColor:(UIColor*)showColor;


//临时添加一种单元 高度不要添加导航栏的高度
-(instancetype)createNeedCustomShowDetailWithNoNavigationHeightFirstShowColor:(UIColor*)color;
-(instancetype)createNeedCustomShowDetailWithNoNavigationHeightSecondShowColor:(UIColor*)color;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
