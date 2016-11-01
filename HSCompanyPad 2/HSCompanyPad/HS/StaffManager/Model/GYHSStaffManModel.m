//
//  GYHSStaffManModel.m
//
//  Created by apple on 16/8/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSStaffManModel.h"
#import <MJExtension/MJExtension.h>

#define kMax(a,b) (a>b ? a : b)

@implementation GYHSStaffManModel
//- (CGFloat)fCellHeight
//{
//    if (_roleList.count <= 1 && _relationShops.count <= 1 && ([_bindResNoStatus isEqualToString:@"0"] || [_bindResNoStatus isEqualToString:@"1"])) {
//        return 40;
//    }else if (_roleList.count <= 1 && _relationShops.count <= 1 && [_bindResNoStatus isEqualToString:@"-1"]){
//        return  40 * 2;
//    }else if (kMax(_roleList.count,_relationShops.count) == _roleList.count){
//        return _roleList.count * 40;
//    }else{
//        return _relationShops.count * 40;
//    }
//}
- (CGFloat)fCellHeight
{
    if (_roleList.count <= 1  && ([_bindResNoStatus isEqualToString:@"0"] || [_bindResNoStatus isEqualToString:@"1"])) {
        return 40;
    }else if (_roleList.count <= 1 && [_bindResNoStatus isEqualToString:@"-1"]){
        return  40 * 2;
    }else{
        return _roleList.count * 20;
    }
}

+ (NSDictionary*)mj_objectClassInArray
{
    return @{ @"roleList" : @"GYRoleListModel",
              @"relationShops" : @"GYRelationShopsModel" };
}

@end

@implementation GYRelationShopsModel

@end

@implementation GYRoleListModel

//- (CGFloat)cellHeight
//{
//    return [self.roleDesc heightForFont:kFont24 width:kScreenWidth * 0.6] + 20; //20为给的上下空隙
//}

@end
