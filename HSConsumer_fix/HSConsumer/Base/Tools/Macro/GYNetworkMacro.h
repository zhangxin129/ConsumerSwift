//
//  GYNetworkMacro.h
//  HSConsumer
//
//  Created by zhangqy on 16/2/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#ifndef GYNetworkMacro_h
#define GYNetworkMacro_h

#pragma mark - Basic URL
//-------------------Basic URL-------------------------
// 互商
#define retailDomainBase globalData.retailDomain

// 互动
#define hdImPersonInfoDomainBase globalData.loginModel.hdbizDomain

// 调用互生
#define HSReconsitutionUrl [[GYHSLoginEn sharedInstance] getLoginUrl]

// 餐饮
#define foodConsmerDomainBase globalData.foodConsmerDomain

// 过滤服务器的URL
#define kFilterServerBaseURL [[GYHSLoginEn sharedInstance] getFilterUrl]

#pragma mark - 登录
//-------------------登录-------------------------
//登录
#define LoginUrl [[[GYHSLoginEn sharedInstance] getLoginUrl] stringByAppendingString:@"/uias/userLogin"]

//登出
#define LoginOutUrl [[[GYHSLoginEn sharedInstance] getLoginUrl] stringByAppendingString:@"/uias/logout"]

//强制登录
#define ForceLoginUrl [[[GYHSLoginEn sharedInstance] getLoginUrl] stringByAppendingString:@"/uias/updateSameType"]

