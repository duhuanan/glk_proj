//
//  ViewController.h
//  glk_proj
//
//  Created by apple on 14-6-2.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "opengl_general_define.h"
#import "obj_file_read.h"

@interface ViewController : GLKViewController {
    GLKBaseEffect *_effect;
    GLuint _vertex, _line_vertex;
    obj_v_info *_obj_info;
    int _obj_count;
    float _rotate, _m_x, _m_y, _m_z, _x, _y;
    BOOL _is_select;
}

@end
