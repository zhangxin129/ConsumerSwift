//
//  GYHDSendModel.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSendModel : NSObject

@property(nonatomic, strong)NSAttributedString *sendAttString;
@property(nonatomic, copy)NSString *sendString;
@property(nonatomic, copy)NSString *fileBaseName;
@property(nonatomic, copy)NSString *fileDetailName;
@end
