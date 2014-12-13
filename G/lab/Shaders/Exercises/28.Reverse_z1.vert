void main(){
	vec4 new_position = gl_ModelViewProjectionMatrix * gl_Vertex;
	new_position.z *= -1.0;
	gl_Position = new_position;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
