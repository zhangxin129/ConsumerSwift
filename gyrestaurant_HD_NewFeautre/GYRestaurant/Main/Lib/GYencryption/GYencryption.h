
#import <Foundation/Foundation.h>

@interface GYencryption : NSObject

/**
 *	16位长MD5字符串加密
 *
 *	@param 	string 	要加密的字符串
 *
 *	@return	加密后的字符串(全小写)
 */
+ (NSString *)md5HexDigest:(NSString*)string;

/**
 *	使用3DES加密字符串
 *
 *	@param 	string 	待加密字符串
 *	@param 	key 	用于加密的key
 *
 *	@return	加密后的字符串
 */
+ (NSString *)DES3_EncWithString:(NSString *)string withKey:(NSString *)key;

/**
 *	解密使用3DES加密的字符串
 *
 *	@param 	string 	待解密的字符串
 *	@param 	key 	用于解密的Key
 *
 *	@return	解密后的字符串
 */
+ (NSString *)DES3_DecWithString:(NSString *)string withKey:(NSString *)key;

/**
 *	取得百度地图的key
 *
 *	@param 	mode 	0：测试key ，1：生产环境key
 *
 *	@return
 */
+ (NSString *)baiduMapKeyWithMode:(int)mode;

/**
 *	用于登录时获获取设备号
 *
 *	@param 	service 	对应的key
 *
 *	@return	返回mid
 */
+ (NSString *)getMid:(NSString *)service;

/**
 *	设置密钥链
 *
 *	@param 	service 	对应key
 *	@param 	data 	对应value
 */
+ (void)setKeychain:(NSString *)service data:(id)data;

/**
 *	获取对应key的密钥链
 *
 *	@param 	service 	对应Key
 *
 *	@return	返回value
 */
+ (id)getKeychain:(NSString *)service;

+ (NSString *)h1:(NSString *)str k:(NSString *)key;//加壳
+ (NSString *)h2:(NSString *)str k:(NSString *)key;//3des加密-加壳
+ (NSString *)dh1:(NSString *)str k:(NSString *)key;//去壳
+ (NSString *)dh2:(NSString *)str k:(NSString *)key;//去壳-3des解密
+ (NSString *)l:(NSString *)content k:(NSString *)key;//密码加密：要加密的原密码，用户名

@end
