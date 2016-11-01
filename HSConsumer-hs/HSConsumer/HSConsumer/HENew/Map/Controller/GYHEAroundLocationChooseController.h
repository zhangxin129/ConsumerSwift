//
//  GYHEAroundLocationChooseController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYAroundLocationChooseControllerDelegate <NSObject>
@optional
- (void)getCity:(NSString*)CityTitle WithType:(int)type;
- (void)getIsLocation:(BOOL)location;
@end
typedef void (^myBlock)();
@interface GYHEAroundLocationChooseController : GYViewController

@property (nonatomic, weak) id<GYAroundLocationChooseControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isLocation;
@property(nonatomic, strong) myBlock block;@end
