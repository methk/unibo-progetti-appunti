// Vertex shader: Wave shading
// ================
#version 320 es

// Input vertex data, different for all executions of this shader.
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;

// Output data
out vec3 N;
out vec3 E;
out vec3 L;

struct PointLight {
	vec3 position;
	vec3 color;
	float power;
};

// Values that stay constant for the whole mesh.
uniform mat4 P;
uniform mat4 V;
uniform mat4 M; // position * rotation * scaling

uniform float time;

uniform PointLight light;

void main() {
    float freq = 0.001, amp = 0.1;
    vec4 pos = vec4(aPos, 1.0);

    pos.y = amp * sin(freq * time + 10.0 * pos.x) * sin(freq * time + 10.0 * pos.z);
    gl_Position = P * V * M * pos;

    vec4 eyePosition = V * M * vec4(aPos, 1.0); // Position in VCS
    vec4 eyeLightPos = V * vec4(light.position, 1.0); // LightPos in VCS

    // Compute vectors E, L, N in VCS
    E = normalize(-eyePosition.xyz);
    L = normalize((eyeLightPos - eyePosition).xyz);
    N = normalize(transpose(inverse(mat3(V * M))) * aNormal);
}