#pragma mark - 互生API
//-------------------互生API-------------------------
// 上传图片
#define kUrlFileUpload [HSReconsitutionUrl stringByAppendingString:@"/fileController/fileUpload"]
#define kUrlCustomerLogin [HSReconsitutionUrl stringByAppendingString:@"/recustomer/customerLogin"]
#define kUrlCustomerLogout [HSReconsitutionUrl stringByAppendingString:@"/recustomer/customerLogout"]
#define kUrlCheckPwdQuestion [HSReconsitutionUrl stringByAppendingString:@"/findPwdController/checkPwdQuestion"]
#define kUrlCheckSmsCode [HSReconsitutionUrl stringByAppendingString:@"/findPwdController/checkSmsCode"]
#define kUrlListPwdQuestion [HSReconsitutionUrl stringByAppendingString:@"/findPwdController/listPwdQuestion"]
#define kUrlResetLoginPwd [HSReconsitutionUrl stringByAppendingString:@"/findPwdController/resetLoginPwdByMobile"]
#define kUrlResetLoginPwdBySecurity [HSReconsitutionUrl stringByAppendingString:@"/findPwdController/resetLoginPwdBySecurity"]
#define kUrlSendCode [HSReconsitutionUrl stringByAppendingString:@"/findPwdController/sendCode"]
#define kUrlSendEmail [HSReconsitutionUrl stringByAppendingString:@"/findPwdController/sendEmail"]
#define kUrlRegister [HSReconsitutionUrl stringByAppendingString:@"/noCardController/register"]
#define kUrlSendSmsCode [HSReconsitutionUrl stringByAppendingString:@"/noCardController/sendSmsCode"]
#define kUrlAddAddress [HSReconsitutionUrl stringByAppendingString:@"/addressController/addAddress"]
#define kUrlAddressDetail [HSReconsitutionUrl stringByAppendingString:@"/addressController/addressDetail"]
#define kUrlAddressList [HSReconsitutionUrl stringByAppendingString:@"/addressController/addressList"]
#define kUrlDefaultAddress [HSReconsitutionUrl stringByAppendingString:@"/addressController/defaultAddress"]
#define kUrlDeleteAddress [HSReconsitutionUrl stringByAppendingString:@"/addressController/deleteAddress"]
#define kUrlUpdateAddress [HSReconsitutionUrl stringByAppendingString:@"/addressController/updateAddress"]
#define kUrlQueryBank [HSReconsitutionUrl stringByAppendingString:@"/lcs/queryBank"]
#define kUrlGlobalData [HSReconsitutionUrl stringByAppendingString:@"/common/globalData"]
#define kUrlBindBank [HSReconsitutionUrl stringByAppendingString:@"/bankAccount/bindBank"]
#define kUrlSetDefaultBindBank [HSReconsitutionUrl stringByAppendingString:@"/bankAccount/setDefaultBindBank"]
#define kUrlUnBindBank [HSReconsitutionUrl stringByAppendingString:@"/bankAccount/unBindBank"]
#define kUrlUpdateLoginPwd [HSReconsitutionUrl stringByAppendingString:@"/findPwdController/updateLoginPwd"]
#define kUrlBindBankDetail [HSReconsitutionUrl stringByAppendingString:@"/bankAccount/bindBankDetail"]
#define kUrlListBindBank [HSReconsitutionUrl stringByAppendingString:@"/bankAccount/listBindBank"]
#define kUrlGetPinganQuickBindBankUrl [HSReconsitutionUrl stringByAppendingString:@"/bankAccount/getPinganQuickBindBankUrl"]
#define kUrlcGetQuickPaymentSmsCode [HSReconsitutionUrl stringByAppendingString:@"/common/getQuickPaySmsCode"]
#define kUrlhGetQuickPaymentSmsCode [HSReconsitutionUrl stringByAppendingString:@"/hsbAccount/getQuickPaySmsCode"]
#define kUrlhPaymentByQuickPay [HSReconsitutionUrl stringByAppendingString:@"/hsbAccount/paymentByQuickPay"]
#define kUrlListQkBanks [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/listQkBanks"]
#define kUrlListQkBanksByBindingChannel [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/listQkBanksByBindingChannel"]
#define kUrlUnBindQkBank [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/unBindQkBank"]
#define kUrlSetPwdQuestion [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/setPwdQuestion"]
#define kUrlSaveTransOut [HSReconsitutionUrl stringByAppendingString:@"/currencyAccount/saveTransOut"]
#define kUrlGetBankTransFee [HSReconsitutionUrl stringByAppendingString:@"/common/getBankTransFee"]
#define kUrlGetLocalInfo [HSReconsitutionUrl stringByAppendingString:@"/lcs/getLocalInfo"]
#define kUrlPaymentByNetBank [HSReconsitutionUrl stringByAppendingString:@"/hsbAccount/paymentByNetBank"]
#define kUrlGetHsbPinganPayUrl [HSReconsitutionUrl stringByAppendingString:@"/hsbAccount/getHsbPinganPayUrl"]

// 获取支付的订单，用于易联支付
#define kUrlPayOperateOrderInfo [HSReconsitutionUrl stringByAppendingString:@"/payOperate/ylCommonPayment"]
#define kUrlApplyAccidentSecurity [HSReconsitutionUrl stringByAppendingString:@"/integral/applyAccidentSecurity"]
#define kUrlApplyDieSecurity [HSReconsitutionUrl stringByAppendingString:@"/integral/applyDieSecurity"]
#define kUrlFindWelfareQualify [HSReconsitutionUrl stringByAppendingString:@"/integral/findWelfareQualify"]

//积分账户明细详情
#define kUrlQueryPointAccountDetail [HSReconsitutionUrl stringByAppendingString:@"/customerPoints/queryPointAccountDetail"]

//货币账户明细详情
#define kUrlQueryHbAccountDetail [HSReconsitutionUrl stringByAppendingString:@"/currencyAccount/queryHbAccountDetail"]

//流通币明细详情
#define kUrlQueryHsbAccountDetailForLtb [HSReconsitutionUrl stringByAppendingString:@"/hsbAccount/queryHsbAccountDetailForLtb"]

//消费币明细详情
#define kUrlQueryHsbAccountDetailForXfb [HSReconsitutionUrl stringByAppendingString:@"/hsbAccount/queryHsbAccountDetailForXfb"]

