//
//  ViewController.m
//  glk_proj
//
//  Created by apple on 14-6-2.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "math_matrix.h"
typedef struct {
    GLKVector3 pos;
}sceneV;

static const sceneV vectices[] = {
    {{-0.5f, -0.5f, 0.0f}},
    {{0.5f, -0.5f, 0.0f}},
    {{-0.5f, 0.5f, 0.0f}}
};

@implementation ViewController

- (void)viewDidLoad
{
    float tmp[16] = {0, 1, 1, 1, 2, 0, 2, 2, 3, 3, 0, 3, 4, 4, 4, 0}, res[16];
    mat_inv(tmp, res);

    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            printf("%f  ", res[i * 4 + j]);
        }
        
        printf("\n");
    }
    
    memcpy(res, GLKMatrix4Invert(GLKMatrix4MakeWithArray(tmp), nil).m, 16);
    
    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            printf("%f  ", res[i * 4 + j]);
        }
        
        printf("\n");
    }
    int k = 0;
    
    float xy[560] = {0};
    _m_x = _m_y = _m_z = 0.0f;
    _obj_info = [obj_file_read return_obj_information_with_file:[[NSBundle mainBundle] pathForResource:@"su-101_hull.obj" ofType:nil] with_count:&_obj_count];
    [super viewDidLoad];
    GLKView *gl_view = (GLKView *)self.view;
    gl_view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:gl_view.context];
    gl_view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    GLKTextureInfo *info = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"hull.jpg"].CGImage options:nil error:nil];
    _effect = [[GLKBaseEffect alloc] init];
    _effect.transform.modelviewMatrix = GLKMatrix4MakeScale(0.4f, 0.4f, 0.4f);
    _effect.useConstantColor = GL_TRUE;
    _effect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    _effect.texture2d0.enabled = GL_TRUE;
    _effect.texture2d0.target = info.target;
    _effect.texture2d0.name = info.name;
    
//    _effect.light0.enabled = GL_TRUE;
    _effect.light0.position = GLKVector4Make(0.0f, 0.0f, 1.0f, 0.0f);
    _effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
    
    for(int i = 0; i < 20; i++) {
        xy[k] = -2.0f;
        xy[k + 1] = 0.0f;
        xy[k + 2] = i * 0.2f - 2.0f;
        xy[k + 3] = 1.0f;
        xy[k + 4] = 0.0f;
        xy[k + 5] = 0.0f;
        xy[k + 6] = 1.0f;
        
        xy[k + 7] = 2.0f;
        xy[k + 8] = 0.0f;
        xy[k + 9] = i * 0.2f - 2.0f;
        xy[k + 10] = 1.0f;
        xy[k + 11] = 0.0f;
        xy[k + 12] = 0.0f;
        xy[k + 13] = 1.0f;
        k += 14;
    }
    
    for(int i = 0; i < 20; i++) {
        xy[k + 2] = -2.0f;
        xy[k + 1] = 0.0f;
        xy[k] = i * 0.2f - 2.0f;
        xy[k + 3] = 1.0f;
        xy[k + 4] = 0.0f;
        xy[k + 5] = 0.0f;
        xy[k + 6] = 1.0f;
        
        xy[k + 9] = 2.0f;
        xy[k + 8] = 0.0f;
        xy[k + 7] = i * 0.2f - 2.0f;
        xy[k + 10] = 1.0f;
        xy[k + 11] = 0.0f;
        xy[k + 12] = 0.0f;
        xy[k + 13] = 1.0f;
        k += 14;
    }
    
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glEnable(GL_DEPTH_TEST);
    glGenBuffers(1, &_line_vertex);
    glBindBuffer(GL_ARRAY_BUFFER, _line_vertex);
    glBufferData(GL_ARRAY_BUFFER, sizeof(xy), xy, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_vertex);
    glBindBuffer(GL_ARRAY_BUFFER, _vertex);
    glBufferData(GL_ARRAY_BUFFER, sizeof(obj_v_info) * _obj_count, _obj_info, GL_STATIC_DRAW);
}

- (void)draw_line {
    [_effect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _line_vertex);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_TRUE, sizeof(float) * 7, NULL);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_TRUE, sizeof(float) * 7, (const GLvoid *)(sizeof(float) * 3));
    glDrawArrays(GL_LINES, 0, 80);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}

