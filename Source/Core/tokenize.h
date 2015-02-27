#ifndef __TOKENIZE_3D9CGA6A_H
#define __TOKENIZE_3D9CGA6A_H

#import "gen.h"

U32 stringify_file
(char** buffer, FILE* fp);

cwdict_t tokenize
(const char* const buffer, const char* delimiters);

#endif
