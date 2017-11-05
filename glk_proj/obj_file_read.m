//
//  obj_file_read.m
//  obj_file_manager
//
//  Created by apple on 14-6-1.
//
//

#import "obj_file_read.h"

@implementation obj_file_read

+ (obj_v_info *)return_obj_information_with_file:(NSString *)file_path with_count:(int *)count{
    NSString *content = [NSString stringWithContentsOfFile:file_path encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [content componentsSeparatedByString:@"\n"], *array;
//    NSLog(@"%d", [lines count]);
//    return NULL;
    float *v_key = (float *)malloc(sizeof(float) * 1024), *vt_key = (float *)malloc(sizeof(float) * 1024), *vn_key = (float *)malloc(sizeof(float) * 1024);
    int v_size = 1, vt_size = 1, vn_size = 1, v_str_size = 1, v_k = 0, vt_k = 0, vn_k = 0, v_str = 0, n, v1 = 0, vt1 = 0, vn1 = 0, v2 = 0, vt2 = 0, vn2 = 0, v3 = 0, vt3 = 0, vn3, v_c;
    float a, b, c;
    obj_v_info *info = (obj_v_info *)malloc(sizeof(obj_v_info) * 1024);
    
    for(NSString *key_string in lines) {
        const char *c_key = [key_string UTF8String];
        
        if(c_key[0] == 'f') {
            if([[key_string componentsSeparatedByString:@" "] count] > 2) {
                array = [[[key_string componentsSeparatedByString:@" "] objectAtIndex:2] componentsSeparatedByString:@"/"];
//                NSLog(@"%@", [key_string componentsSeparatedByString:@" "]);
                n = [array count];
                if(n == 3) {
                    if([[array objectAtIndex:1] length] == 0) {
                        v_c = 0;
                    }else
                        v_c = 1;
                }else
                    v_c = 0;
            }
            else
                continue;
//            NSLog(@" %@  %@", key_string, [[[key_string componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@"/"]);
            if(n == 2) {
                sscanf(c_key, "f %d/%d %d/%d %d/%d", &v1, &vt1, &v2, &vt2, &v3, &vt3);
                vn1 = vn2 = vn3 = 1;
            }else if(n == 3) {
                if(v_c)
                    sscanf(c_key, "f %d/%d/%d %d/%d/%d %d/%d/%d", &v1, &vt1, &vn1, &v2, &vt2, &vn2, &v3, &vt3, &vn3);
                else {
                    sscanf(c_key, "f %d//%d %d//%d %d//%d", &v1, &vn1, &v2, &vn2, &v3, &vn3);
                    vt1 = vt2 = vt3 = 1;
                }
            }else if(n == 1) {
                sscanf(c_key, "f %d %d %d", &v1, &v2, &v3);
                vn1 = vn2 = vn3 = vt1 = vt2 = vt3 = 1;
            }
            
            if(v_str + 3 > 1024 * v_str_size) {
                info = (obj_v_info *)realloc(info, sizeof(obj_v_info) * 1024 * (v_str_size + 1));
                v_str_size++;
            }
            
            (info + v_str)->v[0] = *(v_key + (v1 - 1) * 3);
            (info + v_str)->v[1] = *(v_key + (v1 - 1) * 3 + 1);
            (info + v_str)->v[2] = *(v_key + (v1 - 1) * 3 + 2);
            (info + v_str)->vt[0] = *(vt_key + (vt1 - 1) * 2);
            (info + v_str)->vt[1] = 1.0f - *(vt_key + (vt1 - 1) * 2 + 1);
            (info + v_str)->vn[0] = *(vn_key + (vn1 - 1) * 3);
            (info + v_str)->vn[1] = *(vn_key + (vn1 - 1) * 3 + 1);
            (info + v_str)->vn[2] = *(vn_key + (vn1 - 1) * 3 + 2);
            
            (info + v_str + 1)->v[0] = *(v_key + (v2 - 1) * 3);
            (info + v_str + 1)->v[1] = *(v_key + (v2 - 1) * 3 + 1);
            (info + v_str + 1)->v[2] = *(v_key + (v2 - 1) * 3 + 2);
            (info + v_str + 1)->vt[0] = *(vt_key + (vt2 - 1) * 2);
            (info + v_str + 1)->vt[1] = 1.0f - *(vt_key + (vt2 - 1) * 2 + 1);
            (info + v_str + 1)->vn[0] = *(vn_key + (vn2 - 1) * 3);
            (info + v_str + 1)->vn[1] = *(vn_key + (vn2 - 1) * 3 + 1);
            (info + v_str + 1)->vn[2] = *(vn_key + (vn2 - 1) * 3 + 2);
            
            (info + v_str + 2)->v[0] = *(v_key + (v3 - 1) * 3);
            (info + v_str + 2)->v[1] = *(v_key + (v3 - 1) * 3 + 1);
            (info + v_str + 2)->v[2] = *(v_key + (v3 - 1) * 3 + 2);
            (info + v_str + 2)->vt[0] = *(vt_key + (vt3 - 1) * 2);
            (info + v_str + 2)->vt[1] = 1.0f - *(vt_key + (vt3 - 1) * 2 + 1);
            (info + v_str + 2)->vn[0] = *(vn_key + (vn2 - 1) * 3);
            (info + v_str + 2)->vn[1] = *(vn_key + (vn2 - 1) * 3 + 1);
            (info + v_str + 2)->vn[2] = *(vn_key + (vn2 - 1) * 3 + 2);
            
//            NSLog(@"%d %d %d", v1, v2, v3);
//            NSLog(@"%d %f %f %f", v2, (info + v_str + 1)->v[0], (info + v_str + 1)->v[1], (info + v_str + 1)->v[2]);
            v_str += 3;
        }else if(c_key[0] == 'v'){
            if(c_key[1] == ' ') {
                sscanf(c_key, "v %f %f %f", &a, &b, &c);
                
                if(v_k + 3 > 1024 * v_size) {
                    v_key = (float *)realloc(v_key, 1024 * (v_size + 1) * sizeof(float));
                    v_size++;
                }
                
                *(v_key + v_k) = a;
                *(v_key + v_k + 1) = b;
                *(v_key + v_k + 2) = c;
                v_k += 3;
            }else if(c_key[1] == 't') {
                sscanf(c_key, "vt %f %f", &a, &b);
                
                if(vt_k + 2 > 1024 * vt_size) {
                    vt_key = (float *)realloc(vt_key, 1024 * (vt_size + 1) * sizeof(float));
                    vt_size++;
                }
                
                *(vt_key + vt_k) = a;
                *(vt_key + vt_k + 1) = b;
                vt_k += 2;
            }else if(c_key[1] == 'n') {
                sscanf(c_key, "vn %f %f %f", &a, &b, &c);
                
                if(vn_k + 3 > 1024 * vn_size) {
                    vn_key = (float *)realloc(vn_key, 1024 * (vn_size + 1) * sizeof(float));
                    vn_size++;
                }
                
                *(vn_key + vn_k) = a;
                *(vn_key + vn_k + 1) = b;
                *(vn_key + vn_k + 2) = c;
                vn_k += 3;
            }
        }
    }
    
    *count = v_str;
    free(v_key);
    free(vt_key);
    free(vn_key);
    return info;
}

@end
