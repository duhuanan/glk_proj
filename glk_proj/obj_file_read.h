//
//  obj_file_read.h
//  obj_file_manager
//
//  Created by apple on 14-6-1.
//
//

#import <Foundation/Foundation.h>
typedef struct v_info {
    float v[3];
    float vt[2];
    float vn[3];
}obj_v_info;
@interface obj_file_read : NSObject;
+ (obj_v_info *)return_obj_information_with_file:(NSString *)file_path with_count:(int *)count;
@end
