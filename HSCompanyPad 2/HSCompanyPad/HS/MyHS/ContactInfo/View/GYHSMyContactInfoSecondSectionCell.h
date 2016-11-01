//
//  GYHSMySecondSectionCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSMyContactInfoSecondSectionCellDeleage <NSObject>

/*!
 *    修改联系地址
 *
 *    @param modifyContactAddress 输入框中的联系地址
 *    @param modifyContactAddress 回调事件
 */
- (void)updateContactAddress:(UITextField*)modifyContactAddressTextField complete:(dispatch_block_t)complete;
/*!
 *    修改邮政编码
 *
 *    @param modifyPostCode 输入框中的邮政编码
 *    @param modifyContactAddress 回调事件
 */
- (void)updatePostCode:(UITextField*)modifyPostCodeTextField complete:(dispatch_block_t)complete;
/*!
 *    修改企业邮箱
 *
 *    @param modifyCompanyEmail 输入框中的企业邮箱
 *    @param modifyContactAddress 回调事件
 */
- (void)updateCompanyEmail:(UITextField *)modifyCompanyEmailTextField complete:(dispatch_block_t)complete;
/*!
 *    更新cell的高度
 *
 *    @param height 计算出高度
 */
-(void)updateCellHeight:(float)height;

@end

@class GYHSMyContactInfoMainModel;

@interface GYHSMyContactInfoSecondSectionCell : UITableViewCell

@property (nonatomic, weak) id<GYHSMyContactInfoSecondSectionCellDeleage> delegate;

@property (nonatomic, strong) GYHSMyContactInfoMainModel *model;

@end
