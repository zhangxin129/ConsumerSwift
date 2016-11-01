//
//  GYHSMyContactInfoThirdCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GYContactInfoBlock)(UIButton *btn);

@class GYHSMyContactInfoMainModel;
@interface GYHSMyContactInfoThirdCell : UITableViewCell

/*!
 *    上传帮扶文件
 */
@property (nonatomic, copy) GYContactInfoBlock toUploadHelpFileBlock;
/*!
 *    浏览帮扶文件
 */
@property (nonatomic, copy) GYContactInfoBlock toBrowerHelpFileBlock;
/*!
 *    上传联系人授权委托书
 */
@property (nonatomic, copy) GYContactInfoBlock toUploadLinkFileBlock;
/*!
 *    浏览联系人授权委托书
 */
@property (nonatomic, copy) GYContactInfoBlock toBrowerLinkFileBlock;

@property (nonatomic, strong) GYHSMyContactInfoMainModel *model;

@end
