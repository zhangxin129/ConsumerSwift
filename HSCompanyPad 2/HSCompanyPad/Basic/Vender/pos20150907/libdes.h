/*
********************************************************************************
*
*   File Name:
*       libdes.h
*   Author:
*       SW R&D Department
*   Version:
*       V1.0
*   Description:
*       
*
********************************************************************************
*/

#ifndef _LIBDES_H
#define _LIBDES_H

/*-----------------------------------------------------------------------------
|   Includes
+----------------------------------------------------------------------------*/


#ifdef _LIBDES_C
#define GLOBAL
#else
#define GLOBAL  extern
#endif

/*-----------------------------------------------------------------------------
|   Macros
+----------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------------
|   Enumerations
+----------------------------------------------------------------------------*/



/*-----------------------------------------------------------------------------
|   Typedefs
+----------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------------
|   Variables
+----------------------------------------------------------------------------*/



/*-----------------------------------------------------------------------------
|   Constants
+----------------------------------------------------------------------------*/



/*-----------------------------------------------------------------------------
|   prototypes
+----------------------------------------------------------------------------*/



/*
*******************************************************************************
*   End of File
*******************************************************************************
*/
GLOBAL void Des_Encrypt(unsigned char *pucInput, unsigned char *pucOutput, const unsigned char *pucKey);
GLOBAL void Des_Decrypt(unsigned char *pucInput, unsigned char *pucOutput, const unsigned char *pucKey);
GLOBAL void Des_CBCEncrypt(unsigned char *pucInput, unsigned char*pucIv, unsigned char *pucOutput, unsigned char *pucKey);
GLOBAL void Des_CBCDecrypt(unsigned char *pucInput, unsigned char*pucIv,unsigned char *pucOutput, unsigned char *pucKey);
GLOBAL void TDes_Encrypt(unsigned char *pucInput, unsigned char *pucOutput, const unsigned char *pucKey);
GLOBAL void TDes_Decrypt(unsigned char *pucInput, unsigned char *pucOutput, const unsigned char *pucKey);
GLOBAL int  TDES_CBCEncrypt(unsigned char * pszIn,unsigned char * pszOut,int iDataLen,unsigned char * pszKey,int iKeyLen,unsigned char*pucIv);
GLOBAL  int  TDES_CBCDecrypt(unsigned char * pszIn,unsigned char * pszOut,int iDataLen,unsigned char * pszKey,int iKeyLen,unsigned char*pucIv);

GLOBAL int TDes_Decrypt_all(unsigned char* key, unsigned char* pdata, int raw_data_sz, unsigned char* outbuf);
GLOBAL int TDes_Encrypt_all(unsigned char* key, unsigned char* pdata, int raw_data_sz, unsigned char* outbuf);

#undef GLOBAL

#endif  /* #ifndef _LIBDES_H */

