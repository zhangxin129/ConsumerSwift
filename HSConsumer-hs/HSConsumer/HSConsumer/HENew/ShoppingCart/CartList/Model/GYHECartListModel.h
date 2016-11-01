//
//  GYHECartListModel.h
//  HSConsumer
//
//  Created by User on 16/10/25.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GYHECartItemModel

@end

@interface GYHECartItemModel : JSONModel

@property (nonatomic, copy) NSString* itemId; //商品ID
@property (nonatomic, copy) NSString* vshopId; //商城ID
@property (nonatomic, copy) NSString* name; //商品名称
@property (nonatomic, copy) NSString* num; //数量
@property (nonatomic, copy) NSArray* pics; //商品图片
@property (nonatomic, copy) NSString* skuId; //商品SKU ID
@property (nonatomic, copy) NSString<Optional>* skuContent ; //商品SKU 信息
@property (nonatomic, copy) NSString* skuPrice; //商品价格
@property (nonatomic, copy) NSString* skuPv; //商品积分

@property (nonatomic, assign) BOOL isAdd;//是否可以减
@property (nonatomic, assign) BOOL isSub;//是否可以加
@property (nonatomic, assign) BOOL isSelect;//是否被选中

@end


@interface GYHECartListModel : JSONModel

@property (nonatomic, copy) NSString* vshopId; //商城ID
@property (nonatomic, copy) NSString<Optional>* vshopName; //商城名称
@property (nonatomic, copy) NSArray<GYHECartItemModel>* itemInfos; //商品数组


@property (nonatomic, assign) BOOL isSelect;//是否被选中
//@property (nonatomic, assign) BOOL isShowMore;//是否显示更多

@end
