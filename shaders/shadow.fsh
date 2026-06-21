#version 120
uniform sampler2D texture;
varying vec2 texcoord;
varying vec4 color;

void main() {
    // Отбрасываем тень только от непрозрачных пикселей (важно для листвы/решёток)
    vec4 tex = texture2D(texture, texcoord) * color;
    if (tex.a < 0.5) discard;
    gl_FragColor = vec4(1.0);
}
