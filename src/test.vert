    precision mediump int;
    precision mediump float;

// Instance inputs: 
attribute vec2 position;
vec2 get_position(){return position;}
attribute vec2 texturecoordinates;
vec2 get_texturecoordinates(){return texturecoordinates;}

// Per instance attributes: 
attribute vec4 color;
vec4 get_color(){return color;}
attribute vec2 markersize;
vec2 get_markersize(){return markersize;}
attribute vec3 offset;
vec3 get_offset(){return offset;}
attribute vec4 uv_offset_width;
vec4 get_uv_offset_width(){return uv_offset_width;}

// Uniforms: 
uniform bool transform_marker;
bool get_transform_marker(){return transform_marker;}
uniform sampler2D distancefield;
uniform vec2 resolution;
vec2 get_resolution(){return resolution;}
uniform int shape_type;
int get_shape_type(){return shape_type;}
uniform mat4 model;
mat4 get_model(){return model;}
uniform vec2 marker_offset;
vec2 get_marker_offset(){return marker_offset;}



uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;

varying vec4 frag_color;
varying vec2 frag_uv;
varying float frag_uvscale;
varying float frag_distancefield_scale;
varying vec4 frag_uv_offset_width;



float distancefield_scale(){
    // Glyph distance field units are in pixels; convert to dimensionless
    // x-coordinate of texture instead for consistency with programmatic uv
    // distance fields in fragment shader. See also comments below.
    vec4 uv_rect = get_uv_offset_width();
    float tsize = 1024.0;
    float pixsize_x = (uv_rect.z - uv_rect.x) * tsize;
    return -1.0/pixsize_x;
}

vec3 tovec3(vec2 v){return vec3(v, 0.0);}
vec3 tovec3(vec3 v){return v;}

void main(){
    // get_* gets the global inputs (uniform, sampler, vertex array)
    // those functions will get inserted by the shader creation pipeline
    vec3 vertex_position = tovec3(get_markersize()) * tovec3(get_position());
    //rotate(get_rotations(), vertex_position, N);
    vertex_position = tovec3(get_offset()) + vertex_position;
    vertex_position = vertex_position;
    vec4 position_world;
    if(get_transform_marker()){
        position_world = get_model() * vec4(vertex_position, 1);
    }else{
        position_world = vec4(vertex_position, 1);
    }
    frag_color = get_color();
    vec2 mpixel = (projectionMatrix * vec4(get_markersize(), 0, 0)).xy;
    mpixel = ((mpixel + 1.0) / 2.0) * get_resolution();
    frag_uvscale = length(mpixel) / 2.0;
    vec2 uv = get_texturecoordinates();
    frag_uv = uv;
    frag_distancefield_scale = distancefield_scale();
    frag_uv_offset_width = get_uv_offset_width();
    // screen space coordinates of the vertex
    gl_Position = projectionMatrix * viewMatrix * position_world;
}

