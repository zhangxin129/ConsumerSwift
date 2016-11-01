//
//  GYHSGeneralDetailCheckCell.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//


//生成通用的表视图单元
#import <UIKit/UIKit.h>

@interface GYHSGeneralDetailCheckCell : UITableViewCell


//生成一个显示5个细节的表视图单元
- (instancetype)createNeedCustomWithFiveLabels:(NSString *)stringOne string:(NSString *)stringTwo string:(NSString *)stringThree string:(NSString *)stringFour string:(NSString *)stringFive;

//生成一个显示4个细节的表视图单元
- (instancetype)createNeedCustomWithFourLabels:(NSString *)stringOne string:(NSString *)stringTwo string:(NSString *)stringThree string:(NSString *)stringFour;

//生成一个显示6个细节的表视图单元
- (instancetype)createNeedCustomWithSixLabels:(NSString *)stringOne string:(NSString *)stringTwo string:(NSString *)stringThree string:(NSString *)stringFour string:(NSString *)stringFive string:(NSString *)stringSix;

/**
 *  通用的cell创建方法
 *
 *  @param tableView 表视图
 *
 *  @return 通用的cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;






@end
