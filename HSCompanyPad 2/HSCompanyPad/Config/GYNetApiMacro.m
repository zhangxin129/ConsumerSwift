//
//  GYNetAPiMacro.m
//  company
//
//  Created by sqm on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYNetApiMacro.h"

#pragma mark - 公共接口
NSString *const GYJSUpdateUrl = @"/updated/queryCurrentPatches";//JS更新

#pragma mark - 公共接口
NSString* const GYCommonYiPay = @"/payOperate/ylCommonPayment"; //易联支付获取支付要素接口

#pragma mark - 服务公司申报管理
NSString* const GYHSGetDeclareList = @"/entDeclareManage/getDeclareList"; //分页查询企业申报记录
NSString* const  GYHSDelUnSubmitDeclare = @"/entDeclareManage/delUnSubmitDeclare";//删除未提交的申报信息
NSString* const GYHSGetFilingList = @"/entDeclareManage/getFilingList"; // 分页查询企业报备
NSString* const GYHSGetFilingDetail = @"/entDeclareManage/getFilingDetail"; // 分页查询企业报备详情
NSString* const GYHSGetIntentCustList = @"/entDeclareManage/getIntentCustList"; /// 分页查询企业意向客户
NSString* const GYHSGetIntentCustDetail = @"/entDeclareManage/getIntentCustDetail"; // 查询企业意向客户详情
NSString* const GYHSGetAuthCodeList = @"/entDeclareManage/getAuthCodeList"; // 服务公司授权码查询
NSString* const GYHSGetNotServiceEntQuota = @"/entDeclareManage/getNotServiceEntQuota"; // 查询成员企业或托管企业可用配额数和默认企业互生号
NSString* const GYHSQueryDeclareRegInfo = @"/entDeclareManage/queryDeclareRegInfo";//查询企业系统注册信息及设置的增值点
NSString* const GYHSGetEntResNo = @"/entDeclareManage/getEntResNo"; // 分页查询企业可用互生号
NSString* const GYHSCheckValidEntResNo = @"/entDeclareManage/checkValidEntResNo";//检查企业互生号被占用
NSString* const GYHSGetServiceEntQuota = @"/entDeclareManage/getServiceEntQuota"; // 查询管理公司信息和服务公司可用配额数
NSString* const GYHSGetIncrementInfo = @"/entDeclareManage/getIncrementInfo"; // 查询积分增值点信息
NSString* const GYHSCreateEntDeclare = @"/entDeclareManage/createEntDeclare"; // 创建企业系统注册信息及积分增值点设置
NSString* const GYHSCreateEntBussinessInfo = @"/entDeclareManage/createEntBussinessInfo"; //创建企业工商登记信息
NSString* const GYHSQueryDeclareBizRegInfo = @"/entDeclareManage/queryDeclareBizRegInfo";//查询企业工商登记信息
NSString* const GYHSCreateEntLinkmanInfo = @"/entDeclareManage/createEntLinkmanInfo"; // 创建企业联系人信息
NSString* const GYHSSubmitDeclare = @"/entDeclareManage/submitDeclare";//提交申报
NSString* const GYHSQueryLinkman = @"/entDeclareManage/queryLinkman";//查询企业申报联系人信息
#pragma mark 刷卡器模块
NSString* const GYPOSSourceTransNo = @"/v1/cardReader/sourceTransNo"; //统一生成交易流水号
NSString* const GYPOSSinglePosQuery = @"/cardReader/singlePosQuery"; //单笔交易查询
NSString* const GYPOSCorrect = @"/v1/cardReader/correct"; //冲正
NSString* const GYPOSBack = @"/v1/cardReader/back"; //退货
NSString* const GYPOSCancel = @"/v1/cardReader/cancel"; //撤单
NSString* const GYPOSPoint = @"/cardReader/point"; //消费积分提交
NSString* const GYPOSPrePoint = @"/v1/cardReader/prePoint"; //互生币预付定金
NSString* const GYPOSSearchPosEarnest = @"/v1/cardReaderV3/searchPosEarnest"; //互生币预付定金查询
NSString* const GYPOSCancelEarnest = @"/cardReaderV3/cancelEarnestSettle"; //预付定金撤销
NSString* const GYPOSEarnestSettle = @"/v1/cardReader/earnestSettle"; //预付定金结算
NSString* const GYPOSQueryCusTip = @"/common/queryCusTips"; //查询消费者可兑换互生币余额
NSString* const GYPOSScanPosQuery = @"/v1/account/singlePosQueryV3"; //查询二维码支付结果
NSString* const GYPointWaterQuery = @"/v1/account/queryPointNbc"; //积分流水查询
NSString* const GYPOSCustGloabalCoupon = @"/v1/cardReaderV3/custGlobalCoupon"; //查询平台的抵扣券配置项
NSString* const GYPOSCheckCustCouponData = @"/cardReaderV3/checkCustCouponData"; //校验抵扣券数量是否足够
NSString* const GYPOSV3Point = @"/v1/cardReaderV3/point"; //3.1版本消费积分接口
NSString* const GYPOSFindCardReaderByDeviceNo = @"/cardReaderV3/findCardReaderByDeviceNo"; //检查刷卡器是否合法
NSString* const GYPOSPointRecord = @"/v1/cardReader/pointRecord"; // 可查询退货和撤单查询
NSString* const GYPOSECCorrect = @"/hsecCardReader/posCorrect"; // 电商刷卡器冲正
NSString* const GYPOSOrderList = @"/hsecCardReader/posOrderList"; // 电商手机刷卡器查询订单
NSString* const GYPOSUpdatePointRate = @"/bussinessManager/updatePointRate"; // 修改设备积分比例
NSString* const GYPOSECOrderPay = @"/hsecCardReader/orderPay"; //电商支付
NSString* const GYPOSProxyBuyHsb = @"/v1/hsb/proxyBuyHsb"; // 代兑互生币
NSString* const GYPOSCheckResNoStatus = @"/v1/hsbNew/checkResNoStatus"; //3.1版本查询消费者是否实名注册
NSString* const GYPOSBsCorrect = @"/cardReader/bsCorrect"; ////代兑互生币冲正
#pragma mark - 企业信息
NSString* const GYHSQueryEntInfo = @"/v1/entInfo/queryEntInfo";
NSString* const GYHSGlobalData = @"/common/globalData"; //获取全局参数
NSString* const GYHSBaseInfo = @"/entInfo/baseInfo"; //系统登记信息
NSString* const GYHSCompanyAllInfo = @"/v1/entInfo/companyAllInfo"; //工商登记信息
NSString* const GYHSCreateEntChangeInfo = @"/v1/entInfo/createEntChangeInfo"; //创建企业重要信息变更
NSString* const GYHSQueryDocExampleList = @"/common/queryBizDocList"; //查询示例文档
NSString* const GYHSQueryImageExampleList = @"/common/queryImageDocList"; //查询示例图片
NSString* const GYHSListPwdQuestion = @"/v1/findPwd/listPwdQuestion"; //密保问题列表
NSString* const GYHSSetPwdQuestion = @"/cardHolderController/setPwdQuestion"; //设置密保问题
NSString* const GYHSCreateEntRealNameAuth = @"/v1/entInfo/createEntRealNameAuth"; //创建企业实名认证申请
NSString* const GYHSGetEntRealnameAuthByCustId = @"/v1/entInfo/getEntRealnameAuthByCustId"; //通过客户号查询企业实名认证详情
NSString* const GYHSGetEntRealnameAuthByhsResNo = @"/v1/entInfo/getEntRealnameAuthByhsResNo"; //获取实名认证信息
NSString* const GYHSMainInfo = @"/v1/entInfo/mainInfo"; //企业联系信息
NSString* const GYHSSendMailForValidEmail = @"/v1/entInfo/sendMailForValidEmail"; //修改企业安全邮箱发送链接
NSString* const GYHSUpdateMainInfo = @"/v1/entInfo/updateMainInfo"; //修改企业联系信息
NSString* const GYHSListBindBank = @"/v1/bankAccount/listBindBank"; //查询企业绑定银行列表
NSString* const GYHSQueryBank = @"/lcs/queryBank"; //查询开户银行列表
NSString* const GYHSQueryCountry = @"/lcs/queryCountry"; //查询开户国家
NSString* const GYHSQueryProvince = @"/lcs/queryProvince"; //查询开户省
NSString* const GYHSQueryCity = @"/lcs/queryCity"; //查询开户市
NSString* const GYHSBindBank = @"/v1/bankAccount/bindBank"; //绑定银行卡信息
NSString* const GYHSBankUpdateInfo = @"/v1/bankAccount/updateEntBaseInfo"; //上传开发许可证
NSString* const GYHSBindBankDetail = @"/bankAccount/bindBankDetail"; //企业绑定银行卡详情
NSString* const GYHSUnBindBank = @"/v1/bankAccount/unBindBank"; //删除企业绑定银行
NSString* const GYHSUnBindQKBank = @"/v1/bankAccount/unBindQkBank"; //删除企业绑定快捷支付
NSString* const GYHSUpdateBindBank = @"/entBankAccount/updateBindBank"; //修改企业绑定银行
NSString* const GYHSUpdateBaseInfo = @"/v1/entInfo/updateBaseInfo"; //修改工商信息
NSString* const GYHSUpdateLoginPwd = @"/v1/findPwd/updateLoginPwd"; //修改登录密码
NSString* const GYHSSetPwdTrade = @"/v1/findPwd/setTradePwd";//设置交易密码
NSString* const GYHSSetUpdateTradePwd = @"/v1/findPwd/updateTradePwd";//修改交易密码
NSString* const GYHSSetReserveInfo = @"/v1/findPwd/setReserveInfo";//设置预留信息
NSString* const GYHSSetUpdatePwdQuestion = @"/v1/findPwd/updatePwdQuestion";//设置密保问题和答案
NSString* const GYHSQueryEntMainInfo = @"/v1/entInfo/queryEntMainInfo"; //查询重要信息
NSString* const GYHSUpdateDefaultBindBank = @"/bankAccount/updateDefaultBindBank"; //设置默认绑定银行
NSString* const GYHSGetLocalInfo = @"/lcs/getLocalInfo"; //查询平台信息
NSString* const GYHSisRelease = @"/common/isRelease"; //查询是否生产环境

