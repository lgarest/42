// simple vertex shader
void main(){
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	vec3 matrix = gl_NormalMatrix * gl_Normal;
	gl_FrontColor  = gl_Color * matrix.z;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
