//
//  GYHSRegisterTableCell.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSRegisterTableCellDelegate <NSObject>

@optional
- (void)buttonAction:(UIButton*)button indexPath:(NSIndexPath*)indexPath;

- (void)inputTextField:(NSString*)value indexPath:(NSIndexPath*)indexPath;

- (void)keyBoardAppearWhenEditing:(UITextField *)textField indexPath:(NSIndexPath*)indexPath;

@end

@interface GYHSRegisterTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField* valueTextField;
@property (nonatomic, weak) id<GYHSRegisterTableCellDelegate> cellDelegate;
@property (nonatomic, assign) BOOL isNotShowLine;

- (void)setCellValue:(NSString*)name
               value:(NSString*)value
         placeHolder:(NSString*)placeHolder
             pwdType:(BOOL)pwdType
             maxSize:(NSInteger)maxSize
         keyBoardNum:(BOOL)keyBoardNum
          showSmsBtn:(BOOL)showSmsBtn
        showArrowBtn:(BOOL)showArrowBtn
           indexPath:(NSIndexPath*)indexPath;

- (void)setValueTextFieldEnable:(BOOL)enable;

- (void)updateSMSTitle:(NSString*)title;

- (void)changeArrowImage:(NSString*)imageName;

@end
