//
//  GYUtils+HSConsumer.h
//  HSConsumer
//
//  Created by sqm on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYUtils.h"
#import <CoreLocation/CLLocation.h>

/**
 *  消费者工具类
 */
@interface GYUtils (HSConsumer)

//用于中文按拼音排序 ---逛商铺 品牌专区分类效果
@property (strong, nonatomic) NSString* string;
@property (strong, nonatomic) NSString* pinYin;

// 返回tableview右方indexArray
+ (NSMutableArray*)IndexArray:(NSArray*)stringArr;

//-----  返回联系人
+ (NSMutableArray*)LetterSortArray:(NSArray*)stringArr;

///----------------------
//返回一组字母排序数组(中英混排)
+ (NSMutableArray*)SortArray:(NSArray*)stringArr;

+ (BOOL)isNumber:(char)ch;

// 检测是否是数字
+ (BOOL)isValidNumber:(NSString*)value;

/**
 *检查银行卡是否合法
 *@param value 传入的字符串
 */
+ (BOOL)isValidCreditNumber:(NSString*)value;

/**
 *	国际化接口，内容国际化统一接口。【鉴于后续可能做对app内部国际化，故留此接口】
 *
 *	@param  key     内容在表中对应的键值
 *
 *	@return	国际化内容
 */
+ (NSString*)localizedStringWithKey:(NSString*)key;

/**
 *	 判断是否含有中文
 *
 *	@param   号码
 *	@return 是和否
 */
+ (BOOL)isIncludeChineseInString:(NSString*)value;

/**
 *	 判断是否含有特殊符号
 *
 *	@param   号码
 *	@return 是和否
 */
+ (BOOL)isValidByTrimming:(NSString*)str;

// 格式化的数据反解析为数字格式
+ (NSString*)deformatterCurrencyStyle:(NSString*)value flag:(NSString*)flag;

/**
 *	给view设置边框，圆角
 *
 *	@param  view    要设置的view
 *	@param  width   边框的宽度
 *	@param  radius  圆角半径
 *	@param  color   边框颜色
 */
+ (void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor*)color;

/**
 *	设置UITextField Placeholder 的字体大小，颜色。
 *
 *	@param  textField       要设置的UITextField
 *	@param  fontSize        字体大小
 *	@param  color   字体颜色（如使用默认的颜色，使用nil值）
 */
+ (void)setPlaceholderAttributed:(UITextField*)textField withSystemFontSize:(CGFloat)fontSize withColor:(UIColor*)color;

/**
 *	通过类名实例化viewcontroller,只适合带有同名的xib文件或没有xib文件的实例化。
 *
 *	@param  className       类名（string）
 *
 *	@return	创建好的viewcontroller
 */
+ (id)loadVcFromClassStringName:(NSString*)className;

/**
 *功能：判断字符串是否为null
 *@param
 * NSString     string    要判断的字符串
 *返回：字符串
 */
+ (NSString*)formatNullString:(NSString*)string;

/**
 *功能：判断字符串是否为null
 *@param
 * NSString     string    要判断的字符串
 *返回：字符串
 */
+ (BOOL)isBlankString:(NSString*)string;

+ (BOOL)checkObjectInvalid:(id)param;

+ (BOOL)checkArrayInvalid:(id)param;

+ (BOOL)checkDictionaryInvalid:(id)param;

// 字符串为空判断，非法返回真
+ (BOOL)checkStringInvalid:(NSString*)param;

/**
 *功能：获取字体高度，用于动态计算label高度。
 *   @param  value 要计算高度的字符串
 *   @param  fontSize 设置字符串字体
 *   @param  width    设置label的宽度
 *   返回：高度值
 */
+ (float)heightForString:(NSString*)value fontSize:(float)fontSize andWidth:(float)width;

/**
 *  判断是否是合法的电话号码格式 
 *  +86-0755-83243415 0755-83243415 83243415 8324341
 *
 *  @param phoneNum 电话号码
 *  @return 格式正确为YES
 */
