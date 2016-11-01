//
//  GYHDSearchModel.h
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSearchModel : NSObject
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, strong) NSArray *searchReasultArr;
@property (nonatomic, assign)BOOL isShowAllContent;
@end
