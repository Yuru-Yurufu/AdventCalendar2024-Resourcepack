#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

out float depthLevel;

out vec3 ColorValue;

void main() {
    depthLevel = Position.z;
    vec3 pos = Position;

    // 透明度だけ引き継いだ白色
    vec4 white = vec4(1.0, 1.0, 1.0, 1.0);
    white.w = Color.w;

    // RGBを整数値で取得
    ColorValue = vec3(round(Color.r * 255.0), round(Color.g * 255.0), round(Color.b * 255.0));

    if (ColorValue.r == 1.0 && depthLevel == 2400.12) {
        // title
        vertexColor = white * texelFetch(Sampler2, UV2 / 16, 0);

        if (ColorValue.b == 8.0) {
            gl_Position = ProjMat * ModelViewMat * vec4(pos.x + 16.0, pos.y + 46.0, pos.z, 1.0);
            gl_Position.x -= 1.0;
            gl_Position.y += 1.0;
        } else {
            gl_Position = ProjMat * ModelViewMat * vec4(pos.x, pos.y + 40.0, pos.z, 1.0);
        }
    } else {
        // その他
        vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
        gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
    }

    vertexDistance = fog_distance(pos, FogShape);
    texCoord0 = UV0;
}