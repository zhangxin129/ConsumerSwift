#ifndef _ONE_TIME_PAY_CODE_H 
#define _ONE_TIME_PAY_CODE_H 
//#include <string>
//using namespace std;


/*************************
*函数说明：
*参数：	szChannelId --- 渠道号
			  szUserId --- 用户ID（11位）
			  szKey --- 用户的秘钥(由服务器生成)
			  nTime --- 当前时间 (联网为网络时间为准，断网为本地时间)
			  pCodeBuf --- 生成支付码首地址（外部传入，空间大小必须大于23）
			  nMaxLen --- pCodeBuf的大小，必须大于23，不然生成失败
*返回值：
				返回是否成功（成功位0，失败为小于0）
**************************/
int  GeneratePayCode(const char* szChannelId,const char* szUserId,const char* szKey,unsigned long nTime,char* pCodeBuf,int nMaxLen);

#endif