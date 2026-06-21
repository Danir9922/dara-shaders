#version 120
uniform sampler2D colortex0;
uniform float viewWidth;
uniform float viewHeight;

varying vec2 texcoord;

vec3 sampleBlur(vec2 uv, vec2 texel) {
    vec3 sum = vec3(0.0);
    float total = 0.0;
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * texel * 2.5;
            float weight = clamp(1.0 - length(offset) * 8.0, 0.0, 1.0);
            sum += texture2D(colortex0, uv + offset).rgb * weight;
            total += weight;
        }
    }
    return sum / max(total, 0.001);
}

void main() {
    vec2 texel = vec2(1.0 / viewWidth, 1.0 / viewHeight);
    vec3 base = texture2D(colortex0, texcoord).rgb;

    float brightness = dot(base, vec3(0.2126, 0.7152, 0.0722));
    vec3 bloom = vec3(0.0);
    if (brightness > 0.7) {
        bloom = sampleBlur(texcoord, texel);
    }

    vec3 color = base + bloom * 0.35;

    float luma = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(vec3(luma), color, 1.18);

    color = (color - 0.5) * 1.08 + 0.5;

    color = color / (color + vec3(1.0));
    color = pow(max(color, 0.0), vec3(1.0 / 1.1));

    vec2 centered = texcoord - 0.5;
    float vig = 1.0 - dot(centered, centered) * 0.6;
    color *= vig;

    gl_FragColor = vec4(color, 1.0);
}
