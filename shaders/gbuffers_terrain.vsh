#version 120
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 color;
varying vec3 normal;
varying float vertexDistance;
varying vec4 shadowPos;

void main() {
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    color = gl_Color;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    vertexDistance = length((gl_ModelViewMatrix * gl_Vertex).xyz);

    vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
    vec4 worldPos = gbufferModelViewInverse * viewPos;
    shadowPos = shadowProjection * shadowModelView * worldPos;
}
