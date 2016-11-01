//
//  GYHSMyImportantInfoChageMainCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSMyImportantInfoChageMainCellDelegate <NSObject>

/*!
 *    修改内容
 *
 *    @param content   输入框中的内容
 *    @param indexPath cell的indexPath
 *
 *    @return 是否更新成功
 */
- (BOOL)updateContent:(UITextField *)contentTextField indexPath:(NSIndexPath*)indexPath;
/*!
 *    更新cell的高度
 *
 *    @param height 计算出高度
 *    @param indexPath cell的indexPath
 */
-(void)updateCellHeight:(float)height indexPath:(NSIndexPath*)indexPath;

@end

@interface GYHSMyImportantInfoChageMainCell : UITableViewCell

@property (nonatomic, weak) id<GYHSMyImportantInfoChageMainCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign,getter=isModify) BOOL modify;
@property (nonatomic, strong) NSDictionary *paramter;

@end
