//
//  SecondTableViewCell.h
//  DropDownDemo
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYEasyBuyThirdTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton* btnSelected;

- (void)refreshUIWith:(NSString*)title;

- (void)selectOneRow:(NSInteger)index WithSelected:(BOOL)selected;

@end