+ (BOOL)isValidFixedLineTelephone:(NSString*)phoneNum;

/**
 *	验证输入的是否是正确格式的手机号
 *
 *	@param  手机号字符串
 *
 *
 *   返回：布尔型
 */

+ (BOOL)isMobileNumber:(NSString*)mobileNum;

/**
 * 判断是否是合法的电话号码格式 +86-0755-83243415 0755-83243415 83243415 8324341
 *  @param phoneNum 电话号码
 *
 *  @return 格式正确为YES
 */
+ (BOOL)isValidTelPhoneNum:(NSString*)phoneNum;

/**
 *	验证邮箱地址的支持格式xxx.xxx@xxx.xxx.xxx
 *
 *	@param  邮箱字符串号字符串
 *
 *
 *   返回：布尔型
 */
+ (BOOL)emailCheck:(NSString*)str;

/**
 *	 隐藏提示器    隐藏后 会从父试图中移除
 
 *  @param      superview    superView通常为self.view self.view.window
 
 *   返回：  MBProgressHUD *
 */
+ (void)hideHudViewWithSuperView:(UIView*)superView;

/**
 *	将string转换成字典
 *
 *	@param  string  入参：字符串
 *
 *	@return	字典
 */
+ (NSDictionary*)stringToDictionary:(NSString*)string;

/**
 *	将字典转换成string
 *
 *	@param  dic   入参：字典
 *
 *	@return	字符串
 */
+ (NSString*)dictionaryToString:(NSDictionary*)dic;

/**
 *	设置view自动缩小字体以适应宽高
 *
 *	@param  view    要设置的view
 *	@param  lines   行数
 */
+ (void)setFontSizeToFitWidthWithLabel:(id)view labelLines:(NSInteger)lines;

/**
 *	id类型安全转换成float
 *
 *	@param  idVaule         要转换的id值
 *
 *	@return	转换后的CGFloat
 */
+ (double)saftToDouble:(id)idVaule;

/**
 *	id类型安全转换成 double
 *
 *	@param  idVaule         要转换的id值
 *
 *	@return	转换后的CGFloat
 */
+ (CGFloat)saftToCGFloat:(id)idVaule;

/**
 *	 *
 *	@param Email 需要判断的邮箱字符串
 *
 *	@return	bool
 */
+ (BOOL)isValidateEmail:(NSString*)Email;

/**
 *	 *判断是否是邮编
 *	@param value 需要判断的邮编字符串
 *
 *	@return	bool
 */
+ (BOOL)isValidZipcode:(NSString*)value;

/**
 *	 *判断是否是护照号码
 *	@param value 需要判断的邮编字符串
 *
 *	@return	bool
 */
+ (BOOL)isValidPassport:(NSString*)value;

/**
 *	隐藏键盘
 */
+ (void)hideKeyboard;

/**
 *	创建本地通知
 *
 *	@param  timeInterval    延迟响应时间
 *	@param  zone    时区
 *	@param  userDic         传递的info信息，字典对象
 *	@param  body    显示推送的内容
 */
+ (void)creatLocalNotification:(NSTimeInterval)timeInterval timeZone:(NSTimeZone*)zone userInfor:(NSDictionary*)userDic alertBody:(NSString*)body;

/**
 *  判断是不是护照
 *
 *  @param pNo  护照号码
 *
 *  @return YES
 */

+ (BOOL)isPassportNo:(NSString*)pNo;

// 身份证号码的检查
+ (BOOL)verifyIDCardNumber:(NSString*)value country:(NSString*)country;

/**
 * 通过指定宽度裁剪图片
 * @param 要裁剪的图片
 * @param 定义的宽度
 *
 */
+ (UIImage*)imageCompressForWidth:(UIImage*)sourceImage targetWidth:(CGFloat)defineWidth;
/**
 * 通过指定string和字体和最大宽度得到size
 * @str string
 * @font 字体
 * @width 宽度
 *
 */
+ (CGSize)sizeForString:(NSString*)str font:(UIFont*)font width:(CGFloat)width;

