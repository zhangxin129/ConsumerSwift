//
//  GYNetApiMacro.h
//  company
//
//  Created by sqm on 16/3/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#ifndef GYNetApiMacro_h
#define GYNetApiMacro_h


/***** 手机企业接口********/

#pragma mark - 公共接口
FOUNDATION_EXPORT NSString *const GYJSUpdateUrl;//JS更新
FOUNDATION_EXPORT NSString* const GYCommonYiPay; //易联支付获取支付要素接口

#pragma mark - 零售接口
FOUNDATION_EXPORT NSString* const GYHEUploadAndUpdateShopLogoPic;//上传我的互生的头像
FOUNDATION_EXPORT NSString* const GYHERetailGetGoodsInfo; //获取商品详情接口
FOUNDATION_EXPORT NSString* const GYHERetailOrderList; //查询订单列表接口
FOUNDATION_EXPORT NSString* const GYHERetailComplainList; //投诉/举报列表接口(传的状态不一样)
FOUNDATION_EXPORT NSString* const GYHERetailFindOrderByOrderID; //查找订单通过OrderID
FOUNDATION_EXPORT NSString* const GYHERetailFindOrderList; //查找订单列表
FOUNDATION_EXPORT NSString* const GYHERetailFindRefundList; //查找退款列表
FOUNDATION_EXPORT NSString* const GYHERetailComplainSalesDetail; //售后举报详情
FOUNDATION_EXPORT NSString* const GYHERetailProcessSalesComplaints; //售后举报处理
FOUNDATION_EXPORT NSString* const GYHERetailComplainDetail; //举报详情
FOUNDATION_EXPORT NSString* const GYHERetailProcessComplaints; //举报处理
FOUNDATION_EXPORT NSString* const GYHERetailProcessDeal; //处理类型
FOUNDATION_EXPORT NSString* const GYHERetailFoodHaveDinner; //取消待确认
FOUNDATION_EXPORT NSString* const GYHERetailPassRefund; //确认退款
FOUNDATION_EXPORT NSString* const GYHERetailNoPassRefund; //退款失败
FOUNDATION_EXPORT NSString* const GYHERetailSalerFindOrderByOrderID; //查找订单通过订单号
FOUNDATION_EXPORT NSString* const GYHERetailSalerFindOrderList; //查找零售订单列表
FOUNDATION_EXPORT NSString* const GYHERetailFindOrderDetail; //查询订单详情
FOUNDATION_EXPORT NSString* const GYHERetailSalerDelivey; //售后发货
FOUNDATION_EXPORT NSString* const GYHERetailLogistics; //物流
FOUNDATION_EXPORT NSString* const GYHERetailDelivery; //送货员
FOUNDATION_EXPORT NSString* const GYHERetailSalerShopDelivery; //选择送货员
FOUNDATION_EXPORT NSString* const GYHERetailSalerConfirm; //确定收货
FOUNDATION_EXPORT NSString* const GYHERetailSalerShopDelivery; //选择送货员
FOUNDATION_EXPORT NSString* const GYHERetailRefundInfo; //查售后详情
FOUNDATION_EXPORT NSString* const GYHERetailUserNetworkInfo; //跳转聊天
FOUNDATION_EXPORT NSString* const GYHERetailSalerFindRefundList; //企业售后
FOUNDATION_EXPORT NSString* const GYHERetailDelayDeliver; //待确认收货(延迟收货)
FOUNDATION_EXPORT NSString* const GYHERetailConfirmCancelBySaler; //确认退款（仅退款）  拒绝 与同意  两种情况
FOUNDATION_EXPORT NSString* const GYHERetailTakeToOfflineStore; //确认支付（1待自提）
FOUNDATION_EXPORT NSString* const GYHERetailConfirmPayBySaler; //确认支付   无需自提码
FOUNDATION_EXPORT NSString* const GYHERetailCancelOrder; //取消订单（未支付）
FOUNDATION_EXPORT NSString* const GYHERetailSalerOrderStocking; //备货
FOUNDATION_EXPORT NSString* const GYHERetailDeliveryGoods; //发货(非售后)

