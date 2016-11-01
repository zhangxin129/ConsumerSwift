//
//  GYHEAfterSaleListTopPartView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GYHEAfterSaleListTopPartViewDelegate <NSObject>
- (void)click:(NSInteger)index;
@end

@interface GYHEAfterSaleListTopPartView : UIView
@property (nonatomic,weak) id<GYHEAfterSaleListTopPartViewDelegate>delegate;


@end