//积分投资明细详情
#define kUrlInvestBalanceDetail [HSReconsitutionUrl stringByAppendingString:@"/common/investBalanceDetail"]

//投资分行详情
#define kUrlCViewInvestDividendInfo [HSReconsitutionUrl stringByAppendingString:@"/customerPoints/viewInvestDividendInfo"]
#define kUrlGetToken [HSReconsitutionUrl stringByAppendingString:@"/common/getToken"]

//互生医疗补贴计划
#define kHScardMedicalSubsidySchemeUrlString [HSReconsitutionUrl stringByAppendingString:@"/integral/applyMedicalSubsidies"]

//获取图片示例列表
#define kHSqueryImageDocListUrlString [HSReconsitutionUrl stringByAppendingString:@"/common/queryImageDocList"]

//业务状态查询
#define kperBusinessStatusUrl [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/perBusinessStatus"]

//查询互生卡的状态
#define ksearchHsCardInfoByResNoUrl [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/searchHsCardInfoByResNo"]

#define kUrlQueryCountry [HSReconsitutionUrl stringByAppendingString:@"/lcs/queryCountry"]

//国家参数  countryNo=156
#define kUrlQueryProvince [HSReconsitutionUrl stringByAppendingString:@"/lcs/queryProvince"]

//国家 省 参数 countryNo=156&provinceNo=11
#define kUrlQueryCity [HSReconsitutionUrl stringByAppendingString:@"/lcs/queryCity"]

//中国全部市
#define kUrlAllCity [HSReconsitutionUrl stringByAppendingString:@"/lcs/queryProvinceTree"]

//查看是否已设置收货地址、密保问题和交易密码
#define kHScardcheckInfoStatusUrlString [HSReconsitutionUrl stringByAppendingString:@"/customer/checkInfoStatus"]

//设置交易密码
#define kHSsetTradePwdUrlString [HSReconsitutionUrl stringByAppendingString:@"/tradePwd/setTradePwd"]

//修改交易密码
#define kHSupdateTradePwdUrlString [HSReconsitutionUrl stringByAppendingString:@"/tradePwd/updateTradePwd"]

//查询消费者兑换互生币温馨提示数据
#define kHScardqueryCusTipsUrlString [HSReconsitutionUrl stringByAppendingString:@"/common/queryCusTips"]

//查询消费者的各种状态
#define kHSqueryCustomerStatusUrlString [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/queryCustomerStatus"]
//获取个人信息 customer/queryNetworkInfo
#define kHSGetInfo [HSReconsitutionUrl stringByAppendingString:@"/customer/queryNetworkInfo"]

//校验消费者抵扣券数量
#define kHSCheckCustCouponData [HSReconsitutionUrl stringByAppendingString:@"/cardReaderV3/checkCustCouponData"]


//查询实名认证信息
#define kHSGetsearchRealNameAuthInfo [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/searchRealNameAuthInfo"]

#pragma mark--- 互动api
#define QueryPersonInfoListUrl [hdImPersonInfoDomainBase stringByAppendingString:@"/userc/queryPersonInfoList"] //查询好友列表
#define ConfirmBbindResourceNoUrl [hdImPersonInfoDomainBase stringByAppendingString:@"/userc/confirmBbindResourceNo"]
#define UpdatePersonInfoUrl [hdImPersonInfoDomainBase stringByAppendingString:@"/userc/updatePersonInfo"]
#define QueryPersonInfoUrl [hdImPersonInfoDomainBase stringByAppendingString:@"/userc/queryPersonInfo"]
//我的互商里面的用户信息
#define CustomerInfoUrl [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/customerInfo"]

#pragma mark--- 互商api
#define ModifyPwdUrl [retailDomainBase stringByAppendingString:@"/user/modifyPwd"]
#define ModifyPwdForFindUrl [retailDomainBase stringByAppendingString:@"/user/modifyPwdForFind"]
#define CheckMobileCodeUrl [retailDomainBase stringByAppendingString:@"/user/checkMobileCode"]
#define SendShortMsgUrl [retailDomainBase stringByAppendingString:@"/recustomer/sendSmsCode"]
#define SendEmailUrl [retailDomainBase stringByAppendingString:@"/user/sendEmail"]
#define appealUrl [retailDomainBase stringByAppendingString:@"/easybuy/appeal"]

