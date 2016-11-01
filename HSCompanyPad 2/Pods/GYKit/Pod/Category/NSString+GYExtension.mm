//
//  NSString+Size.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/22.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "NSString+GYExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#define ENCRYPT 0
#define DESCRYPT 1

#pragma mark - 互生业务数据加密解密 c 算法

#ifdef __cplusplus
extern "C" {
#endif
//3DES
unsigned char* DES3_enc(unsigned char const* key, unsigned char const* input, int len);
unsigned char* DES3_dec(unsigned char const* key, unsigned char const* input, int* len);

void Shift(unsigned char* data);

//外加密方法
void Initial();
char* Code(const char* data);
char* Decode(const char* data);

#ifdef __cplusplus
}
#endif

char Base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                "abcdefghijklmnopqrstuvwxyz"
                "0123456789+/";

#define GETBASE64(x) (x >= 'A' && x <= 'Z') ? x - 'A' : ((x >= 'a' && x <= 'z') ? x - 'a' + 26 : ((x >= '0' && x <= '9') ? x - '0' + 52 : ((x == '+') ? 62 : (x == '/' ? 63 : 0))))

//static unsigned char KEY[] = "289bb611d549485d";

/*
 * The 8 selection functions.
 * For some reason, they give a 0-origin
 * index, unlike everything else.
 */
static unsigned char const XM_S[8][64] = {
    { 14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7,
     0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8,
     4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0,
     15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13 },

    { 15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10,
     3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5,
     0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15,
     13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9 },

    { 10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8,
     13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1,
     13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7,
     1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12 },

    { 7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15,
     13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9,
     10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4,
     3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14 },

    { 2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9,
     14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6,
     4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14,
     11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3 },

    { 12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11,
     10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8,
     9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6,
     4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13 },

    { 4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1,
     13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6,
     1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2,
     6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12 },

    { 13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7,
     1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2,
     7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8,
     2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11 }
};

/*
 * P is a permutation on the selected combination
 * of the current L and key.
 */
static unsigned char const XM_P[] = {
    16, 7, 20, 21,
    29, 12, 28, 17,
    1, 15, 23, 26,
    5, 18, 31, 10,
    2, 8, 24, 14,
    32, 27, 3, 9,
    19, 13, 30, 6,
    22, 11, 4, 25,
};

static unsigned char const XM_IP[] = {
    58, 50, 42, 34, 26, 18, 10, 2,
    60, 52, 44, 36, 28, 20, 12, 4,
    62, 54, 46, 38, 30, 22, 14, 6,
    64, 56, 48, 40, 32, 24, 16, 8,
    57, 49, 41, 33, 25, 17, 9, 1,
    59, 51, 43, 35, 27, 19, 11, 3,
    61, 53, 45, 37, 29, 21, 13, 5,
    63, 55, 47, 39, 31, 23, 15, 7,
};

/*
 * Final permutation, FP = IP^(-1)
 */
static unsigned char const XM_FP[] = {
    40, 8, 48, 16, 56, 24, 64, 32,
    39, 7, 47, 15, 55, 23, 63, 31,
    38, 6, 46, 14, 54, 22, 62, 30,
    37, 5, 45, 13, 53, 21, 61, 29,
    36, 4, 44, 12, 52, 20, 60, 28,
    35, 3, 43, 11, 51, 19, 59, 27,
    34, 2, 42, 10, 50, 18, 58, 26,
    33, 1, 41, 9, 49, 17, 57, 25,
};

/*
 * Permuted-choice 1 from the key bits
 * to yield C and D.
 * Note that bits 8,16... are left out:
 * They are intended for a parity check.
 */
static unsigned char const XM_PC1_C[] = {
    57, 49, 41, 33, 25, 17, 9,
    1, 58, 50, 42, 34, 26, 18,
    10, 2, 59, 51, 43, 35, 27,
    19, 11, 3, 60, 52, 44, 36,
};

static unsigned char XM_PC1_D[] = {
    63, 55, 47, 39, 31, 23, 15,
    7, 62, 54, 46, 38, 30, 22,
    14, 6, 61, 53, 45, 37, 29,
    21, 13, 5, 28, 20, 12, 4,
};

/*
 * Sequence of shifts used for the key schedule.
 */
static unsigned char const XM_shifts[] = {
    1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1,
};

/*
 * Permuted-choice 2, to pick out the bits from
 * the CD array that generate the key schedule.
 */
static unsigned char const XM_PC2_C[] = {
    14, 17, 11, 24, 1, 5,
    3, 28, 15, 6, 21, 10,
    23, 19, 12, 4, 26, 8,
    16, 7, 27, 20, 13, 2,
};

static unsigned char const XM_PC2_D[] = {
    41, 52, 31, 37, 47, 55,
    30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53,
    46, 42, 50, 36, 29, 32,
};

