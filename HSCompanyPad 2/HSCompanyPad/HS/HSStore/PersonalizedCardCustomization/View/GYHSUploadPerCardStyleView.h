//
//  GYHSUploadPerCardStyleView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSUploadPerCardStyleDelegate <NSObject>

- (void)transCardName:(NSString *)cardName Remark:(NSString *)remark;

@end

@interface GYHSUploadPerCardStyleView : UIView

@property (nonatomic, weak) id<GYHSUploadPerCardStyleDelegate> delegate;

@end
