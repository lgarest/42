// simple vertex shader
uniform float time;
varying float A;
varying float F;

void main() {
	float pi = 3.141592654;
	float d = 0.1*sin(time*2.0*pi);
	vec3 trans = gl_Normal*d + vec3(gl_Vertex);
	gl_Position    = gl_ModelViewProjectionMatrix*vec4(trans,1.0);
	gl_FrontColor  = vec4((gl_NormalMatrix * gl_Normal).z);;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}