static unsigned char const XM_e[] = {
    32, 1, 2, 3, 4, 5,
    4, 5, 6, 7, 8, 9,
    8, 9, 10, 11, 12, 13,
    12, 13, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21,
    20, 21, 22, 23, 24, 25,
    24, 25, 26, 27, 28, 29,
    28, 29, 30, 31, 32, 1,
};

static unsigned char const toASCI[] = {
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
};

int memxor(unsigned char* result, unsigned char const* field1, unsigned char const* field2, int length)
{

    int i;
    for (i = 0; i < length; i++)
        result[i] = (field1[i] ^ field2[i]);
    return (0);
}

void Do_XOR(unsigned char* dest, unsigned char const* source, int size)
{

    int i;
    for (i = 0; i < size; i++)
        dest[i] ^= source[i];
}

void bcd_to_asc(unsigned char const* src, unsigned char* dst, int srclen)
{
#define ds_to_char(x) ((x) > 9 ? (x) + 'A' - 10 : (x) + '0')
    int i;
    unsigned char d;
    for (i = 0; i < srclen; i++) {
        d = src[i] >> 4;
        *dst++ = ds_to_char(d);
        d = src[i] & 0x0F;
        *dst++ = ds_to_char(d);
    }
}

unsigned char __ord(char c)
{
    if (c >= 'A' && c <= 'F')
        return c - 'A' + 10;
    else if (c >= 'a' && c <= 'f')
        return c - 'a' + 10;
    else if (c >= '0' && c <= '9')
        return c - '0';
    return 0;
}
int asc_to_bcd(unsigned char const* src, unsigned char* dst, int dstlen)
{

    int i;
    unsigned char d;
    for (i = 0; i < dstlen; i++) {
        d = __ord(src[i * 2]);
        d <<= 4;
        d += __ord(src[i * 2 + 1]);
        *dst++ = d;
    }
    return 0;
}

/*
 ** 	compress is the inverse of expand
 **	it converts a 64 character bit stream into eight characters.
 */
void XM_compress(unsigned char const* in, unsigned char* out)
{
    int temp;
    int i, j;

    for (i = 0; i < 8; i++) {
        out[i] = 0;
        temp = 1;
        for (j = 7; j >= 0; j--) {
            out[i] = out[i] + (in[i * 8 + j] * temp);
            temp *= 2;
        }
    }
}

/*
 * Set up the key schedule from the key.
 */
void XM_setkey(unsigned char const* key, unsigned char* XM_KS)
{

    register int i, j, k;
    int t;
    //The C and D arrays used to calculate the key schedule.
    unsigned char XM_C[28];
    unsigned char XM_D[28];
    /*
     * First, generate C and D by permuting
     * the key.  The low order bit of each
     * 8-bit unsigned char is not used, so C and D are only 28
     * bits apiece.
     */
    for (i = 0; i < 28; i++) {
        XM_C[i] = key[XM_PC1_C[i] - 1];
        XM_D[i] = key[XM_PC1_D[i] - 1];
    }

    /*
     * To generate Ki, rotate C and D according
     * to schedule and pick up a permutation
     * using PC2.
     */
    for (i = 0; i < 16; i++) {
        /*
         * rotate.
         */
        for (k = 0; k < XM_shifts[i]; k++) {
            t = XM_C[0];
            for (j = 0; j < 28 - 1; j++)
                XM_C[j] = XM_C[j + 1];

            XM_C[27] = t;
            t = XM_D[0];

            for (j = 0; j < 28 - 1; j++)
                XM_D[j] = XM_D[j + 1];

            XM_D[27] = t;
        }
        /*
         * get Ki. Note C and D are concatenated.
         */
        for (j = 0; j < 24; j++) {
            XM_KS[i * 48 + j] = XM_C[XM_PC2_C[j] - 1];
            XM_KS[i * 48 + j + 24] = XM_D[XM_PC2_D[j] - 28 - 1];
        }
    }
}

/*
 * The payoff: encrypt a block.
 */
