//
//  GYHSMyComanyFooterViewNewCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSMyComanyFooterViewCellDeleage <NSObject>

/*!
 *    修改成了日期
 *
 */
- (void)updateStandDateComplete:(dispatch_block_t)complete;
/*!
 *    修改营业日期
 *
 *    @param modifyTime 输入框中的营业日期
 */
- (void)updateBusinessTime:(NSString*)modifyTime complete:(dispatch_block_t)complete;
/*!
 *    修改经营范围
 *
 *    @param modifyRunArea 输入框中的经营范围
 */
- (void)updateRunArea:(NSString *)modifyRunArea complete:(dispatch_block_t)complete;
/*!
 *    更新cell的高度
 *
 *    @param height 计算出高度
 */
-(void)updateCellHeight:(float)height;

@end


@class GYHSMyCompanyInfoModel;
@interface GYHSMyComanyFooterViewCell : UITableViewCell

@property (nonatomic, weak) id<GYHSMyComanyFooterViewCellDeleage> delegate;
@property (nonatomic, strong) GYHSMyCompanyInfoModel* model;

@end
