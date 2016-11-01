//
//  GYSetingSafeSetUpdateCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

//企业登录权限roleId
typedef NS_ENUM(NSUInteger, safeSetUpdateTouchEvent) {
    safeSetUpdateTouchEventUpload ,//上传
    safeSetUpdateTouchEventDownload ,//下载模板
};
@protocol GYSetingSafeSetUpdateCellDelegate <NSObject>

- (void)safeSetupdateCellTouch:(safeSetUpdateTouchEvent) event button:(UIButton*)button;

@end

@interface GYSetingSafeSetUpdateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImagesView;
@property (weak, nonatomic) id<GYSetingSafeSetUpdateCellDelegate> delegate;

@end