#define SearchShopItemUrl [retailDomainBase stringByAppendingPathComponent:@"shops/searchShopItem"]
#define GetGoodsMainInterfaceUrl [retailDomainBase stringByAppendingString:@"/goods/v2/getMainInterface"]
#define GetShopsMainInterfaceUrl [retailDomainBase stringByAppendingString:@"/shops/v2/getMainInterface"]
#define GetBeforeShopListUrl [retailDomainBase stringByAppendingString:@"/shops/getBeforeShopList"]

#define GetChildCategoryByParentIdUrl [retailDomainBase stringByAppendingString:@"/goods/v2/getChildCategoryByParentId"]
#define SortTypeUrl [retailDomainBase stringByAppendingString:@"/goods/sortType"]
#define ShopSortTypeUrl [retailDomainBase stringByAppendingString:@"/shops/sortType"]
#define GetTopicListUrl [retailDomainBase stringByAppendingString:@"/shops/v2/getTopicList"]
#define GetGoodsTopicListUrl [retailDomainBase stringByAppendingString:@"/goods/v2/getTopicList"]
#define GetShopInfoUrl [retailDomainBase stringByAppendingString:@"/shops/getShopInfo"]
#define ShopColumnClassifyUrl [retailDomainBase stringByAppendingString:@"/shops/v2/columnClassify"]
#define GetVShopIntroductionUrl [retailDomainBase stringByAppendingString:@"/shops/v2/getVShopIntroduction"]
#define NoCardRigisterUrl [retailDomainBase stringByAppendingString:@"/user/noCardRigister"]
#define GoodsSortNameUrl [retailDomainBase stringByAppendingString:@"/goods/sortName"]

#define EasybuyGetGoodsInfo [retailDomainBase stringByAppendingString:@"/easybuy/getGoodsInfo"]

#define GetLocationUrl [retailDomainBase stringByAppendingString:@"/shops/getLocation"]
#define GetVShopShortlyInfoUrl [retailDomainBase stringByAppendingString:@"/easybuy/getVShopShortlyInfo"]
#define GetDefaultDeliveryAddressUrl [retailDomainBase stringByAppendingString:@"/easybuy/getDefaultDeliveryAddress"]
#define GetVShopCategoryUrl [retailDomainBase stringByAppendingString:@"/shops/getVShopCategory"]
#define GetHotItemsByVshopIdUrl [retailDomainBase stringByAppendingString:@"/easybuy/getHotItemsByVshopId"]
#define GetFindMapUrl [retailDomainBase stringByAppendingString:@"/shops/getFindMap"]
#define CollectionGoodsUrl [retailDomainBase stringByAppendingString:@"/goods/collectionGoods"] //收藏商品
#define CancelCollectionGoodsUrl [retailDomainBase stringByAppendingString:@"/goods/cancelCollectionGoods"] //取消收藏商品
#define CancelConcernShopUrl [retailDomainBase stringByAppendingString:@"/shops/cancelConcernShop"] //取消收藏商铺
#define ConcernShopUrl [retailDomainBase stringByAppendingString:@"/shops/concernShop"] //收藏商铺