NSString* const GYHSQueryEntStatus = @"/entInfo/queryEntStatus"; //查询企业的各种状态(企业信息 实名状态、银行卡绑定状态、重要信息变更状态)
NSString* const GYHSQueryEntChangeByCustId = @"/v1/entInfo/queryEntChangeByCustId";//查询重要信息变更的详情
#pragma mark - 资源管理
NSString* const GYSettingCreateResetTransPwdApply = @"/v1/findPwd/createResetTransPwdApply";//提交重置交易密码申请
NSString* const GYSettingQueryLastApplyBean = @"/v1/findPwd/queryLastApplyBean";//重置交易密码记录查询
NSString* const GYSettingResetTradePwdByAuthCode = @"/v1/findPwd/resetTradePwdByAuthCode";//重置交易密码

NSString* const GYHSGetResourceStatistics = @"/v1/entResource/getResourceStatistics"; //资源管理 关联消费者统计 (服务公司与托管企业)
NSString* const GYHSGetResourceList = @"/v1/conResources/searchPerResListPage"; //服务公司 中的托管企业、成员企业、团队资源列表
#pragma mark - 系统应用信息查询
NSString* const GYHSSysApplyProgress = @"/sysApplication/applyProgress"; //申报进度查询
NSString* const GYHSSysContractInfo = @"/sysApplication/contractInfo"; //合同查询
NSString* const GYHSSysSalerCer = @"/sysApplication/salerCer"; //销售资格证书查询
NSString* const GYHSSysThirdPartCer = @"/sysApplication/thirdPartCer"; //第三方业务认证证书查询
#pragma mark - 登录登出
NSString* const GYHSOperatorLogin = @"/recompany/operatorLogin"; //登录接口
NSString* const GYHSOperatorLogout = @"/recompany/operatorLogout"; //登出接口
NSString* const GYHSLoginPwdValid = @"/common/loginPwdValid"; //校验登录密码
NSString* const GYHSEntGloabalData = @"/common/entGlobalData"; //配置参数
#pragma mark - 找回密码
NSString* const GYHSResetLoginPwdByMobile = @"/v1/findPwd/resetLoginPwdByMobile"; //重置登录密码(手机方式)
NSString* const GYHSResetLoginPwdBySecurity = @"/v1/findPwd/resetLoginPwdBySecurity"; //重置登录密码(密保方式)
NSString* const GYHSCheckPwdQuestion = @"/v1/findPwd/checkPwdQuestion"; //密保验证

