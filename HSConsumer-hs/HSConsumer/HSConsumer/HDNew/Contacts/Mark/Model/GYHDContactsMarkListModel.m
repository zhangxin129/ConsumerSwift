//
//  GYHDContactsMarkListModel.m
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDContactsMarkListModel.h"

@implementation GYHDContactsMarkListModel
-(NSMutableArray *)markListArray{
    if (!_markListArray) {
        
        _markListArray=[NSMutableArray array];
    }
    return _markListArray;
}

- (NSMutableArray *)markListCustIDArray {
    if (!_markListCustIDArray) {
        _markListCustIDArray = [NSMutableArray array];
    }
    return _markListCustIDArray;
}
@end
