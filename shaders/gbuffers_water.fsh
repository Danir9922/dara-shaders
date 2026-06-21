#version 120
uniform sampler2D texture;
uniform sampler2D lightmap;
uniform vec3 fogColor;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 shadowLightPosition;

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 color;
varying float vertexDistance;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    vec3 lm = texture2D(lightmap, lmcoord).rgb;
    vec3 waterTint = vec3(0.22, 0.52, 0.74);

    vec3 lightDir = normalize(shadowLightPosition);
    float glint = pow(max(lightDir.y, 0.0), 4.0) * 0.4;

    vec3 finalColor = albedo.rgb * lm * waterTint * 1.4 + glint;

    float fogFactor = clamp((vertexDistance - fogStart) / max(fogEnd - fogStart, 0.001), 0.0, 1.0);
    finalColor = mix(finalColor, fogColor, fogFactor);

    gl_FragColor = vec4(finalColor, albedo.a * 0.75);
}
