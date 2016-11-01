//
//  ISOUtil.cpp
//  DESTESTss
//
//  Created by zengqingfu on 14/12/9.
//  Copyright (c) 2014年 zengqingfu. All rights reserved.
//

#include "ISOUtil.h"
#include <string.h>
#include "libdes.h"

void CalcMac(unsigned char *msg,unsigned char *key,unsigned char *mac, int len, int keylen){
    unsigned char iv[] = {0,0,0,0,0,0,0,0};
    unsigned char m[8];
    unsigned int l =0;
    unsigned char temp[8];
    int i = 0;
    int j = 0;
    l = len % 8;
    if (l != 0){
        memset(msg + len, 0, 8 - l);
        l = len + 8 - l;
    }else{
        l = len;
    }
    
    memcpy(temp, msg, 8);
    //l -= 8;
    while (i < l){
        if (i+8 == l)
        {
            //Spdes(temp, m, key, 1, size);
            Des_CBCEncrypt(temp, iv, m, key);
            
            printf("数据:\n");
            for (int i = 0; i < 8; i++) {
                printf("%d ", m[i]);
            }
            printf("\n");
            if (keylen > 16 ) {
                
                unsigned char temp_m[8];
                unsigned char key2[8];
                memset(key2, 0, 8);
                memset(temp_m, 0, 8);
                memcpy(key2, &key[8], 8);
                
                printf("key数据:\n");
                for (int i = 0; i < 16; i++) {
                     printf("%d ", key[i]);
                }
                printf("\n");
                
                printf("key2数据:\n");
                for (int i = 0; i < 8; i++) {
                    printf("%d ", key2[i]);
                }
                printf("\n");
                if (keylen % 8 == 0) {
                    Des_CBCDecrypt(m, iv, temp_m, key2);
                }
                
                printf("解密数据数据:\n");
                for (int i = 0; i < 8; i++) {
                    printf("%d ", temp_m[i]);
                }
                printf("\n");
                
                Des_CBCEncrypt(temp_m, iv, m, key);
                
                memcpy(mac, m, 8);
                return;
            }
        }
        else {
            //des(temp, m, key, 8, 8, 0);
            //Spdes(temp, m, key, 1, 8);
            Des_CBCEncrypt(temp, iv, m, key);
        }
        //l -= 8;
        i += 8;
        //memcpy(temp, msg + i, 8);
        for (j = 0; j < 8; j++){
            temp[j] = (char)((char) m[j] ^ (char) msg[i + j]);
        }
    }
    memcpy(mac, m, 8);
}