void XM_encrypt(unsigned char* block, int edflag, unsigned char* XM_E, unsigned char* XM_KS)
{
    int i, ii;
    int t, j, k;
    unsigned char XM_tempL[32];
    unsigned char XM_f[32];

    //The current block, divided into 2 halves.
    unsigned char XM_L[64];
    unsigned char* XM_R = &XM_L[32];

    // The combination of the key and the input, before selection.
    unsigned char XM_preS[48];

    //First, permute the bits in the input
    for (j = 0; j < 64; j++)
        XM_L[j] = block[XM_IP[j] - 1];

    for (j = 0; j < 32; j++)
        XM_R[j] = XM_L[j + 32];

    // Perform an encryption operation 16 times.
    for (ii = 0; ii < 16; ii++) {
        /*
         * Set direction
         */
        if (edflag)
            i = 15 - ii;
        else
            i = ii;
        /*
         * Save the R array,
         * which will be the new L.
         */
        for (j = 0; j < 32; j++)
            XM_tempL[j] = XM_R[j];

        /*
         * Expand R to 48 bits using the E selector;
         * exclusive-or with the current key bits.
         */
        for (j = 0; j < 48; j++)
            XM_preS[j] = XM_R[XM_E[j] - 1] ^ XM_KS[i * 48 + j];

        /*
         * The pre-select bits are now considered
         * in 8 groups of 6 bits each.
         * The 8 selection functions map these
         * 6-bit quantities into 4-bit quantities
         * and the results permuted
         * to make an f(R, K).
         * The indexing into the selection functions
         * is peculiar; it could be simplified by
         * rewriting the tables.
         */
        for (j = 0; j < 8; j++) {
            t = 6 * j;
            k = XM_S[j][(XM_preS[t + 0] << 5) + (XM_preS[t + 1] << 3) + (XM_preS[t + 2] << 2) + (XM_preS[t + 3] << 1) + (XM_preS[t + 4] << 0) + (XM_preS[t + 5] << 4)];
            t = 4 * j;
            XM_f[t + 0] = (k >> 3) & 0x01;
            XM_f[t + 1] = (k >> 2) & 0x01;
            XM_f[t + 2] = (k >> 1) & 0x01;
            XM_f[t + 3] = (k >> 0) & 0x01;
        }

        /*
         * The new R is L ^ f(R, K).
         * The f here has to be permuted first, though.
         */
        for (j = 0; j < 32; j++)
            XM_R[j] = XM_L[j] ^ XM_f[XM_P[j] - 1];
        /*
         * Finally, the new L (the original R)
         * is copied back.
         */
        for (j = 0; j < 32; j++)
            XM_L[j] = XM_tempL[j];
    }
    /*
     * The output L and R are reversed.
     */
    for (j = 0; j < 32; j++) {
        t = XM_L[j];
        XM_L[j] = XM_R[j];
        XM_R[j] = t;
    }

    for (j = 32; j < 64; j++)
        XM_L[j] = XM_R[j - 32];

    /*
     * The final output
     * gets the inverse permutation of the very original.
     */
    for (j = 0; j < 64; j++)
        block[j] = XM_L[XM_FP[j] - 1];
}

/*
 **	expand takes the eight character string in
 **	and converts it to a 64 character array containing
 **	zero or one (bit stream).
 */
void XM_expand(unsigned char const* in, unsigned char* out)
{

    int i, j;

    for (i = 0; i < 8; i++) {
        for (j = 0; j < 8; j++) {
            *out = (in[i] << j) & 0x80;
            if (*out == 0x80)
                *out = 0x01;
            out++;
        }
    }
}

void des_encrypt(unsigned char const* key, unsigned char* inoutput, int len, int ed_flag)
{
    int i;
    unsigned char bits[64];
    //The key schedule.Generated from the key.
    unsigned char XM_KS[16 * 48];
    //The E bit-selection table.
    unsigned char XM_E[48];

    XM_expand(key, bits);
    XM_setkey(bits, XM_KS);

    for (i = 0; i < 48; i++)
        XM_E[i] = XM_e[i];

    /***********************************************************************
     Because DES can only encrypt 8 bytes, we divide the data into several
     pieces of 8 bytes to encrypt
     ***********************************************************************/
    while (len >= 8) {
        XM_expand(inoutput, bits); /* expand to bit stream */
        XM_encrypt(bits, ed_flag, XM_E, XM_KS); /* encrypt */
        XM_compress(bits, inoutput); /* compress to 8 characters */
        inoutput += 8;
        len -= 8;
    }

    for (i = 0; i < len; i++)
        inoutput[i] ^= key[i];
}

/**********************************************
 Use DES algoritm to encrypt or decrypt data
 if ed_flag is ENCRYPT, it encrypts data
 if ed_flag is DECRYPT, it decrypts data
 ***********************************************/
void DES_encrypt(unsigned char const* key, unsigned char const* input, int in_len, unsigned char* output, int ed_flag)
{
    memcpy(output, input, in_len);

    des_encrypt(key, output, in_len, ed_flag);
}

int DES3_encrypt(unsigned char const* key, int len, unsigned char* output)
{
    unsigned char szkey[9];

    szkey[8] = 0;

    //1.begin MAB的3DES加密
    /**********************************************
     if ed_flag is ENCRYPT<0>, it encrypts data
     if ed_flag is DECRYPT<1>, it decrypts data
     ***********************************************/

    memcpy(szkey, key, 8);
    des_encrypt(szkey, output, len, ENCRYPT);

    memcpy(szkey, key + 8, 8);
    des_encrypt(szkey, output, len, DESCRYPT);

    memcpy(szkey, key, 8);
    des_encrypt(szkey, output, len, ENCRYPT);
    //1.end MAB的3DES加密

    return 0;
}

