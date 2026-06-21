#version 120
uniform sampler2D texture;
uniform sampler2D lightmap;
uniform vec3 shadowLightPosition;

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 color;
varying vec3 normal;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    if (albedo.a < 0.1) discard;

    vec3 lightDir = normalize(shadowLightPosition);
    float NdotL = max(dot(normalize(normal), lightDir), 0.0);
    float diffuse = 0.5 + 0.5 * NdotL;

    vec3 lm = texture2D(lightmap, lmcoord).rgb;
    gl_FragColor = vec4(albedo.rgb * lm * diffuse * 1.15, albedo.a);
}
