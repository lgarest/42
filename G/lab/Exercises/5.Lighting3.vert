varying vec3 Vobs, Nobs;

void main () {
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	Vobs = vec3 ( gl_ModelViewMatrix * gl_Vertex);
	Nobs = gl_NormalMatrix * gl_Normal;
    //gl_FrontColor = gl_Color;
}