//3DES解密
int DES3_decrypt(unsigned char const* key, int len, unsigned char* output)
{
    unsigned char szkey[8] = { 0 };

    //1.begin MAB的3DES加密
    /**********************************************
     if ed_flag is ENCRYPT<0>, it encrypts data
     if ed_flag is DECRYPT<1>, it decrypts data
     ***********************************************/
    memcpy(szkey, key, 8);
    des_encrypt(szkey, output, len, DESCRYPT);

    memcpy(szkey, key + 8, 8);
    des_encrypt(szkey, output, len, ENCRYPT);

    memcpy(szkey, key, 8);
    des_encrypt(szkey, output, len, DESCRYPT);
    //1.end MAB的3DES加密

    return 0;
}
void Shift(unsigned char* data)
{
    int len = strlen((char*)data);
    int phase = len - len / 3;
    int i = 0;
    unsigned char tmp;
    int clen = phase / 2 - 1;
    while (i <= clen) {
        tmp = data[i];
        data[i] = data[phase - 1 - i];
        data[phase - 1 - i] = tmp;
        i++;
    }
    clen = (len - phase) / 2 - 1;
    i = 0;
    while (i <= clen) {
        tmp = data[phase + i];
        data[phase + i] = data[len - 1 - i];
        data[len - 1 - i] = tmp;
        i++;
    }
}
unsigned char* InsertUrl(const unsigned char* data)
{
    int len = strlen((char*)data);
    int i;
    int pannum = 0;
    unsigned char* rc;
    int position;
    for (i = 0; i < len; i++) {
        if (data[i] == '+' || data[i] == '=' || data[i] == '/')
            pannum++;
    }
    rc = (unsigned char*)malloc(len + 2 * pannum + 1);
    if (!rc)
        return NULL;
    position = 0;
    for (i = 0; i < len; i++) {
        if (data[i] == '+') {
            rc[position] = '%';
            rc[position + 1] = '2';
            rc[position + 2] = 'B';
            position += 3;
        }
        else if (data[i] == '=') {
            rc[position] = '%';
            rc[position + 1] = '3';
            rc[position + 2] = 'D';
            position += 3;
        }
        else if (data[i] == '/') {
            rc[position] = '%';
            rc[position + 1] = '2';
            rc[position + 2] = 'F';
            position += 3;
        }
        else {
            rc[position] = data[i];
            position++;
        }
    }
    rc[len + 2 * pannum] = 0;
    free((void*)data);
    return rc;
}
unsigned char* DeleteUrl(const unsigned char* data)
{
    int len = strlen((char*)data);
    int i;
    int pannum = 0;
    unsigned char* rc;
    int position;
    for (i = 0; i < len; i++) {
        if (data[i] == '%')
            pannum++;
    }
    rc = (unsigned char*)malloc(len - pannum + 1);
    if (!rc)
        return NULL;
    position = 0;
    for (i = 0; i < len - pannum; i++) {
        if (data[position] == '%') {
            if (data[position + 1] == '2') {
                if (data[position + 2] == 'B' || data[position + 2] == 'b')
                    rc[i] = '+';
                else
                    rc[i] = '/';
            }
            else {
                rc[i] = '=';
            }
            position += 3;
        }
        else {
            rc[i] = data[position];
            position++;
        }
    }
    rc[len - pannum] = 0;
    free((void*)data);
    return rc;
}
unsigned char* EnCodeBase64(unsigned char* data, int len)
{
    int outlen = ((len + 2) / 3) * 4;
    int pad = 3 - len % 3;
    int position = 0;
    int i;
    unsigned char* rc = (unsigned char*)malloc(outlen + 1);
    if (!rc)
        return NULL;
    for (i = 0; i < len; i += 3) {
        rc[position] = Base64[(data[i] >> 2) & 0x3f];
        rc[position + 1] = Base64[((data[i] << 4) | (data[i + 1] >> 4)) & 0x3f];
        rc[position + 2] = Base64[((data[i + 1] << 2) | (data[i + 2] >> 6)) & 0x3f];
        rc[position + 3] = Base64[data[i + 2] & 0x3f];
        position += 4;
    }
    if (pad == 1) {
        rc[outlen - 1] = '=';
    }
    else if (pad == 2) {
        rc[outlen - 1] = '=';
        rc[outlen - 2] = '=';
    }
    rc[outlen] = 0;
    free(data);
    return rc;
}
unsigned char* DecodeBase64(unsigned char* data, int* out_len)
{
    int len = strlen((char*)data);
    int position = 0;
    char d1, d2, d3, d4;
    int i;
    unsigned char* rc;

    *out_len = (len >> 2) * 3;
    rc = (unsigned char*)malloc(*out_len);
    if (!rc)
        return NULL;

    for (i = 0; i < len; i += 4) {
        d1 = GETBASE64(data[i]);
        d2 = GETBASE64(data[i + 1]);
        d3 = GETBASE64(data[i + 2]);
        d4 = GETBASE64(data[i + 3]);
        rc[position++] = (d1 << 2) | (d2 >> 4);
        rc[position++] = (d2 << 4) | (d3 >> 2);
        rc[position++] = (d3 << 6) | d4;
    }
    if (data[len - 2] == '=')
        *out_len -= 2;
    else if (data[len - 1] == '=')
        *out_len -= 1;
    free(data);
    return rc;
}
unsigned char* DES3_enc(unsigned char const* key, unsigned char const* input, int len)
{
    int lenPan = (len + 8) & 0xFFFFFFF8;
    int Pans = lenPan - len;
    unsigned char* inputPan = (unsigned char*)malloc(lenPan + 2);
    unsigned char* rc;
    unsigned char* url;
    if (!inputPan)
        return NULL;
    memcpy(inputPan, input, len);
    memset(inputPan + len, Pans, Pans);

    DES3_encrypt(key, lenPan, inputPan);
    //    DES3_encrypt(KEY, lenPan, inputPan);
    inputPan[lenPan] = 0;
    inputPan[lenPan + 1] = 0;

    rc = EnCodeBase64(inputPan, lenPan);
    if (!rc)
        return NULL;

    url = InsertUrl(rc);
    if (!rc)
        return NULL;

    Shift(url);
    return url;
}
unsigned char* DES3_dec(unsigned char const* key, unsigned char const* input, int* len)
{
    unsigned char* shift;
    unsigned char* delurl;
    unsigned char* inputbase;
    *len = strlen((char*)input);
    shift = (unsigned char*)malloc(*len + 1);

    if (!shift) {
        return NULL;
    }
    memcpy(shift, input, *len + 1);
    Shift(shift);
    delurl = DeleteUrl(shift);
    if (!delurl)
        return NULL;

    inputbase = DecodeBase64(delurl, len);
    if (!inputbase)
        return NULL;

    DES3_decrypt(key, *len, inputbase);
    //    DES3_decrypt(KEY,*len,inputbase);
    *len -= inputbase[*len - 1];
    inputbase[*len] = 0;
    return inputbase;
}

