//
//  GYHSMyImportantCommitCellTableViewCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSMyImportantCommitCellDelegate <NSObject>

/*!
 *    上传营业执照
 *
 *    @param imageButton 点击的button
 *    @return 上传营业执照成功时的图片
 */
- (void)uploadTheBusinessLicense:(UIButton*)imageButton;
/*!
 *    上传联系人授权委托书
 *
 *    @param imageButton 点击的button
 *    @return 上传联系人授权委托书成功时的图片
 */
- (void)uploadTheContactPowerOfAttorney:(UIButton*)imageButton;
/*!
 *    上传业务办理申请书
 *
 *    @param imageButton 点击的button
 *    @return 上传业务办理申请书成功时的图片
 */
- (void)uploadTheBusinessProcessApplication:(UIButton*)imageButton;
/*!
 *    营业执照示例
 */
- (void)loadDownBusinessLicense;
/*!
 *    下载联系人授权委托书模板
 */
- (void)loadDownContactPowerOfAttorney;
/*!
 *    下载业务办理申请书模板
 */
- (void)loadDownBusinessProcessApplication;

@end

@interface GYHSMyImportantCommitCell : UITableViewCell

@property (nonatomic, weak) id<GYHSMyImportantCommitCellDelegate> delegate;
/*!
 *    通过判断该字典的key值来布局UI
 */
@property (nonatomic, strong) NSDictionary *requestDict;
/*!
 *    判断验证码是否输入正确
 */
@property (nonatomic, assign) BOOL isRightCode;
/*!
 *    判断验证码是否为空
 */
@property (nonatomic, assign) BOOL isEmptyCode;
/*!
 *    变更原因
 */
@property (nonatomic, copy) NSString *textViewsText;

//一下三个是为了方便设置button的图片
@property (nonatomic, strong) UIImage* businessLicenseImage;
@property (nonatomic, strong) UIImage* contactPowerOfAttorneyIamge;
@property (nonatomic, strong) UIImage* businessProcessApplicationImage;

@end
