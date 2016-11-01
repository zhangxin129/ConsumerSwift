//
//  DUKPT_2009_CBC.m
//  DUKPT_2009_CBC_OC
//
//  Created by zengqingfu on 15/3/12.
//  Copyright (c) 2015年 zengqingfu. All rights reserved.
//

#import "DUKPT_2009_CBC.h"
#import "libdes.h"

static const char* HEXES = "0123456789ABCDEF";
@implementation DUKPT_2009_CBC

/*--------------------------------------
 |   Function Name:
 |       nrkgp
 |   Description:
 |   Parameters:
 |   Returns:
 +-------------------------------------*/
void nrkgp(unsigned char* key, unsigned char* ksn)
{
    unsigned char temp[8], key_l[8], key_r[8], key_temp[8];
    int i;
    
    memcpy(key_temp, key, 8);
    for (i = 0; i < 8; i++)
        temp[i] = (ksn[i] ^ key[8 + i]);
    //    des_enc_ksn(temp, key_temp, key_r);
    Des_Encrypt(temp, key_r, key_temp);
    
    for (i = 0; i < 8; i++)
        key_r[i] ^= key[8 + i];
        
    key_temp[0] ^= 0xC0;
    key_temp[1] ^= 0xC0;
    key_temp[2] ^= 0xC0;
    key_temp[3] ^= 0xC0;
    key[8] ^= 0xC0;
    key[9] ^= 0xC0;
    key[10] ^= 0xC0;
    key[11] ^= 0xC0;
    
    for (i = 0; i < 8; i++)
        temp[i] = (ksn[i] ^ key[8 + i]);
    //    des_enc_ksn(temp, key_temp, key_l);
    Des_Encrypt(temp, key_l, key_temp);
    for (i = 0; i < 8; i++)
        key[i] = (key_l[i] ^ key[8 + i]);
        
    key[8] = key_r[0];
    key[9] = key_r[1];
    key[10] = key_r[2];
    key[11] = key_r[3];
    key[12] = key_r[4];
    key[13] = key_r[5];
    key[14] = key_r[6];
    key[15] = key_r[7];
}

///*
+ (NSData*)GenerateIPEK:(NSData*)ksn bdk:(NSData*)bdk
{

    Byte result[16];
    Byte temp[8];
    Byte temp2[16];
    Byte keyTemp[16];
    
    memcpy(&keyTemp, (Byte*)[bdk bytes], 16);
    memcpy(&temp, (Byte*)[ksn bytes], 8);
    
    temp[7] &= 0xE0;
    TDes_Encrypt_all(keyTemp, temp, 8, temp2);
    memcpy(result, temp2, 8);
    
    keyTemp[0] ^= 0xC0;
    keyTemp[1] ^= 0xC0;
    keyTemp[2] ^= 0xC0;
    keyTemp[3] ^= 0xC0;
    keyTemp[8] ^= 0xC0;
    keyTemp[9] ^= 0xC0;
    keyTemp[10] ^= 0xC0;
    keyTemp[11] ^= 0xC0;
    
    TDes_Encrypt_all(keyTemp, temp, 8, temp2);
    memcpy(&result[8], temp2, 8);
    
    NSData* resultDat = [NSData dataWithBytes:result length:16];
    return resultDat;
}

+ (NSData*)GetDUKPTKey:(NSData*)ksn ipek:(NSData*)ipek
{
    unsigned char key[16];
    unsigned char cnt[3];
    unsigned char temp[8];
    unsigned char shift;
    Byte* ksn2;
    
    memcpy(key, (Byte*)[ipek bytes], 16);
    memset(temp, 0, 8);
    
    ksn2 = (Byte*)[ksn bytes];
    
    cnt[0] = ksn2[7] & 0x1F;
    cnt[1] = ksn2[8];
    cnt[2] = ksn2[9];
    
    temp[0] = ksn2[2];
    temp[1] = ksn2[3];
    temp[2] = ksn2[4];
    temp[3] = ksn2[5];
    temp[4] = ksn2[6];
    temp[5] = ksn2[7];
    temp[5] &= 0xE0;
    
    shift = 0x10;
    while (shift > 0) {
        if ((cnt[0] & shift) > 0) {
            temp[5] |= shift;
            nrkgp(key, temp);
        }
        shift >>= 1;
    }
    shift = 0x80;
    while (shift > 0) {
        if ((cnt[1] & shift) > 0) {
            temp[6] |= shift;
            nrkgp(key, temp);
        }
        shift >>= 1;
    }
    shift = 0x80;
    while (shift > 0) {
        if ((cnt[2] & shift) > 0) {
            temp[7] |= shift;
            nrkgp(key, temp);
        }
        shift >>= 1;
    }
    
    NSData* resultDat = [NSData dataWithBytes:key length:16];
    return resultDat;
}