/**
 *  返货去掉jid中的_符号
 
 */
+ (NSString*)getResNO:(NSString*)resNo;

+ (BOOL)isBankCardNo:(NSString*)pNo;
/** add by songjk 根据id获取服务名称
 *
 *
 *  @param serviceCode 服务码
 *
 *  @return 服务名称
 */
+ (NSString*)getServiceNameWithServiceCode:(NSString*)serviceCode;

/** add by songjk 把英文逗号改成中文逗号
 *
 *  @return
 */
+ (NSString*)exchangeENCommaToChCommaWithString:(NSString*)string;

/**
 * 判断是否是正确中文名字
 *  @return
 */
+ (BOOL)isCHNameWithName:(NSString*)name;

// 检查名称格式，只运行中文、英文 .
+ (BOOL)isUserName:(NSString*)name;

/** add by songjk 判断是否收货联系人正确
 *
 *  @return
 */

+ (BOOL)isValidTureWithName:(NSString*)validTureWithName;

#pragma mark - 新的封装
+ (CGFloat)fontSizeScreen:(CGFloat)originSize;

/**
 *	根据毫秒获取时间
 *
 *	@param  millisend 毫秒数
 *  @param      dateFormat 时间格式
 *	@return	时间字符串
 */
+ (NSString*)getStringDateFromMillisecond:(NSString*)millisend dateFormat:(NSString*)dateFormat;

/**
 * 字符串转时间
 *
 *  @param string
 *
 *  @return
 */
+ (NSDate*)stringToDate:(NSString*)string;

// 指定格式格式化时间
+ (NSDate*)dateFromeString:(NSString*)strDate formate:(NSString*)formatter;

// 带时区格式化时间
+ (NSDate *)dateFromeString:(NSString *)strDate formate:(NSString *)formatter forceCnZone:(BOOL)cnZone;

+ (void)collectUserInfoAppMapLocationsWithLocation:(CLLocationCoordinate2D)location;

+ (void)collectUserInfoAppPlayTimesWithStatus:(NSString *)status;

+ (void)collectUserInfoAppRequestURLsWith:(NSString *)url parmas:(NSDictionary *)params;

// 用户名加密
+ (NSString *) encryptUserName:(NSString *)userName;

// 身份证好加密
+ (NSString *) encryptIdentityCard:(NSString *) cardId;

// 营业执照加密
+ (NSString *) encryptBusinessLicense:(NSString *) cardId;

// 护照掩码
+ (NSString *) encryptPassport:(NSString *) cardId;

// 邮箱掩码
+ (NSString *) encryptEmail:(NSString *) email;

#pragma mark - 消费者使用
+ (NSString*)deviceUdid;

// 按指定分隔符进行字符串分割
+ (NSString*)separatedStringByFlag:(NSString*)value flag:(NSString *)flag;

+ (void)showMessage:(NSString*)message;

+ (void)showMessage:(NSString*)message confirm:(void (^)())confirmBlock;

+ (void)showMessge:(NSString*)message confirm:(void (^)())confirmBlock cancleBlock:(void (^)())cancleBlock;
//带颜色
+ (void)showMessage:(NSString*)message confirm:(void (^)())confirmBlock withColor:(UIColor*)color;

+ (void)showMessge:(NSString*)message confirm:(void (^)())confirmBlock cancleBlock:(void (^)())cancleBlock withColor:(UIColor*)color;

// 网络请求通用参数, 如：[request commonParams:[GYUtils netWorkCommonParams]];
+ (NSDictionary*)netWorkCommonParams;
//互商的
+ (NSDictionary*)netWorkHECommonParams;

// 网络请求失败信息解析
+ (void)parseNetWork:(NSError*)error resultBlock:(void (^)(NSInteger retCode))resultBlock;

+ (CGFloat)scaleY;

//
+ (NSMutableDictionary*)valueArray:(NSArray*)valueArray keyArray:(NSArray*)keyArray;
@end
