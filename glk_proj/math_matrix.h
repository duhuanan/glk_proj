//
//  math_matrix.h
//  glk_proj
//
//  Created by apple on 14-7-2.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#ifndef glk_proj_math_matrix_h
#define glk_proj_math_matrix_h
#ifndef bool
#define bool int
#endif

#ifndef false
#define false 0
#endif

#ifndef true
#define true 1
#endif

bool mat_inv(float mat[16], float res[16]);
#endif