//外加密C方法
const int ccKey[] = { 6, 4, 1, 2, 0, 5, 7, 3 };
const int Key1[] = { 2, 1, 3, 0, 7, 4, 5, 6 };
void Code8(char* data)
{
    char out[8];
    for (int i = 0; i < 8; i++) {
        out[i] = (data[ccKey[i]] & 0xf0) | (data[Key1[i]] & 0x0f);
    }
    memcpy(data, out, 8);
}
void Decode8(const char* data, char* out)
{
    for (int i = 0; i < 8; i++) {
        out[ccKey[i]] = data[i] & 0xf0;
    }
    for (int i = 0; i < 8; i++) {
        out[Key1[i]] |= (data[i] & 0x0f);
    }
}
char* Code(const char* data)
{
    int i;
    int sourcelen = (int)strlen(data);
    int tagetlen = ((sourcelen >> 3) + 1) << 3;
    char* rc = new char[tagetlen + 1];
    memcpy(rc, data, sourcelen);

    for (i = sourcelen; i < tagetlen - 1; i++) {
        rc[i] = 0x20 + (char)((double)rand() / ((double)RAND_MAX + 1) * (0x7f - 0x20));
    }
    rc[i] = '0' + tagetlen - sourcelen;
    rc[tagetlen] = 0;

    for (i = 0; i < tagetlen; i += 8) {
        Code8(rc + i);
    }
    return rc;
}
char* Decode(const char* data)
{
    int i;
    int tagetlen = (int)strlen(data);
    if (tagetlen % 8 != 0) {
        printf("tagetlen=%d\n", tagetlen);
        return NULL;
    }
    char* rc = new char[tagetlen + 1];
    for (i = 0; i < tagetlen; i += 8) {
        Decode8(data + i, rc + i);
    }

    if (rc[tagetlen - 1] <= '0' || rc[tagetlen - 1] > '8') {
        printf("rc[tagetlen - 1]=%d\n", rc[tagetlen - 1]);
        return NULL;
    }
    tagetlen -= rc[tagetlen - 1] - '0';
    rc[tagetlen] = 0;
    return rc;
}
void Initial()
{
    srand((unsigned int)time(0));
}

@implementation NSString (GYExtension)
/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont*)font constrainedToWidth:(CGFloat)width
{
    UIFont* textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary* attributes = @{ NSFontAttributeName : textFont,
            NSParagraphStyleAttributeName : paragraph };
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    }
    else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{ NSFontAttributeName : textFont,
        NSParagraphStyleAttributeName : paragraph };
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif

    return ceil(textSize.height);
}