#pragma mark - 餐饮接口
FOUNDATION_EXPORT NSString* const GYHEFoodTopicListQuey; //互商主界面角标接口
FOUNDATION_EXPORT NSString* const GYHEFoodOuterOrderQuery; //订单列表接口
FOUNDATION_EXPORT NSString* const GYHEFoodReceivingOrder; // 店内,外卖,自提接单,确认订单
FOUNDATION_EXPORT NSString* const GYHEFoodRefuseOrder; //外卖拒接
FOUNDATION_EXPORT NSString* const GYHEFoodHaveDinner; //店内用餐
FOUNDATION_EXPORT NSString* const GYHEFoodTakeawayDelivery; //外卖送餐
FOUNDATION_EXPORT NSString* const GYHEFoodQueryOneRoomOrder; //查询送餐员
FOUNDATION_EXPORT NSString* const GYHEFoodDeliverQuey; //送餐员列表
FOUNDATION_EXPORT NSString* const GYHEFoodConfirmationOfSelf; //确认自提
FOUNDATION_EXPORT NSString* const GYHEFoodTakeOutCollection; //外卖收款
FOUNDATION_EXPORT NSString* const GYHEFoodCancelReservations; //取消预约
FOUNDATION_EXPORT NSString* const GYHEFoodAgreeToCancel; //消费者取消确认
FOUNDATION_EXPORT NSString* const GYHEFoodFindOrderDetails; //订单详情
FOUNDATION_EXPORT NSString* const GYHEFoodDelOrderDetail; //删除已点菜品
FOUNDATION_EXPORT NSString* const GYHEFoodSendOrderToBuyer; //打单发送
FOUNDATION_EXPORT NSString* const GYHEFoodCheckout; //现金结账
FOUNDATION_EXPORT NSString* const GYHEFoodUpdateOrder; //修改详情中就餐人数
FOUNDATION_EXPORT NSString* const GYHEFoodAddMenu; //菜品列表
FOUNDATION_EXPORT NSString* const GYHEFoodAddOrderDetail; //添加菜品明细
#pragma mark - 企业账户
FOUNDATION_EXPORT NSString* const GYHSAccountBalanceDetail; //查询(积分(accCategory=1),互生币(accCategory=2),货币(accCategory=3))账户余额详情
FOUNDATION_EXPORT NSString* const GYHSGetEntCashAccountDetail; //货币账户列表明细详情
FOUNDATION_EXPORT NSString* const GYHSGetAccountDetailList; //(流通币(20110),慈善(20130),积分账户(10110),投资账户(10410),货币账户(30110))明细查询
FOUNDATION_EXPORT NSString* const GYHSInvestBalanceDetail; //查询投资账户余额详情
FOUNDATION_EXPORT NSString* const GYHSCheckMail; //邮件链接验证
FOUNDATION_EXPORT NSString* const GYHSSaveTransOut; //货币转银行
FOUNDATION_EXPORT NSString* const GYHSGetBankTransFee; //企业互生币转货币
FOUNDATION_EXPORT NSString* const GYHSHsbToCash; //企业互生币转货币
FOUNDATION_EXPORT NSString* const GYHSExchangeHsb; //兑换互生币
FOUNDATION_EXPORT NSString* const GYHSPaymentByCurrency; //企业兑换互生币货币支付
FOUNDATION_EXPORT NSString* const GYHSCreatePointInvest; //积分转投资
FOUNDATION_EXPORT NSString* const GYHSCreatePvToHsb; //积分转互生币
FOUNDATION_EXPORT NSString* const GYHSQueryAccountDetail; //账户明细查询
FOUNDATION_EXPORT NSString* const GYHSCityTaxJointAccount; //城市税收对接账户查询
FOUNDATION_EXPORT NSString* const GYHSCreateTaxRate; //城市税收税率调整
FOUNDATION_EXPORT NSString* const GYHSListTaxRate; //城市税收申请列表
FOUNDATION_EXPORT NSString* const GYHSAccBalance; //城市税收明细查询
FOUNDATION_EXPORT NSString* const GYHSTaxRate; //城市税率调整详情
FOUNDATION_EXPORT NSString* const GYHSCheckTaxrateChangePending; //城市税率是否正在审批
FOUNDATION_EXPORT NSString* const GYHSGetEntHsbAccountDetail; //互生币账户列表明细详情
FOUNDATION_EXPORT NSString* const GYHSGetEntPointAccountDetail; //积分账户列表明细详情
FOUNDATION_EXPORT NSString* const GYHSGetDividendRateList ; //历年投资回报率
FOUNDATION_EXPORT NSString* const GYHSQueryPointDividendList; //投资分红明细列表
FOUNDATION_EXPORT NSString* const GYHSViewInvestDividendInfo; //投资分红详情
FOUNDATION_EXPORT NSString* const GYHSGetEntAccBalanceDetail; //城市对接账号 投资明细查询  详单
FOUNDATION_EXPORT NSString* const GYHSQueryEntTips; //兑换互生币限额
FOUNDATION_EXPORT NSString* const GYHSGetBonusPointDistributionInfo; //托管企业－获取消费积分分配详情
#pragma mark - 登录登出
FOUNDATION_EXPORT NSString* const GYHSOperatorLogin; //登录接口
FOUNDATION_EXPORT NSString* const GYHSOperatorLogout; //登出接口
FOUNDATION_EXPORT NSString* const GYHSLoginPwdValid; //校验登录密码
FOUNDATION_EXPORT NSString* const GYHSEntGloabalData; //配置参数
#pragma mark - 业务办理
FOUNDATION_EXPORT NSString* const GYHSListConfirmCardStyle; //查询企业下的个性卡样列表
FOUNDATION_EXPORT NSString* const GYHSQueryEntResourceSegment; //查询企业资源段
FOUNDATION_EXPORT NSString* const GYHSAddressDetail; //获取收货地址详情
FOUNDATION_EXPORT NSString* const GYHSUpdateAddress; //修改地址
FOUNDATION_EXPORT NSString* const GYHSAddAdress; //新增地址
FOUNDATION_EXPORT NSString* const GYHSDeleteAddress; //删除地址
FOUNDATION_EXPORT NSString* const GYHSGetQuickPaySmsCode; //获取快捷支付短信验证码
FOUNDATION_EXPORT NSString* const GYHSListQkBanks; //快捷支付卡列表
FOUNDATION_EXPORT NSString* const GYHSPaymentByQuickPay; //快捷支付
FOUNDATION_EXPORT NSString* const GYHSQueryMayBuyToolNum; //查询工具可申购数量
FOUNDATION_EXPORT NSString* const GYHSGetPayAnnualFeeInfo; //获取支付企业年费详情
FOUNDATION_EXPORT NSString* const GYHSGetToolBuyOrderInfo; //获取申购工具订单详情
FOUNDATION_EXPORT NSString* const GYHSCancelToolOrder ; //取消订单
FOUNDATION_EXPORT NSString* const GYHSAddCardStyleOrder; //个性卡定制下单
FOUNDATION_EXPORT NSString* const GYHSEntConfirmCardStyle; //确认卡样
FOUNDATION_EXPORT NSString* const GYHSGetEntStatus; //获取企业资格状态
FOUNDATION_EXPORT NSString* const GYHSListSpecCardStyle; //个性卡定制列表
FOUNDATION_EXPORT NSString* const GYHSUpdateDeviceStatus; //启用或停用终端设备
FOUNDATION_EXPORT NSString* const GYHSFindPointRate; //查看设备积分比例
FOUNDATION_EXPORT NSString* const GYHSListAsDevice; //刷卡终端管理列表
FOUNDATION_EXPORT NSString* const GYHSQueryAllOrderList; //获取所有订单列表
FOUNDATION_EXPORT NSString* const GYHSDeleteOperator; //删除操作员
FOUNDATION_EXPORT NSString* const GYHSGetSalerShopList; //获取营业点列表
FOUNDATION_EXPORT NSString* const GYHSEditOperator; //操作员修改
FOUNDATION_EXPORT NSString* const GYHSGrantRole; //绑定角色
FOUNDATION_EXPORT NSString* const GYHSRelationShop; //绑定营业点
FOUNDATION_EXPORT NSString* const GYHSUnbindCardLogin; //互生卡登录解绑
FOUNDATION_EXPORT NSString* const GYHSBindCardLogin; //互生卡登录绑定
FOUNDATION_EXPORT NSString* const GYHSResetLoginPwdByAdmin; //管理员重置操作员登录密码
FOUNDATION_EXPORT NSString* const GYHSResetLoginPwd; //重置登录密码
FOUNDATION_EXPORT NSString* const GYHSAddOperator; //新增操作员
FOUNDATION_EXPORT NSString* const GYHSGetRoleList; //获取角色列表
FOUNDATION_EXPORT NSString* const GYHSGetOperatorList; //获取操作员列表
FOUNDATION_EXPORT NSString* const GYHSApplyProgress; //工具申购列表或互生卡申购
FOUNDATION_EXPORT NSString* const GYHSReciveAddr; //收货地址列表
FOUNDATION_EXPORT NSString* const GYHSCreateToolBuyOrder; //申购互生卡或工具 提交订单
FOUNDATION_EXPORT NSString* const GYHSPayToolOrder; //申购工具订单 立即支付
FOUNDATION_EXPORT NSString* const GYHSCreateAnnualFeeOrder; //生成缴纳年费订单
FOUNDATION_EXPORT NSString* const GYHSCreateMemberQuit; //成员企业销户
FOUNDATION_EXPORT NSString* const GYHSCreatePointActivity; //申请参与/停止积分活动
FOUNDATION_EXPORT NSString* const GYHSGetAnnualFeeInfo; //获取企业年费信息
FOUNDATION_EXPORT NSString* const GYHSPayAnnualFeeOrder; //缴纳年费
FOUNDATION_EXPORT NSString* const GYHSGetEntPointRateList; //获取网上登记积分比例列表
FOUNDATION_EXPORT NSString* const GYHSEditEntPointRate; //修改积分比例
FOUNDATION_EXPORT NSString* const GYHSSetEntPointRate; //设置积分比例
FOUNDATION_EXPORT NSString* const GYHSSaveEntProxyBuyHsb; //兑换互生币
FOUNDATION_EXPORT NSString* const GYHSPointRegister; //网上积分登记
#pragma mark - 找回密码
FOUNDATION_EXPORT NSString* const GYHSResetLoginPwdByMobile; //重置登录密码(手机方式)
FOUNDATION_EXPORT NSString* const GYHSResetLoginPwdBySecurity; //重置登录密码(密保方式)
FOUNDATION_EXPORT NSString* const GYHSCheckPwdQuestion; //密保验证
FOUNDATION_EXPORT NSString* const GYHSCheckSmsCode; //校验短信验证码
FOUNDATION_EXPORT NSString* const GYHSListPwdQuestion; //查找密保问题列表
FOUNDATION_EXPORT NSString* const GYHSSendCode; //获取短信验证码
FOUNDATION_EXPORT NSString* const GYHSResetLoginPwdByEmail; //发送邮箱链接
#define upLoadPictureUrl [NSString stringWithFormat:@"%@/fileController/fileUpload?custId=%@&token=%@&isPub=%@", [[GYLoginEn sharedInstance] getLoginUrl], globalData.loginModel.custId, globalData.loginModel.token, @"1"] //上传图片
#pragma mark - 系统应用信息查询
FOUNDATION_EXPORT NSString* const GYHSSysApplyProgress; //申报进度查询
FOUNDATION_EXPORT NSString* const GYHSSysContractInfo; //合同查询
FOUNDATION_EXPORT NSString* const GYHSSysSalerCer; //销售资格证书查询
FOUNDATION_EXPORT NSString* const GYHSSysThirdPartCer; //第三方业务认证证书查询
#pragma mark - 企业信息
FOUNDATION_EXPORT NSString* const GYHSQueryEntInfo;// 查询企业各种信息
FOUNDATION_EXPORT NSString* const GYHSGlobalData; //系统登记信息
FOUNDATION_EXPORT NSString* const GYHSBaseInfo; //系统登记信息
FOUNDATION_EXPORT NSString* const GYHSCompanyAllInfo; //工商登记信息
FOUNDATION_EXPORT NSString* const GYHSCreateEntChangeInfo; //创建企业重要信息变更
FOUNDATION_EXPORT NSString* const GYHSQueryDocExampleList; //查询示例文档
FOUNDATION_EXPORT NSString* const GYHSQueryImageExampleList; //查询示例图片
FOUNDATION_EXPORT NSString* const GYHSSetPwdQuestion; //设置密保问题
FOUNDATION_EXPORT NSString* const GYHSCreateEntRealNameAuth; //创建企业实名认证申请
FOUNDATION_EXPORT NSString* const GYHSGetEntRealnameAuthByCustId; //通过客户号查询企业实名认证详情
FOUNDATION_EXPORT NSString* const GYHSGetEntRealnameAuthByhsResNo; //获取实名认证信息
FOUNDATION_EXPORT NSString* const GYHSMainInfo; //企业联系信息
FOUNDATION_EXPORT NSString* const GYHSSendMailForValidEmail; //修改企业安全邮箱发送链接
FOUNDATION_EXPORT NSString* const GYHSUpdateMainInfo; //修改企业联系信息
FOUNDATION_EXPORT NSString* const GYHSListBindBank; //查询企业绑定银行列表
FOUNDATION_EXPORT NSString* const GYHSQueryBank; //查询开户银行列表
FOUNDATION_EXPORT NSString* const GYHSQueryCountry; //查询开户国家
FOUNDATION_EXPORT NSString* const GYHSQueryProvince; //查询开户省
FOUNDATION_EXPORT NSString* const GYHSQueryCity; //查询开户市
FOUNDATION_EXPORT NSString* const GYHSBindBank; //绑定银行卡信息
FOUNDATION_EXPORT NSString* const GYHSBankUpdateInfo; //上传开发许可证
FOUNDATION_EXPORT NSString* const GYHSBindBankDetail; //企业绑定银行卡详情
FOUNDATION_EXPORT NSString* const GYHSUnBindBank; //删除企业绑定银行
FOUNDATION_EXPORT NSString* const GYHSUnBindQKBank; //删除企业绑定快捷支付卡
FOUNDATION_EXPORT NSString* const GYHSUpdateBindBank; //修改企业绑定银行
FOUNDATION_EXPORT NSString* const GYHSUpdateBaseInfo; //修改工商信息
FOUNDATION_EXPORT NSString* const GYHSUpdateLoginPwd; //修改登录密码
FOUNDATION_EXPORT NSString* const GYHSSetPwdTrade;//设置交易密码
FOUNDATION_EXPORT NSString* const GYHSSetUpdateTradePwd;//修改交易密码
FOUNDATION_EXPORT NSString* const GYHSSetReserveInfo;//设置预留信息
FOUNDATION_EXPORT NSString* const GYHSSetUpdatePwdQuestion;//设置密保问题和答案
FOUNDATION_EXPORT NSString* const GYHSQueryEntMainInfo; //查询重要信息
FOUNDATION_EXPORT NSString* const GYHSUpdateDefaultBindBank; //设置默认绑定银行
FOUNDATION_EXPORT NSString* const GYHSGetLocalInfo; //查询平台信息
FOUNDATION_EXPORT NSString* const GYHSisRelease; //查询是否生产环境
FOUNDATION_EXPORT NSString* const GYHSQueryProvinceTree; //查询平台信息
FOUNDATION_EXPORT NSString* const GYHSQueryEntStatus; //查询企业的各种状态(企业信息 实名状态、银行卡绑定状态、重要信息变更状态)
FOUNDATION_EXPORT NSString* const GYHSQueryEntChangeByCustId; //查询重要信息变更的详情

