#version 120
uniform sampler2D texture;
uniform sampler2D lightmap;
varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 color;
void main() {
    vec4 tex = texture2D(texture, texcoord);
    vec3 light = texture2D(lightmap, lmcoord).rgb;
    gl_FragColor = vec4(tex.rgb * light * color.rgb, tex.a * color.a * 0.85);
}
