//
//  GYSelectTitleViewController.h
//  HSCompanyPad
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYSelectTitleViewController;
@protocol GYSelectTitleViewControllerDelegate<UITableViewDelegate>
- (void)transSelectedShopNameArray:(NSMutableArray *)selectArray;
@end


@interface GYSelectTitleViewController : UIViewController

@property (nonatomic, weak) id<GYSelectTitleViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, copy) NSString * heardString;
@property (nonatomic, assign) BOOL flag;
-(id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array heardTitle:(NSString *)heardTitle select:(BOOL)select;


@end
