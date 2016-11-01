//
//  GYHSMyContactInfoFirstSectionCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSMyContactInfoMainModel;
@interface GYHSMyContactInfoFirstSectionCell : UITableViewCell

@property (nonatomic, strong) GYHSMyContactInfoMainModel *model;
/*!
 *    通过index 加边框
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
