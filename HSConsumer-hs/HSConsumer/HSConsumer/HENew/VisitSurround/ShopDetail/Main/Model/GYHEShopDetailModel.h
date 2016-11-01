//
//  GYHEShopDetailModel.h
//  HSConsumer
//
//  Created by xiongyn on 16/10/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface GYHEShopDetailModel : JSONModel

@property (nonatomic, copy)NSString *contactWay;//"0755-1234567"
@property (nonatomic, copy)NSString *vshopName;// "互生-商铺名称",
@property (nonatomic, copy)NSString *dist;// null,
@property (nonatomic, copy)NSString *idCod;//0
@property (nonatomic, copy)NSString *priceSendStart;// "136.00",
@property (nonatomic, assign)BOOL isFreeSendPostage;// false,
@property (nonatomic, strong)NSArray *openTime;// "[{time:周一至周六,value:1,2,3,4,5,6,timeList0:08,timeList1:17,timeList2:17,timeList3:00}]",
@property (nonatomic, copy)NSString *resourceNo;// "06032120000",
@property (nonatomic, strong)NSDictionary *servicesInfo;//
//{
//"hasSerDeposit;// false,
//"hasSerTakeout;// true,
//"hasSerCoupon;// true
//},
@property (nonatomic, strong)NSDictionary *customCateInfo;
//customCateInfo =         {
//    511 =             {
//        cates =                 (
//                                 {
//                                     id = 3073941738947584;
//                                     name = "\U96f6\U552e1";
//                                     sort = 959;
//                                 },
//                                 {
//                                     id = 3077948557591552;
//                                     name = "\U96f6\U552e2";
//                                     sort = 996;
//                                 },
//                                 {
//                                     id = 3083235572548608;
//                                     name = 123456;
//                                     sort = 971;
//                                 }
//                                 );
//        name = "\U5546\U54c1\U96f6\U552e";
//    };
//    512 =             {
//        cates =                 (
//                                 {
//                                     id = 3077468762637312;
//                                     name = 1234;
//                                     sort = 991;
//                                 },
//                                 {
//                                     id = 3079353499730944;
//                                     name = 22;
//                                     sort = 962;
//                                 },
//                                 {
//                                     id = 3079354142278656;
//                                     name = 33;
//                                     sort = 960;
//                                 }
//                                 );
//        name = "\U5916\U5356\U9001\U8d27";
//    };
//    513 =             {
//        cates =                 (
//                                 {
//                                     id = 3052132601922560;
//                                     name = qq;
//                                     sort = 995;
//                                 },
//                                 {
//                                     id = 3077719246455808;
//                                     name = 121;
//                                     sort = 987;
//                                 },
//                                 {
//                                     id = 3077722116047872;
//                                     name = 1;
//                                     sort = 986;
//                                 },
//                                 {
//                                     id = 3077722188760064;
//                                     name = 4;
//                                     sort = 984;
//                                 },
//                                 {
//                                     id = 3077722275546112;
//                                     name = 5;
//                                     sort = 983;
//                                 },
//                                 {
//                                     id = 3077722319586304;
//                                     name = 6;
//                                     sort = 982;
//                                 },
//                                 {
//                                     id = 3077722367214592;
//                                     name = 7;
//                                     sort = 981;
//                                 },
//                                 {
//                                     id = 3077722403046400;
//                                     name = 8;
//                                     sort = 980;
//                                 },
//                                 {
//                                     id = 3077722502644736;
//                                     name = 10;
//                                     sort = 978;
//                                 },
//                                 {
//                                     id = 3079337158509568;
//                                     name = 18;
//                                     sort = 967;
//                                 },
//                                 {
//                                     id = 3079349918843904;
//                                     name = 17;
//                                     sort = 963;
//                                 }
//                                 );
//        name = "\U4fe1\U606f\U670d\U52a1";
//    };
//};
@property (nonatomic, strong)NSDictionary *logo;
// {
//"p200x200;// "",
//"p300x300;// "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1CXWTBXVT1RXrhCrK.jpg",
//"p110x110;// "",
//"p400x400;// "",
//"sourceSize;// "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1XNWTBXJT1RXrhCrK.jpg",
//"p340x340;// ""
//}
@property (nonatomic, strong)NSArray * vshopPics;
//[
//               {
//                   "p200x200" : "",
//                   "p300x300" : "",
//                   "p110x110" : "",
//                   "p400x400" : "",
//                   "sourceSize" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1XFWTB4bT1RXrhCrK.jpg",
//                   "p340x340" : ""
//               },
//               {
//                   "p200x200" : "",
//                   "p300x300" : "",
//                   "p110x110" : "",
//                   "p400x400" : "",
//                   "sourceSize" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1iFWTBCLT1RXrhCrK.jpg",
//                   "p340x340" : ""
//               },
//               {
//                   "p200x200" : "",
//                   "p300x300" : "",
//                   "p110x110" : "",
//                   "p400x400" : "",
//                   "sourceSize" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1KFWTBXdT1RXrhCrK.jpg",
//                   "p340x340" : ""
//               },
//               {
//                   "p200x200" : "",
//                   "p300x300" : "",
//                   "p110x110" : "",
//                   "p400x400" : "",
//                   "sourceSize" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1XzWTB4DT1RXrhCrK.jpg",
//                   "p340x340" : ""
//               }
//               ]
@property (nonatomic, strong)NSArray *takeoutTime;//[{time:周一至周五,value:1,2,3,4,5,timeList0:08,timeList1:17,timeList2:17,timeList3:00}]"
@property (nonatomic, copy)NSString *licenseImg;//http:\/\/192.168.229.27:8080\/hsi-fs-server\/fs\/download\/F00Sn22E62e2FD7e313390Ca5b71UZ",
@property (nonatomic, copy)NSString *addr;//广东省深圳市地王大厦101",
@property (nonatomic, copy)NSString *intrduction;//这是一个商场11",
@property (nonatomic, assign)BOOL isCanHairpin;//true,
@property (nonatomic, assign)BOOL hasFavorite;

@end





    