#define GetEvaluationInfoUrl [retailDomainBase stringByAppendingString:@"/easybuy/getEvaluationInfo"]
#define GetGoodsInfoUrl [retailDomainBase stringByAppendingString:@"/goods/getGoodsInfo"]
#define GetAddCartUrl [retailDomainBase stringByAppendingString:@"/easybuy/getAddCart"] //加入购物车
#define GetGoodsSkuUrl [retailDomainBase stringByAppendingString:@"/easybuy/getGoodsSKU"] //获取商品的sku
#define GetVShopBrandNameUrl [retailDomainBase stringByAppendingString:@"/shops/getVShopBrandName"]
#define GetEasyBuyTopicListUrl [retailDomainBase stringByAppendingString:@"/easybuy/getTopicList"]
#define EasyBuyColumnClassifyUrl [retailDomainBase stringByAppendingString:@"/easybuy/columnClassify"]
#define EasyBuySortNameUrl [retailDomainBase stringByAppendingString:@"/easybuy/sortName"]
#define EasyBuySortTypeUrl [retailDomainBase stringByAppendingString:@"/easybuy/sortType"]
#define EasyBuySearchUrl [retailDomainBase stringByAppendingString:@"/easybuy/search"]
#define EasyBuySearchShopUrl [retailDomainBase stringByAppendingString:@"/easybuy/searchShop"]
#define EasyBuyGetEvaluationGoodsListUrl [retailDomainBase stringByAppendingString:@"/easybuy/getEvaluationGoodsList"]
#define EasyBuyGetPublishEvaluationUrl [retailDomainBase stringByAppendingString:@"/easybuy/getPublishEvaluation"]
#define EasyBuyFeedbackUrl [retailDomainBase stringByAppendingString:@"/easybuy/feedback"] //意见反馈
#define EasyBuyGetHomePageUrl [retailDomainBase stringByAppendingString:@"/easybuy/getHomePage"]
#define EasyBuyGetMyVoucherUrl [retailDomainBase stringByAppendingString:@"/easybuy/getMyVoucher"] //未使用抵扣券
#define EasyBuyGetUsedVoucherUrl [retailDomainBase stringByAppendingString:@"/easybuy/getUsedVoucher"] //已使用抵扣券
#define EasyBuyGetShopsByItemIdUrl [retailDomainBase stringByAppendingString:@"/easybuy/getShopsByItemId"]
#define EasyBuyGetExpressTypeUrl [retailDomainBase stringByAppendingString:@"/easybuy/getExpressType"]
#define EasyBuyGetMybusinessUrl [retailDomainBase stringByAppendingString:@"/easybuy/getMyBusiness"]
#define DelayDeliverUrl [retailDomainBase stringByAppendingString:@"/saler/delayDeliver"] //延迟收货
#define EasyBuyCancelOrderUrl [retailDomainBase stringByAppendingString:@"/easybuy/cancelOrder"] //取消订单
#define EasyBuyAgainBuyUrl [retailDomainBase stringByAppendingString:@"/easybuy/againBuy"] //再次购买
#define EasyBuyConfirmReceiptUrl [retailDomainBase stringByAppendingString:@"/easybuy/confirmReceipt"] //确认收货
#define EasyBuyRemindDeliverUrl [retailDomainBase stringByAppendingString:@"/easybuy/remindDeliver"] //提醒收货
#define EasyBuyGetOrderInfoUrl [retailDomainBase stringByAppendingString:@"/easybuy/getOrderInfo"] //获取订单详情
#define EasyBuyBuildTakeQRCodeUrl [retailDomainBase stringByAppendingString:@"/easybuy/buildTakeQRCode"] //创建二维码
#define EasyBuyGetMyOrderUrl [retailDomainBase stringByAppendingString:@"/easybuy/getMyOrder"]
#define EasyBuyGetRefundRecordUrl [retailDomainBase stringByAppendingString:@"/easybuy/getRefundRecord"]
#define EasyBuyGetMyConcernShopUrl [retailDomainBase stringByAppendingString:@"/easybuy/getMyConcernShop"] //获取关注的商铺
#define EasyBuyGetMyConcernGoodsUrl [retailDomainBase stringByAppendingString:@"/easybuy/getMyConcernGoods"] //获取关注的商品
#define EasyBuyGetMyConcernNumberUrl [retailDomainBase stringByAppendingString:@"/easybuy/getUserFavoriteCount"] //获取关注的商品，商铺的数量