NSString* const GYHSCheckSmsCode = @"/v1/findPwd/checkSmsCode"; //校验短信验证码
NSString* const GYHSSendCode = @"/v1/findPwd/sendCode"; //获取短信验证码
NSString* const GYHSResetLoginPwdByEmail = @"/v1/findPwd/resetLoginPwdByEmail"; //发送邮箱链接
#pragma mark - 业务办理


NSString* const GYHSAddressDetail = @"/addressController/addressDetail"; //获取收货地址详情
NSString* const GYHSGetQuickPaySmsCode = @"/common/getQuickPaySmsCode"; //获取快捷支付短信验证码
NSString* const GYHSListQkBanks = @"/v1/bankAccount/listQkBanks"; //快捷支付卡列表
//NSString* const GYHSPaymentByQuickPay = @"/v1/hsb/paymentByQuickPay"; //快捷支付
NSString* const GYHSPaymentByQuickPay = @"/entHsbController/paymentByQuickPay"; //快捷支付
NSString* const GYHSGetPayAnnualFeeInfo = @"/businessProcess/getPayAnnualFeeInfo"; //获取支付企业年费详情
NSString* const GYHSGetToolBuyOrderInfo = @"/v1/businessProcess/getToolBuyOrderInfo"; //获取申购工具订单详情
NSString* const GYHSCancelToolOrder = @"/v1/bussinessManager/cancelOrder"; //取消订单
NSString* const GYHSGetEntStatus = @"/v1/businessProcess/getEntStatus"; //获取企业资格状态