- (GLKVector3)unproj:(GLKMatrix4)proj model:(GLKMatrix4)model x:(float)x y:(float)y z:(float)z win_w:(float)w win_h:(float)h{
    GLKMatrix4 mat = GLKMatrix4Invert(GLKMatrix4Multiply(proj, model), nil);
    x = (x * 2/ w - 1.0f);
    y = -(2.0f * y / h - 1.0f);
    GLKVector4 vec4 = GLKMatrix4MultiplyVector4(mat, GLKVector4Make(x, y, z, 1.0f));
    
    return GLKVector3Make(vec4.x / vec4.w, vec4.y / vec4.w, vec4.z / vec4.w);
}

- (void)draw_model {
    glBindBuffer(GL_ARRAY_BUFFER, _vertex);
//    _effect.transform.modelviewMatrix = GLKMatrix4Translate(_effect.transform.modelviewMatrix, 1, 0, 1);
    _effect.transform.modelviewMatrix = GLKMatrix4Rotate(_effect.transform.modelviewMatrix, GLKMathDegreesToRadians(90.0f), 0.0f, 0.0f, 1.0f);
    _effect.transform.modelviewMatrix = GLKMatrix4Rotate(_effect.transform.modelviewMatrix, GLKMathDegreesToRadians(90.0f), 0.0f, 1.0f, 0.0f);
    _effect.transform.modelviewMatrix = GLKMatrix4Multiply(_effect.transform.modelviewMatrix, GLKMatrix4Multiply(GLKMatrix4MakeScale(0.3f, 0.3f, 0.3f), GLKMatrix4MakeRotation(_rotate, 0.0f, 0.0f, 1.0f)));
    [_effect prepareToDraw];
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_TRUE, sizeof(obj_v_info), NULL);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(obj_v_info), (const GLvoid *)(sizeof(float) * 3));
    glDrawArrays(GL_TRIANGLES, 0, _obj_count);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}

#define AGLKVerySmallMagnitude (FLT_EPSILON * 8.0f)

BOOL AGLKPointsAreOnSameSideOfLine(
                                   GLKVector3 p1,
                                   GLKVector3 p2,
                                   GLKVector3 a,
                                   GLKVector3 b)
{
    GLKVector3      cp1 = GLKVector3CrossProduct(
                                                 GLKVector3Subtract(b, a), GLKVector3Subtract(p1, a));
    GLKVector3      cp2 = GLKVector3CrossProduct(
                                                 GLKVector3Subtract(b, a), GLKVector3Subtract(p2, a));
    
    return (0 <= GLKVector3DotProduct(cp1, cp2));
}

BOOL AGLKPointIsInTriangle(
                           GLKVector3 p,
                           GLKVector3 a, 
                           GLKVector3 b, 
                           GLKVector3 c)
{
    float abx = b.x - a.x, abz = b.z - a.z, acx = c.x - a.x, acz = c.z - a.z;
    float tmp = fabs(abx * acz - abz * acx);
    if(tmp > 0.001) {
        float v1x = p.x - a.x, v1z = p.z - a.z, v2x = p.x - b.x, v2z = p.z - b.z, v3x = p.x - c.x, v3z = p.z - c.z;
        float val = fabs(v1x * v2z - v1z * v2x) + fabs(v1x * v3z - v1z * v3x) + fabs(v2x * v3z - v3x * v2z) - tmp;
        return val < 0.001 && val > -0.001;
    }else {
        float aby = b.y - a.y, acy = c.y - a.y;
        tmp = fabs(abx * acy - aby * acx);
        
        if(tmp > 0.001) {
            float v1x = p.x - a.x, v1y = p.y - a.y, v2x = p.x - b.x, v2y = p.y - b.y, v3x = p.x - c.x, v3y = p.y - c.y;
            float val = fabs(v1x * v2y - v1y * v2x) + fabs(v1x * v3y - v1y * v3x) + fabs(v2x * v3y - v2y * v3x) - tmp;
            return val < 0.001 && val > -0.001;
        }else {
            tmp = fabs(aby * acz - abz * acy);

            float v1z = p.z - a.z, v1y = p.y - a.y, v2z = p.z - b.z, v2y = p.y - b.y, v3z = p.z - c.z, v3y = p.y - c.y;
            float val = fabs(v1y * v2z - v1z * v2y) + fabs(v1y * v3z - v1z * v3y) + fabs(v2y * v3z - v2z * v3y) - tmp;
            return val < 0.001 && val > -0.001;
        }
    }
    return false;
}

