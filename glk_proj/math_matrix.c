//
//  math_matrix.c
//  glk_proj
//
//  Created by apple on 14-7-2.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#include <stdio.h>
#include "math_matrix.h"

float det3(float m[16], int x1, int x2, int x3, int y1, int y2, int y3, int z1, int z2, int z3) {
    return m[x1] * m[y2] * m[z3] + m[x2] * m[y3] * m[z1] + m[x3] * m[y1] * m[z2]
    - m[x1] * m[y3] * m[z2] - m[x2] * m[y1] * m[z3] - m[x3] * m[y2] * m[z1];
}

bool mat_inv(float mat[16], float res[16]) {
    int i, j;
    float trans_mat[16], d;
    
    for(i = 0; i < 4; i++) {
        for(j = 0; j < 4; j++) {
            trans_mat[i * 4 + j] = mat[j * 4 + i];
        }
    }
    
    d = 1.0f / (trans_mat[0] * det3(trans_mat, 5, 6, 7, 9, 10, 11, 13, 14, 15) - trans_mat[1] * det3(trans_mat, 4, 6, 7, 8, 10, 11, 12, 14, 15) + trans_mat[2] * det3(trans_mat, 4, 5, 7, 8, 9, 11, 12, 13, 15) - trans_mat[3] * det3(trans_mat, 4, 5, 6, 8, 9, 10, 12, 13, 14));
    
    res[0] = d * det3(trans_mat, 5, 6, 7, 9, 10, 11, 13, 14, 15);
    res[1] = -d * det3(trans_mat, 4, 6, 7, 8, 10, 11, 12, 14, 15);
    res[2] = d * det3(trans_mat, 4, 5, 7, 8, 9, 11, 12, 13, 15);
    res[3] = -d * det3(trans_mat, 4, 5, 6, 8, 9, 10, 12, 13, 14);
    
    res[4] = -d * det3(trans_mat, 1, 2, 3, 9, 10, 11, 13, 14, 15);
    res[5] = d * det3(trans_mat, 0, 2, 3, 8, 10, 11, 12, 14, 15);
    res[6] = -d * det3(trans_mat, 0, 1, 3, 8, 9, 11, 12, 13, 15);
    res[7] = d * det3(trans_mat, 0, 1, 2, 8, 9, 10, 12, 13, 14);
    
    res[8] = d * det3(trans_mat, 1, 2, 3, 5, 6, 7, 13, 14, 15);
    res[9] = -d * det3(trans_mat, 0, 2, 3, 4, 6, 7, 12, 14, 15);
    res[10] = d * det3(trans_mat, 0, 1, 3, 4, 5, 7, 12, 13, 15);
    res[11] = -d * det3(trans_mat, 0, 1, 2, 4, 5, 6, 12, 13, 14);
    
    res[12] = -d * det3(trans_mat, 1, 2, 3, 5, 6, 7, 9, 10, 11);
    res[13] = d * det3(trans_mat, 0, 2, 3, 4, 6, 7, 8, 10, 11);
    res[14] = -d * det3(trans_mat, 0, 1, 3, 4, 5, 7, 8, 9, 11);
    res[15] = d * det3(trans_mat, 0, 1, 2, 4, 5, 6, 8, 9, 10);
    
    return true;
}