NSString* const GYHSUpdateDeviceStatus = @"/v1/bussinessManager/updateDeviceStatus"; //启用或停用终端设备
NSString* const GYHSFindPointRate = @"/bussinessManager/findPointRate"; //查看设备积分比例
NSString* const GYHSListAsDevice = @"/v1/bussinessManager/listAsDevice"; //刷卡终端管理列表
NSString* const GYHSQueryAllOrderList = @"/v1/businessProcess/queryAllOrderList"; //获取所有订单列表
NSString* const GYHSGetSalerShopList = @"/businessProcess/getSalerShopList"; //删除操作员
NSString* const GYHSGrantRole = @"/v1/businessProcess/grantRole"; //绑定角色
NSString* const GYHSRelationShop = @"/v1/businessProcess/relationShop"; //绑定营业点
NSString* const GYHSUnbindCardLogin = @"/v1/businessProcess/unbindCardLogin"; //互生卡登录解绑
NSString* const GYHSBindCardLogin = @"/v1/businessProcess/bindCardLogin"; //互生卡登录绑定

NSString* const GYHSResetLoginPwd = @"/findPwdController/resetLoginPwd"; //重置登录密码
NSString* const GYHSAddOperator = @"/businessProcess/addOperator"; //新增操作员
NSString* const GYHSGetRoleList = @"/businessProcess/getRoleList"; //获取角色列表
NSString* const GYHSGetOperatorList = @"/businessProcess/getOperatorList"; //获取操作员列表
NSString* const GYHSCreateToolBuyOrder = @"/v1/bussinessManager/createToolBuyOrder"; //申购互生卡或工具 提交订单
NSString* const GYHSPayToolOrder = @"/v1/bussinessManager/payToolOrder"; //申购工具订单 立即支付
NSString* const GYHSPayPurchaseToolOrder = @"/bussinessManager/payToolOrder"; //申购工具订单 立即支付
NSString* const GYHSCreateAnnualFeeOrder = @"/v1/businessProcess/createAnnualFeeOrder"; //生成缴纳年费订单
NSString* const GYHSCreateMemberQuit = @"/v1/businessProcess/createMemberQuit"; //成员企业销户
NSString* const GYHSCreatePointActivity = @"/v1/businessProcess/createPointActivity"; //申请参与/停止积分活动
NSString* const GYHSGetAnnualFeeInfo = @"/v1/businessProcess/getAnnualFeeInfo"; //获取企业年费信息
NSString* const GYHSPayAnnualFeeOrder = @"/v1/businessProcess/payAnnualFeeOrder"; //缴纳年费
NSString* const GYHSGetEntPointRateList = @"/v1/account/getEntPointRateList"; //获取网上登记积分比例列表
NSString* const GYHSEditEntPointRate = @"/v1/points/editEntPointRate"; //修改积分比例
NSString* const GYHSSetEntPointRate = @"/v1/businessProcess/setEntPointRate"; //设置积分比例
NSString* const GYHSSaveEntProxyBuyHsb = @"/businessProcess/saveEntProxyBuyHsb"; //兑换互生币
NSString* const GYHSPointRegister = @"/businessProcess/pointRegister"; //网上积分登记
#pragma mark - 企业账户
NSString* const GYHSAccountBalanceDetail = @"/v1/account/accountBalanceDetail"; //查询(积分(accCategory=1),互生币(accCategory=2),货币(accCategory=3))账户余额详情
NSString* const GYHSGetEntCashAccountDetail = @"/entCashController/getEntCashAccountDetail"; //货币账户列表明细详情
NSString* const GYHSGetAccountDetailList = @"/v1/account/getAccountDetailList"; //(流通币(20110),慈善(20130),积分账户(10110),投资账户(10410),货币账户(30110))明细查询
NSString* const GYHSInvestBalanceDetail = @"/v1/account/investBalanceDetail"; //查询投资账户余额详情
NSString* const GYHSViewInvestDividendInfo = @"/v1/entInvest/viewInvestDividendInfo"; //查询投资账户分红明细
NSString* const GYHSCheckMail = @"/findPwdController/checkMail"; //邮件链接验证
NSString* const GYHSSaveTransOut = @"/v1/cash/saveTransOut"; //货币转银行
NSString* const GYHSGetBankTransFee = @"/v1/account/getBankTransFee"; //企业互生币转货币
NSString* const GYHSHsbToCash = @"/v1/hsb/hsbToCash"; //企业互生币转货币
NSString* const GYHSExchangeHsb = @"/v1/hsb/exchangeHsb"; //兑换互生币
NSString* const GYHSPaymentByCurrency = @"/v1/hsb/paymentByCurrency"; //企业兑换互生币货币支付
NSString* const GYHSCreatePointInvest = @"/v1/points/createPointInvest"; //积分转投资
NSString* const GYHSCreatePvToHsb = @"/v1/points/createPvToHsb"; //积分转互生币
NSString* const GYHSQueryAccountDetail = @"/v1/account/queryAccountDetail"; //账户明细查询
NSString* const GYHSCityTaxJointAccount = @"/common/cityTaxJointAccount"; //城市税收对接账户查询
NSString* const GYHSCreateTaxRate = @"/entCityTax/createTaxRate"; //城市税收税率调整
NSString* const GYHSListTaxRate = @"/entCityTax/listTaxRate"; //城市税收申请列表
NSString* const GYHSAccBalance = @"/entCityTax/accBalance"; //城市税收明细查询
NSString* const GYHSTaxRate = @"/entCityTax/taxRate"; //城市税率调整详情
NSString* const GYHSCheckTaxrateChangePending = @"/entCityTax/checkTaxrateChangePending"; //城市税率是否正在审批
NSString* const GYHSGetEntHsbAccountDetail = @"/entHsbController/getEntHsbAccountDetail"; //互生币账户列表明细详情
NSString* const GYHSGetEntPointAccountDetail = @"/entPointsController/getEntPointAccountDetail"; //积分账户列表明细详情
NSString* const GYHSQueryPointDividendList = @"/v1/entInvest/queryPointDividendList"; //投资分红明细列表
//NSString* const GYHSViewInvestDividendInfo = @"/v1/entInvest/viewInvestDividendInfo"; //投资分红详情
NSString* const GYHSGetDividendRateList = @"/v1/entInvest/getDividendRateList"; //历年投资回报率

