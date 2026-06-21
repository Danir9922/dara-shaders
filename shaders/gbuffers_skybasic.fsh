#version 120
uniform vec3 fogColor;
uniform vec3 skyColor;

varying vec4 color;
varying vec3 viewPos;

void main() {
    vec3 dir = normalize(viewPos);
    float horizon = clamp(1.0 - abs(dir.y), 0.0, 1.0);
    vec3 zenith = skyColor * 1.15;
    vec3 grad = mix(zenith, fogColor, pow(horizon, 1.5));
    gl_FragColor = vec4(grad, color.a);
}
