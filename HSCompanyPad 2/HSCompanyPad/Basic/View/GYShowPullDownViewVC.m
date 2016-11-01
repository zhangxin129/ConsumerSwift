//
//  GYShowPullDownView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYShowPullDownViewVC.h"
#import "GYTitleViewController.h"

@interface GYShowPullDownViewVC () <GYTitleViewControllerDelegate> {
    GYTitleViewController* vc;
}

@end

@implementation GYShowPullDownViewVC

- (instancetype)initWithView:(UIView*)view PullDownArray:(NSArray<NSString*>*)titleArray direction:(UIPopoverArrowDirection)direction
{
    vc = [[GYTitleViewController alloc] init];
    self = [super initWithContentViewController:vc];
    if (self) {
        vc.modalPresentationStyle = UIModalPresentationPopover;
        if (titleArray.count > 5) {
            vc.view.height = 5 * 40;
        } else{
            vc.view.height = titleArray.count * 40;
        }
        vc.view.width = view.width;
        vc.dataSource = titleArray;
        vc.delegate = self;
        
        self.popoverContentSize = vc.view.size;
        
        if (titleArray.count > 0) {
            
            [self presentPopoverFromRect:view.frame inView:view.superview permittedArrowDirections:direction animated:YES];
        }
    }
    return self;
}

#pragma mark - GYTitleViewControllerDelegate
- (void)titleViewController:(GYTitleViewController*)titleVc didSelectedIndex:(int)index
{
    self.selectBlock(index);
    [self dismissPopoverAnimated:YES];
}

- (void)dealloc
{
    DDLogInfo(@"doooooooooooooooealloc");
}

@end