#define EasyBuyCancelCollectionGoodsUrl [retailDomainBase stringByAppendingString:@"/easybuy/cancelCollectionGoods"]
#define EasyBuyCollectionGoodsUrl [retailDomainBase stringByAppendingString:@"easybuy/collectionGoods"]
#define EasyBuyRefundOrSwapItemUrl [retailDomainBase stringByAppendingString:@"/easybuy/refundOrSwapItem"] //退款退货
#define EasyBuyGetRefundInfoUrl [retailDomainBase stringByAppendingString:@"/easybuy/getRefundInfo"]
#define EasybuyAppealStatus [retailDomainBase stringByAppendingString:@"/easybuy/appealStatus"] //是否已经申诉
#define EasyBuyGetPaymentTypeUrl [retailDomainBase stringByAppendingString:@"/easybuy/getPaymentType"]
#define EasyBuyPayOrderInOnlineBankUrl [retailDomainBase stringByAppendingString:@"/easybuy/payOrderInOnlineBank"]
#define EasyBuyGetConfirmOrderInfoUrl [retailDomainBase stringByAppendingString:@"/easybuy/getConfirmOrderInfo"]
#define EasyBuyDeleteOrderUrl [retailDomainBase stringByAppendingString:@"/easybuy/deleteOrder"]
#define EasyBuyDeleteRefundUrl [retailDomainBase stringByAppendingString:@"/easybuy/deleteRefund"]
#define EasyBuyExpressUrl [retailDomainBase stringByAppendingString:@"/saler/getLogistics"] //获取快递方式
#define EasyBuyBuyersDeliveryUrl [retailDomainBase stringByAppendingString:@"/easybuy/buyersDelivery"] //买家发货
#define EasyBuyrefConfirmReceiptUrl [retailDomainBase stringByAppendingString:@"/easybuy/refConfirmReceipt"] //售后确认收货
#define EasyBuyUpdateCartNumberUrl [retailDomainBase stringByAppendingString:@"/easybuy/updateCartNumber"] //更新购物车数量
#define EasyBuyDeleteCartUrl [retailDomainBase stringByAppendingString:@"/easybuy/deleteCart"]
#define EasyBuyGetCartListUrl [retailDomainBase stringByAppendingString:@"/easybuy/getCartList"]
#define EasyBuyGetCartMaxSizeUrl [retailDomainBase stringByAppendingString:@"/easybuy/getCartMaxSize"]
#define EasyBuySaveDeliveryAddressUrl [retailDomainBase stringByAppendingString:@"/easybuy/saveDeliveryAddress"]
#define EasyBuyDeleteDeliveryAddressUrl [retailDomainBase stringByAppendingString:@"/easybuy/deleteDeliveryAddress"]
#define EasyBuyGetDeliveryAddressUrl [retailDomainBase stringByAppendingString:@"/easybuy/getDeliveryAddress"]
#define EasyBuyUpdateDeliveryAddressUrl [retailDomainBase stringByAppendingString:@"/easybuy/updateDeliveryAddress"]
#define EasyBuySetDefaultDeliveryAddressUrl [retailDomainBase stringByAppendingString:@"/easybuy/setDefaultDeliveryAddress"]
#define EasyBuyGetConsumerCouponsUrl [retailDomainBase stringByAppendingString:@"/easybuy/getConsumerCoupons"]
#define EasyBuyConfirmationOrderUrl [retailDomainBase stringByAppendingString:@"/easybuy/confirmationOrder"]
#define EasyBuyPayHsbOnlineUrl [retailDomainBase stringByAppendingString:@"/easybuy/payHsbOnline"]

#define EasyBuyUpdateNewPicUrl [retailDomainBase stringByAppendingString:@"/easybuy/updatedUserNetWorkInfo"]  //上传新图片


// 订单、餐饮快捷支付验证码
#define kUrlSendOrderQuickPaySmsCode [retailDomainBase stringByAppendingString:@"/pay/sendQuickPaySmsCode"]