#pragma mark - 资源管理
FOUNDATION_EXPORT NSString* const GYSettingCreateResetTransPwdApply;//提交交易密码重置申请
FOUNDATION_EXPORT NSString* const GYSettingQueryLastApplyBean;//交易密码重置记录查询
FOUNDATION_EXPORT NSString* const GYSettingResetTradePwdByAuthCode;//交易密码重置
FOUNDATION_EXPORT NSString* const GYHSGetResourceStatistics; //资源管理 关联消费者统计 (服务公司与托管企业)
FOUNDATION_EXPORT NSString* const GYHSGetResourceList; //服务公司 中的托管企业、成员企业、团队资源列表
#pragma mark - 刷卡器模块
FOUNDATION_EXPORT NSString* const GYPOSSourceTransNo; //统一生成交易流水号
FOUNDATION_EXPORT NSString* const GYPOSSinglePosQuery; //单笔交易查询
FOUNDATION_EXPORT NSString* const GYPOSCorrect; //冲正
FOUNDATION_EXPORT NSString* const GYPOSBack; //退货
FOUNDATION_EXPORT NSString* const GYPOSCancel; //撤单
FOUNDATION_EXPORT NSString* const GYPOSPoint; //消费积分提交
FOUNDATION_EXPORT NSString* const GYPOSPrePoint; //互生币预付定金
FOUNDATION_EXPORT NSString *const GYPOSSearchPosEarnest;//互生币预付定金查询
FOUNDATION_EXPORT NSString *const GYPOSCancelEarnest;//互生币预付定金撤销
FOUNDATION_EXPORT NSString *const GYPOSEarnestSettle;//预付定金结算
FOUNDATION_EXPORT NSString *const GYPOSQueryCusTip;//查询消费者可兑换互生币余额
FOUNDATION_EXPORT NSString *const GYPOSScanPosQuery;//查询二维码支付结果
FOUNDATION_EXPORT NSString* const GYPointWaterQuery ; //积分流水查询
FOUNDATION_EXPORT NSString* const GYPOSCustGloabalCoupon; //查询平台的抵扣券配置项
FOUNDATION_EXPORT NSString* const GYPOSCheckCustCouponData; //校验抵扣券数量是否足够
FOUNDATION_EXPORT NSString* const GYPOSV3Point; //3.1版本消费积分接口
FOUNDATION_EXPORT NSString* const GYPOSCheckResNoStatus; //3.1版本查询消费者是否实名注册
FOUNDATION_EXPORT NSString* const GYPOSFindCardReaderByDeviceNo; //检查刷卡器是否合法
FOUNDATION_EXPORT NSString *const GYPOSPointRecord ;// 积分流水查询
FOUNDATION_EXPORT NSString *const GYPOSECCorrect;// 电商刷卡器冲正
FOUNDATION_EXPORT NSString *const GYPOSOrderList;// 电商手机刷卡器查询订单
FOUNDATION_EXPORT NSString *const GYPOSUpdatePointRate;// 修改设备积分比例
FOUNDATION_EXPORT NSString *const GYPOSECOrderPay;//电商支付
FOUNDATION_EXPORT NSString *const GYPOSProxyBuyHsb ;// 代兑互生币
FOUNDATION_EXPORT NSString *const GYPOSBsCorrect;////代兑互生币冲正
#pragma mark - 服务公司申报管理
FOUNDATION_EXPORT NSString *const GYHSGetDeclareList;//分页查询企业申报记录
FOUNDATION_EXPORT NSString *const GYHSDelUnSubmitDeclare;//删除未提交的申报信息
FOUNDATION_EXPORT NSString *const GYHSGetFilingList; // 分页查询企业报备
FOUNDATION_EXPORT NSString *const GYHSGetFilingDetail; // 分页查询企业报备详情
FOUNDATION_EXPORT NSString *const GYHSGetIntentCustList;/// 分页查询企业意向客户
FOUNDATION_EXPORT NSString *const GYHSGetIntentCustDetail;// 查询企业意向客户详情
FOUNDATION_EXPORT NSString *const GYHSGetAuthCodeList;// 服务公司授权码查询
FOUNDATION_EXPORT NSString *const GYHSGetNotServiceEntQuota; // 查询成员企业或托管企业可用配额数和默认企业互生号
FOUNDATION_EXPORT NSString *const GYHSQueryDeclareRegInfo;//查询企业系统注册信息及设置的增值点
FOUNDATION_EXPORT NSString *const GYHSGetEntResNo ;// 分页查询企业可用互生号
FOUNDATION_EXPORT NSString *const GYHSCheckValidEntResNo;//检查企业互生号被占用
FOUNDATION_EXPORT NSString *const GYHSGetServiceEntQuota;// 查询管理公司信息和服务公司可用配额数
FOUNDATION_EXPORT NSString *const GYHSGetIncrementInfo;// 查询积分增值点信息
FOUNDATION_EXPORT NSString *const GYHSCreateEntDeclare;// 创建企业系统注册信息及积分增值点设置
FOUNDATION_EXPORT NSString *const GYHSCreateEntBussinessInfo;//创建企业工商登记信息
FOUNDATION_EXPORT NSString *const GYHSQueryDeclareBizRegInfo;//查询企业工商登记信息
FOUNDATION_EXPORT NSString *const GYHSCreateEntLinkmanInfo ;// 创建企业联系人信息和提交申报
FOUNDATION_EXPORT NSString *const GYHSSubmitDeclare;//提交申报
FOUNDATION_EXPORT NSString *const GYHSQueryLinkman;//查询企业申报联系人信息
FOUNDATION_EXPORT NSString *const GYHEServerceGetComplainSalesDetail;//服务公司申诉详情
#pragma mark - 吴冰冰增加快捷支付调试
FOUNDATION_EXPORT NSString *const GYHSGetPinganQuickBindBankUrl;//快捷开通卡
FOUNDATION_EXPORT NSString *const GYHSGETListQkBanksUrl;//快捷已开通银行列表
FOUNDATION_EXPORT NSString* const GYHSPayPurchaseToolOrder;
#pragma mark - 操作员管理
FOUNDATION_EXPORT NSString *const GYHSOperatorList; //企业操作员列表
FOUNDATION_EXPORT NSString *const GYHSSalerShopList;
FOUNDATION_EXPORT NSString* const GYHSRoleList;
FOUNDATION_EXPORT NSString* const GYHSAddNewOperator;
/********/





#endif /* GYNetApiMacro_h */

