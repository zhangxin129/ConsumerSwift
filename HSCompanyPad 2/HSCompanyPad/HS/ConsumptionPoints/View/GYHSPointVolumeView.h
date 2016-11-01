//
//  GYHSPointVolumeView.h
//  HSCompanyPad
//
//  Created by 梁晓辉 on 16/7/27.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYHSVolumeViewDelegate <NSObject>

- (void)selectedVolume:(NSString*)volumeAmount pageVolume:(NSString*)pageVolume;
@end
typedef void (^touchBlcok)();
@interface GYHSPointVolumeView : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak) id<GYHSVolumeViewDelegate> delegate;
@property (nonatomic, copy) touchBlcok block;
@end
