//
//  GYHDContactsMarkListModel.h
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDContactsMarkListModel : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic ,copy)NSString *teamID;
@property(nonatomic,strong)NSMutableArray *markListArray;
@property(nonatomic,strong)NSMutableArray *markListCustIDArray;/**好友ID*/

@end