// 订单、餐饮快捷支付申请提交
#define kUrlSendConfirmQuickPay [retailDomainBase stringByAppendingString:@"/pay/confirmQuickPay"]

#pragma mark--- 互商餐饮api
#define GetFoodBeforeListUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/getBeforeDineList"] //外卖历史
#define QueryDiningServicesUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/queryDiningServices"]
#define GetFoodMainPageUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/mainPage"] //餐饮主界面
#define GetFoodShopByIdUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/getShopById"]
#define QueryItemFoodsUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/queryItemfoods"]
#define GetFoodShopCommentUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/getShopComment"] //获取订单评价列表
#define FoodSearchShopsUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/searchShops"]
#define FoodSearchItemsUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/searchItems"]
#define FoodDetailUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/QueryShopByDetails"]
#define FoodConfirmOrderFoodUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/confirmOrderFood"]
#define GetTokenUrl [HSReconsitutionUrl stringByAppendingString:@"/common/getToken"]

#define FoodPayOrderUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/payOrder"] //确认付款
#define GetFoodOrderDetailUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/getOrderDetail"] //获取订单详情
#define FoodCancelOrderUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/cancelOrder"] //取消订单
#define GetFoodOrderListUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/getOrderList"] //获取餐饮订单列表
#define FoodConfirmReceiptUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/confirmReceipt"]
#define FoodCommentShopUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/commentShop"] //评价餐厅
#define GetFoodShopCommitFoodScoreUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/getCommentFoodScore"] //获取餐厅评价列表评分
#define commentGoodUrl [foodConsmerDomainBase stringByAppendingString:@"/ph/food/commentGood"]

//上传图片
#define FoodUploadImageURL ([NSString stringWithFormat:@"%@/easybuy/uploadIncludeSrcUrl?type=%@&fileType=%@", globalData.retailDomain, @"refund", @"image"])

//投资账户投资分红明细查询（单独接口）
#define kInvestAccountInvestDividendsListDetailUrlString [HSReconsitutionUrl stringByAppendingString:@"/invest/queryPointDividendList"]
//投资分红详情
#define kInvestAccountInvestDividendsDetailUrlString [HSReconsitutionUrl stringByAppendingString:@"/invest/viewInvestDividendInfo"]

//查询投资账户余额详情
#define kInvestBalanceDetailUrlString [HSReconsitutionUrl stringByAppendingString:@"/common/investBalanceDetail"]

//兑换互生币
#define kHSExchangeHsbUrlString [HSReconsitutionUrl stringByAppendingString:@"/hsbAccount/exchangeHsb"]

#define kExchangeHsbUrlString [HSReconsitutionUrl stringByAppendingString:@"hsbAccount/paymentByQuickPay"]

//兑换互生币-货币支付
#define kHSExchangeHsbByHbUrlString [HSReconsitutionUrl stringByAppendingString:@"/hsbAccount/paymentByCurrency"]

//互生币转货币
#define kHSDToCashToCashAccountUrlString [HSReconsitutionUrl stringByAppendingString:@"/hsbAccount/hsbToCash"]

//积分转互生币
#define kPointToHSDUrlString [HSReconsitutionUrl stringByAppendingString:@"/customerPoints/createPvToHsb"]

//积分投资
#define kPointInvestUrlString [HSReconsitutionUrl stringByAppendingString:@"/customerPoints/createPointInvest"]

//积分,货币,投资,互生币(流通币、定向消费币)账户明细查询
#define kBaseQueryListDetailUrlString [HSReconsitutionUrl stringByAppendingString:@"/common/getAccountDetailList"]
//检查重要信息是否在变更期
#define kImportantChangeWarmingUrlString [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/checkChangePeriodV3"]

//重要信息变更申请
#define kPushImportantChangeUrlString [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/createPerChange"]

//查询互生币支付限额
#define kHsbQueryPayLimitUrlString [HSReconsitutionUrl stringByAppendingString:@"/common/queryHsbPayLimit"]

