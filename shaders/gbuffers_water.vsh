#version 120
uniform float frameTimeCounter;

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 color;
varying float vertexDistance;

void main() {
    vec4 pos = gl_Vertex;
    pos.y += sin(pos.x * 0.5 + frameTimeCounter * 1.5) * 0.035
           + cos(pos.z * 0.5 + frameTimeCounter * 1.3) * 0.035;

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * pos;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    color = gl_Color;
    vertexDistance = length((gl_ModelViewMatrix * pos).xyz);
}
