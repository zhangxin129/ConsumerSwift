//
//  GYHSMyCompanyInfoCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSMyCompanyInfoCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
/*!
 *    通过index 加边框
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