//设置互生币支付限额
#define kHsbSetPayLimitUrlString [HSReconsitutionUrl stringByAppendingString:@"/common/setHsbPayLimit"]

//提交实名注册
#define kPushRegisterRealNameUrlString [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/regRealName"]

//提交实名(身份证)认证
#define kPushAuthRealNameWithIdentifyUrlString [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/perRealnameAuthWithIdCard"]

//提交实名(护照)认证
#define kPushAuthRealNameWithPassportUrlString [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/perRealnameAuthWithPassport"]

//提交实名(营业执照)认证
#define kPushAuthRealNameWithBusinessLicenceUrlString [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/perRealnameAuthWithBusLicense"]

//查询消费者是否实名注、是否实名认证
#define kQueryAuthRealNameWithUrlString [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/queryCustomerReal"]

//查询实名认证信息
#define kQueryRealNameAuthInfoUrlString [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/perRealnameAuthInfo"]

//查询实名注册信息
#define kQueryRegisterRealNameUrlString [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/searchRealNameRegInfo"]

//查询账户余额详情
#define kAccountBalanceDetailUrlString [HSReconsitutionUrl stringByAppendingString:@"/common/accountBalanceDetail"]

//互生卡挂失解挂
#define kHSCardLossUnlockUrlString [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/updateHsCardStatus"]

//邮箱绑定
#define kEmailBandingUrlString [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/bindEmail"]

//绑定手机号码
#define kPhoneNumberBandingUrlString [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/bindMobile"]

//修改绑定邮箱
#define kModifyEmailBandingUrlString [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/changeBindEmail"]

//非持卡人修改绑定邮箱
#define kNocardModifyEmailBandingUrlString [HSReconsitutionUrl stringByAppendingString:@"/noCardController/changeBindEmail"]

//发送手机验证码
#define kSendMobileSmsUrlString [HSReconsitutionUrl stringByAppendingString:@"/customerAccount/sendMobileSms"]

//给邮箱发送链接
#define kSendEmailLinkUrlString [HSReconsitutionUrl stringByAppendingString:@"/email/sendEmailLink"]

//互生卡补办生成订单号
#define kHSCardMendCardOrderUrlString [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/mendCardOrder"]
//互生卡补办支付
#define kHSCardMendCardPayUrlString [HSReconsitutionUrl stringByAppendingString:@"/cardHolderController/payToolOrder"]

//积分福利查询
#define kPointWelfareCheckUrlString [HSReconsitutionUrl stringByAppendingString:@"/integral/listWelfareApply"]

//积分福利查询详情
#define kPointWelfareDetailUrlString [HSReconsitutionUrl stringByAppendingString:@"/integral/queryWelfareApplyDetail"]

//上传
#define kUploadFileUrlString [HSReconsitutionUrl stringByAppendingString:@"/fileController/fileUpload"]

//查询默认收货地址
#define kGetDefaultReceiveGoodsAddressUrlString [HSReconsitutionUrl stringByAppendingString:@"/addressController/queryDefaultAddress"]

//修改预留信息
#define kSetReserveInfoUrlString [HSReconsitutionUrl stringByAppendingString:@"/customer/setReserveInfo"]

// 消费者获取全局数据
#define kCustGlobalDataUrlString [HSReconsitutionUrl stringByAppendingString:@"/common/custGlobalData"]




#pragma mark - 过滤服务器接口
//-------------------过滤服务器接口-------------------------
// 检查升级的接口
#define kCheckVersionUpdateURL [kFilterServerBaseURL stringByAppendingString:@"/appfilter/getTipUpdateType"]
//检查js升级
#define kCheckJSPatchUpdateURL [kFilterServerBaseURL stringByAppendingString:@"/updated/queryCurrentPatches"]


//获取支付方式
#define kGetPaymentTypeUrlString [kFilterServerBaseURL stringByAppendingString:@"/appfilter/getPaymentType"]

#endif