/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont*)font constrainedToHeight:(CGFloat)height
{
    UIFont* textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary* attributes = @{ NSFontAttributeName : textFont,
            NSParagraphStyleAttributeName : paragraph };
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    }
    else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{ NSFontAttributeName : textFont,
        NSParagraphStyleAttributeName : paragraph };
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif

    return ceil(textSize.width);
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)sizeWithFont:(UIFont*)font constrainedToWidth:(CGFloat)width
{
    UIFont* textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary* attributes = @{ NSFontAttributeName : textFont,
            NSParagraphStyleAttributeName : paragraph };
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    }
    else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{ NSFontAttributeName : textFont,
        NSParagraphStyleAttributeName : paragraph };
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif

    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont*)font constrainedToHeight:(CGFloat)height
{
    UIFont* textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary* attributes = @{ NSFontAttributeName : textFont,
            NSParagraphStyleAttributeName : paragraph };
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    }
    else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{ NSFontAttributeName : textFont,
        NSParagraphStyleAttributeName : paragraph };
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif

    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

+ (NSString*)reverseString:(NSString*)strSrc
{
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [strSrc length];
    while (charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[strSrc substringWithRange:subStrRange]];
    }
    return reverseString;
}

#pragma mark - 正则相关
- (BOOL)isValidateByRegex:(NSString*)regex
{
    NSPredicate* pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pre evaluateWithObject:self];
}

#pragma mark -

//手机号分服务商
- (BOOL)isMobileNumberClassification
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况

    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString* CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString* CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString* CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";

    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString* PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    if (([self isValidateByRegex:CM])
        || ([self isValidateByRegex:CU])
        || ([self isValidateByRegex:CT])
        || ([self isValidateByRegex:PHS])) {
        return YES;
    }
    else {
        return NO;
    }
}

//手机号有效性
- (BOOL)isMobileNumber
{
    /**
     *手机号码
     *移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     *联通：130,131,132,152,155,156,185,186
     *电信：133,1349,153,180,189
     *4G号码段：178，177，176
     */
    
    
    NSString* MOBILE =@"^(\\+?\\d{2,3}\\-?\\s?)?1\\d{10}$";//不需要配备这么多规则，只用验证11位且开头是1的数字即可
    
    /**
     10         *中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString* CM =@"^1(34[0-8]|(3[5-9]|5[017-9]|8[278]|78)\\d)\\d{7}$";
    /**
     15         *中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString* CU =@"^1(3[0-2]|5[256]|8[56]|7[6])\\d{8}$";
    /**
     20         *中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString* CT =@"^1((33|53|8[09]|77)[0-9]|349)\\d{7}$";
    /**
     25         *大陆地区固话及小灵通
     26         *区号：010,020,021,022,023,024,025,027,028,029
     27         *号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    /**
     29         *国际长途中国区(+86)
     30         *区号：+86
     31         *号码：十一位
     32         */
    NSString* IPH =@"^\\+861(3|5|7|8)\\d{9}$";
    
 
    if(([self isValidateByRegex:MOBILE] == YES)
       || ([self isValidateByRegex:CM]  == YES)
       || ([self isValidateByRegex:CU] == YES)
       || ([self isValidateByRegex:CT]  == YES)
       || ([self isValidateByRegex:IPH]  == YES))
    {
        return YES;
    }
    else
    {
        
        return NO;
    }


}
- (BOOL) isValidNumberAndLetter {
    NSString* numberAndLetterRegex = @"^[a-zA-Z0-9]*$";
    return [self isValidateByRegex:numberAndLetterRegex];
}

//邮箱
- (BOOL)isEmailAddress
{
    NSString* emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:emailRegex];
}

//身份证号
- (BOOL)simpleVerifyIdentityCardNum
{
    NSString* regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self isValidateByRegex:regex2];
}

//车牌
- (BOOL)isCarNumber
{
    //车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    NSString* carRegex = @"^[\u4e00-\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fff]$"; //其中\u4e00-\u9fa5表示unicode编码中汉字已编码部分，\u9fa5-\u9fff是保留部分，将来可能会添加
    return [self isValidateByRegex:carRegex];
}

- (BOOL)isMacAddress
{
    NSString* macAddRegex = @"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}";
    return [self isValidateByRegex:macAddRegex];
}

- (BOOL)isValidUrl
{
    NSString* regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self isValidateByRegex:regex];
}

- (BOOL)isValidNumber{
    NSString* numberRegex = @"^[0-9]*$";
    return [self isValidateByRegex:numberRegex];
}