NSString* const GYHSGetEntAccBalanceDetail = @"/entCityTax/getEntAccBalanceDetail"; //城市对接账号 投资明细查询  详单
NSString* const GYHSQueryEntTips = @"/v1/account/queryEntTips"; //兑换互生币限额
NSString* const GYHSGetBonusPointDistributionInfo = @"/entPointsController/getBonusPointDistributionInfo"; //托管企业－获取消费积分分配详情
#pragma mark - 吴冰冰增加快捷支付调试
NSString *const GYHSGetPinganQuickBindBankUrl = @"/bankAccount/getPinganQuickBindBankUrl";//快捷开通卡
NSString *const GYHSGETListQkBanksUrl = @"/customerAccount/listQkBanksByBindingChannel";//快捷已开通银行列表
#pragma mark - 餐饮
NSString* const GYHEFoodTopicListQuey = @"/ph/food/topicListQuey"; //互商主界面角标接口
NSString* const GYHEFoodOuterOrderQuery = @"/ph/food/outerOrderQuery"; //订单列表接口
NSString* const GYHEFoodReceivingOrder = @"/ph/food/receivingOrder"; // 店内,外卖,自提接单,确认订单
NSString* const GYHEFoodRefuseOrder = @"/ph/food/refuseOrder"; //外卖拒接
NSString* const GYHEFoodHaveDinner = @"/ph/food/haveDinner"; //店内用餐
NSString* const GYHEFoodTakeawayDelivery = @"/ph/food/takeawayDelivery"; //外卖送餐
NSString* const GYHEFoodQueryOneRoomOrder = @"/ph/food/queryOneRoomOrder"; //查询送餐员
NSString* const GYHEFoodDeliverQuey = @"/ph/food/deliverQuey"; //送餐员列表
NSString* const GYHEFoodConfirmationOfSelf = @"/ph/food/confirmationOfSelf"; //确认自提
NSString* const GYHEFoodTakeOutCollection = @"/ph/food/takeOutCollection"; //外卖收款
NSString* const GYHEFoodCancelReservations = @"/ph/food/cancelReservations"; //取消预约
NSString* const GYHEFoodAgreeToCancel = @"/ph/food/agreeToCancel"; //消费者取消确认
NSString* const GYHEFoodFindOrderDetails = @"/ph/food/findOrderDetails"; //订单详情
NSString* const GYHEFoodDelOrderDetail = @"/ph/food/delOrderDetail"; //删除已点菜品
NSString* const GYHEFoodSendOrderToBuyer = @"/ph/food/sendOrderToBuyer"; //打单发送
NSString* const GYHEFoodCheckout = @"/ph/food/checkout"; //现金结账
NSString* const GYHEFoodUpdateOrder = @"/ph/food/updateOrder"; //修改详情中就餐人数
NSString* const GYHEFoodAddMenu = @"/ph/food/addMenu"; //修改详情中就餐人数
NSString* const GYHEFoodAddOrderDetail = @"/ph/food/addOrderDetail"; //添加菜品明细
#pragma  mark - 零售接口
NSString *const GYHEUploadAndUpdateShopLogoPic = @"/hsecFiles/uploadAndUpdateShopLogoPic";//上传我的互生的头像
NSString *const GYHERetailGetGoodsInfo = @"/service/getGoodsInfo"; //获取商品详情接口
NSString *const GYHERetailOrderList = @"/service/getEvaluationInfo"; //查询订单列表接口
NSString *const GYHERetailComplainList = @"/service/getComplainList"; //投诉/举报列表接口(传的状态不一样)
NSString *const GYHERetailFindOrderByOrderID = @"/service/findOrderByOrderId"; //查找订单通过OrderID
NSString *const GYHERetailFindOrderList = @"/service/findOrderList"; //查找订单列表
NSString *const GYHERetailFindRefundList = @"/service/findRefundList"; //查找退款列表
NSString *const GYHERetailComplainSalesDetail = @"/service/getComplainSalesDetail"; //售后举报详情
NSString *const GYHERetailProcessSalesComplaints = @"/service/processSalesComplaints"; //售后举报处理
NSString *const GYHERetailComplainDetail = @"/service/getComplainDetail"; //举报详情
NSString *const GYHERetailProcessComplaints = @"/service/processComplaints"; //举报处理
NSString *const GYHERetailProcessDeal = @"/service/getCompalinTypeList"; //服务公司处理类型

