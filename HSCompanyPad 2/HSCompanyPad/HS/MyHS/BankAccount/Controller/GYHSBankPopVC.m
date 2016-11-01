//
//  GYHSBankPopVC.m
//
//  Created by apple on 16/8/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSBankPopVC.h"
#import "GYBankListViewController.h"
@interface GYHSBankPopVC () <sendSelectBankDelegate> {
    GYBankListViewController* vc;
}

@end
@implementation GYHSBankPopVC

- (instancetype)initWithView:(UIView*)view dict:(NSMutableDictionary*)dict direction:(UIPopoverArrowDirection)direction
{

    vc = [[GYBankListViewController alloc] init];
    self = [super initWithContentViewController:vc];
    if (self) {
        vc.modalPresentationStyle = UIModalPresentationPopover;
        if (dict.count > 5) {
            vc.view.height = 5 * 40;
        } else {
            vc.view.height = dict.count * 40;
        }
        vc.view.width = view.width;
        vc.delegate = self;
        vc.nameDictionary = dict;
        self.popoverContentSize = vc.view.size;
        
        if (dict.count > 0) {
        
            [self presentPopoverFromRect:view.frame inView:view.superview permittedArrowDirections:direction animated:YES];
        }
    }
    return self;
}
#pragma mark - sendSelectBankDelegate
- (void)getBank:(BankModel*)model
{
    if (_selectBlock) {
        _selectBlock(model);
    }
    [self dismissPopoverAnimated:YES];
}

@end