- (BOOL)isValidChinese;
{
    NSString* chineseRegex = @"^[\u4e00-\u9fa5]+$";
    return [self isValidateByRegex:chineseRegex];
}

- (BOOL)isValidPostalcode
{
    NSString* postalRegex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self isValidateByRegex:postalRegex];
}

- (BOOL)isValidTaxNo
{
    NSString* taxNoRegex = @"[0-9]\\d{13}([0-9]|X)$";
    return [self isValidateByRegex:taxNoRegex];
}
/**
 *  是否简单登录密码
 *
 *  @return <#return value description#>
 */
- (NSComparisonStringResult)isSimpleLoginPwd
{
    if ([self isContainSimpleCode] != NSOrderedStringOther) {
        return [self isContainSimpleCode];
    }

    if ([self isValidateByRegex:@"^(\\d)\\1{5}$"]) {
        return NSOrderedStringSame;
    }
    return NSOrderedStringOther;
}
/**
 *  是否简单交易密码
 *
 *  @return <#return value description#>
 */
- (NSComparisonStringResult)isSimpleTransPwd
{

    if ([self isContainSimpleCode] != NSOrderedStringOther) {
        return [self isContainSimpleCode];
    }

    if ([self isValidateByRegex:@"^(\\d)\\1{7}$"]) {
        return NSOrderedStringSame;
    }
    return NSOrderedStringOther;
}

- (NSComparisonStringResult)isContainSimpleCode
{

    if ([@"0123456789" containsString:self]) {
        return NSOrderedStringAscending;
    }

    if ([@"9876543210" containsString:self]) {
        return NSOrderedStringDescending;
    }

    return NSOrderedStringOther;
}

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;
{
    //  [\u4e00-\u9fa5A-Za-z0-9_]{4,20}
    NSString* hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString* first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";

    NSString* regex = [NSString stringWithFormat:@"%@[%@A-Za-z0-9_]{%d,%d}", first, hanzi, (int)(minLenth - 1), (int)(maxLenth - 1)];
    return [self isValidateByRegex:regex];
}

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString*)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;
{
    NSString* hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString* first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString* lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString* digtalRegex = containDigtal ? @"(?=(.*\\d.*){1})" : @"";
    NSString* letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString* characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString* regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    return [self isValidateByRegex:regex];
}

#pragma mark - 算法相关
//精确的身份证号码有效性检测
+ (BOOL)accurateVerifyIDCardNumber:(NSString*)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    int length = 0;
    if (!value) {
        return NO;
    }
    else {
        length = (int)value.length;

        if (length != 15 && length != 18) {
            return NO;
        }
    }
    // 省份代码
    NSArray* areasArray = @[ @"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91" ];

    NSString* valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString* areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }

    if (!areaFlag) {
        return false;
    }

    NSRegularExpression* regularExpression;
    NSUInteger numberofMatch;

    int year = 0;
    switch (length) {
    case 15:
        year = [value substringWithRange:NSMakeRange(6, 2)].intValue + 1900;

        if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {

            regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                     options:NSRegularExpressionCaseInsensitive
                                                                       error:nil]; //测试出生日期的合法性
        }
        else {
            regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                     options:NSRegularExpressionCaseInsensitive
                                                                       error:nil]; //测试出生日期的合法性
        }
        numberofMatch = [regularExpression numberOfMatchesInString:value
                                                           options:NSMatchingReportProgress
                                                             range:NSMakeRange(0, value.length)];

        if (numberofMatch > 0) {
            return YES;
        }
        else {
            return NO;
        }
    case 18:
        year = [value substringWithRange:NSMakeRange(6, 4)].intValue;
        if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {

            regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                     options:NSRegularExpressionCaseInsensitive
                                                                       error:nil]; //测试出生日期的合法性
        }
        else {
            regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                     options:NSRegularExpressionCaseInsensitive
                                                                       error:nil]; //测试出生日期的合法性
        }
        numberofMatch = [regularExpression numberOfMatchesInString:value
                                                           options:NSMatchingReportProgress
                                                             range:NSMakeRange(0, value.length)];

        if (numberofMatch > 0) {
            int S = ([value substringWithRange:NSMakeRange(0, 1)].intValue + [value substringWithRange:NSMakeRange(10, 1)].intValue) * 7 + ([value substringWithRange:NSMakeRange(1, 1)].intValue + [value substringWithRange:NSMakeRange(11, 1)].intValue) * 9 + ([value substringWithRange:NSMakeRange(2, 1)].intValue + [value substringWithRange:NSMakeRange(12, 1)].intValue) * 10 + ([value substringWithRange:NSMakeRange(3, 1)].intValue + [value substringWithRange:NSMakeRange(13, 1)].intValue) * 5 + ([value substringWithRange:NSMakeRange(4, 1)].intValue + [value substringWithRange:NSMakeRange(14, 1)].intValue) * 8 + ([value substringWithRange:NSMakeRange(5, 1)].intValue + [value substringWithRange:NSMakeRange(15, 1)].intValue) * 4 + ([value substringWithRange:NSMakeRange(6, 1)].intValue + [value substringWithRange:NSMakeRange(16, 1)].intValue) * 2 + [value substringWithRange:NSMakeRange(7, 1)].intValue * 1 + [value substringWithRange:NSMakeRange(8, 1)].intValue * 6 + [value substringWithRange:NSMakeRange(9, 1)].intValue * 3;
            int Y = S % 11;
            NSString* M = @"F";
            NSString* JYM = @"10X98765432";
            M = [JYM substringWithRange:NSMakeRange(Y, 1)]; // 判断校验位
            if ([M isEqualToString:[value substringWithRange:NSMakeRange(17, 1)]]) {
                return YES; // 检测ID的校验位
            }
            else {
                return NO;
            }
        }
        else {
            return NO;
        }
    default:
        return NO;
    }
}

