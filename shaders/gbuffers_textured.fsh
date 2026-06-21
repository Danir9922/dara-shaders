#version 120
uniform sampler2D texture;
varying vec2 texcoord;
varying vec4 color;
void main() {
    vec4 tex = texture2D(texture, texcoord);
    gl_FragColor = tex * color;
}