NSString *const GYHERetailFoodHaveDinner = @"/ph/food/haveDinner"; //取消待确认
NSString *const GYHERetailPassRefund = @"/saler/passRefund"; //确认退款
NSString *const GYHERetailNoPassRefund = @"/saler/noPassRefund"; //退款失败
NSString *const GYHERetailSalerFindOrderByOrderID = @"/saler/findOrderByOrderId"; //查找订单通过订单号
NSString *const GYHERetailSalerFindOrderList = @"/saler/findOrderList"; //查找零售订单列表
NSString *const GYHERetailFindOrderDetail = @"/saler/findOrderDetail"; //查询订单详情
NSString *const GYHERetailSalerDelivey = @"/saler/salerDelivey"; //售后发货
NSString *const GYHERetailLogistics = @"/saler/getLogistics"; //物流
NSString *const GYHERetailDelivery = @"/saler/delivery"; //送货员
NSString *const GYHERetailSalerShopDelivery = @"/saler/getSalerShopDeliver"; //选择送货员
NSString *const GYHERetailSalerConfirm = @"/saler/salerConfirm"; //确定收货
NSString *const GYHERetailRefundInfo = @"/saler/getRefundInfo"; //查售后详情
NSString *const GYHERetailUserNetworkInfo = @"/customer/getUserNetworkInfo"; //跳转聊天（直接跳到互生)
NSString *const GYHERetailSalerFindRefundList = @"/saler/findRefundList"; //企业售后列表
NSString *const GYHERetailDelayDeliver = @"/saler/delayDeliver"; //待确认收货(延迟收货)
NSString *const GYHERetailConfirmCancelBySaler = @"/saler/confirmCancelBySaler"; //确认退款（仅退款）  拒绝 与同意  两种情况
NSString *const GYHERetailTakeToOfflineStore = @"/saler/takeToOfflineStore"; //确认支付（1待自提）
NSString *const GYHERetailConfirmPayBySaler = @"/saler/confirmPayBySaler"; //确认支付   无需自提码
NSString *const GYHERetailCancelOrder = @"/saler/cancelOrder"; //取消订单（未支付）
NSString *const GYHERetailSalerOrderStocking = @"/saler/salerOrderStocking"; //备货
NSString *const GYHERetailDeliveryGoods = @"/saler/deliveryGoods";//发货(非售后)
NSString *const GYHEServerceGetComplainSalesDetail = @"/service/getComplainSalesDetail";//服务公司申诉详情