/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
- (BOOL)bankCardluhmCheck
{
    NSString* lastNum = [[self substringFromIndex:(self.length - 1)] copy]; //取出最后一位
    NSString* forwardNum = [[self substringToIndex:(self.length - 1)] copy]; //前15或18位

    NSMutableArray* forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < forwardNum.length; i++) {
        NSString* subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }

    NSMutableArray* forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count - 1); i > -1; i--) { //前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }

    NSMutableArray* arrOddNum = [[NSMutableArray alloc] initWithCapacity:0]; //奇数位*2的积 < 9
    NSMutableArray* arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0]; //奇数位*2的积 > 9
    NSMutableArray* arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0]; //偶数位数组

    for (int i = 0; i < forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i % 2) { //偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }
        else { //奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }
            else {
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }

    __block NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL* stop) {
        sumOddNumTotal += [obj integerValue];
    }];

    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL* stop) {
        sumOddNum2Total += [obj integerValue];
    }];

    __block NSInteger sumEvenNumTotal = 0;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL* stop) {
        sumEvenNumTotal += [obj integerValue];
    }];

    NSInteger lastNumber = [lastNum integerValue];

    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;

    return (luhmTotal % 10 == 0) ? YES : NO;
}

- (BOOL)isIPAddress
{
    NSString* regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    NSPredicate* pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL rc = [pre evaluateWithObject:self];

    if (rc) {
        NSArray* componds = [self componentsSeparatedByString:@","];

        BOOL v = YES;
        for (NSString* s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }

        return v;
    }

    return NO;
}

#pragma mark - 加解密

- (NSString*)md5HexDigest:(NSString*)string
{
    const char* original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned int)strlen(original_str), result);
    NSMutableString* hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    NSString* mdfiveString = [hash lowercaseString];
    return mdfiveString;
}

- (NSString*)AES128Operation:(CCOperation)operation withString:(NSString*)content key:(NSString*)keyString
{
    static NSString* iv = @"0102030405060708";
    NSData* contentData = [content dataUsingEncoding:NSUTF8StringEncoding];

    NSString* key = [self md5HexDigest:keyString];
    key = [key substringToIndex:16];

    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [contentData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void* buffer = malloc(bufferSize);
    size_t numBytesCrypted = 0;

    CCCryptorStatus cryptStatus = CCCrypt(operation,
        kCCAlgorithmAES128,
        kCCOptionPKCS7Padding | kCCOptionECBMode,
        keyPtr,
        kCCBlockSizeAES128,
        ivPtr,
        [contentData bytes],
        dataLength,
        buffer,
        bufferSize,
        &numBytesCrypted);
    NSString* r = @"";
    if (cryptStatus == kCCSuccess) {
        char* p = (char*)buffer;
        NSMutableString* mStr = [NSMutableString string];
        for (int i = 0; i < numBytesCrypted; i++) {
            NSString* _oset = [NSString stringWithFormat:@"%02x", p[i]];
            _oset = [_oset substringFromIndex:_oset.length - 2]; //取后两位
            [mStr appendString:_oset];
        }
        r = [mStr uppercaseString];
        NSLog(@"buffer string:%@", r);
    }
    free(buffer);
    return r;
}

- (NSString *)md5String16:(NSString *)key {
    return [self AES128Operation:kCCEncrypt withString:self key:key];
}

- (NSString*)encodeWithKey:(NSString*)key
{
    return [self AES128Operation:kCCEncrypt withString:self key:key];
}

/**
 *  @brief  JSON字符串转成NSDictionary
 *
 *  @return NSDictionary
 */
- (NSDictionary*)dictionaryValue
{
    NSError* errorJson;
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil) {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, errorJson);
#endif
    }
    return jsonDict;
}

- (id)toJSONObject
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSObject* obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return obj;
}


@end





