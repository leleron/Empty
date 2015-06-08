//
//  base64.h
//  QianFangGuJie
//
//  Created by 财道 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#ifndef QianFangGuJie_base64_h
#define QianFangGuJie_base64_h
extern size_t EstimateBas64EncodedDataSize(size_t inDataSize);
extern size_t EstimateBas64DecodedDataSize(size_t inDataSize);

extern bool Base64EncodeData(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize, BOOL wrapped);
extern bool Base64DecodeData(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize);


#endif