#pragma mark - 操作员管理
NSString *const GYHSOperatorList = @"/v1/businessProcess/getOperatorList";//企业操作员列表
NSString *const GYHSSalerShopList = @"/v1/businessProcess/getSalerShopList";

NSString* const GYHSRoleList = @"/v1/businessProcess/getRoleList"; //获取角色列表
NSString* const GYHSAddNewOperator = @"/v1/businessProcess/addOperator"; //新增操作员
NSString* const GYHSDeleteOperator = @"/v1/businessProcess/deleteOperator"; //删除操作员
NSString* const GYHSEditOperator = @"/v1/businessProcess/editOperator"; //操作员修改
NSString* const GYHSResetLoginPwdByAdmin = @"/v1/businessProcess/resetLoginPwdByAdmin"; //管理员重置操作员登录密码
NSString* const GYHSApplyProgress = @"/v1/bussinessManager/applyProgress"; //工具申购列表或互生卡申购
NSString* const GYHSQueryMayBuyToolNum = @"/v1/bussinessManager/queryMayBuyToolNum"; //查询工具可申购数量
NSString* const GYHSReciveAddr = @"/v1/bussinessManager/reciveAddr"; //收货地址列表
NSString* const GYHSQueryProvinceTree = @"/lcs/queryProvinceTree"; //查询平台信息
NSString* const GYHSDeleteAddress = @"/v1/addressController/deleteAddress"; //删除地址
NSString* const GYHSAddAdress = @"/v1/addressController/addAddress"; //新增地址
NSString* const GYHSUpdateAddress = @"/v1/addressController/updateAddress"; //修改地址
NSString* const GYHSQueryEntResourceSegment = @"/v1/bussinessManager/queryEntResourceSegment"; //查询企业资源段
NSString* const GYHSListConfirmCardStyle = @"/v1/bussinessManager/listConfirmCardStyle"; //查询企业下的个性卡样列表
NSString* const GYHSListSpecCardStyle = @"/v1/bussinessManager/listSpecCardStyle"; //个性卡定制列表
NSString* const GYHSEntConfirmCardStyle = @"/v1/bussinessManager/entConfirmCardStyle"; //确认卡样
NSString* const GYHSAddCardStyleOrder = @"/v1/bussinessManager/addCardStyleOrder"; //个性卡定制下单