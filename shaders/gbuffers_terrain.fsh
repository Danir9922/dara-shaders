#version 120
uniform sampler2D texture;
uniform sampler2D lightmap;
uniform sampler2D shadowtex0;
uniform vec3 shadowLightPosition;
uniform vec3 fogColor;
uniform float fogStart;
uniform float fogEnd;

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 color;
varying vec3 normal;
varying float vertexDistance;
varying vec4 shadowPos;

float getShadow() {
    vec3 shadowScreen = shadowPos.xyz / shadowPos.w;
    shadowScreen = shadowScreen * 0.5 + 0.5;

    if (shadowScreen.x < 0.0 || shadowScreen.x > 1.0 ||
        shadowScreen.y < 0.0 || shadowScreen.y > 1.0 ||
        shadowScreen.z < 0.0 || shadowScreen.z > 1.0) {
        return 1.0;
    }

    float bias = 0.0015;
    float shadow = 0.0;
    vec2 texel = vec2(1.0 / 1024.0);

    // Мягкая тень: 3x3 PCF-фильтрация
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            float depth = texture2D(shadowtex0, shadowScreen.xy + vec2(x, y) * texel).r;
            shadow += (shadowScreen.z - bias > depth) ? 0.35 : 1.0;
        }
    }
    return shadow / 9.0;
}

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    if (albedo.a < 0.1) discard;

    float shadow = getShadow();

    vec3 lightDir = normalize(shadowLightPosition);
    float NdotL = max(dot(normalize(normal), lightDir), 0.0) * shadow;
    float diffuse = 0.4 + 0.6 * NdotL;

    vec3 skyTint   = vec3(0.55, 0.68, 1.00);
    vec3 blockTint = vec3(1.00, 0.74, 0.42);
    vec3 lm = texture2D(lightmap, lmcoord).rgb;
    vec3 tintedLight = lm * mix(blockTint, skyTint, lmcoord.y);

    vec3 finalColor = albedo.rgb * tintedLight * diffuse * 1.25;

    float fogFactor = clamp((vertexDistance - fogStart) / max(fogEnd - fogStart, 0.001), 0.0, 1.0);
    finalColor = mix(finalColor, fogColor, fogFactor);

    gl_FragColor = vec4(finalColor, albedo.a);
}