+ (NSData*)GetDataKeyVariant:(NSData*)ksn ipek:(NSData*)ipek
{
    Byte* key;
    NSData* key2 = [DUKPT_2009_CBC GetDUKPTKey:ksn ipek:ipek];
    key = (Byte*)[key2 bytes];
    
    key[5] ^= 0xFF;
    key[13] ^= 0xFF;
    NSData* keyDat = [NSData dataWithBytes:key length:16];
    return keyDat;
}
+ (NSData*)GetPinKeyVariant:(NSData*)ksn ipek:(NSData*)ipek
{
    Byte* key;
    NSData* key2 = [DUKPT_2009_CBC GetDUKPTKey:ksn ipek:ipek];
    key = (Byte*)[key2 bytes];
    
    key[7] ^= 0xFF;
    key[15] ^= 0xFF;
    NSData* keyDat = [NSData dataWithBytes:key length:16];
    return keyDat;
}

+ (NSData*)GetMacKeyVariant:(NSData*)ksn ipek:(NSData*)ipek
{
    Byte* key;
    NSData* key2 = [DUKPT_2009_CBC GetDUKPTKey:ksn ipek:ipek];
    key = (Byte*)[key2 bytes];
    
    key[6] ^= 0xFF;
    key[14] ^= 0xFF;
    NSData* keyDat = [NSData dataWithBytes:key length:16];
    return keyDat;
}
+ (NSData*)GetDataKey:(NSData*)ksn ipek:(NSData*)ipek
{
    Byte outbuf[16];
    NSData* temp1 = [DUKPT_2009_CBC GetDataKeyVariant:ksn ipek:ipek];
    NSData* temp2 = [NSData dataWithData:temp1];
    
    Byte* temp1C = (Byte*)[temp1 bytes];
    Byte* temp2C = (Byte*)[temp2 bytes];
    
    TDes_Encrypt_all(temp1C, temp2C, 16, outbuf);
    
    NSData* keyDat = [NSData dataWithBytes:outbuf length:16];
    
    return keyDat;
}

// 十六进制字符串转字节数组
- (NSData*)parseHexStr2Byte:(NSString*)hexString
{
    if (hexString == nil) {
        return ([NSData new]);
    }
    const char* bytes = [hexString UTF8String];
    NSUInteger length = strlen(bytes);
    unsigned char* r = (unsigned char*)malloc(length / 2 + 1);
    unsigned char* index = r;
    
    while ((*bytes) && (*(bytes + 1))) {
        char a = (*bytes);
        char b = (*(bytes + 1));
        //*index = strToChar(a, b);
        
        char encoder[3] = { '\0', '\0', '\0' };
        encoder[0] = a;
        encoder[1] = b;
        *index = ((char)strtol(encoder, NULL, 16));
        
        index++;
        bytes += 2;
    }
    *index = '\0';
    
    NSData* result = [NSData dataWithBytes:r length:length / 2];
    free(r);
    
    return (result);
}
//字节数组转十六进制字符串
- (NSString*)parseByte2HexStr:(NSData*)data
{

    if (data == nil) {
        return ([NSString new]);
    }
    NSUInteger numBytes = [data length];
    const unsigned char* bytes = [data bytes];
    char* strbuf = (char*)malloc(numBytes * 2 + 1);
    char* hex = strbuf;
    NSString* hexBytes = nil;
    
    for (int i = 0; i < numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = HEXES[(c >> 4) & 0xF];
        *hex++ = HEXES[(c)&0xF];
    }
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    free(strbuf);
    return (hexBytes);
}

//数据补位
- (NSString*)dataFill:(NSString*)dataStr
{
    NSInteger len = dataStr.length;
    if (len % 16 != 0) {
        dataStr = [dataStr stringByAppendingString:@"80"];
        len = dataStr.length;
    }
    while (len % 16 != 0) {
        dataStr = [dataStr stringByAppendingString:@"0"];
        len++;
        NSLog(@"%@", dataStr);
    }
    return dataStr;
}


@end
