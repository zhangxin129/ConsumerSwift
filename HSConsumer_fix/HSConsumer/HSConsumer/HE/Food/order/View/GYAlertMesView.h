//
//  GYAlertMesView.h
//  HSConsumer
//
//  Created by kuser on 16/4/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYAlertMesView : UIView

- (instancetype)initWithTitle:(NSString*)title
                  contentText:(NSString*)content
              leftButtonTitle:(NSString*)leftTitle
             rightButtonTitle:(NSString*)rigthTitle;

- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end

@interface UIImage (colorful)

+ (UIImage*)imageWithColor:(UIColor*)color;

@end