BOOL AGLKRayDoesIntersectTriangle(
                                  GLKVector3 d,
                                  GLKVector3 p,
                                  GLKVector3 v0,
                                  GLKVector3 v1,
                                  GLKVector3 v2,
                                  GLKVector3 *intersectionPoint)
{
    GLKVector3 e1 = GLKVector3Subtract(v1, v0), e2 = GLKVector3Subtract(v2, v0);
    GLKVector3 n = GLKVector3CrossProduct(e1, e2);
    if(GLKVector3DotProduct(n, d) == 0) return NO;
    float t = (GLKVector3DotProduct(n, v0) - GLKVector3DotProduct(n, p)) / GLKVector3DotProduct(n, d);
    GLKVector3 vec = GLKVector3Make(p.x + d.x * t, p.y + d.y * t, p.z + d.z * t);
    return AGLKPointIsInTriangle(vec, v0, v1, v2);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    _rotate += 0.005f;
//    int vp[4] = {0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height};
//    float coord[4];
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    _effect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), self.view.frame.size.width / self.view.frame.size.height, 0.1f, 100.0f);
    _effect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(1.0f, 1.0f, 1.0f, 0, 0, 0, 0.0f, 1.0f, 0.0f);
//    _effect.transform.modelviewMatrix = GLKMatrix4Translate(_effect.transform.modelviewMatrix, -2, -2, -0);
    _effect.transform.modelviewMatrix = GLKMatrix4Rotate(_effect.transform.modelviewMatrix, 40, 0, 1, 0);
    GLKVector3 vec3 = [self unproj:_effect.transform.projectionMatrix model:_effect.transform.modelviewMatrix x:_x y:_y z:1.0f win_w:self.view.frame.size.width win_h:self.view.frame.size.height];
    
//    for (int i = 0; i < 4; i++) {
//        for(int j = 0; j < 4; j++) {
//            printf("%f  ", GLKMatrix4Invert(GLKMatrix4MakeLookAt(4.0f, 4.0f, -4.0f, 0, 0, 0, 0.0f, 1.0f, 0.0f), nil).m[i * 4 + j]);
//        }
//        
//        printf("\n");
//    }
    
//    -0.707107  -0.000000  -0.707107  0.000000
//    -0.408248  0.816497  0.408248  0.000000
//    0.577350  0.577350  -0.577350  0.000000
//    4.000000  4.000000  -4.000000  1.000000
    GLKVector4 vec4 = GLKMatrix4MultiplyVector4(GLKMatrix4Invert(_effect.transform.modelviewMatrix, nil), GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f));
//    GLKVector3 vec4 = [self unproj:_effect.transform.projectionMatrix model:_effect.transform.modelviewMatrix x:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 y:_y z:0.0f win_w:self.view.frame.size.width win_h:self.view.frame.size.height];
//    glhUnProjectf(_x, _y, 1.0f, _effect.transform.modelviewMatrix.m, _effect.transform.projectionMatrix.m, vp, coord);
    GLKVector4 dir = GLKVector4Subtract(GLKVector4Make(vec3.x, vec3.y, vec3.z, 1.0f), vec4);
//    if(dir.y < 0) dir = GLKVector4Negate(dir);
    float scale = fabs(vec4.y / dir.y);
    GLKVector3 inter;
    _m_x = vec4.x + dir.x * scale, _m_y = 0, _m_z = vec4.z + dir.z * scale;
//    _m_x = 3.8, _m_y = 3.8, _m_z = 3.8;
    if(_is_select) {
        if(AGLKRayDoesIntersectTriangle(GLKVector3Make(dir.x, dir.y, dir.z), GLKVector3Make(vec4.x, vec4.y, vec4.z), GLKVector3Make( 0.5f, 0.0f,  0.5f), GLKVector3Make( 0.5f, 0.0f, 1.5f), GLKVector3Make(1.5f, 0.0f, 1.5f), &inter)) {
        NSLog(@"SKJDHLAKSJDHLAKSHDLKAHSDLKAHSDASD");
        }
    }
    _is_select = NO;
    
    [_effect prepareToDraw];
    [self draw_line];
    [self draw_model];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    _x = pt.x, _y = pt.y;
    _is_select = YES;
}

@end
